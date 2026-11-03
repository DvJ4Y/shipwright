---
title: 07 — Glossary
type: context
status: active
version: 1.0
supersedes: —
decision_refs: []
why: One term per concept, so every document says the same thing the same way
last_updated: 2026-11-02
---

# 07 — Glossary

> Last verified: 2026-11-02

One term per concept. Use the term in the left column in every document. Chat may use the
reader's own words (`_profile.md`, "My words → our terms").

## Terms that carry a specific meaning here

| Term | What it means | Not |
|---|---|---|
| **case** | One request for one policy from one customer, from `Quote` to `Active` and beyond | lead, application, file |
| **customer** | The shop owner or policyholder | user, client |
| **policyholder** | The named person on the issued policy; may differ from the person on WhatsApp | — |
| **sum insured** | The amount of cover the customer asks for, per product | coverage amount, limit |
| **sum-insured band** | One of the configured ranges the engine uses | bracket, slab |
| **risk tier** | The engine's output: 1, 2 or 3, from shop type × sum-insured band and the hard rules | risk score, grade |
| **refer** | A case a person must decide; it is open, not declined | manual review, escalation |
| **declined** | Current information does not fit the rules; always carries a recovery path | rejected, failed |
| **recovery path** | What would change a declined or rework outcome, and where to do it | appeal, retry |
| **rework** | A returned document with a reason code; the case stays at `Verification` | resubmission, bounce |
| **reason code** | The configured reason on a rework item: `unreadable`, `mismatched`, `missing` | comment, note |
| **on hold** | A customer-side condition is pending | paused, waiting |
| **lapsed** | A hold expired, or a policy was not renewed | expired, dead |
| **placement** | Choosing the insurer and submitting the verified case | underwriting, binding |
| **cooling-off** | The period after `Policy issued` in which the customer may cancel for a refund | free-look, grace period |
| **service level** | The time a queue commits to; a policy value per queue | SLA, TAT |
| **inspection** | A field verifier's shop visit with the checklist and photos | survey, audit |
| **replacement document** | A document the field verifier captures on site against a rework item | re-upload |
| **provider-failed** | The identity-check provider did not answer within its timeout | error, timeout |
| **regulated action** | One of the six actions in `regulated-actions.md` | compliance item |
| **evidence record** | The audit row kept for a regulated action | log, trail |
| **landed** | A shipped PRD whose behaviours are now rows in `current-behaviour.md` | closed, done |

## Stage vocabulary

The production stage names, in order: `Quote` · `Eligibility` · `Documents` ·
`Verification` · `Placement` · `Policy issued` · `Active` · then `Claim` · `Renewal`.
Sub-statuses: `open` · `on hold` · `rework` · `declined` · `cancelled` · `lapsed`.
Funnel words for charts: `Quote` · `Eligible` · `Documented` · `Verified` · `Issued`.

## Delivery vocabulary

| Term | Means |
|---|---|
| `committed` | On the commitments list; not yet in build |
| `in build` | Engineering is working on it |
| `in UAT` | Built; being accepted by ops or product |
| `deployed to prod` | Live for customers or staff. **The only state that counts as shipped**, once the product lead confirms the behaviour in production |
| `Done` in the tracker | The engineer finished; it may not be deployed. Never report `Done` as shipped |
| `shipped` (PRD status) | Set after release reconciliation shows `deployed to prod` |
| `landed` (PRD status) | Set by `land` after the behaviours are appended to `current-behaviour.md` |

## Systems

| Name | What |
|---|---|
| Harbor | customer web app · workstream code `hub` · current-behaviour ids `HUB-` |
| Desk | internal ops console · workstream code `desk` · current-behaviour ids `DESK-` |
| Field | field and partner app · workstream code `field` · current-behaviour ids `FLD-` |
| the eligibility engine | rule configuration and outcomes · workstream code `rules` |
| the SQL replica | `harbor_replica`, read-only |
| the BI tool | funnel and impact views |
| event analytics | behaviour events |
| the tracker | issues; product team key `HBR`; the engineering team's key is recorded here once the adapter asks for it |

## Capability names, not vendor names

| Write | Not |
|---|---|
| identity-check provider | the vendor's name |
| payment provider | the vendor's name |
| WhatsApp BSP, or "WhatsApp" | the vendor's name |
| event analytics | the vendor's name |
| the BI tool | the vendor's name |
| the tracker | the vendor's name, except where the adapter is meant |

## Themes

Theme codes are in `08-strategy-and-outcomes.md`. Use the code and the name together on
first mention in a document.
