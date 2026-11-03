---
title: "Metric contract: <metric_id> — <name>"
type: metric-contract
status: draft            # draft | approved | retired
version: 0.1
owner: <role>
decision_refs: []
why: <one line — the decision this metric enables>
last_updated: YYYY-MM-DD
---

# Metric contract: <metric_id> — <name>

> One definition, used by every dashboard, query and summary. Once approved, add or update
> the row in `context/metrics-dictionary.csv`.

| Field | Value |
|---|---|
| `metric_id` | <`<JOURNEY>-<M or G><n>`> |
| `category` | <headline / outcome / guardrail / diagnostic> |
| `meaning` | <one sentence a stakeholder understands> |
| `numerator` | <unique cases or items, not events> |
| `denominator` | <the full eligible population; unknowns stay in it as a bucket> |
| `cohort_anchor` | <e.g. quote-created week> |
| `maturity` | <e.g. D+14; compare equal maturities only> |
| `authority` | <the BI tool / the SQL replica / event analytics — and why> |
| `where_to_get` | <dashboard, saved query, or "not built"> |
| `traps` | <population exclusions, schema traps, events that do not fire> |
| `latest_value` | <value + period, or none> |
| `latest_label` | <DB-verified <date> / analytics / operational — unverified / example> |
| `target` | <value + who set it + date, or unknown> (`target`) |
| `status` | <target / baseline / proxy / proposed> |
| `owner` | <role> |
| `secondary_owner` | <role: the other lane's product lead / designer / engineering lead / ops lead> |
| `cadence` | <weekly / monthly / cycle> |
| `sources` | <file paths> |

## Population boundary

<What the source excludes, and which rates are therefore uncomputable.>

## Decision enabled

<Who acts on this number, how often, and what they do differently.>

## Guardrail and anti-metric

- **Guardrail:** <what must not get worse while this improves>
- **Anti-metric:** <how this number could rise while the customer outcome falls>

## Open

- <unresolved definition point> → P-nn
