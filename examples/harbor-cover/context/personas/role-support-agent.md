---
title: "Persona: Support agent — first contact, quote data"
type: persona-card
kind: internal-role
status: evidence-backed
version: 1.0
owner: product lead (ops and platform)
supersedes: —
decision_refs: []
last_verified: 2026-11-02
last_updated: 2026-11-02
why: Grounds persona-panel critique of first-contact and data-collection workflows
---

# Persona: Support agent — first contact, quote data

> Last verified: 2026-11-02

> Used by the persona panel. Every claim cites an evidence row or is listed under "What we
> don't know". Panel output from this card is labelled SYNTHETIC.

## Evidence sources

| # | Source (README code) | Type | Date | Sample | Label |
|---|---|---|---|---|---|
| E1 | `OI` | interviews with support agents | Sep 2026 | 2 of 9 staff | example |
| E2 | `SR` | support call review | Sep 2026 | 40 recordings | example |
| E3 | `DB` | `h_case` entering `Quote` by channel | Sep 2026 | September cases | example |

## Who

One of four agents (`example`) working Desk and WhatsApp in shifts (E1). First contact for
customers who message, call, or leave a quote half-finished on Harbor (E1, E3). Collects
the quote data the customer did not enter and moves the case to `Eligibility` (E1).

## Jobs

- When a customer stops at the premium range, the agent wants to know what they saw and
  where they stopped, so the call starts from there. (E1, E2)
- When a customer asks "what documents", the agent wants the checklist for that shop type on
  screen, so the answer is the same as Harbor's. (E1, E2)
- When a referred customer arrives, the agent wants the referral agent's notes, so the
  customer is not asked the same things twice. (E1)

## Pain points

- Repeating the quote questions a customer already answered on Harbor. (E1, E2)
- Explaining `declined` without the rule in plain words on screen. (E1, E2)
- Callbacks promised on WhatsApp are tracked in a personal list, not in Desk. (E1)

## Operational constraints

| Dimension | Reality | Evidence |
|---|---|---|
| Volume | Each agent handles the day's new quotes and the WhatsApp inbox | E1 |
| Channel | WhatsApp templates plus calls; Desk open at all times | E1, E2 |
| Language | Speaks the customer's language; Desk is in English | E1 |
| Authority | Can move `Quote` → `Eligibility` and put a case `on hold`; cannot decline | E1 |

## What we don't know

- Average handling time per first contact — needs call data joined to cases; not built.
- Whether a warm transfer to a verification officer would cut repeat calls — test it.
