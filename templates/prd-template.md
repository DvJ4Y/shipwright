---
title: "PRD: <feature>"
type: prd
status: draft            # draft | in-review | approved | shipped | landed | superseded
version: 0.1
tier: M                  # S | M | L
owner: <role>
lane: <customer | ops-platform>
supersedes: —
decision_refs: []        # decision-point IDs, e.g. [P-03, D-006]
shipped_on: —            # set by `issue-tracker release` after reconciliation (YYYY-MM-DD)
landed_into: []          # set by `land`: current-behaviour row ids
why: <one line — the outcome this feature serves and the metric it moves>
last_updated: YYYY-MM-DD
---

# PRD: <feature>

> WHAT and WHY only. No API, schema, architecture, component, test, rollout or estimate
> content. Open points use `[NEEDS CLARIFICATION: <question> → P-nn]`; any open marker
> blocks `in-review`.

## 1. Objective

<2–3 sentences. The business outcome, the users it serves, and the outcome metric ID it
moves (from `context/metrics-dictionary.csv`).>

## 2. Users and primary use cases

| # | User / role | Situation (When…) | Need (I want to…) | Outcome (so I can…) |
|---|---|---|---|---|
| U1 | | | | |

<Name the customer segment where it matters (by shop type) and cite the persona card.
Solve for the hardest case first.>

## 3. Current behaviour and reuse

| What exists today | Evidence (current-behaviour row, issue, query) | Reused / extended / replaced |
|---|---|---|

<Start from `context/surfaces/<surface>/current-behaviour.md`. Cite row ids.>

## 4. Flow and scope

<The main flow as numbered steps or a diagram. In scope, as a list.>

## 5. Non-goals

- <What this feature does not do, and where it goes instead.>

## 6. Business rules and configuration

| Rule | Condition | Behaviour | Configurable per partner / segment? | Policy file |
|---|---|---|---|---|

## 7. Information, permissions and audit

| Data point | Who provides it | Who can see / edit | Regulated action (register row) | Evidence kept |
|---|---|---|---|---|

**Regulated actions touched:** <register rows from `context/regulated-actions.md`, or "none">

## 8. States

| State | When it happens | What the user sees | What the user can do |
|---|---|---|---|
| NORMAL | | | |
| EMPTY | | | |
| PARTIAL | | | |
| MISSING | | | |
| RESTRICTED | | | |
| PROVIDER-FAILED | | | |
| REWORK | | | |

<Add one row per sub-status the flow can set (`on hold`, `lapsed`, `declined`), each with
its recovery path.>

## 9. Acceptance criteria

- **A1** — When <situation>, then <observable result>.
- **A2** — When …, then …

## 10. Metrics

| Metric ID | Role | Source | Claim level | Baseline | Target |
|---|---|---|---|---|---|
| | outcome | the BI tool / event analytics / the SQL replica | measurement capability / descriptive movement / causal | <value + label, or "not measured"> | <value> (`target`) |
| | guardrail | | | | |
| | anti-metric | | | | |

<Guardrail: what must not get worse. Anti-metric: the number that would look good while the
customer outcome gets worse.>

## 11. Dependencies, open inputs and owners

| Item | Type (dependency / open input) | Owner (role) | Blocks |
|---|---|---|---|

## 12. Interconnections and impact

**Connected features:** feeds <feature> · depends on <feature> · conflicts with <feature>

| Layer | What changes | Existing or new | Owner (role) |
|---|---|---|---|
| Data | | | |
| Workflow and events | | | |
| Communication | | | |
| Notifications | | | |
| Harbor | | | |
| Desk | | | |
| Field | | | |
| Rules | | | |
| Other teams | | | |
| Metrics | | | |

Write "not affected" in a row that is. Second- and third-order effects:

| Effect | Who feels it | Early signal |
|---|---|---|

Write "none found" if there are none.

<Scale it: full for a feature that changes data, workflow, another team's work or a metric;
two lines for a small one.>

## 13. Crosswalk to earlier requirements

<Only if older requirements, drafts or issues exist. One line per carried requirement, no
paths or decision ids. The full table lives at `internal/crosswalk.md`
(`templates/crosswalk-template.md`).>

<!-- No phase check in the body: a shared file is self-contained. The phase check lives in
chat and in internal/readiness.md. -->
