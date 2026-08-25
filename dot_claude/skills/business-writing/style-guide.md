# Business writing style guide

Use this guide for workplace text: email, chat message, status update,
decision memo, proposal, meeting notes, and incident or customer notice. The
base rules in `../clear-writing/style-guide.md` apply in full and are not
repeated here. Read that file first. Your reader is busy, and English may not
be their first language.

## Structure

### The point first

- **B1** State the ask in the first two lines, before any background.
  - Before: "After last week's review, Friday looks possible to us."
  - After: "Please approve the Friday launch. Reply by Wednesday."
- **B2** Give the ask its own line. Never bury it inside a paragraph.
- **B3** Name a deadline with a date and a time.
  - Before: "Get this sorted soon." — After: "Approve it by Thursday, 5pm."
- **B4** Say what happens if the reader does nothing.
  - Before: (no default) — After: "No reply by Friday means I book the room."
- **B5** Make the subject line or headline carry the point.
  - Before: subject "Update" — After: subject "Deploy done, no problems"
- **B6** Make one ask per message. Two unrelated asks means two messages.
- **B7** Put the ask in a form the reader can answer at once: yes, no, a date.

### Make it easy to act

- **B8** Name the one person who must act, not a group.
- **B9** Say why the message matters to the reader, not to you.
  - Before: "We are changing the deploy process."
  - After: "The new deploy process stops your Friday deploys from blocking."
- **B10** Cut background that does not change the decision. Link to it.
- **B11** Put the key word first in every heading and every bullet.
  - Before: "Things to know about the policy" — After: "New policy: three
    changes start Monday"
- **B12** Use bold for a lead-in label only, never for emphasis.
  - Why: when many words are bold, no word stands out.

### Pick a structure pattern

- **B13** Use BLUF when the reader must act soon: request, status, incident.
- **B14** Use SCQA when the recommendation is not obvious: proposal, strategy.
- **B15** Use Smart Brevity for a broadcast many readers skim: a newsletter.
- **B16** Use a narrative memo when one person decides and needs your reasoning.
- **B17** Pick the shorter pattern when two patterns fit.

#### BLUF, or bottom line up front

- **B18** Skeleton: bottom line / detail, most important first / background.
- **B19** Write the bottom line as one sentence the reader can act on alone.
  - Before: "It was decided to delay the launch." — After: "We moved the
    launch to Friday."
- **B20** Order everything after the bottom line from most to least important.

#### SCQA, or the pyramid

SCQA stands for situation, complication, question, answer.

- **B21** Skeleton: situation / complication / question / answer / support.
- **B22** Keep the situation to facts the reader already agrees with.
- **B23** State the complication as one change or one problem, not a list.
- **B24** Group the support under the answer by logic, not by order of thought.

#### Smart Brevity

- **B25** Skeleton: headline / bold lede / why it matters / bullets / link.
- **B26** Keep the headline to about six words, and put the news in it.
  - Before: "Quarterly Migration Project Status Update" — After: "Migration
    finishes two weeks early"
- **B27** Link out for background instead of expanding it inline.

#### Narrative memo

- **B28** Skeleton: context / goals / options / recommendation / risks /
  appendix.
- **B29** Write full sentences under each heading, not slide bullets.
  - Why: bullets hide the logic that ties the facts to the conclusion.
- **B30** Move data tables and long detail to the appendix.
- **B31** Put the decision and the deadline at the top, even in a memo.

### Length

- **B32** Match reading time to the decision, not to how much you know.
- **B33** Turn a message that needs a table of contents into a linked document.

## Kinds of message

### Email

Send a request or a fact to someone who does not need it this minute, and
leave a record. Template: `subject / the ask / detail / sign-off`

- **K1** Cover one topic per email. A second topic gets its own email.
  - Why: an email with mixed topics gets a partial reply.
- **K2** Make the subject line name the topic and the action.
  - Before: "Quick question" — After: "Budget approval needed by Friday"
- **K3** State the ask in the first two sentences.
- **K4** Reply to the sender alone, unless every reader needs your answer.
- **K5** Use Cc for people who need to know, not to act. A reply is optional.
- **K6** Check that the subject still matches the text before you send.

Most common mistake: three unrelated asks, so only the first gets an answer.

### Chat message

Get a fast answer from someone who is probably at their desk now. Template:
`one message: greeting + the full question + the context`

- **K7** Put the whole question in the first message. Never send a greeting
  alone and wait.
  - Before: "Hi" ... "can you check the deploy?" — After: "Hi, can you check
    the deploy? It fails on the test system."
- **K8** Include the context the reader needs to answer without asking back.
- **K9** Reply inside the thread of the message you answer.
- **K10** Move to a call when a few rounds of messages settle nothing.
- **K11** Mention one person when one person needs to read it, not everyone.

Most common mistake: a bare greeting, which doubles the wait for no reason.

### Status update

Tell the people who depend on the work what changed, so they stop asking.
Template: `state / what changed / what is next / blockers / the ask`

- **K12** Keep changes, next steps, blockers, and the ask in separate sections.
- **K13** Give every blocker an owner and one line on what unblocks it.
- **K14** Give every next step one named owner and one date.
  - Before: "Continuing work on the migration" — After: "Migration: Dana
    finishes it by Thursday."
- **K15** Define red, amber, and green in writing before you use them.
- **K16** Keep the update under a minute to read. Longer is a report.
- **K17** End with the ask when you need something.

Most common mistake: blockers mixed into the progress notes, and so hidden.

### Decision memo

Get one decision, from one person, by one date. Template: `decision needed /
by when / by whom / context / options / recommendation`

- **K18** State the decision, the decider, and the deadline in the first lines.
  - Before: three paragraphs of history — After: "Sam decides go or no-go on
    the new supplier by Friday."
- **K19** Give the context in two to four lines: why the decision is needed now.
- **K20** List every option, including doing nothing, with its real trade-off.
- **K21** Give every option the same level of detail.
  - Why: uneven detail signals a fake choice.
- **K22** State your recommendation and its main reason, apart from the options.
- **K23** Say what happens if no decision arrives by the deadline.

Most common mistake: one real option beside two weak ones, so the choice is
not real.

### Proposal

Convince a reader further from the work to approve a plan, a spend, or new
work. Template: `problem / approach / cost / what we need from you`

- **K24** Open with the problem in the reader's terms, before your solution.
- **K25** State what you ask for on one line: money, a person, or approval.
- **K26** Put a number on the cost and the benefit. Say plainly when you cannot.
  - Before: "This will save a lot of time." — After: "This should save about
    five hours a week. We have not tested that yet."
- **K27** Show at least one alternative you rejected, and why.
- **K28** Say what the current situation costs if nobody approves.
- **K29** Keep the reading time shorter than the decision it supports.

Most common mistake: a solution with no cost and no rejected alternative.

### Meeting notes

Leave a record of what was decided, who owes what, and what is still open.
Template: `decisions / action items with owner and date / open questions`

- **K30** Record what was decided, not the discussion that led to it.
- **K31** Give every action item one named owner and one date.
  - Before: "Follow up on pricing" — After: "Follow up on pricing: Dana, by
    Wednesday."
- **K32** List open questions apart from action items; they have no owner yet.
- **K33** Write so that a person who missed the meeting knows the outcome.
- **K34** Send the notes the same working day.
- **K35** Say plainly when nothing was decided.
  - Before: (silence) — After: "No decision. We return to this on Tuesday."

Most common mistake: a record of who said what, which buries the decisions.

### Incident or customer notice

Tell affected people what is happening, without hiding it and without
guessing. Template: `what happened / who is affected / what we are doing /
next update at a named time`

- **K36** State what happened and who is affected in the first two lines.
- **K37** Name the time of the next update. Send then, even with no news.
- **K38** State only confirmed facts. Do not name a cause before you confirm it.
  - Before: "This was probably a bad deploy." — After: "We are still looking
    for the cause."
- **K39** Own the problem, even when a supplier caused it.
- **K40** Say plainly whether data or security was affected.
- **K41** Match how often you write to how bad it is. Say when it is over.

Most common mistake: naming a cause before it is confirmed.

## Register

Match the message to the reader. The ask stays the same; the framing changes.

| Reader | Length | Detail | The ask | Context |
| --- | --- | --- | --- | --- |
| Peer | Short | Only what they need to act | Direct: "Can you review this by Thursday?" | Little; you share the background |
| Manager | Short to medium | State, risk, decision needed | Direct, with a date: "I need a decision by Friday" | Enough to justify the ask |
| Client | Medium | More framing; define internal terms | Clear and formal: "Please confirm by Friday so we can start" | Enough that no follow-up question is needed |
| Executive | Very short | The decision or the number, not the process | One line, at the top, with the stakes | Almost none; link to the detail |

- **R1** Cut length and move detail out as the reader gets more senior or more
  external. Do not make the sentences longer.
- **R2** State the ask just as clearly at every level of formality. Formality
  changes word choice, not whether you state the ask.

## Tone

- **R3** Use one polite phrase, not three.
  - Before: "I hope this finds you well. Do you maybe have a moment?"
  - After: "Could you look at this by Thursday?"
- **R4** Delete a filler opener and a filler closer.
- **R5** State bad news in the first two lines, then the cause and the fix.
  - Before: a long preamble, then "we missed the date" — After: "We missed the
    date. Here is why, and here is the new date."
- **R6** State a disagreement plainly. Give a reason and an alternative.
  - Before: "I am not sure that is a good idea." — After: "I disagree. This
    risks data loss. I suggest we do B instead."
- **R7** Critique the work, not the person.
  - Before: "Your plan has problems." — After: "This plan has a scheduling
    risk we should fix."
- **R8** Hedge only if you would bet against your claim. Say what is unsure.
  - Before: "This might maybe work, I think." — After: "This should work. I
    have not tested it under load."
  - Why: S27 (base) cuts a hedge you do not mean. A hedge you do mean is
    information, so make it carry the reason.
- **R9** Never hedge a claim you checked. State it, and name the check.
  - Before: "This should be fixed now." — After: "This is fixed. The test
    suite passes."
- **R10** Apologize once, in one sentence, then move to the fix.
  - Before: "I am so sorry, I know this is bad, I apologize again." — After:
    "Sorry for the delay. Here is the fix and the new date."
- **R11** Delete a conditional apology. Say what went wrong instead.
  - Before: "Sorry if this caused any issues." — After: "This broke the export
    for two hours."
- **R12** Name a third person by name and role on first mention, then use one
  term for that person (W8, base).
  - Before: "Dana", then "the project manager", then "she" — After: "Dana
    Reyes, the project manager", then "Dana" everywhere.
- **R13** Raise a concern to a senior reader as a direct question.
  - Before: (say nothing) — After: "Would the missing backup be a problem?"
- **R14** Use one "please" or one "could you" in a request to a person. Never
  stack them (see R3).
  - Why: S16 (base) drops "please" from instructions in a document. A request
    to a person is not an instruction, so one courtesy word stays.

### Openers and closers to delete

| Do not write | Write |
| --- | --- |
| I hope this email finds you well. | (delete it; start with the ask) |
| Just circling back. | I still need the budget number by Thursday. |
| Just checking in. | Do you have an answer on the supplier? |
| Thanks so much in advance! | Thanks. |
| Let me know your thoughts. | Reply yes or no by Friday. |
| Sorry if this caused any issues. | This broke the export for two hours. |

## Review checklist

Run this before you send any text. Fix every hit.

- [ ] The ask and the deadline appear in the first two lines (B1, B3).
- [ ] The message makes one ask, on its own line (B2, B6).
- [ ] The text says what happens if the reader does nothing (B4).
- [ ] The subject line or headline carries the point (B5).
- [ ] Every next step and action item names one owner and one date (K14, K31).
- [ ] Options carry equal detail, and doing nothing is one of them (K20, K21).
- [ ] An incident notice names the next update time and states only confirmed
      facts (K37, K38).
- [ ] No filler opener or closer, and any apology is one sentence (R4, R10).
- [ ] Every hedge passes the bet test and says what is unsure (R8).
- [ ] The answer or conclusion comes first (O1, base).
- [ ] Every sentence is under 26 words (S4, base).
- [ ] Every request carries at most one "please" or "could you" (R14).
- [ ] One term per concept, and one term per person (W8, base).
- [ ] No idiom, slang, metaphor, or exclamation mark (W9, base).

## Sources and licenses

Every rule here is restated in our own words, not copied.

| Source | URL | License |
| --- | --- | --- |
| BLUF, from Army Regulation 25-50, via Wikipedia | https://en.wikipedia.org/wiki/BLUF_(communication) | Public domain (US government work) |
| Minto pyramid principle and SCQA, via a summary | https://thinkinsights.net/strategy/scqa-logic | Copyrighted; restated |
| Rogers and Lasky-Fink, *Writing for Busy Readers* | https://writingforbusyreaders.com | Copyrighted; restated |
| Smart Brevity, by Axios HQ | https://www.axioshq.com/research/smart-brevity-communication-checklist | Copyrighted; restated |
| Amazon narrative memo, from secondary write-ups | https://www.anecdote.com/2018/05/amazons-six-page-narrative-structure/ | Copyrighted; restated |
| GOV.UK content design guidance | https://www.gov.uk/guidance/content-design/writing-for-gov-uk | Crown copyright, Open Government Licence v3.0 |
| Federal Plain Language Guidelines | https://digital.gov/guides/plain-language/ | Public domain |
| Mailchimp Content Style Guide | https://styleguide.mailchimp.com/voice-and-tone/ | CC BY-NC 4.0 |
| nohello.net | https://www.nohello.net/en/ | No license stated; restated |
| Atlassian Statuspage, incident communication | https://support.atlassian.com/statuspage/docs/incident-communication-tips/ | No license stated; restated |
| Slack etiquette and threads | https://slack.com/blog/collaboration/etiquette-tips-in-slack | No license stated; restated |

For every other source, see `../clear-writing/style-guide.md`.

### Where sources disagree

| Topic | Resolution |
| --- | --- |
| Narrative memo against bottom line first | B16 and B31: use the memo only when the reader must follow the reasoning, and still put the decision and deadline at the top |
| Memo sections against pure prose | B28 fixes one section list, and B29 keeps full sentences inside each section, so the agent does not choose |
| Amazon memo has no published spec, and the decision-memo source could not be read | Treated as a convention from secondary write-ups. K18 to K23 follow it. No page count is a rule; B32 uses reading time instead |
| Six-word Smart Brevity headline | Reported, not confirmed at the source. B26 makes it a target, "about six words", not a limit |
| AR 25-50 and GOV.UK could not be fetched directly | BLUF is kept, because GOV.UK, Axios, and *Writing for Busy Readers* reach it on their own. Of GOV.UK, only the parts that match the base guide are kept |
| Two of the six *Writing for Busy Readers* principles are names only | The two well-sourced ones became B7 and B9. The two unverified ones were dropped |
| Incident update every 30 minutes | Not universal. K37 and K41 ask for a named time and a cadence matched to severity, with no fixed number |
| One topic per email | Sourced to the Federal Plain Language Guidelines, not to Mailchimp |
| When to leave chat for a call | No authoritative number exists. K10 says "a few rounds", stated as judgment |
