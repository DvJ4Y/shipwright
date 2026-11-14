---
title: Desk — current behaviour
type: current-behaviour
surface: desk
status: active
version: 1.0
supersedes: —
decision_refs: [D-002]
why: One durable statement of what Desk does today, so no PRD re-specifies a landed behaviour
last_updated: 2026-11-02
---

# Desk — current behaviour

> Last verified: 2026-11-02

This table is the durable requirements layer for Desk. One row per observable behaviour
that is live. The `land` skill appends rows here when a PRD reaches `shipped`, then sets the
PRD to `landed` with `landed_into:` pointing at the row ids. Rows are never deleted; a
replaced behaviour gets a new row and the old row's `Behaviour` is prefixed `SUPERSEDED by
DESK-nnn`.

**Before writing a PRD for this surface, read this table.** Desk is role-based: a behaviour
that differs by role is one row per role.

| ID | Behaviour | Source PRD | Landed on |
|---|---|---|---|
| DESK-001 | When a verification officer opens the verification queue, then cases are ordered by risk tier (3 first) and within a tier by time since entering the queue, oldest first | pre-pack (no PRD in this repo) | 2026-09 |
| DESK-002 | When a case is in the queue, then the row shows stage, sub-status, tier, time since entry against the service level, and PROVIDER-FAILED where the identity check timed out | pre-pack (no PRD in this repo) | 2026-09 |
| DESK-003 | When an officer opens a case, then the rule outcomes panel lists every rule that fired with its configured name and the input value that triggered it | pre-pack (no PRD in this repo) | 2026-07 |
| DESK-004 | When an officer returns a document, then a reason code (`unreadable`, `mismatched`, `missing`) is required and free text is optional; the rework item is created on save | pre-pack (no PRD in this repo) | 2026-08 |
| DESK-005 | When an officer sets `declined`, then a rule must be selected from the configured list and the recovery path text for that rule is shown before save | pre-pack (no PRD in this repo) | 2026-08 |
| DESK-006 | When a case has open rework items and a field verifier uploads a replacement, then the replacement is attached to the item and the case returns to the officer's queue at its original position | pre-pack (no PRD in this repo) | 2026-09 |
| DESK-007 | When a placement specialist opens a passed case, then the placement screen shows each insurer partner's appetite notes for the shop type and band, and the query thread per partner | pre-pack (no PRD in this repo) | 2026-07 |
| DESK-008 | When a claims handler opens a new claim, then an acknowledgement timer shows time remaining against the claim service level and turns amber at half the remaining time | pre-pack (no PRD in this repo) | 2026-08 |
| DESK-009 | When any user opens the audit view on a case, then every regulated action on the case is listed with actor role, time and a link to the evidence record | pre-pack (no PRD in this repo) | 2026-08 |
| DESK-010 | When a support agent opens a case, then the agent sees stage, sub-status and the customer's answers but cannot set `rework`, `refer` or `declined` | pre-pack (no PRD in this repo) | 2026-07 |
| DESK-011 | When a case is `refer`, then it appears in the ops lead's refer queue with the rule that referred it and leaves the officer's queue | pre-pack (no PRD in this repo) | 2026-08 |
| DESK-012 | When a verification officer returns a document with reason `mismatched`, then the field that differs must be chosen from the configured list before save, and the rework item carries the reason code, the field, what the record says and the requirement; when a field verifier proposed it on inspection, then the officer picks the field at confirmation | products/desk/verification-outcome-and-rework/shared/prd.md (A1; replaces DESK-004 (prefix SUPERSEDED on a real landing)) | rehearsal 2026-11-02 |
| DESK-013 | When a verification officer returns a document with reason `unreadable` or `missing`, then the rework item carries the reason code, the tip, the accepted alternatives and, for `missing`, why the insurer needs it | products/desk/verification-outcome-and-rework/shared/prd.md (A2) | rehearsal 2026-11-02 |
| DESK-014 | When a case in the verification queue has open rework rounds, then its row shows the count of open items, how many await re-check, the reason codes, the clock as stopped or paused and the hold date, and keeps its position; an item raised before this feature shows "not recorded" for the field | products/desk/verification-outcome-and-rework/shared/prd.md (A3; extends DESK-002) | rehearsal 2026-11-02 |
| DESK-015 | When a resubmission arrives by field send, new upload or corrected detail, then it attaches to the item as a new version of the same document, the case returns to the officer's queue at its original position, the re-check clock starts, and a duplicate in the same round sends one notification | products/desk/verification-outcome-and-rework/shared/prd.md (A8; replaces DESK-006 (prefix SUPERSEDED on a real landing)) | rehearsal 2026-11-02 |
| DESK-016 | When the identity-check provider does not answer within its timeout, then the row shows PROVIDER-FAILED with the attempt count, the case stays `open`, the verification clock pauses, `declined` cannot be set for the provider failure from the identity panel or the case, no rework item is raised on the identity proof, and every attempt writes an evidence record with the provider response reference, the result, the time and the officer role where an officer acted — regulated action: identity verification | products/desk/verification-outcome-and-rework/shared/prd.md (A9; extends DESK-002) | rehearsal 2026-11-02 |
| DESK-017 | When the retry limit is reached, then the verification officer records a manual verification with its method and result, the evidence record holds the method, the result, the officer's role, the time and the references of the failed attempts, and `not matched` returns the identity proof as `mismatched` with the field — regulated action: identity verification | products/desk/verification-outcome-and-rework/shared/prd.md (A10) | rehearsal 2026-11-02 |
| DESK-018 | When a round is raised, a replacement is captured or a detail is corrected, then the audit view lists an evidence record with the actor role, the time, the document reference and version, the reason code, the field that differs, the requirement shown and the message text version, or for a correction who, the old value, the new value and the time, and the compliance officer sees the delete-after date — regulated action: record retention; identity verification | products/desk/verification-outcome-and-rework/shared/prd.md (A11, A15; extends DESK-009) | rehearsal 2026-11-02 |
| DESK-019 | When the compliance officer opens the consent record on a case, then it holds the text version, time, channel and language, a record from before this feature shows "not recorded" for channel and language, and the verification officer sees own actions only — regulated action: consent and disclosure | products/desk/verification-outcome-and-rework/shared/prd.md (A12; extends DESK-009) | rehearsal 2026-11-02 |
| DESK-020 | When a support agent opens a case with open rework rounds, then return, refer and decline are disabled; the identity number shows its last 4 characters (`example`) outside the verification screen and each view of the full value is an audit event — regulated action: identity verification | products/desk/verification-outcome-and-rework/shared/prd.md (A13; extends DESK-010) | rehearsal 2026-11-02 |
| DESK-021 | When the verification officer records `accepted` on re-check, then the item closes; when the officer returns it again, then a new round opens on the same item with its own raised time and the customer is told what changed | products/desk/verification-outcome-and-rework/shared/prd.md (A14) | rehearsal 2026-11-02 |

## Reading the columns

| Column | Holds |
|---|---|
| `ID` | `DESK-nnn`, append-only |
| `Behaviour` | One observable "When … then …" sentence, scoped to a role where the role matters. A behaviour that performs a regulated action ends with "— regulated action: <register row>" |
| `Source PRD` | The PRD path under `products/desk/…/shared/`; `pre-pack` for behaviour that predates this repo |
| `Landed on` | The date the behaviour reached production (`YYYY-MM-DD`, written by `land`; pre-pack rows carry a month). `rehearsal 2026-11-02` marks a row from the worked feature's PRD (v1.1, in review) that has not shipped. A rehearsal never prefixes a row |

## Gaps the table makes visible

- DESK-004 records the reason code but not the field that differs on `mismatched`. DESK-012
  replaces DESK-004 (prefix SUPERSEDED on a real landing) and is at rehearsal; nothing has
  shipped.
- No live row states what the queue shows when a case has more than one open rework item.
  DESK-014 states it at rehearsal.
- The refer queue (DESK-011) has no service level row; see `policies/service-levels.md`.
