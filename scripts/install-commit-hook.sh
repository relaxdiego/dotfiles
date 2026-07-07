#!/usr/bin/env bash
# Backfill the commit-msg hook into existing git repos.
#
# New clones/inits get the hook automatically via the git template dir
# (~/.git-template, set by dot_gitconfig.tmpl). This one-time helper installs
# it into repos that already existed before the hook did. It resolves each
# repo's real hooks dir, so it handles bare + worktree layouts, and it never
# overwrites a repo's own commit-msg hook (pre-commit, husky, etc.).
#
# Usage:
#   ./scripts/install-commit-hook.sh            # dry run — show what would change
#   ./scripts/install-commit-hook.sh --apply    # actually install
#   SRC=~/code ./scripts/install-commit-hook.sh # scan a different tree (default ~/src)
#
# Portable to macOS: avoids bash 4 features (no associative arrays).
set -euo pipefail

SRC="${SRC:-$HOME/src}"
HOOK="$HOME/.git-template/hooks/commit-msg"
APPLY=0
[ "${1:-}" = "--apply" ] && APPLY=1

[ -f "$HOOK" ] || { echo "source hook missing: $HOOK (run 'chezmoi apply' first)" >&2; exit 1; }
[ -d "$SRC" ]  || { echo "no such directory: $SRC" >&2; exit 1; }

# Print the real hooks dir for every repo found under $SRC (one per line).
resolve_hooks_dirs() {
    local marker dir hooks
    while IFS= read -r marker; do
        if [ -d "$marker" ]; then dir="$marker"; else dir="$(dirname "$marker")"; fi
        hooks="$(cd "$dir" && git rev-parse --git-path hooks 2>/dev/null)" || continue
        case "$hooks" in /*) ;; *) hooks="$(cd "$dir" && pwd)/$hooks" ;; esac
        ( cd "$(dirname "$hooks")" 2>/dev/null && printf '%s/%s\n' "$(pwd)" "$(basename "$hooks")" )
    done < <(find "$SRC" -maxdepth 5 \( -name .git -o -name .bare \) 2>/dev/null)
}

installed=0 existing=0
while IFS= read -r hooks; do
    [ -n "$hooks" ] || continue
    repo="${hooks#"$SRC"/}"; repo="${repo%/hooks}"
    if [ -e "$hooks/commit-msg" ]; then
        echo "  exists  $repo"
        existing=$((existing + 1))
        continue
    fi
    if [ "$APPLY" -eq 1 ]; then
        mkdir -p "$hooks"
        cp "$HOOK" "$hooks/commit-msg"
        chmod +x "$hooks/commit-msg"
        echo "install  $repo"
    else
        echo " would   $repo"
    fi
    installed=$((installed + 1))
done < <(resolve_hooks_dirs | sort -u)

echo
echo "repos needing hook: $installed   already have one: $existing"
[ "$APPLY" -eq 1 ] || echo "(dry run — re-run with --apply to install)"
