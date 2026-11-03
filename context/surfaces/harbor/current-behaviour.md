---
title: Harbor — current behaviour
type: current-behaviour
surface: harbor
status: active
version: 1.0
supersedes: —
decision_refs: [D-003]
why: One durable statement of what Harbor does today, so no PRD re-specifies a landed behaviour
last_updated: 2026-11-02
---

# Harbor — current behaviour

> Last verified: 2026-11-02

This table is the durable requirements layer for Harbor. One row per observable behaviour
that is live. The `land` skill appends rows here when a PRD reaches `shipped`, then sets the
PRD to `landed` with `landed_into:` pointing at the row ids. Rows are never deleted; a
replaced behaviour gets a new row and the old row's `Behaviour` is prefixed `SUPERSEDED by
HUB-nnn`.

**Before writing a PRD for this surface, read this table.** Most "new" behaviour is an
extension of a row below. Cite the row id in the PRD's "Current behaviour and reuse" section.

| ID | Behaviour | Source PRD | Landed on |
|---|---|---|---|
| HUB-001 | When a customer enters shop type, sum insured and location on the quote page, then the page shows a premium range before any eligibility question is asked | pre-pack (no PRD in this repo) | 2026-09 |
| HUB-002 | When a customer enters a mobile number, then a one-time code is required unless the customer arrived from a WhatsApp link, in which case the code step is skipped | pre-pack (no PRD in this repo) | 2026-06 |
| HUB-003 | When a customer chooses a language at entry, then every screen and every message for the case uses that language until the customer changes it | pre-pack (no PRD in this repo) | 2026-06 |
| HUB-004 | When the eligibility engine returns a tier, then the premium range narrows and the document checklist for the product and shop type is shown in full before the first upload | pre-pack (no PRD in this repo) | 2026-07 |
| HUB-005 | When the eligibility engine returns `declined`, then the screen shows the rule in plain words, what would change the outcome, and a link to the recovery route; no numeric score is shown | pre-pack (no PRD in this repo) | 2026-07 |
| HUB-006 | When the eligibility engine returns `refer`, then the screen says a person will review the case and states the service level; the word "declined" does not appear | pre-pack (no PRD in this repo) | 2026-08 |
| HUB-007 | When a customer uploads a document, then the checklist item shows `received`; the customer can replace it until verification starts | pre-pack (no PRD in this repo) | 2026-07 |
| HUB-008 | When a rework item is raised on a case, then the customer's status page lists each returned document with its reason code and one next step, and a WhatsApp message carries the same list | pre-pack (no PRD in this repo) | 2026-08 |
| HUB-009 | When the identity check is `provider-failed`, then the customer sees "We could not complete the identity check. We will retry; nothing is needed from you." and the case does not show `declined` | pre-pack (no PRD in this repo) | 2026-09 |
| HUB-010 | When a case reaches `Placement`, then the customer sees the chosen insurer, the final premium and a payment link; the link is also sent on WhatsApp | pre-pack (no PRD in this repo) | 2026-07 |
| HUB-011 | When a policy is issued, then the policy document is available on the status page and the cooling-off end date is shown | pre-pack (no PRD in this repo) | 2026-07 |
| HUB-012 | When a customer opens a claim, then a reference and the acknowledgement service level are shown immediately, and the claim appears on the status page with its stage | pre-pack (no PRD in this repo) | 2026-08 |
| HUB-013 | When a rework round is raised on a case, then the status page and the WhatsApp message list each returned document with what happened, what it means for the policy, the requirement in plain words, the tip, the accepted alternatives, the recovery paths, the send-by window and "talk to our team", in the case language; a `mismatched` item names the detail that differs and what the record says; the configured rule name and the risk tier never appear | products/desk/verification-outcome-and-rework/shared/prd.md (A4, A5) | rehearsal 2026-11-02 |
| HUB-014 | When a customer corrects a case detail, then the page says the premium range may change before confirmation, the rules re-run after it and the customer sees the new range or the refer or declined screen with its recovery path, and a name or date-of-birth correction re-runs the identity check — regulated action: identity verification | products/desk/verification-outcome-and-rework/shared/prd.md (A15) | rehearsal 2026-11-02 |
| HUB-015 | When a customer views the rework list, then it shows what was agreed, when and on which channel, and the message asks for nothing outside the consented checklist — regulated action: consent and disclosure | products/desk/verification-outcome-and-rework/shared/prd.md (A12) | rehearsal 2026-11-02 |
| HUB-016 | When the send-by window ends with an item open, then the case moves to `on hold` and the customer message gives what happened, what it means, the open paths and the lapse date; when 30 days (`example`) pass on hold, then the case is `lapsed` and the message offers to start again with documents kept | products/desk/verification-outcome-and-rework/shared/prd.md (A16) | rehearsal 2026-11-02 |
| HUB-017 | When the identity check is provider-failed, then the customer message also offers "talk to our team", combines with any open items, and shows no send-by field when nothing is returned | products/desk/verification-outcome-and-rework/shared/prd.md (A9; extends HUB-009) | rehearsal 2026-11-02 |
| HUB-018 | When the verification officer records `accepted` on re-check, then the customer's list shows the item done; when the officer returns it again, then the same item shows what changed, the new requirement in plain words in the case language and the take-another-look path | products/desk/verification-outcome-and-rework/shared/prd.md (A14) | rehearsal 2026-11-02 |

## Reading the columns

| Column | Holds |
|---|---|
| `ID` | `HUB-nnn`, append-only |
| `Behaviour` | One observable "When … then …" sentence. No mechanism, no screen component names. A behaviour that performs a regulated action ends with "— regulated action: <register row>" |
| `Source PRD` | The PRD path under `products/hub/…/shared/`; `pre-pack` for behaviour that predates this repo |
| `Landed on` | The date the behaviour reached production (`YYYY-MM-DD`, written by `land`; pre-pack rows carry a month) |

## Gaps the table makes visible

- The rework list (HUB-008) shows the reason code but not the field that differs on a
  `mismatched` document. The worked feature (`products/desk/verification-outcome-and-rework/`)
  extends this row.
- No row covers `Renewal`. The renewal journey is live but unspecified (commitment C8).
