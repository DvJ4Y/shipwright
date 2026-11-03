---
title: "Review: <artifact> — <mode>"
type: review-report
mode: <gate | red-team | post-ship>
artifact: <path> (version x.y)
lenses: [strategy, customer, engineering-readiness, data, writing]
verdict: <ready | fix | rethink>
date: YYYY-MM-DD
why: Records what the reviewers found, so the gate decision has evidence
---

# Review: <artifact> — <mode>

**Verdict:** <ready | fix | rethink> — <one line: why>

> Reviewers report; they never edit. The author applies fixes and re-runs `/review`.
> **Grades:** Critical (blocks the gate) · Major (fix before handover) · Minor (fix when
> convenient) · Outdated (the spec itself has drifted from production or a newer decision).

## Must-fix

| # | Grade | Lens | Location (file#section) | Finding | Fix |
|---|---|---|---|---|---|

## Other findings

| # | Grade | Lens | Location | Finding |
|---|---|---|---|---|

## Kill-assumptions (red-team mode, ranked)

| Rank | Assumption that would kill this if false | Evidence today | Cheapest test |
|---|---|---|---|

## Pre-mortem (red-team mode)

<Six months on, this failed. The most likely three causes, with an early signal for each.>

## Intended vs built (post-ship mode)

| Acceptance criterion | Built behaviour (evidence) | Match / gap |
|---|---|---|

## Gate decision

**Decision:** <approve | send back> · **By:** <role> · **Reason:** <one line>
