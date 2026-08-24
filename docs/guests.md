# How the guest shims are installed

This note covers Linux agent machines only. The "Guest users" section of
`AGENTS.md` holds the rules. This note holds the plumbing behind them.

`/opt/relaxdiego/usr/local/` is the host-wide prefix. It exists because a
guest's `0700` home cannot see the owner's home, so anything every user needs
must live outside both.

The GitHub shims, `git-credential-gh-org` and `gh`, live in
`.chezmoitemplates/`. They contain no chezmoi data, on purpose, so one source
serves every user. From that one source, `chezmoi apply` installs them twice:

- Into the owner's `~/.local/bin`, on agent machines only. On other machines
  `.chezmoiignore` drops them.
- Host-wide, by `run_onchange_after_996_install_shared_agent_tools.sh.tmpl`.
  `run_once_220_install_github_cli.sh.tmpl` also puts the `gh` binary itself
  under `/opt/relaxdiego`.

Every shim reads `$HOME/.config/gh-org-tokens`, so each user gets only its own
tokens.
