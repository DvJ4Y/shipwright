---
title: 03 — Surfaces and systems
type: context
status: active
version: 1.0
supersedes: —
decision_refs: []
why: Settles what exists, its status and every integration by capability name
last_updated: 2026-11-02
---

# 03 — Surfaces and systems

> Last verified: 2026-11-02

Three surfaces, one engine, and a data and messaging layer. Workstream codes are the folder
names under `products/`.

## What exists

| Surface | Code | Who uses it | What it does | Status |
|---|---|---|---|---|
| **Harbor** — customer web app | `hub` | customers, with referral agents alongside | quote, eligibility, documents, payment, policy and claim tracking | live |
| **Desk** — internal ops console | `desk` | support agents, verification officers, placement specialists, claims handlers, ops lead, compliance officer | verification queue, rule outcomes, insurer placement, claims, audit view | live |
| **Field** — field and partner app | `field` | field verifiers, referral agents | shop inspection checklist and photos; referral status | live |
| **the eligibility engine** | `rules` | configured by product and ops; run by Harbor and Desk | rule configuration and outcomes; a capability, not a surface | live |
| Data and messaging | `data`, `comms` | everyone | event analytics, the SQL replica, the BI tool; WhatsApp, SMS and email templates | live; email templates partial |

## Harbor — the detail that matters

- The quote page shows the premium range before eligibility (shipped; `surfaces/harbor/current-behaviour.md` HUB-001).
- Entry is a mobile number and a one-time code. A customer arriving from a WhatsApp link skips the code.
- The customer's language is chosen at entry and held for the whole journey, including messages.
- Documents are uploaded one checklist item at a time; the checklist is per product and shop type.
- A `declined` or `rework` outcome shows the reason in plain words and the recovery route.
- Status and claim tracking need no call. This is the job on the electronics-retail persona card (`personas/customer-arjun.md`).

## Desk — what is already built

- Verification queue ordered by risk tier, then by age (shipped; DESK-001).
- Rule outcomes shown per case with the rule that fired.
- Rework items with reason codes; the officer picks a reason, never free text alone.
- Placement screen with insurer appetite notes and query threads.
- Claims desk with the acknowledgement timer.
- Audit view: every regulated action with the evidence record.

Do not propose a new dashboard. Extend the queue and the case view.

## Field — what is already built

- Inspection checklist per shop type with mandatory photo slots.
- Replacement document capture on site, attached to the rework item.
- The referral agent's referral list with stage and sub-status, and the commission ledger.

## Integrations — by capability name

| Capability | Purpose | Status | Note |
|---|---|---|---|
| identity-check provider | Verifies the policyholder's identity document against the issuing registry | live | Times out at 90 seconds (`example`); the officer retries by hand today and an automatic retry queue is in UAT (C4); a timeout never sends the case to `declined` |
| payment provider | Collects the premium and fees at `Placement` | live | Payment links in WhatsApp and Harbor |
| WhatsApp BSP | Customer and referral-agent messaging | live | The main channel; templates per stage and language |
| SMS and email | Fallback messaging and policy documents | partial | Email templates for `Policy issued` and `Claim` only |
| insurer partner APIs | Case submission, query threads, issuance, claim status | live for 4 of 6 partners (`example`) | The other 2 run on email and a shared sheet (`example`) |
| event analytics | Behaviour on Harbor and Field | live | Event names in `05-numbers-data-and-traps.md` |
| SQL replica | Read-only copy of production for counts | live | `harbor_replica`; tables in `05` |
| BI tool | Funnel and impact views | live | Authoritative for funnel figures |
| tracker | Product and engineering issues | live | Team key `HBR`; second adapter available |

## Already done — do not re-propose

| Capability | Where |
|---|---|
| Premium range before eligibility | Harbor quote page |
| Risk-tier ordering of the verification queue | Desk |
| Reason codes on rework | Desk, surfaced on Harbor |
| Replacement document capture on site | Field |
| Referral agent status view | Field |
| Audit view of regulated actions | Desk |

## Where product documents live

| Path | Contents |
|---|---|
| `products/<code>/<feature>/shared/` | PRD and engineering brief — self-contained, readable by engineering |
| `products/<code>/<feature>/internal/` | Discovery, decision log, data packet, reviews, readiness, issue pack, crosswalk |
| `products/<code>/<feature>/mockups/` | Wireframes and prototypes, versioned by filename |
| `context/surfaces/<surface>/current-behaviour.md` | What is live today; `land` appends here |
