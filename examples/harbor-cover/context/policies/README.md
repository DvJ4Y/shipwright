---
title: Internal policies — index
type: context-index
status: active
version: 1.0
supersedes: —
decision_refs: [D-004]
why: One place for every internal rule the product must enforce, as condition → outcome tables
last_updated: 2026-11-02
---

# Internal policies

> Last verified: 2026-11-02

An internal policy is a rule Harbor Cover sets for itself. A regulated action is a rule
set from outside (`../regulated-actions.md`). Keep them apart.

Every policy file has the same shape: a condition → outcome table, an owner role, a `Last
verified` line, a rule source, and one line that says what the product must do. Use
`templates/policy-template.md` for a new one. Production configuration is authoritative;
these files describe it and are refreshed from it.

All values are invented and carry `example`.

| File | Settles | Owner |
|---|---|---|
| `eligibility-rules.md` | Shop type × sum-insured band → risk tier; the hard rules; recovery paths | ops lead (proposes), product lead (ops and platform) locks |
| `document-checklist.md` | The documents per product and shop type; what makes a submission complete | ops lead |
| `risk-tiers-and-routing.md` | What each tier means for routing: desk check, inspection, refer | ops lead |
| `service-levels.md` | Time commitments per queue; hold and lapse rules | ops lead |
| `data-handling-and-retention.md` | Who may see what; how long records are kept; what is masked | compliance officer |

## How a policy changes

1. The owner proposes the change with the reason and the metric it should move.
2. The product lead logs it PENDING in `decisions/decision-log.md` with its blast radius:
   which surfaces, which messages, which QA rows.
3. The owner locks it. Configuration changes in production.
4. The policy file is refreshed from production and `Last verified` is updated.

A policy file edited before production changed is a plan, not a policy. Mark it `proposed`
in the table until production matches.
