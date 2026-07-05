#!/bin/bash
# Claude Code status line: reads session JSON on stdin, prints one line.
IFS=$'\t' read -r model ctx dir < <(
  jq -r '"\(.model.display_name)\t\(.context_window.used_percentage // 0 | floor)\t\(.workspace.current_dir // .cwd)"'
)

# Abbreviate $HOME to ~ for a shorter path.
path="${dir/#$HOME/\~}"

# Current git branch, if the dir is inside a repo.
branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null)

# Muted 256-color palette: colors separate the segments so we don't
# need "·" dividers. Low saturation to stay easy on the eyes.
r=$'\033[0m'
c_model=$'\033[38;5;110m'   # soft blue
c_ctx=$'\033[38;5;144m'     # soft khaki
c_branch=$'\033[38;5;108m'  # soft green
c_path=$'\033[38;5;245m'    # gray

line="${c_model}${model}${r}  ${c_ctx}${ctx}% ctx${r}"
[ -n "$branch" ] && line="${line}  ${c_branch}⎇ ${branch}${r}"
printf '%s  %s%s%s\n' "$line" "$c_path" "$path" "$r"
