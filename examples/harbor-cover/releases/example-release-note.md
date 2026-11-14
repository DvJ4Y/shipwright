---
title: "Release note — cycle 44 (example)"
type: release-note
status: example
version: 1.0
owner: product lead (ops and platform)
why: Shows the shape `/issue-tracker release` writes and `/land` reads; every value is invented
last_updated: 2026-11-02
---

# Release note — cycle 44 (`example`)

Written by `/issue-tracker release` after reconciliation. Item status uses the commitments
vocabulary; the rollout boundary sits beside `deployed to prod`.

| Item | Status | Rollout boundary | Production evidence | PRD | Criteria with evidence | Criteria without |
|---|---|---|---|---|---|---|
| C1 Verification outcome and rework | deployed to prod | production, all regions | release tag confirmed by the engineering lead; product lead checked Desk and Harbor on three cases (`example`) | `products/desk/verification-outcome-and-rework/shared/prd.md` | A1–A5, A7–A16 | A6 (customer-requested visit) — `deferred` through the feature's decision P-18 |
| C4 Automatic retry queue | in UAT | — | — | — | — | — |
| C7 Referral status in Field | deployed to prod | pilot, one region | ops lead's pilot report (`example`) | pre-pack | — | — |

## Impact chains

- C1: a returned document now carries the rule in plain words and a recovery path → fewer
  second returns is the hypothesis → read `VER-M2` at D+14 and `REW-G1` beside it.

## Shipped without an approved PRD

None.

## What `/land` reads from this note

The row for C1: PRD path, the criteria with production evidence (land), the criteria without
(`deferred` with a decision point). The PRD flips to `shipped` only because every criterion is
landed or deferred through `/decide` (single landing).
