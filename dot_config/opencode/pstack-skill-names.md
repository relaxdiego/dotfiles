# pstack skill names in opencode

pstack's session-start mandate is written for Claude Code, where its skills are
namespaced by the plugin. It tells you to invoke `pstack:poteto-mode`, and no
such skill exists here.

opencode registers a skill under the bare `name:` in its own frontmatter. Drop
the `pstack:` prefix from every id the mandate names, and load it with the
`skill` tool:

| The mandate says | Load this |
| --- | --- |
| `pstack:poteto-mode` | `poteto-mode` |
| `pstack:tdd` | `tdd` |
| `pstack:architect` | `architect` |
| `pstack:how` | `how` |
| `pstack:why` | `why` |
| `pstack:arena` | `arena` |
| `pstack:interrogate` | `interrogate` |

The same rule covers every other skill the corpus cites, and the `/pmode`
command already uses the bare name.

The skills themselves are written against Claude Code's tool names. Where one
names a tool opencode does not have, use opencode's equivalent: `task` for
subagents, `skill` for loading another skill. A model id in `models.json` or in
a skill body is a Claude Code slug, so it needs a provider prefix here.
