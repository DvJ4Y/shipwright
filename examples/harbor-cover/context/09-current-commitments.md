---
title: 09 — Current commitments (snapshot)
type: context
status: active
version: 1.0
supersedes: —
decision_refs: [D-002, D-003]
why: A dated snapshot of committed work and its delivery state, so planning starts from what exists
last_updated: 2026-11-02
---

# 09 — Current commitments — snapshot

> Last verified: 2026-11-02

This is a snapshot. The tracker (team `HBR`) is live and wins on any disagreement. Status
vocabulary: `committed` · `in build` · `in UAT` · `deployed to prod`. Only `deployed to prod`
is shipped.

| # | Capability | Lane | Theme | Status | Metric | Areas |
|---|---|---|---|---|---|---|
| C1 | Verification outcome and rework — plain reason and recovery route on Harbor; rework item with the rule that fired on Desk; replacement capture on Field | ops and platform | `VEF`, `CTT`, `CMP` | committed (at discovery) | `VER-M1`, `VER-M2` | Harbor, Desk, Field, engine, comms |
| C2 | Desk verification queue ordered by risk tier, then age | ops and platform | `VEF` | deployed to prod | `VER-G1` | Desk |
| C3 | Harbor quote page shows the premium range before eligibility | customer | `CTT` | deployed to prod | `QUO-M1` | Harbor |
| C4 | Automatic retry queue on provider timeout (today the officer retries by hand; the customer message is live as HUB-009) | ops and platform | `VEF`, `CMP` | in UAT | `VER-M1` | Desk, Harbor, comms |
| C5 | Replacement capture from the inspection checklist itself (today FLD-005 captures from the case screen; attachment to the item is live as DESK-006) | ops and platform | `VEF` | in build | `VER-M2` | Field, Desk |
| C6 | Claim acknowledgement message sent inside the service level, with the evidence record | ops and platform | `CLM`, `CMP` | in build | `CLM-M1` | Desk, comms |
| C7 | Referral agent referral status and commission ledger in Field | ops and platform | `REF` | deployed to prod | `REF-M1` | Field |
| C8 | Renewal reminder sequence before expiry, in the customer's language | customer | `CTT` | committed | `POL-M1` | Harbor, comms |

## Reading the table

- `C1` is the worked feature in this pack: `products/desk/verification-outcome-and-rework/`.
- `C2` and `C3` are live. Their behaviours are rows in `surfaces/*/current-behaviour.md`.
- `C4` to `C6` are engineering's. Product's job is acceptance against the PRD and the QA rows.
- `C8` has no PRD yet. It starts at discovery.

## Deliberately not in scope this window

| Item | Why |
|---|---|
| A separate claims portal | The claims desk lives in Desk; the customer tracks claims in Harbor. No third surface |
| Insurer-side document upload | The insurer partner APIs carry documents; a partner portal duplicates them |
| Automated decline without a recovery path | Violates the lifecycle rule in `02`; not a feature |
| Numeric risk score shown to customers | Tiers are internal routing. The customer sees a premium range and a checklist |

## Refreshing this file

After each release reconciliation, move items whose state changed, add new committed items,
and update `Last verified`. Remove nothing; a dropped item moves to the table above with the
reason.
