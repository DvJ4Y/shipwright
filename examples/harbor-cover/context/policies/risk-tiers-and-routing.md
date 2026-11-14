---
title: Policy — risk tiers and routing
type: policy
status: active
version: 1.0
supersedes: —
decision_refs: [D-002]
why: States what each risk tier means for who works the case and whether a shop inspection is needed
last_updated: 2026-11-02
---

# Policy — risk tiers and routing

> Last verified: 2026-11-02

**Owner:** ops lead.
**Rule source:** internal; aligned with insurer partner survey requirements.
**What the product must do:** order the verification queue by tier then age, show the tier
to staff and never to the customer, and route inspections and refers as the table says.

All values are invented and carry `example`.

## What each tier means

| Tier | Meaning | Who works it | Shop inspection | Label |
|---|---|---|---|---|
| 1 | Low: common shop type, low band, no risk flags | verification officer, desk check only | no | example |
| 2 | Standard: mid band or a raised flag | verification officer, desk check | yes, if band C; otherwise no | example |
| 3 | Elevated: high band, open storage, or food service | verification officer plus field verifier | yes, always | example |
| refer | A person must decide before the case proceeds | ops lead, refer queue | decided by the ops lead | example |

## Routing rules

| Condition | Outcome | Label |
|---|---|---|
| Tier 1 or 2, no inspection | Case enters the verification queue on tier and age | example |
| Tier 2 band C, or tier 3 | Inspection task is created for the field verifier of the shop's region at the same time as the verification task | example |
| Inspection returns `rework` on an item | Rework item is raised; customer is told after the officer confirms | example |
| Tier 3 passes verification | Placement specialist reviews before submission to the insurer | example |
| `refer` resolved by the ops lead | Case is assigned a tier and enters the verification queue at the front of its tier | example |
| Officer raises the tier during verification | Routing follows the new tier; the change is an audit event | example |

## Queue ordering — the shipped rule

The verification queue is ordered by tier, 3 first, then by time since entering the queue,
oldest first (DESK-001). PROVIDER-FAILED items keep their position and show the flag.

## Service level by tier

Service levels are per queue, not per tier (`service-levels.md`). A tier 3 case has the same
24-hour verification service level (`example`) as a tier 1 case; the ordering is what gets
it worked first.

## Configuration or code

Tier meanings, inspection conditions and routing are configuration. How tasks are created
and assigned is engineering's.
