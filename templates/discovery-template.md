---
title: "Discovery: <name>"
type: discovery
status: draft            # draft | in-review | approved | superseded
version: 0.1
tier: <S | M | L>
owner: <role>
lane: <customer | ops-platform>
theme: <theme code from context/08-strategy-and-outcomes.md>
supersedes: —
decision_refs: []
why: <one line — the decision this discovery enables>
last_updated: YYYY-MM-DD
---

# Discovery: <name>

> Phase 1. Output is a business case with a recommendation, not a solution. Expect several
> rounds. An item that reached a PRD in a day did not have discovery.

## The question

<One sentence. What decision does this discovery enable, and who owns it?>

## Outcome alignment

**Outcome metric:** <metric_id> · **Target:** <value> (`target`) · **Commitment it serves:**
<row in `context/09-current-commitments.md`, or "none — new">

## Who has this problem

<Persona and segment, role, volume. Cite the persona cards in `context/personas/`. Solve
for the hardest case first.>

## Evidence

**Population boundary first.** What does each dataset EXCLUDE? Which metrics are therefore
uncomputable?

| # | Finding | Value | Source | Label | Claim level |
|---|---|---|---|---|---|
| E1 | | | query / dashboard / interview | DB-verified <date> / analytics / operational — unverified / target / example | implementation fact / measurement capability / descriptive movement / causal impact |

## What already exists

<Rows in `context/surfaces/<surface>/current-behaviour.md`, live tracker items, the current
commitments. Most "new" things are extensions.>

## Regulated actions touched

<One line per row of `context/regulated-actions.md` the idea touches, or "none".>

## Options

| Option | Pull | Cost to ops | Operational viability | Verdict |
|---|---|---|---|---|

**Operational viability test:** who captures each new data point? How long per case? Can the
system derive it instead? If it needs a training manual, it is too complex.

## Prioritisation

<RICE or MoSCoW, shown. Not a flat list.>

## Decision inputs

| Decision point | Input needed | Owner | State |
|---|---|---|---|

## Recommendation

**Go / clarify / kill:** <verdict>. <What to do, and what you are choosing against.>

## Open questions

- <question> — <named answerer (role)> → P-nn

## Phase check

- Discovery: in progress
- PRD: not started
- Engineering alignment: N/A at this phase
