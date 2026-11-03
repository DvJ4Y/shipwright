---
title: 04 — Eligibility and verification
type: context
status: active
version: 1.0
supersedes: —
decision_refs: [D-007]
why: Settles how the engine decides, what verification checks and what rework means — WHAT only
last_updated: 2026-11-02
---

# 04 — Eligibility and verification

> Last verified: 2026-11-02

Product owns the rules and the outcome vocabulary. Engineering owns how the engine evaluates
them. This file states the WHAT.

## The eligibility engine

The engine takes the customer's answers and returns one outcome per case. The rule tables
are configuration (`policies/eligibility-rules.md`); the outcome vocabulary is fixed.

**Inputs:** shop type · sum-insured band per product · location · construction and storage
answers · prior claims declared · fire-safety evidence declared.

**Decision:** shop type × sum-insured band → risk tier, then hard rules that can override to
`refer` or `declined`.

| Outcome | Meaning | What the customer sees |
|---|---|---|
| `tier assigned` (1, 2 or 3) | Case proceeds to `Documents`; the tier sets the checklist and routing | The premium range narrows; the document checklist appears |
| `refer` | A person must decide; the case goes to the ops lead's queue | "We need a quick look from our team" with the service level |
| `declined` | Current information does not fit the rules | The rule in plain words, what would change it, and where to do it |

Two distinctions to hold:

- **Tier assigned ≠ policy issued.** Verification and placement can still change the path.
- **`refer` ≠ `declined`.** A referred case is open. Never show a referred customer a decline.

## Verification — what it checks

A verification officer works a case in Desk against the checklist for its product and shop
type (`policies/document-checklist.md`).

| Check | Source | Outcome values |
|---|---|---|
| Identity | identity-check provider, against the identity proof uploaded | `verified` · `not matched` · `provider-failed` |
| Each checklist document | the upload | `accepted` · `unreadable` · `mismatched` · `missing` |
| Shop inspection (tier 2 in the high band, all tier 3) | Field checklist and photos | `accepted` · `rework` |
| Rules re-run on verified data | the eligibility engine | tier confirmed · `refer` · `declined` |

The case outcome is `pass` only when identity is `verified`, every checklist item is
`accepted` and the re-run confirms the tier.

Verification is not the insurer's underwriting. The insurer may still ask questions at
`Placement`; the placement specialist answers them from the verified record.

## Rework — what it means

Rework is a returned document, not a returned case. The case stays at `Verification` with
sub-status `rework`.

| Trigger | Rework item carries | Customer path |
|---|---|---|
| `unreadable` | the document, the reason code, a capture tip | Re-upload on Harbor, or a field verifier captures it on site |
| `mismatched` | the document, which field differs from the identity record | Re-upload the correct document, or correct the case detail |
| `missing` | the checklist item name and why it is needed | Upload on Harbor, or the field verifier captures it on site |

One rework item per document. A case can carry several. The officer sees them as a group;
the customer sees one list with one next step each.

## The provider-failed case

When the identity-check provider does not answer within 90 seconds (`example`):

| Rule | Behaviour |
|---|---|
| The case is never declined on a provider failure | Sub-status stays `open`; the identity check moves to a retry queue |
| The customer is told | "We could not complete the identity check. We will retry; nothing is needed from you." |
| The officer sees it | The queue row shows PROVIDER-FAILED, not a blank |
| After the retry limit | The officer verifies manually from the uploaded identity proof and records the method |

The retry limit is an ops policy value and is open (`D-007`).

## Configuration or code — product writes the WHAT

| Item | Owned as |
|---|---|
| Sum-insured bands, tier matrix, hard rules | configuration; product and ops lead change them |
| Document checklist per product and shop type | configuration |
| Reason codes for rework | configuration; the list is product-owned |
| Service levels per queue | configuration |
| Message templates per outcome and language | configuration |
| How the engine evaluates, stores and versions rules | engineering |
| How retries, timeouts and queues are implemented | engineering |

Product documents name the configuration item and the value. They never describe the
mechanism.

## Where to check these facts

| Question | Where |
|---|---|
| Which rule fired on a case | Desk case view, "rule outcomes" |
| The current rule tables | `policies/eligibility-rules.md`; production configuration is authoritative |
| Outcome counts | the SQL replica, `h_verification.outcome` |
| First-pass and rework figures | the BI tool, `VER-M1`, `VER-M2` |
