---
title: "Persona: Compliance officer — regulated actions and complaints"
type: persona-card
kind: internal-role
status: thin
version: 1.0
owner: product lead (ops and platform)
supersedes: —
decision_refs: []
last_verified: 2026-11-02
last_updated: 2026-11-02
why: Grounds persona-panel critique of audit, consent and complaint workflows; raises questions
---

# Persona: Compliance officer — regulated actions and complaints

> Last verified: 2026-11-02

> Used by the persona panel. Every claim cites an evidence row or is listed under "What we
> don't know". Panel output from this card is labelled SYNTHETIC. Status is `thin`.

## Evidence sources

| # | Source (README code) | Type | Date | Sample | Label |
|---|---|---|---|---|---|
| E1 | `OI` | interview with the compliance officer | Sep 2026 | 1 of 9 staff | example |
| E2 | `DB` | `h_audit_event` coverage by regulated action | Sep 2026 | September cases | example |

## Who

The one person (`example`) who answers to the insurance regulator and the data-protection
law for how Harbor Cover distributes, keeps records and handles complaints (E1). Owns
`regulated-actions.md` and the audit view in Desk (E1).

## Jobs

- When a regulator asks about a case, the officer wants every regulated action on it with
  its evidence record, so the answer takes minutes. (E1, E2)
- When a complaint arrives, the officer wants it logged with a reference and a first-response
  clock, so nothing is late. (E1)
- When a feature changes a regulated action, the officer wants the register row updated
  before release, so the evidence does not drift from the product. (E1)

## Pain points

- `h_audit_event.metadata` empty since the August release (`example`); decline reasons now
  come from `h_case.reasons`. (E1, E2)
- Consent wording differs between Harbor and the WhatsApp template. (E1)

## What we don't know

- Whether the officer should approve customer copy on regulated actions before release, or
  review after — a process decision with no owner.
- The real volume of complaints by channel — logged in a sheet, not in Desk.
