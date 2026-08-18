# AGENTS.md

Orientation for AI agents working in this repository.

## What this repo is

This is a [chezmoi](https://chezmoi.io) source directory for Mark Maglana's
dotfiles. It lives at `~/.local/share/chezmoi`. Running `chezmoi apply` reads
these files and writes the real config into `$HOME`. The repo is public
(`github.com/relaxdiego/dotfiles`) and targets both macOS and Linux.

Do not edit files under `$HOME` directly. Edit the source here; the user then
runs `chezmoi apply`.

## chezmoi naming (read before editing)

File names encode how chezmoi installs them:

- `dot_foo` → `~/.foo` (e.g. `dot_vimrc` → `~/.vimrc`).
- `private_` prefix → restricted permissions (0600).
- `executable_` prefix → adds the executable bit.
- `*.tmpl` → processed as a Go template; host facts come from `.chezmoi.*`.
- `run_once_NNN_*.sh.tmpl` → script run ONCE, in `NNN` numeric order, on apply.
- `run_NNN_*.sh.tmpl` (no `once`) → runs on EVERY apply.

Many templates branch on the OS:
`{{ if eq .chezmoi.os "darwin" }} ... {{ else if eq .chezmoi.os "linux" }} ...`.

## Install scripts

The `run_once_*` scripts install the tooling (vim, tmux, go, node, k9s, and so
on). Each pins a version in one of four ways: exact version + SHA256 checksum, a
git tag/commit, `latest` fetched at apply time, or whatever the OS package
manager (brew/apt) provides. When you bump a checksum-pinned tool, update BOTH
the version and its SHA256.

## Neovim plugins

Plugin versions live in two places: a `commit =` pin in each spec under
`dot_config/nvim/lua/relaxdiego/plugins/`, and `.nvim/lazy-lock.json` in the
source root. The lockfile wins at apply time, so editing a pin alone changes
nothing. Read `docs/nvim-plugins.md` before changing, adding, or removing a
plugin.

## Checking installed tool versions

`scripts/verify-inventory.sh` prints the real installed path + version of
each common tool on the current host. Run it to take an accurate software
inventory — for a security / CVE review, for example — instead of trusting the
version pins in the install scripts, which drift between machines. Output is
host-specific, so re-run it on each host.

Prefer `./scripts/verify-inventory.sh` over a tool's `--version` by hand. Some shells
wrap `grep`/`find` with aliases or functions, so a manual check can report the
wrong binary; the script avoids that by running in a clean subprocess.

## Colors and theming

The terminal color setup (git-delta, lazygit, Neovim, tmux, and the terminal
emulator palette) is interrelated and easy to get wrong. Before touching any of
it, read `docs/color-scheme.md`. Do not assume a specific terminal emulator —
ask the user which one they use.

One color is spread across four unrelated files and has no shared variable:
the selection highlight, set in the Ghostty config, `dot_tmux.conf`, the
Neovim kanagawa spec, and (unchangeably) Claude Code. Change all of them in
one commit or none — see the selection section of `docs/color-scheme.md`.

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
trust domain, so an agent runs as that user and sees only its own tokens:
`guest add / enter / run / secrets / steps / sync / list / rm`. Never copy a
secret from the owner's home into a guest — share code instead.

`/opt/relaxdiego/usr/local/` is the host-wide prefix that makes that
possible, because a guest's `0700` home cannot see the owner's. The GitHub
shims live in `.chezmoitemplates/` (`git-credential-gh-org` and `gh`, with no
chezmoi data in them, on purpose). From that one source they go to the
owner's `~/.local/bin` — on agent machines only, `.chezmoiignore` drops them
elsewhere — and host-wide by
`run_onchange_after_996_install_shared_agent_tools.sh.tmpl`, where
`run_once_220` also puts the `gh` binary itself under `/opt/relaxdiego`.
Every shim reads `$HOME/.config/gh-org-tokens`, so each user gets only its
own tokens.

Three rules hold this together. **The boundary is the `0700` home** — nothing
else. Guests share the kernel, the network, and `/proc`, so never put a
secret in a command line, and never run an unauthenticated service on
localhost. **The owner's `chezmoi apply` owns every host-wide install and
mode**; `guest add` owns nothing outside a guest's home and only warns when
something host-wide is missing, so each mode is defined in one place.
**Never put a guest in `sudo`, `docker`, or any other root-equivalent
group** — a root daemon it can talk to is a way out of the boundary.

`guest add` also writes the agent instruction files into each guest —
`.claude/CLAUDE.md`, `.codex/AGENTS.md`, `.pi/agent/AGENTS.md`,
`.config/AGENTS.md` — from the same `.chezmoitemplates/AGENTS.md` the owner's
copies use, plus `~/.local/share/agent-docs/`. After editing either source,
run `guest sync` to push it to every guest. If you add a new consumer of that
template for the owner, add it to `write_managed_files` in the guest script
too.

## Conventions

- History goes straight to `main`. Do not open PRs unless asked.
- Make surgical changes and match the style of the file you touch.
- The repo is public — never commit secrets, tokens, or host-identifying data.
  Secrets are pulled from 1Password at apply time (see the `.tmpl` files), not
  stored here.
