#!/usr/bin/env bash
# ssh-split.sh — split the current window; if the pane is running SSH,
# reconnect to the same host in the new pane.
#
# For ssh, the new pane also cd's into the directory that session is
# currently in. tmux cannot learn the remote directory on its own
# (pane_current_path is the LOCAL ssh client's cwd), so we ask the remote
# host: match this exact session by its SSH_CONNECTION client port and read
# the session shell's cwd from /proc. This works even when Claude Code or
# Neovim is in the foreground, because we read the shell's cwd, not
# anything drawn on screen.
#
# Safe by design: the ssh command is only ever the exact argv YOU launched
# (read from the local process), requoted with printf %q. The remote
# discovery reads only YOUR OWN processes on the host you already trust,
# and the single value taken from the remote (the cwd) is used solely as a
# `cd` target there, POSIX single-quoted — it never runs on this
# workstation. If discovery finds nothing (non-Linux host, no port match),
# the reconnect just lands in the remote $HOME, exactly as before.
#
# Works on Linux and macOS. Uses only bash 3.2 features (macOS ships 3.2).
#
# Set SSH_SPLIT_DEBUG=1 to append diagnostics to /tmp/ssh-split.log.
# A fixed path is used on purpose: $TMPDIR differs between an interactive
# shell and tmux's run-shell environment (especially on macOS), which would
# otherwise scatter the log across files.
#
# Usage: ssh-split.sh -h   (left/right split)
#        ssh-split.sh -v   (top/bottom split)

set -euo pipefail

debug() {
  [[ -n "${SSH_SPLIT_DEBUG:-}" ]] || return 0
  printf '%s\n' "$*" >> /tmp/ssh-split.log
}
# Log why we bailed out if the script exits non-zero before splitting.
# shellcheck disable=SC2154  # rc is assigned inside the trap string
trap 'rc=$?; [[ $rc -ne 0 ]] && debug "abnormal exit rc=$rc near line $LINENO"' EXIT

orient="${1:--v}"

debug "=== trigger orient=$orient os=$(uname -s) TMUX_PANE=${TMUX_PANE:-<unset>} ==="
debug "tmux=$(command -v tmux || echo NOT_FOUND) PATH=$PATH"

# Resolve the pane that triggered us. run-shell sets TMUX_PANE; targeting it
# explicitly avoids acting on the wrong pane when several are active.
if [[ -n "${TMUX_PANE:-}" ]]; then
  pane_pid="$(tmux display -p -t "$TMUX_PANE" '#{pane_pid}')"
  pane_path="$(tmux display -p -t "$TMUX_PANE" '#{pane_current_path}')"
else
  pane_pid="$(tmux display -p '#{pane_pid}')"
  pane_path="$(tmux display -p '#{pane_current_path}')"
fi
debug "pane_pid=$pane_pid pane_path=$pane_path"

is_ssh_comm() {
  # Match on the executable basename only.
  case "${1##*/}" in
    ssh | mosh | mosh-client | autossh) return 0 ;;
    *) return 1 ;;
  esac
}

# Print the pid of the first ssh-family process in the descendant tree of
# $1. Walking by ppid works the same on Linux and macOS and finds ssh
# whether it is a direct child or nested, foreground or background — it
# does not depend on session/process-group semantics, which differ across
# platforms.
find_ssh_pid() {
  local root="$1"
  local snapshot cur pid ppid comm
  # -A is POSIX and lists every process on both Linux and macOS.
  snapshot="$(ps -Ao pid=,ppid=,comm=)"

  local queue="$root"
  while [[ -n "$queue" ]]; do
    cur="${queue%% *}"
    if [[ "$queue" == *" "* ]]; then queue="${queue#* }"; else queue=""; fi

    while read -r pid ppid comm; do
      [[ "$ppid" == "$cur" ]] || continue
      if is_ssh_comm "$comm"; then
        printf '%s\n' "$pid"
        return 0
      fi
      queue="$queue $pid"
    done <<< "$snapshot"
  done
  return 1
}

# Do an ordinary split that keeps the local working directory.
plain_split() {
  debug "plain split ($orient) in $pane_path"
  tmux split-window "$orient" -c "$pane_path"
  exit 0
}

# Print the local source TCP port of the ssh session's connection. The
# remote sshd exposes this same port in SSH_CONNECTION, so it uniquely
# identifies this session on the remote host. Empty if it can't be found.
source_port() {
  local pid="$1" lsof_bin
  lsof_bin="$(command -v lsof || true)"
  [[ -n "$lsof_bin" ]] || { [[ -x /usr/sbin/lsof ]] && lsof_bin=/usr/sbin/lsof; }
  [[ -n "$lsof_bin" ]] || return 0
  # The NAME column looks like 10.0.0.5:53422->10.0.0.9:22 — take the port
  # right before '->'. An interactive ssh has one established connection.
  "$lsof_bin" -nPan -p "$pid" -iTCP -sTCP:ESTABLISHED 2>/dev/null \
    | sed -n 's/.*:\([0-9][0-9]*\)->.*/\1/p' | head -1
}

# Build the remote command: find the session shell whose SSH_CONNECTION
# client port is $1, cd into its working directory, then start an
# interactive login shell. The remote script reads only our own processes
# and uses no data from outside the remote host. $1 is a validated number,
# so it is embedded directly.
#
# The script unsets __ETC_PROFILE_NIX_SOURCED before the final login shell.
# sshd runs this whole script as a non-login "sh -c", so the exec below is a
# nested login shell. If sshd's own environment carries nix's
# __ETC_PROFILE_NIX_SOURCED guard (it does when sshd was started from a nix
# shell), /etc/profile wipes PATH but /etc/profile.d/nix.sh then skips
# re-adding nix, so nix disappears from PATH and direnv/devbox break. A real
# login shell has no such guard set, so clearing it restores that behavior.
#
# Keep the here-doc body free of backticks and apostrophes: it is embedded in
# a single-quoted argument on the local side, and those characters have broken
# the quoting on macOS bash 3.2.
remote_cd_script() {
  local script
  script="$(cat <<'REMOTE'
target=__PORT__
dir=
for e in /proc/[0-9]*/environ; do
  [ -r "$e" ] || continue
  # Group-redirect stderr so a failed open (readable per mode bits but
  # blocked by the kernel ptrace check) does not leak into the new pane.
  cc=$( { tr '\0' '\n' < "$e" | sed -n 's/^SSH_CONNECTION=//p'; } 2>/dev/null )
  [ -n "$cc" ] || continue
  set -- $cc
  [ "${2:-}" = "$target" ] || continue
  p=${e%/environ}
  st=$(cat "$p/stat" 2>/dev/null) || continue
  set -- ${st##*) }
  pcomm=$(cat "/proc/${2:-0}/comm" 2>/dev/null)
  d=$(readlink "$p/cwd" 2>/dev/null) || continue
  case "$pcomm" in
    sshd*) dir=$d; break ;;
    *) [ -n "$dir" ] || dir=$d ;;
  esac
done
[ -n "$dir" ] && cd -- "$dir" 2>/dev/null
# Clear nix guard so the login shell below rebuilds PATH (see function header).
unset __ETC_PROFILE_NIX_SOURCED
exec "${SHELL:-/bin/sh}" -l
REMOTE
)"
  printf '%s' "${script//__PORT__/$1}"
}

ssh_pid="$(find_ssh_pid "$pane_pid" || true)"
debug "ssh_pid=${ssh_pid:-<none>}"

[[ -n "$ssh_pid" ]] || plain_split

# Recover the ssh process argv.
argv=()
if [[ -r "/proc/$ssh_pid/cmdline" ]]; then
  # Linux: exact, null-separated arguments.
  while IFS= read -r -d '' arg; do
    argv+=("$arg")
  done < "/proc/$ssh_pid/cmdline"
else
  # macOS: no procfs. Recover argv from ps by whitespace-splitting.
  # Arguments containing spaces are not preserved, but this stays
  # injection-safe because every field is requoted below.
  read -r -a argv < <(ps -ww -o command= -p "$ssh_pid" 2>/dev/null)
fi

[[ ${#argv[@]} -gt 0 ]] || plain_split

# If this pane is itself a previous ssh-split reconnect, its argv already
# carries the "-t '<remote script>'" we injected last time. Replaying that
# would wrap our own command in a second layer of quoting (and on macOS,
# ps/read turns the script's newlines into literal \012), producing a broken
# remote command. Strip our trailer back to the base ssh invocation so we
# rebuild a fresh, clean reconnect. Our trailer is a "-t" whose next argument
# is the remote script, which always begins with "target=<digits>" — a value
# no one would type by hand, so a real "ssh -t host cmd" is left untouched.
for (( i=0; i<${#argv[@]}; i++ )); do
  if [[ "${argv[$i]}" == "-t" && "${argv[$((i+1))]:-}" =~ ^target=[0-9]+ ]]; then
    argv=( "${argv[@]:0:i}" )
    debug "stripped previous reconnect trailer at argv[$i]"
    break
  fi
done

[[ ${#argv[@]} -gt 0 ]] || plain_split

cmd=""
for arg in "${argv[@]}"; do
  cmd+="$(printf '%q ' "$arg")"
done

# The trailing `exec "${SHELL}" -l` runs LOCALLY after ssh returns, so
# exiting the remote host drops back to a local login shell instead of
# closing the pane.
plain_reconnect() {
  debug "reconnect cmd: $cmd"
  tmux split-window "$orient" "$cmd; exec \"\${SHELL:-/bin/sh}\" -l"
}

case "${argv[0]##*/}" in
  ssh | autossh)
    # Reconnect and cd into the remote session's directory (see header).
    # || true: lsof exits non-zero when it lists nothing; without the guard
    # set -e would abort the split instead of falling back to a plain one.
    port="$(source_port "$ssh_pid" || true)"
    debug "ssh source port=${port:-<none>}"
    if [[ "$port" =~ ^[0-9]+$ ]]; then
      remote_cmd="$(remote_cd_script "$port")"
      # POSIX single-quote remote_cmd for the LOCAL split shell (which may
      # be any sh), rather than printf %q which is bash-specific.
      local_arg="'${remote_cmd//\'/\'\\\'\'}'"
      debug "reconnect with remote-cwd discovery (port $port)"
      tmux_cmd="$cmd -t $local_arg; exec \"\${SHELL:-/bin/sh}\" -l"
      if [[ -n "${SSH_SPLIT_DEBUG:-}" ]]; then
        debug "=== tmux_cmd byte dump begin ==="
        printf '%s' "$tmux_cmd" | od -An -c >> /tmp/ssh-split.log 2>&1
        debug "=== tmux_cmd byte dump end ==="
      fi
      tmux split-window "$orient" "$tmux_cmd"
    else
      plain_reconnect
    fi
    ;;
  *)
    # mosh and friends: no matching SSH_CONNECTION port, reconnect plainly.
    plain_reconnect
    ;;
esac

# vim: set ft=bash et ts=2 sw=2 :
