---
title: 03 — The loop
type: doc
status: active
version: 1.0
supersedes: —
decision_refs: []
why: Settles what happens next on a piece of work, how much process it deserves, and who approves each step
last_updated: 2026-11-02
---

# 03 — The loop

Read this when you need to decide what happens next on a piece of product work, how much
process it deserves, and who approves each step.

```
INTAKE → QUESTION → ALIGN → PRODUCE → GATE → REVIEW → DECIDE → HANDOFF → LAND → COMPOUND
```

| Step | Owner skill | Output |
|---|---|---|
| Intake | `/product-loop` | Verdict (go, clarify, park), tier, lane, workflow |
| Question | the producing skill | One batched round of 3–5 questions; answers logged as decision points |
| Align | `/review` strategy lens, outcome check only | Outcome metric, target, commitment served |
| Produce | the specialist skill | The artifact, with `[NEEDS CLARIFICATION: … → P-nn]` markers |
| Gate | the producing skill | Tier checklist passed; zero open markers |
| Review | `/review` | Verdict, must-fix list, kill-assumptions |
| Decide | `/decide` | PENDING or LOCKED rows; a propagation list |
| Handoff | `/engineering-brief`, `/issue-tracker` | Brief, issue pack, publication with read-back |
| Land | `/land` | Rows in `context/surfaces/<surface>/current-behaviour.md`; PRD `landed` |
| Compound | `/session end`, `/session retro` | Handoff, lessons, memory facts, closeout checklist |

Between Handoff and Land, engineering builds and releases. Two product steps then run
before Land. `/issue-tracker release` reconciles what reached production and sets the PRD
to `shipped`. `/review post-ship` compares what was meant with what was built.
`docs/08-handoff-to-engineering.md` covers both. Every workflow ends with `/session end`.
Every feature closes with `/session retro`.

## Where work comes from

Read in this order: `context/09-current-commitments.md` (the snapshot), the tracker (live),
then your own grooming. Most "new" work extends a current-behaviour row or duplicates a
committed item. `/product-loop` runs that check before it gives a verdict.

## Tiers

| Tier | When | Artifacts | Gate |
|---|---|---|---|
| S (tweak) | One surface, no new data, reversible | One document | Phase check · self-review against the writing standard · boundary check |
| M (feature) | One coherent business capability | A feature folder | The 10 readiness checks and `/review` gate mode |
| L (initiative) | Several features, several sessions | An initiative folder | The M gate per feature · state matrix current · crosswalk before any supersession |

Escalate when the work touches new data, a second surface, a regulated action or more than
one role. Never de-escalate to skip a gate. The tier sizes the process: a copy change
carries no ceremony, and an initiative skips nothing.

## Workflows by request shape

| Request | Tier | Workflow |
|---|---|---|
| Copy or label change | S | `/product-copy` → self-review → `/session end` |
| Small UI tweak | S | `/mockup` → self-review → `/session end` |
| A data question | S | `/data-analysis` |
| A choice between options | S | `/decide` |
| A shipped feature to fold back | S | `/review post-ship` → `/land` |
| New or changed feature | M | `/product-discovery` → `/decide` → `/prd-writer` → `/mockup` and `/product-copy` → `/review gate` → `/engineering-brief` → `/issue-tracker pack` → readiness record → `/review gate` → handoff |
| Several features under one outcome | L | Initiative mode, then the M workflow per feature |

Tier M and L start with an alignment brief in chat, before any file. It names the outcome
and metric, the features in scope, the impact matrix, the top open decisions and the
proposed order. The product lead confirms it. Then a session map: one topic per session, a
fresh session per phase. For a UI-heavy feature, sketch the riskiest flows at L0 before the
PRD gate; a wireframe exposes scope a PRD hides.

## The phase check

State it before every deliverable:

```
Discovery: [Done — path | Done offline | Not done]
PRD: [Done — path | N/A | In progress]
Engineering alignment: [Done | Not yet | N/A at this phase]
```

It stops a polished artifact arriving for a phase whose gate has not passed. Discovery
means interviews, data with a population boundary, and a check of what exists. An idea
that reaches a PRD in a day did not have discovery.

## The 10 readiness checks (tier M)

1. Objective, use cases and non-goals approved.
2. Current behaviour and reuse checked against the surface's current-behaviour table.
3. Partner- or segment-specific behaviour is configuration.
4. Roles and permissions are clear. When `_regulated: yes`, each regulated action touched
   and its evidence are named.
5. Normal, empty, failure, rework and restricted states are covered.
6. PRD and mockup agree.
7. Issues map to acceptance criteria.
8. Older requirements are crosswalked.
9. Open inputs have owners.
10. The brief separates outcomes from engineering-owned design.

Record them in `internal/readiness.md` from `templates/readiness-record-template.md`.
Check 5 covers the six state strips (`docs/04-visual-method.md`) where they can occur.

## Decision points and markers

- Two id series. The workspace log `decisions/decision-log.md` uses `D-001`, `D-002`, …. A
  feature or initiative log uses `P-01`, `P-02`, …. Ids are never reused.
- Status moves `PENDING` → `LOCKED` → `SUPERSEDED`.
- An open point inside an artifact is a marker: `[NEEDS CLARIFICATION: <question> → P-nn]`.
  The marker points at a PENDING row. Any open marker blocks promotion past `draft`.
- The author defaults reversible micro-choices and states each in one line. The author
  asks about material or irreversible choices and logs the answers. `/decide` treats a
  customer-facing commitment, deleted or exposed data, a regulated action, a partner
  contract and a public statement as one-way doors (irreversible choices).

**A recommendation is not a decision.** The author logs it PENDING. Only the named owner
locks it. `context/06-teams-and-who-does-what.md` says which role owns which kind of
decision. A decision that reaches another team, a metric or a locked row carries a
one-line consequence. The owner never accepts it inside a bundle.

## Gates

Every gate ends with one line in the artifact or its review report:

```
Gate: <approve | send back> · By: <role> · On: YYYY-MM-DD · Reason: <one line>
```

A send-back names the failing check and the fix. The author fixes; the reviewer re-runs.
The gate owner is `_gate_owner` in `_profile.md`, by default the lane's product lead. On
approval the gate owner sets `status: approved`. Nobody edits the body in place after that.
`/issue-tracker release` and `/land` may still set the lifecycle fields `status`,
`shipped_on`, `landed_into` and `last_updated`. A send-back is also a lesson.

## Reviews

`/review` dispatches read-only reviewers, one lens each, in fresh contexts: strategy,
customer, engineering-readiness, data, writing, and compliance when `_profile.md` says
`_regulated: yes`. Findings are Critical, Major, Minor or Outdated. The verdict is ready,
fix or rethink. A ready verdict on tier M or L also needs the understanding check. The
engineering-readiness reviewer restates each feature and names the three questions the
engineering lead would ask. Reviewers report; the author edits.

## Statuses on a PRD

`draft` · `in-review` · `approved` · `shipped` (set by `/issue-tracker release` after
reconciliation) · `landed` (set by `/land`, with `landed_into:`) · `superseded`. The full
table, with who sets each, is in `.agents/skills/product-loop/references/conventions.md`.
