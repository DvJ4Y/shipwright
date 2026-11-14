---
title: 02 — Service and lifecycle
type: context
status: active
version: 1.0
supersedes: —
decision_refs: [D-001]
why: The production stage names, sub-statuses, owners and leak points every document must use
last_updated: 2026-11-02
---

# 02 — Service and lifecycle

> Last verified: 2026-11-02

Use these stage names exactly. They come from production (`h_case.stage`), not from any
planning file. If a document uses another name, the document is wrong.

## The stages

Seven stages run in sequence. Two more follow `Active`.

| # | Stage | What happens | Exit condition |
|---|---|---|---|
| 1 | `Quote` | Customer enters shop type, sum insured and location; sees a premium range | Customer starts eligibility |
| 2 | `Eligibility` | Customer answers the eligibility questions; the engine assigns a tier or declines with a recovery path | Tier assigned |
| 3 | `Documents` | Customer uploads the checklist for the product and shop type | Checklist complete at first submission, or submitted with gaps |
| 4 | `Verification` | Verification officer checks identity and documents, applies the rules, raises rework | Outcome `pass` |
| 5 | `Placement` | Placement specialist chooses the insurer, answers insurer queries, collects payment | Insurer accepts and payment completes |
| 6 | `Policy issued` | Insurer issues; customer receives the policy document | Cooling-off starts |
| 7 | `Active` | Policy in force; customer can track, raise a claim, renew | Expiry, claim, or cancellation |
| 8 | `Claim` | Claims handler acknowledges, collects evidence, works the insurer | Settled or closed |
| 9 | `Renewal` | Renewal quote from the active policy; abbreviated eligibility | New `Policy issued` |

Field inspection is not a stage. It happens inside `Verification` when the risk tier or the
rules call for it (`policies/risk-tiers-and-routing.md`).

## Sub-statuses on a case

A case carries one stage and one sub-status at a time.

| Sub-status | Meaning | Who sets it | Leaves it when |
|---|---|---|---|
| `open` | Work is with Harbor Cover | system | stage changes |
| `on hold` | A customer-side condition is pending (document, payment, callback) | verification officer, placement specialist | customer acts, or the hold expires |
| `rework` | A document was returned: unreadable, mismatched or missing | verification officer (a field verifier proposes; the officer confirms) | customer resubmits |
| `declined` | Current information does not fit the rules — always with a recovery path | the engine or a verification officer | customer takes the recovery path |
| `cancelled` | Customer cancelled inside the cooling-off period | placement specialist | terminal |
| `lapsed` | Hold expired, or the policy was not renewed | system | customer re-enters at `Quote` |

**Declined always has a recovery path.** The decline message names the rule, what would
change the outcome (lower sum insured, a fire-safety certificate, a different product, a
manual review) and where to do it. A decline with no recovery path is a defect.

## Who owns each stage

| Stage | Owner | Backed by |
|---|---|---|
| `Quote`, `Eligibility` | support agent (first contact, collects quote data when the customer does not finish online) | Harbor |
| `Documents` | support agent | Harbor, referral agent for referred cases |
| `Verification` | verification officer | field verifier for inspections and replacement documents |
| `Placement` | placement specialist | insurer partner |
| `Policy issued`, `Active`, `Renewal` | ops lead (queues and service levels) | messaging |
| `Claim` | claims handler | insurer partner, compliance officer for complaints |

## Where the funnel leaks

Figures are one quote-week cohort from September, read at the maturity the dictionary
states, and are invented. The BI tool is authoritative for the funnel; see
`05-numbers-data-and-traps.md` before computing any rate. Each row has its own population;
the "in" count is the cases from the cohort that reached that population.

| Transition | Metric | Population in → out | Rate | Label |
|---|---|---|---|---|
| `Quote` → `Eligibility` | `QUO-M1` | 1,420 cases quoted → 824 entered `Eligibility` | 58% | example |
| `Eligibility` → `Documents` with a tier | `ELG-M1` | 824 → 585 entered `Documents` | 71% | example |
| `Documents` complete at first submission | `DOC-M1` | 562 made a first submission → 303 complete | 54% | example |
| `Verification` first pass | `VER-M1` | 541 entered `Verification` → 330 passed first time | 61% | example |

`Placement` → `Policy issued` is read through `PAY-M1` and `PLC-M1`. `POL-M1` is a
calendar-month count and is never a cohort output.

Two leaks matter most.

1. **Documents.** Nearly half of first submissions are incomplete (`example`). Each gap
   becomes a rework item, and rework cycle time runs a median of 31 hours (`example`).
   Rework is the single largest driver of time-to-issue and of support calls.
2. **Quote → Eligibility.** Customers leave after seeing the premium range. The cause is not
   measured. Treat "price shock" as a hypothesis until the BI tool has a view.

## Hold and decline — the customer-side rules

| Condition | Outcome | Label |
|---|---|---|
| Rework item not resubmitted within 7 days | case moves to `on hold` | example |
| Case `on hold` with no customer action for 30 days | case moves to `lapsed` | example |
| Customer cancels within 15 days of `Policy issued` | `cancelled`; premium refunded by the insurer | example |
| Declined case | recovery path shown; customer may re-enter `Eligibility` with changed information | — |

These are internal policy values (`policies/service-levels.md`), not regulatory ones, except
cooling-off, which the regulator sets (`regulated-actions.md`).

## What this means for product work

Any feature that touches a stage names the stage with its production name, states which
sub-statuses it can set, and shows the recovery path for every `declined` or `rework`
outcome it can produce.
