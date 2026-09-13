#!/usr/bin/env bash
#
# Does a bare `git push` on a new branch write to a branch of another name?
#
# The worktree layout documented in dot_local/share/agent-docs/worktrees.md
# starts every new branch from a remote-tracking ref:
#
#     git worktree add ../<branch-dir> -b <branch> origin/main
#
# git's default branch.autoSetupMerge then records origin/main as that
# branch's upstream. Paired with push.default = upstream, a bare `git push`
# resolves to refs/heads/main and the feature commit lands on main. No
# warning, no prompt, and the agent instructions in copilot-instructions.md
# forbid exactly that push.
#
# This script proves the current configuration either way. It builds a
# throwaway origin and worktree layout under a temp dir, runs the documented
# command, pushes for real, and checks which ref on the origin moved. Nothing
# outside the temp dir is touched and no network is used.
#
# Exit 0 when the commit stayed off main. Exit 1 when it landed there.
#
# Run it after any change to [push] or [branch] in dot_gitconfig.tmpl.

set -u

BRANCH=feat/probe
# The real ~/.gitconfig is the subject, so override only what would make the
# probe depend on this host's signing key or commit hooks.
G=(git -c commit.gpgsign=false)

W="$(mktemp -d)"
cleanup() { cd / && rm -rf "$W"; }
trap cleanup EXIT

echo "push.default   = $(git config --get push.default || echo '<unset, git default: simple>')"
echo "autoSetupMerge = $(git config --get branch.autoSetupMerge || echo '<unset, git default: true>')"
echo

# a throwaway origin holding a single main branch
"${G[@]}" init -q --bare "$W/origin.git" --initial-branch=main
"${G[@]}" init -q "$W/seed" --initial-branch=main
(
    cd "$W/seed" || exit 1
    echo seed > file.txt
    "${G[@]}" add file.txt
    "${G[@]}" commit -q --no-verify -m "chore: seed"
    "${G[@]}" remote add origin "$W/origin.git"
    "${G[@]}" push -q origin main
) || { echo "probe setup failed" >&2; exit 2; }

# the bare + worktree layout the `clone` function builds
C="$W/container"
mkdir -p "$C"
"${G[@]}" clone -q --bare "$W/origin.git" "$C/.bare"
"${G[@]}" --git-dir "$C/.bare" config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
"${G[@]}" --git-dir "$C/.bare" fetch -q origin
"${G[@]}" --git-dir "$C/.bare" worktree add -q "$C/main" main

# the command the worktree doc tells a human or an agent to run
cd "$C/main" || exit 2
"${G[@]}" worktree add -q "../${BRANCH//\//-}" -b "$BRANCH" origin/main
cd "../${BRANCH//\//-}" || exit 2

echo "work" > probe.txt
"${G[@]}" add probe.txt
"${G[@]}" commit -q --no-verify -m "feat: probe commit"
commit="$("${G[@]}" rev-parse HEAD)"

upstream="$("${G[@]}" rev-parse --abbrev-ref '@{upstream}' 2>/dev/null || echo '<none>')"
echo "new branch     = $BRANCH"
echo "its upstream   = $upstream"
echo

echo "\$ git push"
push_out="$("${G[@]}" push 2>&1)"
push_rc=$?
echo "$push_out" | sed 's/^/  /'
echo

# The assertion. The probe commit must not be reachable from the origin's main.
if "${G[@]}" --git-dir "$W/origin.git" merge-base --is-ancestor "$commit" refs/heads/main 2>/dev/null; then
    echo "FAIL: \`git push\` put ${commit:0:8} on the origin's main."
    echo "      A first push on any new worktree branch silently writes to main."
    echo "      Set push.default = simple in dot_gitconfig.tmpl."
    exit 1
fi

if [ "$push_rc" -ne 0 ]; then
    echo "PASS: \`git push\` refused and main was left alone."
else
    landed="$("${G[@]}" --git-dir "$W/origin.git" for-each-ref \
        --format='%(refname:short)' --contains "$commit" refs/heads 2>/dev/null | tr '\n' ' ')"
    echo "PASS: \`git push\` wrote to ${landed:-nothing}, not main."
fi
exit 0
