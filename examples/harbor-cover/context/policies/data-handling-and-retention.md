---
title: Policy — data handling and retention
type: policy
status: active
version: 1.0
supersedes: —
decision_refs: []
why: States who may see which data, how long records are kept and what is masked, so every surface enforces the same rule
last_updated: 2026-11-02
---

# Policy — data handling and retention

> Last verified: 2026-11-02

**Owner:** compliance officer.
**Rule source:** the data-protection law; the insurance regulator's record-keeping rules.
**What the product must do:** show each role only the data in its row, keep records for the
period stated, mask identity numbers everywhere except the verification screen, and keep an
evidence record for every access to a masked value.

All values are invented and carry `example`.

## Who may see what

| Data | Customer | Support agent | Verification officer | Placement specialist | Claims handler | Field verifier | Referral agent | Insurer partner | Label |
|---|---|---|---|---|---|---|---|---|---|
| Case stage and sub-status | own | yes | yes | yes | yes | assigned cases | referred cases | submitted cases | example |
| Rework reason code and field | own | yes | yes | no | no | assigned items | no | no | example |
| Identity document image | own | no | yes | no | no | capture only, no view after send | no | yes, on submission | example |
| Identity number | masked | masked | full, on the verification screen | masked | masked | no | no | full, on submission | example |
| Premium and payment status | own | yes | no | yes | no | no | commission only | yes | example |
| Claim details and evidence | own | no | no | no | yes | no | no | yes, on the claim | example |
| Audit view | no | no | own actions | own actions | own actions | no | no | no | example |

The compliance officer and the ops lead see every row for their duties; each view is an
audit event.

## Retention

| Record | Kept for | Then | Label |
|---|---|---|---|
| Case, documents, verification, audit events on an issued policy | 7 years after the policy ends | deleted; the deletion is itself an audit event | example |
| Case that never reached `Policy issued` | 2 years after the last customer action | deleted | example |
| Identity-check provider responses | the life of the case plus 7 years | deleted with the case | example |
| Claim records | 7 years after the claim closes | deleted | example |
| Messaging logs | 2 years | deleted | example |

## Masking and sharing

| Condition | Outcome | Label |
|---|---|---|
| Identity number shown anywhere other than the verification screen | Last 4 characters only | example |
| Document sent to an insurer partner | Only the items on that partner's checklist; the transfer is an audit event | example |
| Referral agent views a case | Stage and sub-status only; no documents, no reasons, no premium | example |
| Customer asks for their data | Export of their case record within the period the law sets; the compliance officer owns the request | example |

## Configuration or code

The access table, retention periods and masking rules are configuration. How access is
enforced and how deletion runs is engineering's.
