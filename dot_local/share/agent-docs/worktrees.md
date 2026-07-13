# Git worktrees on this machine

Every repo under `~/src` is cloned by the `clone` shell function into a
bare + worktree layout, not a normal clone:

```
~/src/<host>/<owner>/<repo>/.bare/      bare git data (no working files)
~/src/<host>/<owner>/<repo>/main/       the `main` branch, as a worktree
~/src/<host>/<owner>/<repo>/fix-login/  the `fix/login` branch, as a worktree
```

**The directory name IS the branch name.** A `/` in a branch name becomes a
`-` in the directory name (`fix/login` → `fix-login`). No worktree is more
important than the others; `main/` is simply the one that holds `main`.

Other tools rely on this. If a directory named `main` holds some other
branch, anything that reads it — a diff, a review, a "branch off main" —
starts from the wrong base and looks correct while being wrong.

## The rule

**Never switch branches in place inside a worktree.** Do not run
`git checkout -b`, `git switch -c`, `git checkout <branch>`, or
`git switch <branch>` there. Each of those leaves a directory whose name no
longer matches its branch.

To start a new branch, add a worktree next to the existing ones:

```sh
git worktree add ../<branch-dir> -b <branch> origin/main
cd ../<branch-dir>
```

To work on a branch that already exists:

```sh
git worktree add ../<branch-dir> <branch>
```

Both work from inside any worktree of that repo. The paths are relative, so
`../` lands in the repo container next to `.bare`.

## Cleaning up

A worktree keeps its files and a git lock even after the branch is merged.
When you are done with a branch:

```sh
git worktree remove ../<branch-dir>    # refuses if there are uncommitted changes
git branch -d <branch>                 # only after the branch is merged
```

Never `rm -rf` a worktree directory. That leaves the bare repo pointing at a
path that no longer exists. If it already happened, run `git worktree prune`
to drop the stale records.

To see the true state of a repo, run `git worktree list` from any worktree.
It prints every directory and the branch it holds, which is the fastest way
to spot a directory whose name and branch have drifted apart.

## Exceptions

The chezmoi source directory (`~/.local/share/chezmoi`) is a normal clone,
not this layout. `chezmoi` looks for its source at that exact path, so a
worktree elsewhere would be ignored by `chezmoi apply`. Do not add worktrees
to it.
