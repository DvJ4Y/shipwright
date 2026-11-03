---
title: Field — current behaviour
type: current-behaviour
surface: field
status: active
version: 1.0
supersedes: —
decision_refs: []
why: One durable statement of what Field does today, so no PRD re-specifies a landed behaviour
last_updated: 2026-11-02
---

# Field — current behaviour

> Last verified: 2026-11-02

This table is the durable requirements layer for Field. One row per observable behaviour
that is live. The `land` skill appends rows here when a PRD reaches `shipped`, then sets the
PRD to `landed` with `landed_into:` pointing at the row ids. Rows are never deleted; a
replaced behaviour gets a new row and the old row's `Behaviour` is prefixed `SUPERSEDED by
FLD-nnn`.

**Before writing a PRD for this surface, read this table.** Field serves two users — field
verifiers and referral agents — who never see each other's screens.

| ID | Behaviour | Source PRD | Landed on |
|---|---|---|---|
| FLD-001 | When a field verifier opens the day, then the route lists assigned cases with shop name, address, tier and the count of open rework items on each | pre-pack (no PRD in this repo) | 2026-08 |
| FLD-002 | When a verifier opens an inspection, then the checklist for the shop type is shown with mandatory photo slots, each slot stating what the officer needs to see | pre-pack (no PRD in this repo) | 2026-07 |
| FLD-003 | When a mandatory slot is empty, then the inspection cannot be submitted and the empty slots are listed | pre-pack (no PRD in this repo) | 2026-07 |
| FLD-004 | When the device has no network, then captures save on the device and send when the network returns; the case shows `pending send` until then | pre-pack (no PRD in this repo) | 2026-08 |
| FLD-005 | When a case has an open rework item, then the verifier can capture the replacement document against that item from the case screen, and the item shows `replacement sent` | pre-pack (no PRD in this repo) | 2026-09 |
| FLD-006 | When a verifier marks an inspection item `rework`, then a reason is required and the customer is not notified until the officer confirms | pre-pack (no PRD in this repo) | 2026-08 |
| FLD-007 | When a referral agent adds a referral, then a name and mobile number are enough to save it, and the case is created at `Quote` with the agent attached | pre-pack (no PRD in this repo) | 2026-06 |
| FLD-008 | When a referral agent opens a referral, then the stage and sub-status are shown with a one-line meaning; rework reason codes are not shown | pre-pack (no PRD in this repo) | 2026-09 |
| FLD-009 | When a referred case moves to `on hold`, then the agent receives a notification naming the referred customer and that a customer action is pending | pre-pack (no PRD in this repo) | 2026-09 |
| FLD-010 | When a referred policy is issued, then the commission ledger shows the amount, the policy reference and the expected payout month | pre-pack (no PRD in this repo) | 2026-09 |
| FLD-011 | When a field verifier opens an assigned case, then every open rework item is listed with the document, the reason, what the officer needs to see and whether it may be captured on site, and the capture action is disabled for reasons not resolvable on site (default `mismatched`) | products/desk/verification-outcome-and-rework/shared/prd.md (A7; extends FLD-005) | rehearsal 2026-11-02 |
| FLD-012 | When a field verifier sends a replacement, then the item shows `pending send` without network and `replacement sent` once sent, a multi-photo item cannot be sent until every slot is filled, the capture attaches as a new version of the same document, and after send the verifier cannot open any capture, including the offline copy — regulated action: record retention | products/desk/verification-outcome-and-rework/shared/prd.md (A8, A13; extends FLD-005) | rehearsal 2026-11-02 |
| FLD-013 | When any Field screen shows a case, then the identity number is never shown, and a referral agent sees stage and sub-status only — regulated action: identity verification | products/desk/verification-outcome-and-rework/shared/prd.md (A13) | rehearsal 2026-11-02 |

## Reading the columns

| Column | Holds |
|---|---|
| `ID` | `FLD-nnn`, append-only |
| `Behaviour` | One observable "When … then …" sentence, scoped to verifier or agent. A behaviour that performs a regulated action ends with "— regulated action: <register row>" |
| `Source PRD` | The PRD path under `products/field/…/shared/`; `pre-pack` for behaviour that predates this repo |
| `Landed on` | The date the behaviour reached production (`YYYY-MM-DD`, written by `land`; pre-pack rows carry a month) |

## Gaps the table makes visible

- FLD-005 does not state which rework reasons a verifier may resolve on site; the worked
  feature decides this (`D-006`).
- No row covers the verifier's view of a `provider-failed` identity check.
- The referral agent sees no rework reason (FLD-008); whether they should is a data-handling
  decision for the compliance officer.
