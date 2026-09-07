## Gather Evidence Before Claims

**Verify what is cheap to verify. Label what you did not.**

- If checking is cheap (read the file, run the command), check before
  claiming, and cite the evidence: `file:line`, or the command and what it
  printed.
- If you did not check, label the claim "Inferred" (from what?) or
  "Assumed" (why is it unchecked?).
- Recalled knowledge about tools, libraries, or APIs may be stale or wrong.
  Verify against the installed version or its docs before stating it as fact
  about this machine.

Scope: these rules govern technical claims. Prose feedback, writing help, and
other non-engineering work keep a natural voice.

## Goal-Driven Execution

Turn the task into a verifiable goal before you start: "fix the bug" becomes
"write a test that reproduces it, then make it pass". For a multi-step task,
state a brief plan with a check for each step, then loop until every check
passes.

## Git

- Read `~/.local/share/agent-docs/commit-style.md` before writing a commit
  message. A `commit-msg` hook enforces it.
- **Never `git push` unless I explicitly say so.** Committing locally is
  fine; I can pull directly from this VM.
{{- if and (hasKey . "agent") .agent }}
- `git` and `gh` authenticate with one token per GitHub org. Read
  `~/.local/share/agent-docs/github-auth.md` before cross-org GitHub work.
  Short version: pass `-R <org>/<repo>` to `gh` when the target repo is not
  the current checkout's org.
{{- end }}

## Git Worktrees

Repos under `~/src` use a bare + worktree layout, one directory per branch.
Read `~/.local/share/agent-docs/worktrees.md` before creating or removing a
branch there. The chezmoi source directory is a normal clone; do not worktree
it.

## My Dotfiles Are Public

**The chezmoi source (`~/.local/share/chezmoi`) is a public GitHub repo.**
Every file it manages is published to the world. That includes this file,
`~/.claude/CLAUDE.md`, `~/.local/share/agent-docs/`, and much of `~/.config`.

**Never write work or client details into a chezmoi-managed file.** No
employer or client names, internal hostnames, repo or service names, cloud
account IDs, ARNs, ticket IDs, customer data, credentials, or internal URLs.

To check before you edit a file under `~`:

```sh
chezmoi source-path <file>   # if it resolves, the file is PUBLIC
```
