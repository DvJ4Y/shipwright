---
title: 06 — Teams, and who does what
type: context
status: active
version: 1.0
supersedes: —
decision_refs: []
why: Settles roles, headcounts, the two product lanes and what nobody owns
last_updated: 2026-11-02
---

# 06 — Teams, and who does what

> Last verified: 2026-11-02

Roles, not names. Headcounts are invented and carry `example`.

## The product function — two lanes

| Lane | Role | Surfaces and capabilities | Label |
|---|---|---|---|
| Customer | one product lead, one designer | Harbor; customer messaging templates | example |
| Ops and platform | one product lead (the reader of this pack) | Desk, Field, the eligibility engine, data and messaging, policies | example |

The two lanes share the metrics dictionary, the decision log and this context folder. Each
lane runs its own feature folders under `products/`. The ops and platform lane carries the
larger surface area and the regulated actions.

## Operations

| Team | Size | Owns | Label |
|---|---|---|---|
| Support agents | 4 | First contact; collect quote data the customer did not finish online; `Quote` to `Documents` | example |
| Verification officers | 5 | Identity and document checks; apply the rules; raise rework; `Verification` | example |
| Placement specialists | 2 | Choose the insurer; handle insurer queries; payment; `Placement` | example |
| Claims handlers | 2 | Acknowledge, evidence, insurer follow-up; `Claim` | example |
| Ops lead | 1 | Queues and service levels; the `refer` queue; policy values | example |
| **Ops team total** | **14** | | example |
| Field verifiers | 9 across 3 regions | Shop inspections; replacement document capture | example |
| Compliance officer | 1 | Regulated actions, complaints, audit evidence; outside the ops team | example |

## External

| Who | Size | Relationship | Label |
|---|---|---|---|
| Referral agents | about 120 | Bring customers; track status in Field; paid commission on issued policies | example |
| Insurer partners | 6 | Carry the risk; issue the policy; settle claims | example |

## Engineering

| Role | Size | Label |
|---|---|---|
| Engineering lead | 1 | example |
| Developers across Harbor, Desk, Field, the engine and data | 7 | example |

Engineering briefs address the engineering lead. Product writes WHAT and WHY; engineering
writes HOW. There is no dedicated QA role; the QA catalog in `qa/` is run by whoever ships.

## Who decides what

| Decision | Owner |
|---|---|
| Rule tables, bands, tier matrix | ops lead proposes; product lead (ops and platform) locks |
| Service levels and hold rules | ops lead |
| Regulated-action wording and evidence | compliance officer |
| Customer copy and voice | product lead (customer) with the designer |
| Technical approach | engineering lead |
| Gates on product artifacts | the lane's product lead |

## What nobody owns

| Area | Reality today |
|---|---|
| Messaging templates across surfaces | Each lane edits its own; the set has drifted. Nobody owns the whole |
| Referral agent onboarding and training | The ops lead answers questions; there is no owner and no material |
| The `Renewal` journey | Live in production; no product owner; renewal reminders are a committed item |
| Secondary owners in the metrics dictionary | Named per row; several are blank |

A feature that touches an unowned area names a proposed owner as a PENDING decision.

## Where the lanes blur

| Area | Reality |
|---|---|
| Rework messages to the customer | Desk raises them (ops lane); Harbor shows them (customer lane). One feature, two owners — the ops lane leads and the customer lane reviews |
| Referral agent view in Field | External users on an internal app. Ops lane owns it; the customer lane reviews copy |
| The quote page premium range | Customer lane owns the page; the engine's bands are ops lane configuration |
