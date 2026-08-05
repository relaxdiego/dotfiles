# Neovim plugins: pins and the lockfile

How plugin versions are recorded, and what to do when you want to change one.

## Two layers

There are two records of every plugin version. They do different jobs.

**The pins** — a `commit = "..."` line in each file under
`dot_config/nvim/lua/relaxdiego/plugins/`. This is the *intent*: the version you
chose, readable and reviewable in the repo. It is also the seed. When you add a
brand new plugin there is no lockfile entry yet, so lazy.nvim falls back to the
pin.

**The lockfile** — `.nvim/lazy-lock.json` in the chezmoi source root. This is
the *record*: the exact commit of every installed plugin, including anything the
pins miss. It is what actually gets installed.

The lockfile wins. When `chezmoi apply` runs the restore, lazy.nvim checks out
what the lockfile says and ignores the pins. So changing only a pin does nothing
— see the upgrade steps below.

## Why the lockfile lives in `.nvim/`

chezmoi copies files one way, from the source into `$HOME`. The lockfile goes
the other way: lazy.nvim writes it. So the file lazy.nvim writes has to *be* the
file in the repo.

`lua/relaxdiego/plugins.lua` points lazy.nvim's `lockfile` option straight at
`~/.local/share/chezmoi/.nvim/lazy-lock.json`. chezmoi skips source entries whose
name starts with a dot, so `.nvim/` is tracked by git but never installed
anywhere. `:Lazy update` writes into the repo, and you commit it.

## The one command: `:Lazy sync`

Whatever you changed — added, removed, or repinned — the command is the same:

```vim
:Lazy sync
```

Plain `:Lazy sync`, with no lockfile flag, so the pins win and the lockfile is
rewritten to match. Then commit the spec file and `.nvim/lazy-lock.json`
together. They must never disagree.

Do not use `:Lazy update` here. It only acts on plugins that are already
installed, so it will not install a plugin you just added, and it does not
delete one you removed. `:Lazy sync` is install + clean + update, which covers
all three cases.

## Adding a plugin

Drop a new file in `dot_config/nvim/lua/relaxdiego/plugins/`. Every `*.lua` file
there is loaded automatically. Include a `commit = "..."` so the first install is
pinned. Then `:Lazy sync` and commit both files.

## Removing a plugin

Delete its spec file, then `:Lazy sync`. The clean step deletes the plugin
directory and drops it from the lockfile. Commit both.

## Upgrading a plugin

Edit the `commit = "..."` line in the spec, then `:Lazy sync` and commit both.

To find a newer commit, open `:Lazy`, press `U` to check for updates, and read
the log. To upgrade *everything* to the newest available you would have to drop
the pins first — with a pin in place, a sync only ever moves a plugin to its pin.

## lazy.nvim pins itself twice, on purpose

lazy.nvim appends an unpinned spec for itself, so a sync would quietly drag it to
the latest `main`. `plugins/lazy.lua` pins it like any other plugin, and that is
the single source of truth for its version.

`plugins.lua` also checks that commit out — but *only* right after cloning, on a
machine that has no lazy.nvim yet. It reads the commit from `plugins/lazy.lua`
rather than repeating it. Do not move that checkout back outside the `if` block:
it then runs on every start and fights the sync, and whichever ran last wins.

## What `chezmoi apply` does

`run_998_sync_nvim_plugins.sh.tmpl` runs on every apply:

```lua
require('lazy').restore({ wait = true })
require('lazy').install({ wait = true, lockfile = true })
require('lazy').clean({ wait = true })
```

That checks every installed plugin out to the lockfile, installs missing ones,
and deletes removed ones. It is a restore, not an upgrade — it will never move
you to a newer version.

Three separate calls, restore first, and deliberately not `:Lazy sync`. Every
lazy.nvim operation ends by rewriting the lockfile from whatever is *installed*
(`manage/lock.lua`, `M.update`), and `sync` starts its clean, install and update
stages at the same time. So the rewrite races the checkout that is supposed to
read the lockfile. On a machine whose plugins had drifted, the install won that
race: the drift was written into the lockfile instead of being undone. Restoring
first means the checkout reads the file before anything can overwrite it.

If the restore changes the lockfile, the closing banner reminds you to commit it.
That normally means a plugin was added or removed somewhere else.

## The `branch` field, and why two specs name it

Each lockfile entry carries a `branch` as well as a commit. lazy.nvim does not
get that name from the repo. It reads `refs/remotes/origin/HEAD` in the plugin
clone, and git writes that ref once, at clone time, and never revisits it. So a
machine that cloned a plugin before upstream renamed `master` to `main` keeps
writing `master`, another machine writes `main`, and the two rewrite the same
line back and forth on every apply. The commit is identical either way — the
installed version is fine — but the banner keeps asking you to commit it.

Naming the branch in the spec ends it, because `Git.get_branch` returns
`plugin.branch` when it is set and only falls back to the clone otherwise:

```lua
branch = "main",
```

`treesitter.lua` and `git-blame.lua` have that line for this reason. Add it to
any other plugin that starts flapping, and make sure the pinned commit really is
on the branch you name.
