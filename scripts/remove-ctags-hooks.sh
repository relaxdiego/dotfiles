#!/usr/bin/env bash
# Remove the retired ctags git hooks from repos that already exist.
#
# Hooks are copied out of ~/.git-template at clone time, so dropping them from
# the template only affects new clones. .chezmoiremove cleans up ~/.git-template
# itself, but nothing touches the copies inside each repo. This one-time helper
# deletes them, along with the tags files they generated.
#
# It resolves each repo's real hooks dir, so it handles bare + worktree layouts,
# and it only deletes a hook whose content still matches the ones we shipped —
# a repo's own post-commit or post-checkout is left alone.
#
# Usage:
#   ./scripts/remove-ctags-hooks.sh            # dry run — show what would go
#   ./scripts/remove-ctags-hooks.sh --apply    # actually delete
#   SRC=~/code ./scripts/remove-ctags-hooks.sh # scan a different tree (default ~/src)
#   DEPTH=20 ./scripts/remove-ctags-hooks.sh   # search deeper (default 12)
#
# Portable to macOS: avoids bash 4 features (no associative arrays).
set -euo pipefail

SRC="${SRC:-$HOME/src}"
# Deep enough to reach vendored clones, e.g. a pip editable install at
# <repo>/services/<svc>/.venv/src/<dep>/.git — 10 levels below ~/src.
DEPTH="${DEPTH:-12}"
HOOKS="post-rewrite post-merge post-checkout post-commit ctags"
APPLY=0
[ "${1:-}" = "--apply" ] && APPLY=1

# Ours name ctags, hardcode the pre-worktree-fix .git/ paths, or (post-rewrite)
# just chain to another hook via git rev-parse --git-path. Any of these means
# the hook exists only to drive ctags.
MINE='ctags|\.git/hooks/|\.git/tags_lock|--git-path hooks/'

[ -d "$SRC" ] || { echo "no such directory: $SRC" >&2; exit 1; }

# Print the real hooks dir for every repo found under $SRC (one per line).
resolve_hooks_dirs() {
    local marker dir hooks
    while IFS= read -r marker; do
        if [ -d "$marker" ]; then dir="$marker"; else dir="$(dirname "$marker")"; fi
        hooks="$(cd "$dir" && git rev-parse --git-path hooks 2>/dev/null)" || continue
        case "$hooks" in /*) ;; *) hooks="$(cd "$dir" && pwd)/$hooks" ;; esac
        ( cd "$(dirname "$hooks")" 2>/dev/null && printf '%s/%s\n' "$(pwd)" "$(basename "$hooks")" )
    done < <(find "$SRC" -maxdepth "$DEPTH" \( -name .git -o -name .bare \) 2>/dev/null)
}

removed=0 kept=0 tagfiles=0 repos=0
while IFS= read -r hooks; do
    [ -n "$hooks" ] || continue
    repo="${hooks#"$SRC"/}"; repo="${repo%/hooks}"
    repos=$((repos + 1))

    for h in $HOOKS; do
        target="$hooks/$h"
        [ -f "$target" ] || continue
        if grep -qE "$MINE" "$target"; then
            if [ "$APPLY" -eq 1 ]; then
                rm -f "$target"
                echo " removed  $repo/$h"
            else
                echo "  would   $repo/$h"
            fi
            removed=$((removed + 1))
        else
            echo "    kept   $repo/$h (not ours)"
            kept=$((kept + 1))
        fi
    done

    # Generated indexes live in each *worktree's* gitdir, not the common dir.
    # So check both <common>/tags and <common>/worktrees/*/tags.
    common="$(dirname "$hooks")"
    for leftover in "$common/tags" "$common/tags_lock" \
                    "$common"/worktrees/*/tags "$common"/worktrees/*/tags_lock; do
        [ -e "$leftover" ] || continue
        if [ "$APPLY" -eq 1 ]; then
            rm -rf "$leftover"
            echo " removed  ${leftover#"$SRC"/}"
        else
            echo "  would   ${leftover#"$SRC"/}"
        fi
        tagfiles=$((tagfiles + 1))
    done
done < <(resolve_hooks_dirs | sort -u)

echo
echo "repos scanned: $repos   hooks: $removed   tags files: $tagfiles   kept (not ours): $kept"
[ "$APPLY" -eq 1 ] || echo "(dry run — re-run with --apply to delete)"
