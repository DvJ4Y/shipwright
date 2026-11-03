# Agent lessons log

> Every correction becomes a rule here. This is the only mechanism by which the agent stops
> repeating a mistake. Reviewed at the start of every session. When the same correction
> appears three times, promote it into the skill that should have prevented it.

Format:

## YYYY-MM-DD — <topic>

**Mistake: <one line>**
What went wrong, concretely.
**Rule**: what to do instead, phrased so it prevents recurrence.

---

## 2026-10-21 — Target quoted as a baseline

**Mistake: the October policies-issued target (300, `target`) appeared in a discovery doc as
"current run-rate".**
The number came from `08-strategy-and-outcomes.md`, where the table mixes measured months
and the target. The label column was dropped when the row was copied.
**Rule**: copy the label with the number, always. When a table mixes measured values and
targets, quote the row with its label or do not quote it. A target is never a baseline.

## 2026-10-24 — Rate computed from a survivors-only table

**Mistake: a "placement acceptance rate" was computed from `h_policy` alone.**
`h_policy` holds only issued policies, so every case in it was accepted by definition; the
rate came out near 100% and was wrong.
**Rule**: state the population boundary before any rate. Anchor the denominator on `h_case`
for the cohort. A table that only holds survivors yields counts, never rates.

## 2026-10-28 — Rework message without a next step

**Mistake: a draft WhatsApp template read "Your document was rejected" and stopped.**
It named no document, no reason and no route. It also used "rejected", which the voice file
rules out.
**Rule**: every customer message has four parts in order — what happened, what it means,
what to do next, where to do it. A message missing the next step is not sent. Check
`context/design/voice.md` "Not" column before sharing any string.
