---
title: Policy — service levels
type: policy
status: active
version: 1.0
supersedes: —
decision_refs: [D-004]
why: States the time each queue commits to and the hold and lapse rules, so timers, messages and metrics agree
last_updated: 2026-11-02
---

# Policy — service levels

> Last verified: 2026-11-02

**Owner:** ops lead.
**Rule source:** internal, except claim acknowledgement and complaint response, which the
insurance regulator's conduct rules set as minimums (`../regulated-actions.md`).
**What the product must do:** show every clock to the role that owns it, tell the customer
the commitment in plain words, and report each guardrail beside the outcome it protects.

All values are invented and carry `example`. A service level is measured from the moment
the item enters the queue to the first outcome, in clock hours.

## Service levels per queue

| Queue | Commitment | Owner | Customer is told | Guardrail | Label |
|---|---|---|---|---|---|
| Verification | first outcome within 24 hours | verification officers | "within one working day" | `VER-G1` | example |
| Rework re-check after resubmission | within 12 hours | verification officers | "we will check it the same day" | — | example |
| Refer queue | decision within 24 hours | ops lead | "our team will take a look within a day" | — | example |
| Placement | insurer submission within 48 hours of `pass` | placement specialists | "your policy is being placed" | — | example |
| Claim acknowledgement | within 48 hours of the claim being opened | claims handlers | reference and the commitment, immediately | `CLM-M1` | example |
| Complaint first response | within 3 working days | compliance officer | reference and the commitment | — | example |
| Field inspection | visit within 72 hours of the task being created | field verifiers | "a visit is being arranged" | — | example |

## Clock rules

| Condition | Outcome | Label |
|---|---|---|
| Identity check is `provider-failed` | The verification clock pauses until the retry succeeds or manual verification starts | example |
| Case moves to `on hold` | All clocks pause; they resume when the customer acts | example |
| Rework raised | The verification clock stops; the rework re-check clock starts on resubmission | example |

## Hold and lapse rules

| Condition | Outcome | Label |
|---|---|---|
| Rework item not resubmitted within 7 days of being raised | Case moves to `on hold`; customer and referral agent are told | example |
| Payment link not completed within 7 days | Case moves to `on hold` | example |
| Case `on hold` with no customer action for 30 days | Case moves to `lapsed`; customer is told how to re-enter | example |
| Customer acts on a lapsed case | Customer re-enters at `Quote`; previous documents are offered for reuse within the retention period | example |

The 7-day (`example`) rework window is PENDING (`D-004`); production runs the value above.

## Configuration or code

Commitments, clock rules and hold rules are configuration. Timers, notifications and queue
mechanics are engineering's.
