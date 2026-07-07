# Commit message standard

Commits on this machine follow **Conventional Commits + Linux-kernel style**.
A `commit-msg` git hook enforces the structure (see "Enforcement" below).

## Format

```
type(scope): summary

optional body — what and why, wrapped at 72 columns

optional footers
```

- **Blank line** between subject, body, and footers.
- **Summary**: imperative mood ("add", not "added"/"adds"), lowercase first
  letter (unless a proper noun), no trailing period, 50 chars target / 72 hard
  max.
- **Body** (optional): explain *what* and *why*, not *how*. Wrap at 72.

## Types

`build chore ci docs feat fix perf refactor revert style test`

## Scope

Optional. In personal repos, use the area you touched: `tmux`, `git`, `nvim`.
Matches existing history like `tmux: move ssh-split debug log out of /tmp`
(now written `chore(tmux): move ssh-split debug log out of /tmp`).

## Breaking changes

Mark with `!` after the type/scope, or add a `BREAKING CHANGE:` footer:

```
feat(api)!: drop v1 auth endpoint
```

## Footers

- `Refs:`, `Fixes #123`, `BREAKING CHANGE: ...` as needed.
- `Signed-off-by:` **only in repos that require DCO** (Developer Certificate of
  Origin). This is a legal attestation of origin, not the same as the
  cryptographic signature git already adds. Omit it everywhere else — it is
  noise. `git commit -s` (alias `git cs`) adds it when you need it.
- **Never** `Co-Authored-By: Claude` or "Generated with Claude Code". This
  applies to all repos and PR bodies.

## Examples

Good:

```
fix(ssh-split): reconnect only into the agent VM subnet
feat(nvim): add spell files for offline use
refactor(tmux): query remote for cwd instead of OSC 7
```

Bad:

```
Fixed the ssh bug.          # past tense, capitalized, no type, trailing period
update tmux config          # no type
feat: Added new feature     # past tense, capitalized description
```

## Enforcement

A `commit-msg` hook (installed via `~/.git-template/hooks`, so it lands in
newly cloned or `git init`'d repos) checks each message:

- **Blocks** on structure: missing/unknown type, subject over 72 chars,
  trailing period, or any Claude/Anthropic attribution line.
- **Warns** (but allows) on mood: a non-imperative leading word, a capitalized
  description, or a body line over 72.
- **Defers** entirely in repos that already validate with
  `conventional-pre-commit` — that repo's config is the authority.

## Team repos

In a team repo, follow *that repo's* commit config, not this file. Example:
`LF-Certification/p3-forge` enforces Conventional Commits with
`conventional-pre-commit` and feeds `git-cliff` for changelogs and semver tags.
Output that passes this standard also passes those checks, since this standard
is a stricter superset.
