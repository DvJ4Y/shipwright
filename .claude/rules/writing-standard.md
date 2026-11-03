# Writing standard — plain, STE-style

**Applies to:** review documents, business memos, PRDs, engineering briefs, decision records
and handoffs. **Does not apply to** customer copy in the customer's language; `/product-copy`
and `/localisation-copy` own that voice.

## Rules

1. **Lead with the decision or the ask.** The first sentence says what the reader must do.
2. **One idea per sentence.** Aim for 20 words or fewer. An acceptance criterion is one
   observable "When … then …" statement and may run longer.
3. **One term per concept.** Take it from `context/07-glossary.md`. Use no synonyms.
4. **Active voice.** Name who does the action.
5. **No repetition, filler or hedging.** Cut "basically", "it should be noted", "arguably".
6. **Use conditions and tables** instead of long prose. "If X, then Y" beats a paragraph.
7. **A rule and a current limitation are two sentences.** Never merge them into one.
8. **Every number carries a source label.** Exactly five. `DB-verified <date>`: a count
   re-run on the SQL replica on that date. `analytics`: a figure from event analytics or the
   BI tool, citing the view or insight and the export date. `operational — unverified`: a
   rate computed on the replica or read from an operational dashboard, not matched to the BI
   tool. `target`. `example` (fictional data only). A target is never presented as a baseline.
9. **Capability names, not vendor names**, in anything a stakeholder reads.
10. **Roles, not person names**, in plans.
11. **No buzzwords.** Say the thing.
12. **Facts, not mistake history.** Write what is true. Put the backstory in
    `tasks/lessons.md`.

## Self-check before sharing

- Can the reader act after the first two sentences?
- Is any sentence carrying two ideas? Split it.
- Is any number missing its label? Add it or remove the number.
