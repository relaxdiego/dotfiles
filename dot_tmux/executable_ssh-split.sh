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
# Usage: ssh-split.sh -h   (left/right split)
#        ssh-split.sh -v   (top/bottom split)

set -euo pipefail

orient="${1:--v}"

pane_pid="$(tmux display -p '#{pane_pid}')"
pane_path="$(tmux display -p '#{pane_current_path}')"

is_ssh_comm() {
  # Match on the executable basename only.
  case "${1##*/}" in
    ssh | mosh | mosh-client | autossh) return 0 ;;
    *) return 1 ;;
  esac
}

# Print "pid comm" for processes belonging to the current pane.
list_pane_procs() {
  if [[ "$(uname -s)" == "Darwin" ]]; then
    # macOS: -g filters by process group, which misses a foreground ssh,
    # so match direct children of the pane shell instead.
    ps -ax -o pid=,ppid=,comm= | awk -v p="$pane_pid" '$2 == p { $2 = ""; print }'
  else
    # Linux: -g selects the whole session, so it also catches a
    # foreground ssh that lives in its own process group.
    ps -o pid=,comm= -g "$pane_pid"
  fi
}

# Do an ordinary split that keeps the local working directory.
plain_split() {
  tmux split-window "$orient" -c "$pane_path"
  exit 0
}

ssh_pid=""
while read -r pid comm; do
  if is_ssh_comm "$comm"; then
    ssh_pid="$pid"
    break
  fi
done < <(list_pane_procs 2>/dev/null)

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

tmux split-window "$orient" "$cmd"

# vim: set ft=bash et ts=2 sw=2 :
