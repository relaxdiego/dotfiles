# Clear writing style guide

Use this guide for any prose a reader must act on. Assume the reader's first
language may not be English. Aim for a B2 / 8th-grade reading level. Every
other writing skill builds on this file and does not repeat it. Each rule has
an ID, so a review can say "violates S4".

## Organize the document

- **O1** Front-load the answer. Give the conclusion or the command first, then
  the detail.
- **O2** Summarize a long document in its first paragraph.
- **O3** Put one idea in one section. If the heading needs "and", split it.
- **O4** Give each document exactly one H1.
- **O5** Do not skip heading levels.
- **O6** Use sentence case for headings ("Set up the database").
- **O7** Start a task heading with a plain verb.
  - Before: "Creating an instance" — After: "Create an instance"
- **O8** Use a noun phrase for a heading that explains rather than instructs.
- **O9** Name the content in the heading.
  - Before: "Details" — After: "How retries are counted"
- **O10** Never put a link inside a heading.
- **O11** Never leave a heading with no text under it.
- **O12** Define an abbreviation used in a heading in the paragraph that
  follows it.
- **O13** Use a numbered list only when the order matters.
- **O14** Use a bulleted list when the order does not matter.
- **O15** Introduce every list and every table with a full sentence.
- **O16** Keep list items parallel in grammar.
- **O17** Capitalize the first word of each item. End with a period unless the
  item is a fragment, a single word, code, or link text.
- **O18** Say whether the items are all required or a choice.
- **O19** Avoid a one-item list. Never end a list with "etc." or "and so on".
- **O20** Use a table when each row holds three or more related facts.
- **O21** Never merge table cells, and never put a table inside numbered steps.
- **O22** Sort rows logically or alphabetically. Keep cell text near one line.
- **O23** Split a long or wide table into smaller ones.

## Paragraphs

- **P1** Open each paragraph with the sentence that states its point.
- **P2** Keep one topic per paragraph.
- **P3** Keep paragraphs to 3-8 sentences and under 150 words.
- **P4** Vary the length. A one-sentence paragraph is fine for emphasis.
- **P5** Keep the same subject words running through the paragraph.
  - Before: "The scheduler queues the job. The dispatcher picks up the task and
    the worker handles the item."
  - After: "The scheduler queues the job. The scheduler then hands the job to a
    worker, which runs the job."
- **P6** Reuse the same term. Never swap in a synonym for variety.
- **P7** Tie each sentence to the one before it: repeat a key term, or use a
  connective such as "however" or "as a result".
- **P8** Put familiar information at the start of a sentence and new
  information at the end.
  - Why: the reader has nothing to attach new information to yet.
  - Before: "A new retry policy governs the timeout described earlier."
  - After: "The timeout described earlier now uses a new retry policy."

## Sentences

- **S1** Make the actor the subject and the action the verb.
  - Before: "A decision was made by the team about the rollout."
  - After: "The team decided to roll it out."
- **S2** Turn abstract nouns back into verbs.
  - Before: "perform an analysis of the log" — After: "analyze the log"
- **S3** Put one idea in one sentence. Split a sentence that makes two claims.
- **S4** Target under 20 words per sentence. Never go over 26.
- **S5** Use plain subject-verb-object order. Avoid comma-heavy chains.
- **S6** Link at most two or three clauses with "and", "or", or "but".
- **S7** Use active voice by default.
  - Before: "The config must be updated before the service is restarted."
  - After: "Update the config before you restart the service."
- **S8** Use passive voice only when one of these is true. Check them:
  - The actor is unknown or does not matter ("the file was corrupted").
  - The passive keeps the paragraph's topic word as the subject (see P5).
  - The passive is the only way to put old information first (see P8).
- **S9** Never use passive voice to hide who is responsible. In a runbook or a
  postmortem, name the actor.
- **S10** Use present tense for normal behavior.
  - Before: "The server will send an ack." — After: "The server sends an ack."
- **S11** Use future tense only for something that truly happens later, and say
  when: "The next backup run archives the file."
- **S12** Never describe unreleased behavior in current docs.
- **S13** State the real condition instead of a hypothetical "would".
  - Before: "The server would then remove you."
  - After: "If you unsubscribe, the server removes you."
- **S14** Put the condition before the instruction.
  - Before: "Click Save, if the form is valid."
  - After: "If the form is valid, click Save."
- **S15** Put the detail you most want noticed at the end of the sentence.
- **S16** Use the imperative for instructions. Drop "please" and "you should".
  - Before: "You should click Submit." — After: "Click Submit."
- **S17** Say what to do, not what not to do, when both work.
  - Before: "If you fail to set the flag, the build will not run."
  - After: "Set the flag so the build runs."
- **S18** Never use a double negative.
  - Before: "A missing path won't prevent you from continuing."
  - After: "You can continue without a path."
- **S19** Keep "that" and "who" in the sentence.
  - Before: "Verify all tables are indexed." — After: "Verify that all tables
    are indexed."
  - Why: this follows Microsoft over Google. The extra word marks the clause
    boundary for readers whose first language is not English.
- **S20** Keep the articles "a", "an", and "the". They mark the nouns.
- **S21** Put "only" next to the word it limits.
  - Before: "The job only runs on Sunday." — After: "The job runs only on
    Sunday."
- **S22** Add a verb to a short label or heading when it reads as a fragment.
  - Before: "Access denied" — After: "Access is denied"
- **S23** Disambiguate an "-ing" or "-ed" word that could be a verb, an
  adjective, or a noun. Add an article, add "is", or split the sentence.
- **S24** Cut redundant pairs.
  - Before: "each and every request" — After: "each request"
- **S25** Cut empty modifiers: "actually", "really", "basically", "very",
  "certain".
- **S26** Cut talk about the writing itself: "it should be noted that", "to sum
  up". Keep it only when it helps the reader navigate.
- **S27** Cut a hedge you do not mean.
  - Before: "It could perhaps be argued that the cache helps."
  - After: "The cache reduces latency by half."
- **S28** Replace a wordy phrase with one word.
  - Before: "due to the fact that" — After: "because"
- **S29** Never use an exclamation mark.

## Words

- **W1** Write for a reader whose first language may not be English. Target B2
  / 8th grade.
- **W2** Assume the reader does not know what you know. Before naming a system,
  a flag, or an internal term, ask whether someone new would understand the
  sentence without asking you.
- **W3** Define or link a term the first time you use it, even when it feels
  obvious.
- **W4** When you cannot tell whether a term needs defining, define it.
  - Why: one extra line costs the expert nothing and saves the newcomer the
    whole document.
- **W5** Use the word the reader already knows.
  - Before: "utilize the API to commence the process"
  - After: "use the API to start the process"
- **W6** Replace a vague phrase with a plain word.
  - Before: "at this point in time" — After: "now"
- **W7** Do not stack nouns in front of a noun.
  - Before: "mine worker safety protection procedures" — After: "procedures
    that protect the safety of mine workers"
- **W8** Use one term for one concept through the whole document.
  - Before: "job", "task", and "item" for the same thing — After: "job"
    everywhere
- **W9** Never use an idiom, a metaphor, or a culture-specific reference.
  - Before: "This is a ballpark figure." — After: "This is an estimate."
- **W10** Never use internet slang: "tl;dr", "ymmv", "RTFM".
- **W11** Write "for example" and "that is". Never write "e.g." or "i.e."
- **W12** Spell out an abbreviation on first use, then use the short form.
  Skip that step for API, URL, HTML, PDF, RAM, and USB.
- **W13** Introduce at most two or three new abbreviations in one document.
- **W14** Never invent an abbreviation, and never use one as a verb.
- **W15** Do not use a slash to mean "and/or". Pick "and" or "or".
- **W16** Do not use a symbol in place of a word. Write "and", not "&".
- **W17** Use second person for the reader. Use third person for the software
  and for other people.
- **W18** Never mix "you" and "the user" for the same person.
- **W19** Spell out zero through nine. Use numerals for 10 and up.
- **W20** Always use numerals for version numbers, quantities with units,
  prices, step numbers, and page numbers.
- **W21** Never start a sentence with a numeral. Spell it out or reword.
- **W22** Write a range with a hyphen and no spaces: 2012-2016. Do not use an
  en dash.
- **W23** Spell out ordinals: "third", not "3rd".
- **W24** Use a comma as a thousands separator from four digits: 10,000.
- **W25** Use gender-neutral role words.
  - Before: "chairman", "manpower" — After: "chair", "workforce"
- **W26** Do not use "he" or "she" for an imagined person. Rewrite in second
  person, make the noun plural, or name the role. Never write "he/she".
- **W27** Use the pronouns a named real person uses.
- **W28** Use varied names in examples, and avoid stereotyped roles.
- **W29** Do not generalize about a group or a country, even in praise.
- **W30** Avoid terms with racial or violent history.
  - Before: "master/slave", "DMZ" — After: "primary/replica", "perimeter
    network"
- **W31** Mention a disability only when relevant, and put the person first:
  "people who are blind". Never use pity words such as "suffering from".
- **W32** Do not name politically disputed places. When listing regions, use
  one kind of unit.

### Substitutions

| Do not write | Write |
| --- | --- |
| simply, just, easily, obviously | (delete it) |
| please note, at this time | (delete it) |
| e.g., i.e. | for example, that is |
| utilize, leverage | use |
| in order to | to |
| due to the fact that | because |
| a number of | several, or the real number |
| is able to, has the ability to | can |
| prior to, subsequent to | before, after |
| in the event that | if |
| terminate, cease | stop |
| commence, initiate | start |
| make a decision | decide |

## Accessibility

- **A1** Never carry meaning in color, icon, or position alone. Add a text
  label.
- **A2** Write "the preceding section" or "the following table". Never write
  "above" or "below".
  - Why: there is no fixed "above" for a screen reader or a right-to-left
    layout.
- **A3** Give every meaningful image alt text that states its purpose. Leave
  alt text empty for decoration only.
- **A4** Never put information in an image that is not also in the text.
- **A5** Use heading levels for structure, not bold or larger text.
- **A6** Avoid ALL CAPS and camelCase in prose. Some screen readers spell them
  out letter by letter.
- **A7** Never force a line break inside a sentence or a paragraph.
- **A8** Keep each heading to one short line, and keep tables narrow. Content
  may be read on a small screen.
- **A9** Mark links with more than color, such as an underline.
- **A10** Keep at least 4.5:1 contrast between text and background.
- **A11** Label every form input with a real label, not placeholder text alone.
- **A12** Read the text aloud, or reread it as someone new to the project,
  before you call it done.
  - Why: you cannot detect your own missing context by silent rereading.

## Review checklist

Run this before you deliver any text. Fix every hit.

- [ ] The answer, command, or conclusion comes first (O1).
- [ ] Every heading names its content, in sentence case, with text under it
      (O6, O9, O11).
- [ ] Each paragraph opens with its point and holds one topic (P1, P2).
- [ ] Every sentence is under 26 words (S4).
- [ ] Every sentence has a real actor as its subject (S1).
- [ ] Every passive sentence passes one of the three tests (S8).
- [ ] Instructions are imperative, with the condition first (S14, S16).
- [ ] No abstract noun stands in for a verb (S2).
- [ ] No idiom, slang, metaphor, or exclamation mark (S29, W9, W10).
- [ ] No "simply", "just", "easily", "please note" (see Substitutions).
- [ ] "for example" and "that is" replace e.g. and i.e. (W11).
- [ ] One term per concept, all the way through (W8).
- [ ] Every new term is defined or linked on first use (W3).
- [ ] "You" means the reader everywhere; nothing mixes "you" and "the user"
      (W17, W18).
- [ ] No "above" or "below" as a location (A2).

## Sources and licenses

Every rule here is restated in our own words, not copied, except where the
source is public domain.

| Source | URL | License |
| --- | --- | --- |
| Google developer docs style guide | https://developers.google.com/style | CC BY 4.0; code Apache 2.0 |
| Microsoft Writing Style Guide | https://learn.microsoft.com/style-guide/ | CC BY 4.0; code MIT |
| Federal Plain Language Guidelines | https://digital.gov/guides/plain-language/ | Public domain |
| Williams, *Style: Lessons in Clarity and Grace* | book | Copyrighted; restated |
| Pinker, *The Sense of Style*, chapter 3 | book | Copyrighted; restated |

Google is the backbone. Where Google and Microsoft disagree, this guide
follows Google, except where Microsoft's rule helps readers whose first
language is not English.

| Topic | Resolution |
| --- | --- |
| Keep "that", "who", articles | Microsoft (S19, S20): helps non-native readers |
| One term per concept | Microsoft (W8): helps non-native readers |
| Ranges | Google (W22): hyphen, no en dash |
| Passive voice | Williams (S8): allowed under three named conditions |
