---
title: "Persona: Field verifier — inspection and replacement capture"
type: persona-card
kind: internal-role
status: evidence-backed
version: 1.0
owner: product lead (ops and platform)
supersedes: —
decision_refs: []
last_verified: 2026-11-02
last_updated: 2026-11-02
why: Grounds persona-panel critique of the Field inspection and replacement-document flows
---

# Persona: Field verifier — inspection and replacement capture

> Last verified: 2026-11-02

> Used by the persona panel. Every claim cites an evidence row or is listed under "What we
> don't know". Panel output from this card is labelled SYNTHETIC.

## Evidence sources

| # | Source (README code) | Type | Date | Sample | Label |
|---|---|---|---|---|---|
| E1 | `FV` | field visit shadowing | Sep 2026 | 6 inspections in 2 regions | example |
| E2 | `OI` | interviews with field verifiers | Sep 2026 | 2 of 9 staff | example |
| E3 | `DB` | `h_rework_item` resolved by field capture | Sep 2026 | September cases | example |

## Who

One of nine verifiers across three regions (`example`) (E2). Visits shops for the
inspection checklist and photos, and captures replacement documents against open rework
items while there (E1, E3). On the road most of the day; the phone is the only tool (E1).

## Jobs

- When the day starts, the verifier wants the route's cases with their open rework items,
  so one visit closes everything. (E1, E2)
- When taking a photo, the verifier wants the slot to say what the officer needs to see, so
  it is not returned as `unreadable`. (E1)
- When the network is weak, the verifier wants the capture to save and send later, so the
  visit is not repeated. (E1, E2)

## Pain points

- Discovering an open rework item after leaving the shop. (E1, E3)
- Photos returned by the officer for a reason the checklist did not state. (E1)
- Customers who see the visit as an inspection by an authority, not help. (E1)

## Operational constraints

| Dimension | Reality | Evidence |
|---|---|---|
| Device | A mid-range phone, often in sunlight; one hand free | E1 |
| Connectivity | Weak inside shops and in two of the three regions | E1, E2 |
| Language | Field is in English; speaks the customer's language on site | E2 |
| Authority | Marks inspection items `accepted` or `rework`; cannot set the case outcome | E2 |

## What we don't know

- The share of visits that close every open item in one go — `h_rework_item` can tell us;
  not pulled yet.
- Whether a voice note in the verifier's language, transcribed, beats typed notes — test.
