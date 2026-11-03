---
title: Metrics dictionary — how to read and extend it
type: context
status: active
version: 1.0
supersedes: —
decision_refs: [D-005]
why: One definition per metric, so every dashboard, query and summary says the same thing
last_updated: 2026-11-02
---

# Metrics dictionary — how to read and extend it

> Last verified: 2026-11-02

Define a metric once, in `metrics-dictionary.csv`. Cite its `metric_id` everywhere else.
Every value in the CSV is invented and labelled `example`; every target is labelled `target`.

## Ownership

| Role | Owns |
|---|---|
| product lead (ops and platform) | The dictionary file; the `outcome` rows for Desk, Field and the engine |
| product lead (customer) | The `outcome` rows for Harbor |
| ops lead | The `guardrail` rows and every policy value a metric depends on |
| engineering lead | That the events and columns a row names exist in production |

A row with a blank `secondary_owner` is listed in `06-teams-and-who-does-what.md`, "What
nobody owns".

## Columns

| Column | Holds |
|---|---|
| `metric_id` | `<JOURNEY>-<M or G><n>`. `M` outcome, `G` guardrail. Never reused |
| `category` | `headline` · `outcome` · `guardrail` · `diagnostic` |
| `meaning` | One sentence a stakeholder understands |
| `numerator` | Unique cases or items, never events |
| `denominator` | The full eligible population; unknowns stay in as a bucket; `—` for counts and medians |
| `cohort_anchor` | The week or month the case entered the population |
| `maturity` | When the cohort is complete enough to compare; compare equal maturities only |
| `authority` | `the BI tool` · `the SQL replica` · `event analytics` |
| `where_to_get` | The view or saved query, or `not built` |
| `traps` | Population exclusions, schema traps, events that do not fire |
| `latest_value`, `latest_label` | The last reading and its source label |
| `target`, `status` | The target with who set it; `status` is `target` · `baseline` · `proxy` · `proposed` |
| `owner`, `secondary_owner` | Roles |
| `cadence` | `weekly` · `monthly` · `cycle` |
| `sources` | The context file that explains the journey or policy |

## Claim levels

Say the strongest thing the evidence supports, and no more.

| Level | Means | Example |
|---|---|---|
| implementation fact | The column or event exists and holds data | `h_verification.outcome` is populated |
| measurement capability | The metric can be computed from an authoritative source | `VER-M1` is in the BI tool |
| descriptive movement | The metric moved between two equal-maturity cohorts | "`VER-M1` rose between two quote-week cohorts at D+45" (illustration, not a reading) |
| causal impact | The movement is attributed to a change, with a comparison group | not claimed for any row today |

A PRD's metrics table names the claim level it expects after release. "Causal" needs a
comparison group the brief has named.

## Status values

| `status` | Means |
|---|---|
| `target` | A target exists and is labelled; the latest value is a measured reading |
| `baseline` | A measured reading exists; no target set |
| `proxy` | The authoritative source has no view; the value is from the replica or analytics and is `operational — unverified` |
| `proposed` | Defined, not yet computed anywhere |

## How to add or change a row

1. Draft the row with `templates/metric-contract-template.md`.
2. State the population boundary in the contract. Name what the source excludes.
3. Check the traps in `05-numbers-data-and-traps.md`.
4. Append the row. Never edit `metric_id` or `meaning` of an existing row; retire it and add a
   new id if the meaning changes.
5. Log the change as a decision (`decisions/decision-log.md`).

## Decisions locked

| Decision | Rows |
|---|---|
| The BI tool is authoritative for every `outcome` row; replica figures are `operational — unverified` (`D-005`) | all |
| Guardrails are reported beside the outcome they protect, in the same cohort | `VER-G1`, `REW-G1`, `CAN-G1` |

## Still open

| Item | Owner | Rows |
|---|---|---|
| A BI tool view for the three guardrails, so they lose the `proxy` reading | engineering lead | `VER-G1`, `REW-G1`, `CAN-G1` |
| Whether `VER-M2` reports the long tail (P90) beside the median | product lead (ops and platform) | `VER-M2` |
