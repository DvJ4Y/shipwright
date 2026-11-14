---
title: "Verification outcome and rework — feature folder"
type: readme
status: active
version: 1.0
supersedes: —
decision_refs: [P-01, P-04, P-10, P-12, P-13, P-18, D-004, D-006, D-007]
why: Index of the worked feature — what engineering gets, what stays internal, and where each artifact stands
last_updated: 2026-11-02
---

# Verification outcome and rework — feature folder

Read `shared/prd.md` first. This folder shows the **pre-land state**: the PRD is approved at v1.1, the
brief is written, the issue pack is approved and not published, and nothing has shipped.
`internal/land-rehearsal.md` shows what `/land` would do once a release note confirms
production; the three surface files already carry those rows marked `rehearsal`.

## Intake verdict (`/product-loop`, tier M)

```
Verdict: go — outcome and owner named; serves commitment C1; extends HUB-008, DESK-004, FLD-005
Tier: M — one capability across Harbor, Desk and Field; new data points; three regulated actions
Lane: ops-platform — the customer lane reviews the rework message and writes its strings
Outcome: VER-M2 — rework cycle time, 31 hours (`example`) → 18 hours (`target`); guardrails VER-M1, REW-G1, VER-G1
Workflow: /product-discovery → /decide → /prd-writer → /review gate → /engineering-brief → /issue-tracker pack → readiness → /land
Phase check: Discovery Done — internal/discovery.md · PRD Done — shared/prd.md v1.0 · Engineering alignment Not yet (P-13)
Sessions: 5 — discovery and decisions · PRD and QA rows · review gate · brief and issue pack · readiness and land rehearsal
```

Mockups and the story were produced by the design pass before this run (`mockups/`, `showcase/`),
so `/mockup` and `/product-copy` were not re-run. Customer-language strings are still open:
`_language_review: no`, so every string goes to a native reviewer (P-11).

## Shared — what engineering and outside readers get

| File | What it is | Status |
|---|---|---|
| `shared/prd.md` | WHAT and WHY: users, rules R1–R14, information and audit, states, acceptance A1–A16, metrics, impact | `approved` v1.1 after the gate of 2026-11-04 (`internal/review-2026-11-04-gate.md`; gate owner PENDING, default applied — P-10). v1.0 is in `archive/superseded-2026-11-03/` |
| `shared/eng-brief.md` | Capability, reuse locations, configuration, invariants, 17 scenarios, evidence, observability, open inputs | `approved` v1.1; `aligned_on: —` (engineering alignment is the owner's conversation — P-13). v1.0 is in `archive/superseded-2026-11-03/` |

## Internal — the reasoning

| File | What it is | Status |
|---|---|---|
| `internal/discovery.md` | The business case: question, evidence, what exists, viability, MoSCoW, verdict go | `approved` (PENDING default, P-09) |
| `internal/decision-log.md` | P-01 … P-24, every owner gate logged PENDING with the default applied | active |
| `internal/data-packet.csv` | 30 data points with provenance and disposition (design pass; read-only here) | reference |
| `internal/review-2026-11-04-gate.md` | Six lenses on v1.1; verdict fix → applied; 2 Critical, 14 Major | done |
| `internal/review-2026-11-02-gate.md` | Six lenses on PRD v0.2 and the three mockups; verdict fix → applied into v1.0; gate line | done |
| `internal/readiness.md` | The 10 readiness checks with evidence; the phase check lives here | `passed` (PENDING default) |
| `internal/issue-pack.md` | One parent, five functional sub-issues S1–S5 mapped to A1–A16 | `approved`; **not published** (P-12) |
| `internal/crosswalk.md` | Where every earlier requirement went; a "Landed (rehearsal)" section | `approved` |
| `internal/land-rehearsal.md` | What `/land` would write, and the rows it did write; A6 shown as deferred | rehearsal |

## Mockups and showcase (design pass; not changed by this run)

`mockups/harbor-verification-outcome-v1.mockup.html` · `mockups/desk-rework-queue-v1.mockup.html` ·
`mockups/field-replacement-capture-v1.mockup.html` · `showcase/story-script.md` and the story build.
Six mismatches between the v1 wireframes and PRD v1.0 are listed in the gate report for the
design pass; the PRD wins where they differ.

## Rows this feature wrote outside the folder

| Where | Rows | State |
|---|---|---|
| `qa/harbor/test-cases.csv` (8 scenarios) · `qa/desk/test-cases.csv` (12) · `qa/field/test-cases.csv` (4) | `Planned` scenarios tracing to A1–A16 (QA trigger 1); `P0` per evidence record | `Planned` — nothing shipped |
| `qa/harbor/analytics-events.csv` · `qa/desk/analytics-events.csv` | `Planned` rows for the four new events | `Planned` |
| `context/surfaces/{harbor,desk,field}/current-behaviour.md` | HUB-013 to HUB-018 · DESK-012 to DESK-021 · FLD-011 to FLD-013 | `Landed on: rehearsal 2026-11-02`; A6 (the visit path) deferred, no row |

## Owner gates logged PENDING (defaults applied)

Discovery verdict (P-09), PRD approval (P-10), issue-pack approval (P-12), engineering alignment
(P-13), the ten policy and regulated defaults from the gate (P-15 to P-24), and the workspace
rows D-004, D-006 and D-007 that the rules cite.

## Known gaps (follow-ups, not blockers)

The gate of 2026-11-02 moved the PRD to v1.0; the cross-link check and the gate of 2026-11-04
moved it to v1.1. Mockups v2, story v2, the refreshed data packet (40 points) and the QA rows
for every state now exist. What still lags:

| Gap | Where | Owner |
|---|---|---|
| Mockups v2 predate three gate changes: the missed visit offers a rebook, the missing-template fallback keeps the paths, the officer runs retries until the retry queue is live | `mockups/` → v2.1 | product lead (design pass) |
| Rules the PRD does not yet state: which days a visit may be booked; whether "take another look" counts as a resubmission; which documents are offered after a lapse; the regulated action for a shop-address correction | `shared/prd.md` → next version | product lead (ops and platform) |
| The clock-resume wording in the service-levels policy, and which customer actions reset retention on an unissued case | `context/policies/` | ops lead; compliance officer |
| The land-rehearsal rows carry v1.0 wording (DESK-016 "stays `open`"); a real landing writes v1.1 | `context/surfaces/` at landing | product lead |
