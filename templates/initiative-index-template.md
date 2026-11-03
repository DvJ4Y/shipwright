---
title: "<Initiative> — start here"
type: initiative-index
status: active           # active | paused | closed
version: 0.1
tier: L
owner: <role>
decision_refs: []
why: <one line — the business outcome this initiative delivers>
last_updated: YYYY-MM-DD
---

# <Initiative> — start here

> Entry point for every session on this initiative. Read this, then
> `intake-feedback.md`, then the open decision points in `decision-log.md`.

## Objective and outcome metric

<2–3 sentences. Outcome metric IDs from `context/metrics-dictionary.csv`.>

## Folder map

```
INDEX.md              this file — state matrix, registers, phases
intake-feedback.md    the owner's running direction — first place to look
decision-log.md       decision points: PENDING / LOCKED / SUPERSEDED
features/<feature>/   one folder per feature: PRD, mockup, brief, issue pack, readiness record
research/             benchmarks, discovery, data pulls
archive/              superseded-YYYY-MM-DD/ folders, each with a "replaced by" README
```

## Feature state matrix

| Feature | Owner | Discovery | PRD | Mockup | Brief | Issue pack | Readiness | Handed to eng |
|---|---|---|---|---|---|---|---|---|
| | | done / — | draft / in-review / approved | | | | passed / — | yes / — |

## Phases

| Phase | Goal | Exit gate | State |
|---|---|---|---|

## Source register

| Source | Authority (governing / evidence / historical) | Last verified | Notes |
|---|---|---|---|

## Scope register

| Scope item | In / out / deferred | Feature | Decision point |
|---|---|---|---|

## Parallel-session task packets

| Packet | Owns (files) | Reads | Depends on | State |
|---|---|---|---|---|

<Two sessions never own the same file. A packet lists the files it may write.>

## Superseded sets

| Folder | Replaced by | Crosswalk |
|---|---|---|
