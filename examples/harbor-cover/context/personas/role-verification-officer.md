---
title: "Persona: Verification officer — identity, documents, rules, rework"
type: persona-card
kind: internal-role
status: evidence-backed
version: 1.0
owner: product lead (ops and platform)
supersedes: —
decision_refs: []
last_verified: 2026-11-02
last_updated: 2026-11-02
why: Grounds persona-panel critique of the verification queue and the rework flow
---

# Persona: Verification officer — identity, documents, rules, rework

> Last verified: 2026-11-02

> Used by the persona panel. Every claim cites an evidence row or is listed under "What we
> don't know". Panel output from this card is labelled SYNTHETIC.

## Evidence sources

| # | Source (README code) | Type | Date | Sample | Label |
|---|---|---|---|---|---|
| E1 | `OI` | interviews with verification officers | Sep 2026 | 3 of 9 staff | example |
| E2 | `DB` | `h_verification` outcomes and `h_rework_item` reason codes | Sep 2026 | September cases | example |
| E3 | `FV` | shadowing officers on field-inspection cases | Sep 2026 | 2 of 6 sessions | example |

## Who

One of five officers (`example`) working the Desk verification queue (E1). Checks identity
against the identity-check provider, each checklist document, and the shop inspection
where the tier needs one; re-runs the rules on verified data; raises rework (E1, E2). Held
to the 24-hour queue service level (`example`) (E1).

## Jobs

- When the queue opens, the officer wants the riskiest and oldest cases first, so the
  service level is met where it matters. (E1)
- When a document is wrong, the officer wants to pick a reason code and the field that
  differs, so the customer fixes it once. (E1, E2)
- When the provider fails, the officer wants the case to show it plainly and wait, so it is
  not declined by mistake and not lost. (E1)
- When a replacement arrives from the field, the officer wants it attached to the rework
  item, so the case is re-checked without a search. (E1, E3)

## Pain points

- Rework returned with a reason the customer cannot act on produces a second rework. (E1, E2)
- Pharmacy and food-service documents need domain knowledge the checklist does not carry. (E1)
- Provider failures showed as blank rows before the retry queue; some were declined by
  mistake. (E1)

## Operational constraints

| Dimension | Reality | Evidence |
|---|---|---|
| Volume | Each officer clears their share of the day's queue inside the service level | E1 |
| Tools | Desk case view, the provider result, the Field photos; no second screen | E1, E3 |
| Authority | Sets `rework`, `refer`, `declined` (with the rule); cannot change a rule | E1 |
| Language | Desk in English; customer documents in several languages | E1 |

## What we don't know

- The share of rework caused by officer judgement versus document fault — no tag exists.
- Whether showing the rule that fired to the customer changes resubmission speed — the
  worked feature tests this.
