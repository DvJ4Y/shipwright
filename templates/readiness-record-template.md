---
title: "Readiness record: <feature>"
type: readiness-record
status: draft            # draft | passed | failed
version: 0.1
tier: M
owner: <role>
decision_refs: []
why: Product-to-engineering handover gate for <feature>
last_updated: YYYY-MM-DD
---

# Readiness record: <feature>

> Tier M gate. Every row needs evidence. Any FAIL or open `[NEEDS CLARIFICATION]` marker
> blocks handover. This is a product handover check, not engineering design review.

| # | Check | Result (PASS / FAIL / N/A) | Evidence (path#section, issue, decision point) |
|---|---|---|---|
| 1 | Objective, use cases and non-goals approved | | |
| 2 | Current behaviour and reuse checked | | |
| 3 | Partner- or segment-specific behaviour is configuration | | |
| 4 | Roles and permissions are clear | | |
| 5 | Normal, empty, failure, rework and restricted states are covered | | |
| 6 | PRD and mockup agree | | |
| 7 | Issues map to acceptance criteria | | |
| 8 | Older requirements are crosswalked | | |
| 9 | Open inputs have owners | | |
| 10 | The brief separates outcomes from engineering-owned design | | |

**Open markers:** <count of `[NEEDS CLARIFICATION]` in the feature folder — must be 0>

**`/review` verdict:** <ready | fix | rethink> — <path to review report>

**Gate decision:** <approve | send back> · **By:** <role> · **On:** YYYY-MM-DD ·
**Reason:** <one line>
