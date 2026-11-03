---
status: active
version: 1.0
supersedes: none
decision_refs: none
why: Name the authoritative source for each kind of question before anyone runs a query
last_updated: 2026-11-02
---

# Data sources — which one is authoritative for what

Pick the source from the table below before writing a query. State the population boundary
before any rate. Label every number with the source you used.

## The three sources a product team usually has

| Source | What it holds | Authoritative for | Not authoritative for | Label on a number |
|---|---|---|---|---|
| **SQL replica** (read replica of the production database) | every record and its stage history, as the system wrote it | counts of cases, documents, policies, claims; stage transitions and their timestamps; cycle times; anything that is a row | what a person saw or tapped; abandonment before a record exists; why a customer left | `DB-verified <date>` |
| **Event analytics** (product event store) | screen views, taps, form progress, per session and per surface | on-surface behaviour: where people stop, retry, abandon; step-to-step drop within a surface | business outcomes; totals that must match finance; anything after the person leaves the surface | `analytics` |
| **BI export request** (the team's joined, curated view) | replica plus analytics plus manual corrections, joined by the data owner | headline funnel and impact figures that leadership quotes; cross-source rates | ad-hoc questions; anything that needs an answer today | `analytics`, citing the view name and the export date |

A dashboard figure nobody has re-checked against its source carries `operational —
unverified`. A planned value carries `target`. Never present a target as a baseline.

## Rules that stop silent wrong answers

1. **Population boundary first.** Write what the dataset excludes before computing a rate. A
   table that only holds survivors (issued policies, closed rework items) yields counts, never
   rates.
2. **One source per number.** A numerator from the replica and a denominator from analytics
   is not a rate. If the question needs both, request a BI export.
3. **Headline figures come from the BI export.** Replica and analytics figures support a
   decision; they do not go in a leadership update unless the BI owner has no export.
4. **A 404 is a stop signal.** An access error means you do not have the source. Solve access;
   do not substitute another source and keep the label.
5. **Name the query.** Every figure in a document cites the saved query id or the statement,
   the source and the date it was run.

## Worked mapping — Harbor Cover (`example`)

| Metric | Question | Source | Population boundary |
|---|---|---|---|
| `POL-M1` policies issued per month | how many policies reached `Policy issued` | SQL replica, `h_policy` with `h_case` stage history | cases with an issued timestamp in the month; excludes cancelled within cooling-off unless stated |
| `QUO-M1` quote → eligibility rate | of people who started a quote, how many saw an eligibility result | event analytics, `quote_started` → `eligibility_result_viewed` | sessions on Harbor in the window; excludes referral-agent-entered quotes, which have no session |
| `DOC-M1` document completeness at first submission | share of cases with every checklist item present at first upload | SQL replica, `h_document` against the checklist policy | cases that reached `Documents`; the checklist differs by product |
| `VER-M1` verification first-pass rate | cases whose earliest officer or field `h_verification` row is `pass`, over cases quoted in the cohort week that entered `Verification` by D+45 (the dictionary definition) | the BI tool (authoritative); the SQL replica for a check, `operational — unverified` | engine re-runs excluded (`outcome_source = engine`); provider-failed is not a fail |
| `VER-M2` rework cycle time | median hours from rework raised to resubmitted (not accepted), per rework item, D+14 (the dictionary definition) | the BI tool (authoritative); the SQL replica for a check, `operational — unverified` | resubmitted items only — a survivor set; report `REW-G1` and the count still open at D+14 beside the median |
| `CLM-M1` claims acknowledged within the service level | share acknowledged inside the claims service level | SQL replica, `h_claim`, `h_audit_event`; the service level from `context/policies/service-levels.md` | claims opened in the window |

Every value derived from this mapping is fictional and carries `example`.
