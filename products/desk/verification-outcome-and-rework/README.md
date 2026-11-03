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

Read `shared/prd.md` first. This folder shows the **pre-land state**: the PRD is at v1.1, in review, the
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
| `shared/prd.md` | WHAT and WHY: users, rules R1–R14, information and audit, states, acceptance A1–A16, metrics, impact | `in-review` v1.1 — the late file, the missing template, the missed visit and a provider failure with open items folded into existing criteria (P-25 to P-27); the gate on v1.1 has not run. v1.0, `approved`, is in `archive/superseded-2026-11-03/` |
| `shared/eng-brief.md` | Capability, reuse locations, configuration, invariants, 17 scenarios, evidence, observability, open inputs | `in-review` v1.1, follows PRD v1.1; `aligned_on: —` (engineering alignment is the owner's conversation — P-13). v1.0 is in `archive/superseded-2026-11-03/` |

## Internal — the reasoning

| File | What it is | Status |
|---|---|---|
| `internal/discovery.md` | The business case: question, evidence, what exists, viability, MoSCoW, verdict go | `approved` (PENDING default, P-09) |
| `internal/decision-log.md` | P-01 … P-24, every owner gate logged PENDING with the default applied | active |
| `internal/data-packet.csv` | 30 data points with provenance and disposition (design pass; read-only here) | reference |
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

## Known gaps after the gate (follow-ups, not blockers)

The gate review moved the PRD from v0.2 to v1.0. The design pass and the data packet are v1
(drawn before the gate) and lag it. A cross-feature link check listed the differences; the
ones that need work:

| Gap | Where | Owner |
|---|---|---|
| Harbor states `on hold`, `lapsed`, `visit being arranged` and the correction-confirm step are not drawn; "talk to our team" and "ask our team to take another look" appear on no frame | `mockups/` → v2 | product lead (design pass) |
| Story script: one retry vs two; beat 5 paths; beat 6 placement; identity verified "next day" | `showcase/` → v2 | product lead |
| Data packet: eight §7 points have no row (accepted alternatives, round, visit request and day, awaiting re-check count, corrected detail, visit switch, manual result, message text version); `RWK-02` surface lacks `field`; `RWK-06` enum lacks two paths. The packet is the design-pass record, updated once for the provider-failure clock (P-17); refresh it with mockups v2 | `internal/data-packet.csv` | product lead |
| QA: no rows for EMPTY on the three surfaces, PARTIAL on Harbor and Field, the Desk MISSING manual-method case, or `cancelled` | `qa/*/test-cases.csv` | product lead, via `qa/PROCESS.md` trigger 1 |
| PRD v1.1 candidates: `POL-M1` serves goal G1; the 90-second (`example`) timeout belongs in R9; criteria for a late file, a missing template and a missed visit; the sub-status when a provider failure hits a case with open rounds; ops-lead visibility of the consent record | `shared/prd.md` → v1.1 (never edit v1.0 in place) | product lead |

`internal/discovery.md` is a dated record and keeps its pre-gate wording; the refinements
live in `internal/crosswalk.md` and the feature decision log.
