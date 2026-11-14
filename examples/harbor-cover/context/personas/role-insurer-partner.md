---
title: "Persona: Insurer partner — carries the risk, issues the policy"
type: persona-card
kind: partner
status: thin
version: 1.0
owner: product lead (ops and platform)
supersedes: —
decision_refs: []
last_verified: 2026-11-02
last_updated: 2026-11-02
why: Grounds persona-panel critique of partner-facing work; raises questions
---

# Persona: Insurer partner — carries the risk, issues the policy

> Last verified: 2026-11-02

> Used by the persona panel. Every claim cites an evidence row or is listed under "What we
> don't know". Panel output from this card is labelled SYNTHETIC. Status is `thin`.

## Evidence sources

| # | Source (README code) | Type | Date | Sample | Label |
|---|---|---|---|---|---|
| E1 | `PR` | partner review calls | Sep 2026 | 4 of 6 partners | example |
| E2 | `DB` | placement outcomes and insurer queries by partner | Sep 2026 | September cases | example |

## Who

One of six insurers (`example`) whose shop, stock, liability or staff-health products Harbor
Cover distributes (E1). Four take cases through their APIs; two work by email (E1, E2).
Each has an appetite by shop type and band that changes without notice (E1).

## Jobs

- When a case arrives, the partner wants verified identity, a complete checklist and
  inspection photos, so underwriting is a check, not an investigation. (E1)
- When a question is needed, the partner wants one thread with one answer, so the file closes.
  (E1, E2)
- When a claim comes in, the partner wants the evidence collected once by Harbor Cover, so
  settlement is not delayed by document chasing. (E1)

## Pain points

- Cases where the stock value is declared but not evidenced. (E1, E2)
- Rework caught after submission instead of before. (E1)

## Constraints

| Dimension | Reality | Evidence |
|---|---|---|
| Channel | API for 4 partners; email and a shared sheet for 2 | E1, E2 |
| Appetite | By shop type and band; updated by email | E1 |
| Regulation | The partner is the regulated insurer; Harbor Cover is the regulated distributor | E1 |

## What we don't know

- Whether partners would accept Field inspection photos in place of their own survey above
  a band — ask the four API partners.
- What the two email partners would need to move to the API — not asked.
