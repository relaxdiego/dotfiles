#!/usr/bin/env bash
# ssh-split.sh — split the current window; if the pane is running SSH,
# reconnect to the same host in the new pane.
#
# Safe by design: this only re-executes the exact ssh argv that YOU
# already launched (read from the running process). It never reads any
# remote-controlled data — no shell-prompt scraping, no OSC7, no remote
# working directory — so a malicious remote host cannot inject commands
# onto this workstation. Each argument is requoted with printf %q, so no
# shell metacharacters can leak into the command tmux runs.
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

cmd=""
for arg in "${argv[@]}"; do
  cmd+="$(printf '%q ' "$arg")"
done

debug "reconnect cmd: $cmd"
# Run ssh, then hand the pane to a local login shell. Without the `exec`,
# ssh would be the pane's main process, so exiting the remote host would
# close the pane instead of dropping back to the local shell.
tmux split-window "$orient" "$cmd; exec \"\${SHELL:-/bin/sh}\" -l"

# vim: set ft=bash et ts=2 sw=2 :
