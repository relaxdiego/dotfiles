---
name: decision-ledger
description: |
  Surface the choices an AI coding session made where the spec was silent,
  audited by an independent subagent and ranked least-confident first. Use
  after any agent-written change too large to read line by line: a long build
  run, a multi-file feature, a large refactor, a generated migration. Also use
  when asked what the agent decided, assumed, guessed, or invented, or why a
  passing change still feels unreviewed. NOT a bug hunt - use a code-review
  skill for defects.
  Trigger: /decision-ledger
---

# Decision Ledger

A long agent run produces thousands of lines nobody will read, and a few dozen
choices that decide whether the result is right. Tests, types, and linters
prove the code does what it says. They say nothing about *what it decided to
say*.

Those choices are not defects. The tests pass, the outputs are correct, the
diff looks clean. They are the silently-picked retry policy, the invented
cache key, the two features quietly sharing a table. They bite three months
later, when something has to change.

The ledger is the review surface. You read the decisions, not the diff.

## What counts as a decision

A decision is a choice the agent made where the request, the spec, or the
surrounding code did NOT determine the answer.

In scope:

- **Invented behaviour** - a retry, timeout, backoff, limit, or default nobody specified.
- **Structural choices** - new table, new module, new interface, shared vs duplicated state.
- **Semantics under ambiguity** - what "empty", "missing", "expired", or "failed" was taken to mean.
- **Silent scope moves** - work skipped, deferred, widened, or substituted.
- **Contested reads** - two plausible readings of the request; one was picked.
- **Borrowed assumptions** - behaviour assumed of an external API, library, or service without checking.

Out of scope:

- Bugs, crashes, failing tests. Those belong to code review.
- Style, naming, formatting. Mechanically enforced, not decided.
- Anything the request or existing code determined. NEVER pad the ledger with
  choices that had only one legal answer.

A short ledger of real decisions beats a long one padded with obedience.

## The independence rule

CRITICAL. The auditor MUST NOT be the implementer.

- **Separate pass, separate subagent.** A model reviewing its own work is
  primed by its own intent and rationalizes the guess into a plan. Spawn a
  fresh subagent that reads the diff cold.
- **Read-only.** The auditor gets read and search tools. It MUST NOT hold
  Edit, Write, or any mutating tool.
- **Non-blocking.** The audit NEVER gates the change and NEVER fixes anything.
  The moment it can fix, it optimizes for a clean report instead of an honest
  one.
- **NEVER let the implementer summarize its own decisions and call that a
  ledger.** That is the failure this rule exists to prevent.

The implementer MAY leave breadcrumbs as it works - a running note of "the
spec was silent here". The auditor treats those as input to verify, NEVER as
the ledger itself.

## Running the audit

1. **Fix the boundary.** Name exactly what is under audit: a commit range, a
   branch diff, a worktree, a set of files. State it in the prompt.
2. **Spawn one independent auditor** per boundary, read-only, with no memory
   of the implementation reasoning.
3. **Feed it the intent, not the rationale.** Give it the original request and
   the spec. Withhold the implementer's explanations - those are what prime it.
4. **Require the format below.** Least-confident first.
5. **Report the ledger verbatim.** NEVER re-rank, soften, or drop entries you
   disagree with; you are the implementer, and that is the primed party.

Split into several auditors when the change spans independent slices, one per
slice. A decision that only touches one slice is cheaper to judge in isolation.

## Ledger format

Ordered least-confident first. One entry per decision:

```
### <short imperative title>

- Confidence: low | medium | high
- Where: <file:line, or the slice it spans>
- Spec said: <what the request or spec actually stated, or "nothing">
- Chose: <the choice made, plain language, no code>
- Because: <the reasoning available at the time>
- Alternative: <the next-best option, and what changes if it wins>
- Would have asked: <the question, if asking were free>
```

Rules:

- Plain language. NEVER paste code into an entry - the point is to be readable
  when the code is not.
- Confidence is about the DECISION being right, NEVER about the code working.
- Every low-confidence entry MUST carry a real alternative. "No alternative"
  means it was not a decision.
- One decision per entry. Split bundled choices apart.
- Close with a one-line count: `N decisions - X low, Y medium, Z high`.

## Reading it

Read from the top. Low-confidence entries are the whole point; high-confidence
ones exist so the ledger is honest about what it looked at.

For each entry you push back on, send it back for a re-audit with your ruling
stated - NEVER hand-edit the ledger. A ruling you give becomes spec: it MUST
be written into the spec or the artifact so the next run does not re-decide it.

## Anti-patterns

| Pattern | Why it fails |
| --- | --- |
| Implementer writes its own ledger | Rationalizes the guess; the one rule this skill has |
| Auditor can edit code | Starts optimizing for a clean report |
| Ledger gates the merge | Turns honesty into a cost, and entries disappear |
| Every entry high-confidence | The auditor was primed, or padded with non-decisions |
| Entries quoting the diff | Rebuilds the unreadable surface you were escaping |
| Ranked by severity | Severity is a guess; confidence is what the auditor knows |
| Ruling given, spec unchanged | The next run re-decides it the same wrong way |
