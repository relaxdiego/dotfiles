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

The lockfile wins. When `chezmoi apply` runs the sync, lazy.nvim checks out what
the lockfile says and ignores the pins. So changing only a pin does nothing —
see the upgrade steps below.

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
require('lazy').sync({ lockfile = true, wait = true })
```

That installs missing plugins, deletes removed ones, and checks everything out
to the lockfile. It is a restore, not an upgrade — it will never move you to a
newer version.

If the sync changes the lockfile, the closing banner reminds you to commit it.
That normally means a plugin was added or removed somewhere else.
