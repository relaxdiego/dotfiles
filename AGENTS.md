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

## Files pulled from other repos

`.chezmoiexternal.toml` fetches a file straight from another repository at
apply time, so nothing is vendored into this source tree. It follows the same
rule as the install scripts: an exact commit in the URL and a `sha256`
checksum beside it, bumped together or not at all.

There is no entry today.

`dot_claude/modify_settings.json` selects Claude Code's output style with
`outputStyle`. It names `Concise`, one of the styles built into the binary, so
nothing is installed for it and no other file has to agree on the name.

`run_after_995_note_output_style.sh` reports a change in the closing banner. It
compares the applied state against a stamp in
`~/.local/state/chezmoi/claude-output-style` rather than hashing the source,
because `/output-style` inside Claude Code edits `settings.json` and the next
apply puts it back; a `run_onchange_` script would never see that. The stamp is
the style's name and the hash of its file, and a built-in has no file, so
`Concise` stamps as `Concise missing`.

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

`guest add` also writes the agent instruction files into each guest:
`.claude/CLAUDE.md`, `.codex/AGENTS.md`, `.pi/agent/AGENTS.md` and
`.config/AGENTS.md`. It does not build that document. chezmoi renders it
during the owner's apply, from `.chezmoitemplates/guest-AGENTS.md`, which is
the guest preamble followed by the same `.chezmoitemplates/AGENTS.md` the
owner's own copies use. The result lands in `~/.local/share/guest/` as
`CLAUDE.md` and `AGENTS.md`, differing only in their H1, and the guest script
copies whichever one a destination wants byte for byte. So a wording change
goes in one of the two templates, never in the script, and the guest preamble
names no particular guest: one rendered file serves every account.

That wrapper renders the shared template with `guest` set on a `deepCopy` of
the context, so a section describing only the owner's machine can be dropped
from a guest's copy with `{{ if not .guest }}`. *My Dotfiles Are Public* is
the one that is, since a guest has no chezmoi and no part in the dotfiles
repo. Before putting anything behind that guard, check that no rule a guest
still needs is inside it. The rule about work and client details is its own
section for that reason, *Keep Work Details Out Of Public Files*, sitting
outside the guard and ahead of the chezmoi-specific part only the owner sees.

The notes those instructions point at, `~/.local/share/agent-docs/`, go into
the guest from the owner's source as well, and so does
`.bashrc.d/046_worktree.bashrc`, because the *Git Worktrees* section describes
a layout that only its `clone` function builds. `guest add` appends the
`.bashrc.d` loop to the guest's `/etc/skel` copy of `.bashrc`, below the early
return that `.bashrc` takes for non-interactive shells. So `clone` reaches an
interactive login and not an agent's tool calls, which is exactly its
behaviour on the owner's account: check with `type -t clone` before assuming
it is there.

After editing any of these, run `chezmoi apply` and then `guest sync` to push
it to every guest. If you add a new consumer of the shared template for the
owner, add it to `write_managed_files` in the guest script too.

## Conventions

Follow these in every change:

- History goes straight to `main`. Do not open PRs unless asked.
- Make surgical changes and match the style of the file you touch.
- The repo is public — never commit secrets, tokens, or host-identifying data.
  Secrets are pulled from 1Password at apply time (see the `.tmpl` files), not
  stored here.
