# Technical writing style guide

Use this guide for any technical prose: README, runbook, how-to guide,
reference page, design note, ADR, AGENTS.md, docstring, code comment, error
message, CLI help. The base rules in `../clear-writing/style-guide.md` apply
in full and are not repeated here. Read that file first, then this one.

## Pick the document kind

Diátaxis sorts documents with two questions about the reader's need. Ask about
the need, not about the topic.

| The reader needs | The reader is | Kind |
| --- | --- | --- |
| To act | Learning a new skill | Tutorial |
| To act | Applying a skill they have | How-to guide |
| To understand | Studying | Explanation |
| To understand | Working, and needs a fact now | Reference |

- **D1** Name the reader and what they must be able to do after reading,
  before you write a word.
- **D2** Pick one cell of the table, then write only that kind.
- **D3** Split a document that fills two cells into two documents.
- **D4** Link between kinds instead of putting one inside another.

### Tutorial

Teach a beginner a skill by walking them through a real task that works.

- **D5** Write one path, with no options and no decision points.
- **D6** State up front what the reader will build.
- **D7** Give the exact command and the exact expected result for each step.
- **D8** Run the whole path yourself so the reader never hits an error.
- **D9** Move every "why" into an explanation and link to it.
- **D10** Keep the scope small enough to finish in one sitting.

Headings: what you will build / what you need first / step 1 … step N / what
you accomplished / where to go next.

### How-to guide

Help a reader who already has the basic skill finish one real task.

- **D11** Name the exact task in the title.
  - Before: "Database credentials" — After: "Rotate database credentials"
- **D12** Assume the basics; do not re-teach them.
- **D13** Cover the real variations: "If you use X, do Y instead."
- **D14** Cover one goal per guide.
- **D15** Link to reference for full option lists, and to explanation for
  background.
- **D16** End with a check the reader can run to confirm it worked.

Headings: title (starts with a verb) / before you start / steps / verify /
related guides.

### Reference

Describe the system so a working reader can look up a fact and trust it.

- **D17** Describe only. Do not instruct, and do not argue.
- **D18** Mirror the real system: same names, same order.
- **D19** Use the same entry template for every entry, so readers can scan.
- **D20** Keep examples minimal. An example illustrates a fact, not a workflow.
- **D21** Update the facts whenever the system changes.

Headings per entry: name / one-line description / signature, parameters, or
fields / behavior and return values / minimal example / related entries.

### Explanation

Help the reader understand the topic, away from the keyboard.

- **D22** Answer "why" and "how does this fit together", not "how do I".
- **D23** Give context, alternatives, and tradeoffs. An opinion is allowed
  here, and only here.
- **D24** Set a scope, so the piece has a natural end.
- **D25** Keep steps and lookup tables out.

Headings: the concept / background / the reasoning / alternatives and
tradeoffs / related concepts.

### Do not mix

- **D26** Move background out of a how-to guide into an explanation, and link.
  - Why: a reader who wants to finish a task gets stuck reading theory.
- **D27** Move a walkthrough out of reference into a tutorial or how-to guide.
- **D28** Move alternatives out of a tutorial into a how-to guide.
- **D29** Write a shared fact once in reference, and link to it from every
  guide that needs it.

### How this maps to real files

- **D30** README: four short slices, each true to its kind. "Get started" is
  a mini tutorial, "usage" is how-to, "configuration" is reference, "why this
  exists" is explanation.
- **D31** Runbook: how-to guides, one per task or incident, plus the reference
  facts an on-call reader needs. No hand-holding, no design essays.
- **D32** AGENTS.md: reference (layout, conventions, commands) plus how-to for
  recurring tasks. Include rationale only when it changes what the agent does.
- **D33** CLI help: reference (flags, arguments, defaults) plus one or two
  example invocations. Point elsewhere for anything longer.
- **D34** Error message: the problem, then the fix. Nothing else.
- **D35** Code comment: explanation. Say why; the code already says what.
  - Before: "// increment i" — After: "// skip the header row"
- **D36** Design note or ADR: explanation. Context, decision, alternatives,
  consequences.

## Procedures and notices

- **T1** Ask whether a procedure is needed at all. One sentence may be enough.
- **T2** Add a first step that names where to start, when the place could be
  unclear.
- **T3** Name the place before the action.
  - Before: "Select Save in the Settings page" — After: "In the Settings
    page, select Save"
- **T4** Give one instruction per step. Combine two short actions only when
  they happen in the same place.
- **T5** Use a note only when the information is optional, skippable, and off
  the main flow.
- **T6** Never hide a prerequisite, a required step, or a cross-reference in a
  note.
- **T7** Use "Caution" for a risk you can undo, and "Warning" for one you
  cannot: data loss, cost, security exposure.
- **T8** Never stack two notices. Rewrite until one is enough.
  - Why: readers skim past callouts, so many notices make all of them
    invisible.

## Code, commands, placeholders, UI text, links

- **C1** Use code font for filenames, paths, commands, flags, function names,
  variable names, constants, environment variables, HTTP status codes, HTTP
  verbs, ports, and IP addresses.
- **C2** Do not use code font for product names, domain names, or a URL the
  reader visits in a browser.
- **C3** Never pluralize or conjugate a code element. Add a plain noun.
  - Before: "the ADDRESS's value" — After: "the value of the ADDRESS constant"
- **C4** Introduce a code block with a full sentence.
- **C5** Mark omitted code with a comment in that language, never with "...".
- **C6** Wrap code lines near 80 characters.
- **C7** Show the expected output, in prose after the block or as a comment.
- **C8** Comment the parts of an example that are not obvious. Do not narrate
  the obvious.
- **C9** Write example code that is safe to copy. Validate input, and never
  hardcode a credential.
- **C10** Show error handling only when error handling is the point.
- **C11** Run every example before you publish it.
- **C12** Never show code, a command, or output only as an image.
- **C13** Write placeholders as UPPERCASE_WITH_UNDERSCORES, and use one
  notation for the whole document.
  - Before: "deploy --name <service>" — After: "deploy --name SERVICE_NAME"
- **C14** Say what each placeholder must be replaced with.
- **C15** Put UI labels in bold, with the capitalization shown on screen. Drop
  a trailing colon or "...".
- **C16** Name a control by its label, not its icon.
  - Before: "Click the bell icon." — After: "Click Notifications."
- **C17** Do not locate a control by direction. Name it instead.
- **C18** Use "select" and "clear" for checkboxes, not "check" and "uncheck".
- **C19** Say "dialog", never "dialog box" or "pop-up".
- **C20** Spell out modifier keys: Control, Shift, Command.
- **C21** Put quotation marks around an error message you discuss in prose. In
  the message itself, use sentence case.
- **C22** Name the thing and the problem in an error message, then the fix.
  - Before: "Invalid input." — After: "Name is required. Enter a name."
- **C23** Write link text that makes sense on its own.
  - Before: "Click here for details." — After: "See the deployment guide."
- **C24** Never use a raw URL, "this document", or "this article" as link text.
- **C25** Put the important word first in link text, and keep the text short.
- **C26** Write "For more information, see X", not "on X".
- **C27** Say up front when a link downloads a file or leaves the site.
- **C28** Keep punctuation and quotation marks outside the link.
- **C29** Link one destination once per page, unless the page is long.

## Review checklist

Run this before you deliver any text. Fix every hit.

- [ ] The reader and their goal are named, at least in your own head (D1).
- [ ] The document is one kind, not two (D2, D3).
- [ ] Each step gives one instruction, and names the place first (T3, T4).
- [ ] No two notices stack, and no note hides a required step (T6, T8).
- [ ] Placeholders use one notation, and each says what to replace it with
      (C13, C14).
- [ ] Link text stands alone (C23, C24).
- [ ] Every command and example was run, and its output is shown (C7, C11).
- [ ] The answer, command, or conclusion comes first (O1, base).
- [ ] Every sentence is under 26 words (S4, base).
- [ ] Instructions are imperative, with no "please" or "you should"
      (S16, base).
- [ ] One term per concept, all the way through (W8, base).
- [ ] "for example" and "that is" replace e.g. and i.e. (W11, base).
- [ ] No "above" or "below" as a location (A2, base).

## Sources and licenses

Every rule here is restated in our own words, not copied.

| Source | URL | License |
| --- | --- | --- |
| Diátaxis, by Daniele Procida | https://diataxis.fr/ | CC BY-SA 4.0 |
| Google developer docs style guide | https://developers.google.com/style | CC BY 4.0; code Apache 2.0 |
| Microsoft Writing Style Guide | https://learn.microsoft.com/style-guide/ | CC BY 4.0; code MIT |

Diátaxis is the source for section D. Google and Microsoft are the sources for
sections T and C. For every other source, see `../clear-writing/style-guide.md`.

Where Google and Microsoft disagree, this guide follows Google, except where
Microsoft's rule helps readers whose first language is not English.

| Topic | Resolution |
| --- | --- |
| Placeholder notation | Google (C13): UPPERCASE_WITH_UNDERSCORES |
| UI verb | Google: use the device-specific verb (click, tap, press) |
