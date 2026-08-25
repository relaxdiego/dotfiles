---
name: business-writing
description: |
  Draft and review workplace text so a busy reader gets the point and knows
  what to do. Use for an email, a chat message to a person, a status update,
  a decision memo, a proposal, meeting notes, or an incident or customer
  notice. Also use when reviewing such text. This skill builds on the
  clear-writing skill, which holds the base rules.
  NOT for technical docs - use the tech-writing skill. NOT for commit
  messages - those follow a separate commit standard. NOT for system prompts.
  Trigger: /business-writing
---

# Business writing

The goal is one thing: the reader decides or acts after one read. They know
what you want from them, and by when. Every rule in this skill serves that.

## Workflow

1. **Name the reader.** Write down who reads this, what role they hold, and
   the one thing you want from them. If you cannot name that one thing, you
   are not ready to write.
2. **Pick the kind and the pattern.** Pick the kind of message from section K
   of `style-guide.md`. Then pick the structure pattern with the decision
   rules B13 to B17. Do not pick a pattern by taste.
3. **Write, following both guides.** Read `../clear-writing/style-guide.md`
   first, then this skill's `style-guide.md`. Read the sections that apply
   before you write. Do NOT write from memory of either guide - the rules are
   specific and easy to half-remember.
4. **Run the Review checklist** at the end of `style-guide.md`. Fix every hit.
   The checklist is short on purpose; run all of it, every time.
5. **When reviewing someone else's text**, report findings as
   `rule ID - location - one-line fix`, most damaging first. Do NOT rewrite
   whole passages unless the author asks. A review that returns a rewrite
   teaches nothing and hides what was wrong.

## Hard rules

These are never bent. Rules marked "(base)" live in
`../clear-writing/style-guide.md`.

- **B1** The ask goes in the first two lines, before any background.
- **B4** Say what happens if the reader does nothing.
- **B5** The subject line or headline carries the point.
- **B6** One ask per message. Two unrelated asks means two messages.
- **R4** No filler opener and no filler closer.
- **R8** Hedge only if you would bet against your claim, and say what is
  unsure.
- **R10** One apology, one sentence, then the fix.
- **S4** (base) Under 20 words per sentence, and never over 26.
- **W1** (base) Plain words, B2 / 8th-grade level, for a non-native reader.
- **W9** (base) No idioms, metaphors, or culture-specific references.

## Anti-patterns

| Pattern | Why it fails |
| --- | --- |
| "I hope this finds you well" | The first line, the one everyone reads, carries no information |
| The ask in the last paragraph | The reader stops before the end and never learns what you want |
| A status update with no blockers section | The one fact the reader needed is buried in the progress notes |
| Options listed with the favorite padded | Uneven detail signals a fake choice, so the reader stops trusting the memo |
| Meeting notes that transcribe the discussion | The decisions and owners are lost inside the talk |
| An incident notice that guesses the cause | You take it back later, and the next notice is believed less |
| "Just checking in" | It repeats the old message without a new deadline or a new fact |
| A greeting sent alone in chat | The reader waits for the question, so the answer takes twice as long |

## The full guides

Two files, read in this order:

1. `../clear-writing/style-guide.md` - the base rules (O, P, S, W, A).
2. `style-guide.md` in this directory - structure and the point first (B),
   kinds of message (K), and register and tone (R), plus the review checklist
   and source attribution.

Rule IDs are shared across the clear-writing, tech-writing, and
business-writing skills, so an ID never means two things.
