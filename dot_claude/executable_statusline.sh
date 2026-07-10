#!/bin/bash
# Claude Code status line: reads session JSON on stdin, prints one line.
# "-" is a placeholder for effort: it is absent on models that have no
# effort setting, and an empty field would collapse under IFS=tab.
IFS=$'\t' read -r model effort ctx ctx_size cost dir < <(
  jq -r '"\(.model.display_name)\t\(.effort.level // "-")\t\(.context_window.used_percentage // 0 | floor)\t\(.context_window.context_window_size // 0)\t\(.cost.total_cost_usd // 0)\t\(.workspace.current_dir // .cwd)"'
)

# 1000000 -> 1M, 200000 -> 200k. Empty when the size is unknown.
if [ "$ctx_size" -ge 1000000 ]; then
  ctx_size="/$((ctx_size / 1000000))M"
elif [ "$ctx_size" -ge 1000 ]; then
  ctx_size="/$((ctx_size / 1000))k"
else
  ctx_size=""
fi

# Abbreviate $HOME to ~ for a shorter path.
path="${dir/#$HOME/\~}"

# Current git branch, if the dir is inside a repo.
branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null)

# Muted 256-color palette: colors separate the segments so we don't
# need "·" dividers. Low saturation to stay easy on the eyes.
r=$'\033[0m'
c_model=$'\033[38;5;110m'   # soft blue
c_effort=$'\033[38;5;139m'  # soft mauve
c_ctx=$'\033[38;5;144m'     # soft khaki
c_cost=$'\033[38;5;180m'    # soft tan
c_branch=$'\033[38;5;108m'  # soft green
c_path=$'\033[38;5;245m'    # gray

line="${c_model}${model}${r}"
[ "$effort" != "-" ] && line="${line}  ${c_effort}${effort}${r}"
line="${line}  ${c_ctx}${ctx}%${ctx_size} ctx${r}"

# Estimated usage value: token count times public API prices. This is
# shown even on subscription plans, where it is not an actual charge.
line="${line}  ${c_cost}$(printf '$%.2f' "$cost")${r}"
[ -n "$branch" ] && line="${line}  ${c_branch}⎇ ${branch}${r}"
printf '%s  %s%s%s\n' "$line" "$c_path" "$path" "$r"
