---
name: clear-writing
description: |
  Base rules for any prose a reader must act on. Use alone for a PR
  description, a chat reply, a summary, a note, a code review comment, or any
  text no other writing skill claims. The tech-writing and business-writing
  skills build on it - do not load this one when one of those fits better.
  NOT for commit messages - those follow a separate commit standard.
  Trigger: /clear-writing
---

# Clear writing

The goal is one thing: a reader whose first language may not be English can
act on the text on the first read. Not the second read, and not after asking
the author. Every rule in this skill serves that.

## Workflow

1. **Name the reader.** Write down who reads this and what they must be able
   to do after reading. If you cannot name it, you are not ready to write.
2. **Write, following `style-guide.md`.** Read the sections that apply before
   you write. Do NOT write from memory of the guide - the rules are specific
   and easy to half-remember.
3. **Run the Review checklist** at the end of `style-guide.md`. Fix every hit.
   The checklist is short on purpose; run all of it, every time.
4. **When reviewing someone else's text**, report findings as
   `rule ID - location - one-line fix`, most damaging first. Do NOT rewrite
   whole passages unless the author asks. A review that returns a rewrite
   teaches nothing and hides what was wrong.

## Hard rules

These are never bent.

- **O1** Front-load the answer. The conclusion or the command comes first.
- **S1** A real actor is the subject; the action is the verb.
- **S4** Under 20 words per sentence, and never over 26.
- **S7** Active voice by default. Passive only under the three tests in S8.
- **W1** Plain words, B2 / 8th-grade level, for a non-native reader.
- **W8** One term per concept, all the way through the document.
- **W9** No idioms, metaphors, or culture-specific references.
- **W11** Write "for example" and "that is". Never "e.g." or "i.e."
- **W17** Second person for the reader. Third person for the software.

## Anti-patterns

| Pattern | Why it fails |
| --- | --- |
| "Simply", "just", "easily" | Adds nothing, and mocks the reader when the step fails |
| Long chains joined by "which" and "that" | The reader loses the subject and re-reads the sentence |
| Nominalizations ("perform an analysis") | Hides the verb, so the action is harder to picture and to check |
| Mixing "you" and "the user" | The reader has to work out whether both mean them |
| Passive voice with no actor named | Nobody knows who must act, which is fatal in an instruction |
| A synonym swapped in for variety | The reader assumes a new term means a new thing |

## The full guide

`style-guide.md` in this directory. It holds every base rule with its ID, the
substitutions table, before/after examples, the review checklist, and source
attribution. Rule IDs are shared across all the writing skills, so an ID never
means two things.
