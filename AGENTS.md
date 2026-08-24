# AGENTS.md

Orientation for AI agents working in this repository.

## What this repo is

This is a [chezmoi](https://chezmoi.io) source directory for Mark Maglana's
dotfiles. It lives at `~/.local/share/chezmoi`. Running `chezmoi apply` reads
these files and writes the real config into `$HOME`. The repo is public
(`github.com/relaxdiego/dotfiles`) and targets both macOS and Linux.

Do not edit files under `$HOME` directly. Edit the source here; the owner
(the person you work for) then runs `chezmoi apply`.

## chezmoi naming (read before editing)

File names encode how chezmoi installs them. In this list, `NAME` stands for
the file name and `NNN` for a three-digit order number:

- `dot_NAME` → `~/.NAME` (for example, `dot_vimrc` → `~/.vimrc`).
- `private_` prefix → restricted permissions (0600).
- `executable_` prefix → adds the executable bit.
- `*.tmpl` → processed as a Go template; host facts come from `.chezmoi.*`.
- `run_once_NNN_*.sh.tmpl` → script run ONCE, in `NNN` numeric order, on apply.
- `run_NNN_*.sh.tmpl` (no `once`) → runs on EVERY apply.

Many templates branch on the OS:
`{{ if eq .chezmoi.os "darwin" }} ... {{ else if eq .chezmoi.os "linux" }} ...`.

## Install scripts

The `run_once_*` scripts install the tooling (vim, tmux, go, node, k9s, and so
on). Each pins a version in one of four ways:

- an exact version and its SHA256 checksum,
- a git tag or commit,
- `latest`, fetched at apply time,
- whatever the OS package manager (brew or apt) provides.

When you bump a checksum-pinned tool, update BOTH the version and its SHA256.

## Neovim plugins

Plugin versions live in two places: a `commit =` pin in each spec under
`dot_config/nvim/lua/relaxdiego/plugins/`, and `.nvim/lazy-lock.json` in the
source root. The lockfile wins at apply time, so editing a pin alone changes
nothing. Read `docs/nvim-plugins.md` before changing, adding, or removing a
plugin.

## Checking installed tool versions

`scripts/verify-inventory.sh` prints the real installed path and version of
each common tool on the current host. Run it to take an accurate software
inventory, for example for a security or CVE review. Do not trust the version
pins in the install scripts; they drift between machines. Output is
host-specific, so re-run it on each host.

Prefer `./scripts/verify-inventory.sh` over a tool's `--version` by hand. Some
shells wrap `grep` or `find` with aliases or functions, so a manual check can
report the wrong binary. The script avoids that by running in a clean
subprocess.

## Colors and theming

The terminal color setup (git-delta, lazygit, Neovim, tmux, and the terminal
emulator palette) is interrelated and easy to get wrong. Before touching any of
it, read `docs/color-scheme.md`. Do not assume a specific terminal emulator —
ask the owner which one they use.

The selection highlight is set in four unrelated files with no shared
variable: the Ghostty config, `dot_tmux.conf`, the Neovim kanagawa spec, and
(unchangeably) Claude Code. Change all of them in one commit or none — see the
selection section of `docs/color-scheme.md`.

## Guest users

**This whole section describes Linux agent machines only.** This file lives
in the repo, not in `$HOME`, so you are reading it on every machine. On a
personal or shared machine none of it is installed: there is no `guest`
command, no `/opt/relaxdiego`, and `gh` stays in `~/.local/opt/github-cli`.
Check which kind of machine you are on with:

```sh
chezmoi data | grep '"agent"'
```

On a Linux agent machine, `~/.local/bin/guest` (source:
`dot_local/bin/executable_guest.tmpl`) creates one unprivileged Unix user per
trust domain. A trust domain is one set of secrets, for example "work" or
"personal". An agent runs as that user and sees only that domain's tokens.
The subcommands are `guest add`, `enter`, `run`, `secrets`, `steps`, `sync`,
`list`, and `rm`. Never copy a secret from the owner's home into a guest —
share code instead.

The `git` and `gh` shims (wrapper scripts that pick the right GitHub token)
each read `$HOME/.config/gh-org-tokens`, so each user gets only its own
tokens. `docs/guests.md` explains where the shims live and how they are
installed host-wide.

Three rules make this safe. **The boundary is the `0700` home** — nothing
else. Guests share the kernel, the network, and `/proc`, so never put a
secret in a command line, and never run an unauthenticated service on
localhost. **The owner's `chezmoi apply` owns every host-wide install and
file mode** (mode means the permission bits). `guest add` owns nothing
outside a guest's home. It only warns when something host-wide is missing, so
each mode is defined in one place. **Never put a guest in `sudo`, `docker`,
or any other root-equivalent group** — a root daemon it can talk to lets the
guest escape the boundary.

`guest add` also writes the agent instruction files into each guest —
`.claude/CLAUDE.md`, `.codex/AGENTS.md`, `.pi/agent/AGENTS.md`,
`.config/AGENTS.md` — from the same `.chezmoitemplates/AGENTS.md` that the
owner's copies use. It also writes `~/.local/share/agent-docs/` into the
guest from the owner's source. After editing either source, run `guest sync`
to push it to every guest. If you add a new consumer of that template for the
owner, add it to `write_managed_files` in the guest script too.

## Conventions

Follow these in every change:

- History goes straight to `main`. Do not open PRs unless asked.
- Make surgical changes and match the style of the file you touch.
- The repo is public — never commit secrets, tokens, or host-identifying data.
  Secrets are pulled from 1Password at apply time (see the `.tmpl` files), not
  stored here.
