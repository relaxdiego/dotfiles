# GitHub auth on this machine

This machine holds one fine-grained GitHub PAT per org, in
`~/.config/gh-org-tokens` (mode 600; one `<org>=<token>` line each, plus
an optional `default=<token>`). Never print the token values. To see
which orgs have tokens: `cut -d= -f1 ~/.config/gh-org-tokens`.

Two shims pick the right token automatically:

- **`git` over HTTPS** — the credential helper
  `~/.local/bin/git-credential-gh-org` (wired in `~/.gitconfig` with
  `useHttpPath = true`) takes the org from the URL path. Clone, fetch,
  and push against `https://github.com/<org>/<repo>` just work for any
  org that has a token. SSH remotes are NOT authenticated on this
  machine — always prefer HTTPS remote URLs.
- **`gh`** — `~/.local/bin/gh` is a wrapper script that shadows the real
  binary on PATH and exports `GH_TOKEN` for that one command. It resolves
  the target org from, in order: a `-R/--repo` flag, a
  `gh api repos/<org>/...` path, a `gh repo <cmd> <org>/<repo>`
  positional, then the current repo's origin URL.

Practical rules:

- Inside a repo checkout, plain `gh pr ...` / `gh issue ...` works; the
  token is picked from origin.
- When targeting a repo in a DIFFERENT org than the current checkout,
  always pass `-R <org>/<repo>` so the wrapper picks that org's token.
- An already-exported `GH_TOKEN` wins; the wrapper does not override it.
- `gh auth ...` commands are never wrapped. Do not run
  `gh auth setup-git` — the git credential helper owns HTTPS credentials.
