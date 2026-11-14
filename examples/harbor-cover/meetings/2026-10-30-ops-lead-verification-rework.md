---
title: "Ops lead — verification rework, 2026-10-30"
type: meeting-note
status: processed
owner: product lead
why: Intake for the verification-outcome-and-rework feature; three questions closed, two decisions raised
last_updated: 2026-10-30
---

# Ops lead — verification rework (2026-10-30)

Present: the product lead, the ops lead, one verification officer. Notes by the product lead.
All figures `operational — unverified`, as stated in the meeting, 2026-10-30.

## Outcomes

| Outcome | Routed to |
|---|---|
| Verification queue service level cut from 24 to 12 hours, effective today | `context/policies/service-levels.md` (proposed until production configuration matches); miner question |
| About 1 in 3 rework items is raised for a document the customer could not have known was needed | `internal/discovery.md` evidence (`example`) |
| Which rework reasons a field verifier may resolve on site stays open | `decisions/decision-log.md` D-006, PENDING, owner ops lead |
| A rework item must carry the rule that fired, in the officer's words | feature decision log, PENDING, owner product lead |
| On a provider timeout the officer cannot see retries run or due; Field shows nothing | discovery scope; D-007 retry limit |

## Follow-ups

- Product lead: frame D-006 and the rule-on-item decision for `/decide`.
- Ops lead: confirm the 12-hour service level is configured in Desk before the policy file changes.
- No tracker issue created; `/meeting-processor` proposed none.
