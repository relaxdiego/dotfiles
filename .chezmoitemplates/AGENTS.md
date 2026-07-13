**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 0. Language

**English is not my first language. Write clearly and simply.**

- Use plain, everyday words. Avoid idioms, slang, and figures of speech.
- Aim for roughly a B2 / 8th-grade reading level.
- Prefer short sentences — one idea per sentence.
- Explain technical terms the first time you use them.
- Skip chit-chat openings; get to the point.
- Understand what I mean despite small grammar mistakes — don't stop to correct
  me unless the meaning is genuinely unclear.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

## 5. Git Messages

**Commit messages follow a fixed standard: Conventional Commits + Linux-kernel
style.** Read `~/.local/share/agent-docs/commit-style.md` before writing a
commit message; a `commit-msg` hook enforces the structure. In short:
`type(scope): summary` — lowercase, imperative, 72 chars max.

- **Never add Claude/Anthropic attribution.** No `Co-Authored-By: Claude`
  trailer on commits; no "Generated with Claude Code" line in PR bodies.
- In a team repo, follow that repo's own commit config instead.
{{ if and (hasKey . "agent") .agent }}
**Never `git push` unless I explicitly say so.** Committing locally is
fine. I can pull directly from this VM, so pushing to origin is not
needed to share work — wait for an explicit push instruction.
{{ end }}
## 6. Git Worktrees

**Repos under `~/src` use a bare + worktree layout, one directory per
branch, where the directory name IS the branch name.** Read
`~/.local/share/agent-docs/worktrees.md` before creating a branch or
cleaning one up there. In short: never `git checkout -b` inside a worktree —
run `git worktree add ../<branch-dir> -b <branch> origin/main` instead, and
`git worktree remove` when done.

- The chezmoi source directory is a normal clone. Do not worktree it.

## 7. My Dotfiles Are Public

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

Work-specific notes belong in the private work repo they describe — in its
`AGENTS.md` or `docs/` — not in my dotfiles. If I ask you to "remember"
something work-specific, put it there, or in your own memory directory, and
say which you chose.
{{ if and (hasKey . "agent") .agent }}
## 8. Machine Notes

Tool-specific setup notes for this machine live in
`~/.local/share/agent-docs/` — read the matching note before
troubleshooting a tool. Current notes:

- `commit-style.md` — the commit message standard (see section 5). Read it
  before writing any commit message.
- `github-auth.md` — `git` (HTTPS) and `gh` authenticate automatically
  with one token per GitHub org. Read it before any cross-org GitHub
  work; short version: pass `-R <org>/<repo>` to `gh` when the target
  repo is not the current checkout's org.
- `worktrees.md` — the bare + worktree layout of repos under `~/src`
  (see section 6). Read it before creating or removing a branch there.
{{ end }}
