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
# Set SSH_SPLIT_DEBUG=1 to append diagnostics to $TMPDIR/ssh-split.log.
#
# Usage: ssh-split.sh -h   (left/right split)
#        ssh-split.sh -v   (top/bottom split)

set -euo pipefail

orient="${1:--v}"

pane_pid="$(tmux display -p '#{pane_pid}')"
pane_path="$(tmux display -p '#{pane_current_path}')"

debug() {
  [[ -n "${SSH_SPLIT_DEBUG:-}" ]] || return 0
  printf '%s\n' "$*" >> "${TMPDIR:-/tmp}/ssh-split.log"
}

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

debug "--- trigger: orient=$orient pane_pid=$pane_pid os=$(uname -s) ---"

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
tmux split-window "$orient" "$cmd"

# vim: set ft=bash et ts=2 sw=2 :
