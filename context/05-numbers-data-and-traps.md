---
title: 05 — Numbers, data and the traps that give silent wrong answers
type: context
status: active
version: 1.0
supersedes: —
decision_refs: [D-005]
why: Settles which source is authoritative, what the replica holds and what returns a wrong answer without an error
last_updated: 2026-11-02
---

# 05 — Numbers, data and the traps that give silent wrong answers

> Last verified: 2026-11-02

State the population boundary before any rate. Name the source. Label the number.

## Which source is authoritative

| Source | Use it for | Authority |
|---|---|---|
| the BI tool | funnel rates and the impact of a change | authoritative for funnel rates and impact |
| the SQL replica (`harbor_replica`) | counts, including `POL-M1`; "does this column hold anything"; case-level checks | authoritative for counts; a rate from it is `operational — unverified` until the BI tool agrees |
| event analytics | behaviour on Harbor and Field: who saw what, in what order, how long | authoritative for behaviour; never for case counts |
| the tracker | what was committed and what reached `Deployed to Prod` | authoritative for delivery state |

A rate from the replica or analytics is labelled `operational — unverified`. It becomes
`DB-verified <date>` when the product lead re-runs it against the replica with the
population boundary stated and records the date. It is never a headline until the BI tool
agrees.

## The numbers

All invented. Measured values carry `example`; the target carries `target`.

| Figure | Value | Label |
|---|---|---|
| Policies issued per month | Jul 180 · Aug 205 · Sep 240 | example |
| Policies issued target | Oct 300 | target |
| Verification first-pass rate, Sep cohort | 61% | example |
| Rework cycle time, median | 31 hours | example |
| Insurer partners | 6 | example |
| Ops team | 14 | example |
| Field verifiers | 9 across 3 regions | example |
| Referral agents | about 120 | example |
| Verification queue service level | 24 hours (`policies/service-levels.md`) | example |
| Cooling-off period | 15 days (`regulated-actions.md`) | example |
| Record retention after policy end | 7 years (`policies/data-handling-and-retention.md`) | example |

Metric definitions live once, in `metrics-dictionary.csv`. Cite the `metric_id`.

## The replica tables

| Table | One-line purpose |
|---|---|
| `h_customer` | One row per policyholder: identity record, language, contact ids |
| `h_case` | One row per case: stage, sub-status, product, shop type, sum insured, `reasons` (jsonb), `contacts` (jsonb) |
| `h_document` | One row per uploaded document: checklist item, status, version |
| `h_verification` | One row per verification outcome: identity result, document results, rule re-run, outcome |
| `h_rework_item` | One row per returned document: reason code, raised by, resubmitted at |
| `h_policy` | One row per issued policy: insurer, premium, start and end, cancellation |
| `h_claim` | One row per claim: opened at, acknowledged at, status |
| `h_audit_event` | One row per regulated action: actor, action, evidence reference, `metadata` (jsonb) |

## Event analytics — the events that exist

`quote_started` · `eligibility_result_viewed` · `document_uploaded` ·
`verification_outcome_viewed` · `rework_resubmitted` · `payment_completed` · `claim_opened`.

An event not on this list does not fire. A PRD that names a new event marks it **new**, and
the QA analytics catalog gets a `Planned` row.

## Three traps that return the wrong answer without an error

| Trap | What breaks | Do this instead |
|---|---|---|
| `h_case.contacts` is a jsonb array of bare ids (`[1042, 1043]`), not objects | A join on `contacts->>'id'` matches nothing and returns zero rows silently | Expand the array with `jsonb_array_elements` and join the bare value to `h_customer.id` |
| `h_audit_event.metadata` has been empty since the August release (`example`) | Decline reasons read from `metadata` return null for every case after that release | Read `h_case.reasons->>'decline'` |
| `h_verification.updated_by` was used as a proxy for "an officer decided"; since 11 August (`example`) each engine re-run adds a new row written by a service user | Counting rows, or rows by `updated_by`, over-counts first passes by every engine re-run | Take the earliest row per case with `h_verification.outcome_source` in (`officer`, `field`); `engine` rows are re-runs |

If a query on these tables returns zero rows, suspect the query before the data.

## Before you compute any rate

1. **State what the source excludes.** `h_policy` holds only issued policies. A funnel rate
   computed from `h_policy` alone is a survivors-only rate and is wrong. A rate whose
   population is issued policies (`CAN-G1`, `REF-M1`) is valid and says nothing about
   unissued cases.
2. **Anchor on the full population.** Funnel rates anchor on `h_case` by `Quote` week.
   Unknowns stay in the denominator as a bucket.
3. **Compare equal maturities.** A September cohort at D+14 against an August cohort at D+30
   is not a comparison.
4. **Numerator is unique cases, not events.** `document_uploaded` fires once per file.

## Vocabulary

Use the stage names in `02-service-and-lifecycle.md` and the funnel words
`Quote` · `Eligible` · `Documented` · `Verified` · `Issued`. Do not invent a synonym.

## Running a query

Read-only, always. Head every query with the decision it serves, the population boundary
and the metric id. `tools/query/run-sql.sh` refuses a write statement. Explore with
`LIMIT 100`.

## Do not build a dashboard without a decision

Decision → data points → representation → cadence → build. A dashboard nobody acts on is a
cost. Name who reads it, how often, and what they do differently.
