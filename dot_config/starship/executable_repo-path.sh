#!/usr/bin/env bash
# Prompt path label for starship's custom.repopath module.
#   bare-worktree repo (.../<repo>/.bare):  repo/worktree[/subpath]
#   plain git repo:                         repo[/subpath]
#   not a git repo:                         ~-relative path
cwd="$(pwd -P)"

top="$(git rev-parse --show-toplevel 2>/dev/null)"
if [ -n "$top" ]; then
  common="$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)"
  if [ "$(basename "$common")" = ".bare" ]; then
    # bare-worktree layout: show repo dir (parent of .bare) + worktree dir
    label="$(basename "$(dirname "$common")")/$(basename "$top")"
  else
    # ordinary clone: anchor to the repo root folder
    label="$(basename "$top")"
  fi
  # use git's own sub-path so casing/symlink differences between pwd and
  # the repo toplevel can't break a string strip
  sub="$(git rev-parse --show-prefix 2>/dev/null)"; sub="${sub%/}"
  [ -n "$sub" ] && label="$label/$sub"
  printf '%s' "$label"
else
  case "$cwd" in
    "$HOME") printf '~' ;;
    "$HOME"/*) printf '~/%s' "${cwd#"$HOME"/}" ;;
    *) printf '%s' "$cwd" ;;
  esac
fi
