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

## Conventions

- History goes straight to `main`. Do not open PRs unless asked.
- Make surgical changes and match the style of the file you touch.
- The repo is public — never commit secrets, tokens, or host-identifying data.
  Secrets are pulled from 1Password at apply time (see the `.tmpl` files), not
  stored here.
