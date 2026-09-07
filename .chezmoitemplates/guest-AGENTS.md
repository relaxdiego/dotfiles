{{/*
The whole agent instruction document for a guest account: the guest preamble
plus the shared AGENTS.md the owner's own agents read. Rendered by chezmoi
into ~/.local/share/guest/, which `guest add` and `guest sync` copy into each
guest's home unchanged. Nothing composes this document at install time, so
the owner's copies and every guest's copy come off the same renderer.

Deliberately says nothing about which guest is reading it. One rendered file
serves every account, and the agent can run `whoami`.

The shared template is rendered with `guest` set on a copy of the context,
which drops the sections that only describe the owner's machine. deepCopy
keeps the owner's own render from seeing the flag. Nothing dropped that way
may carry a rule a guest still needs: *Keep Work Details Out Of Public Files*
is its own section, outside the guard, for exactly that reason.
*/ -}}
## You are a guest user

You are running as an unprivileged guest user on `{{ .chezmoi.hostname }}`;
`whoami` names the account. It exists so that each agent has its own
credentials. You cannot read the owner's home, and other guests cannot read
yours.

What is different here, compared to the sections below:

- **No sudo.** You cannot install host packages. Use
  `nix profile install nixpkgs#<pkg>` or devbox, which install into your own
  profile. If something really needs root, ask the owner in plain words.
- **The GitHub shims live under `/opt/relaxdiego/usr/local/bin/`**, not
  `~/.local/bin`, because they are shared by every user on this host. Their
  behaviour is exactly as described in `agent-docs/github-auth.md`, and they
  read *your* `~/.config/gh-org-tokens` — nobody else's.
- **Your tokens are yours.** Never copy a credential out of this account, and
  never ask the owner to paste theirs in.

{{ template "AGENTS.md" (set (deepCopy .) "guest" true) -}}
