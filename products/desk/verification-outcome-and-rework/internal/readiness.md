---
title: "Readiness record: Verification outcome and rework"
type: readiness-record
status: passed
version: 1.1
tier: M
owner: product lead (ops and platform)
decision_refs: [P-10, P-12, P-13]
why: Product-to-engineering handover gate for Verification outcome and rework
last_updated: 2026-11-04
---

# Readiness record: Verification outcome and rework

> Tier M gate. Every row needs evidence. Any FAIL or open `[NEEDS CLARIFICATION]` marker
> blocks handover. This is a product handover check, not engineering design review.

**Phase check:** Discovery: Done — `internal/discovery.md` (approved on the default, P-09) ·
PRD: Done — `shared/prd.md` v1.0 (approved on the default, P-10) · Engineering alignment:
Not yet — P-13; the brief's `aligned_on` stays `—`.

| # | Check | Result | Evidence (path#section, issue, decision point) |
|---|---|---|---|
| 1 | Objective, use cases and non-goals approved | PASS | `shared/prd.md#1`, `#2` (U1–U7), `#5`; `internal/discovery.md` verdict go; P-09, P-10 |
| 2 | Current behaviour and reuse checked | PASS | `shared/prd.md#3` cites HUB-003, HUB-005, HUB-006, HUB-008, HUB-009, DESK-001 to DESK-006, DESK-009, DESK-010, FLD-001 to FLD-006, FLD-008, FLD-009, each marked reused or extended; `shared/eng-brief.md#2` reuse locations |
| 3 | Partner- or segment-specific behaviour is configuration | PASS | `shared/prd.md#6` "Configurable?" column: field list, templates per language, resolvable on site and visit switch per region, retry limit, method and result lists, service levels, retention per record type; `shared/eng-brief.md#2` Configuration table |
| 4 | Roles and permissions are clear; each regulated action named with its evidence | PASS | `shared/prd.md#7` access per data point and the "Regulated actions touched" line (identity verification · consent and disclosure · record retention); `#6` R12; `shared/eng-brief.md#6` evidence per register row |
| 5 | Normal, empty, failure, rework and restricted states are covered | PASS | `shared/prd.md#8`: NORMAL plus the six strips, ON HOLD and LAPSED, per surface; Harbor RESTRICTED and Field PROVIDER-FAILED say why they do not apply; `shared/eng-brief.md#4` scenarios 1–7 |
| 6 | PRD and mockup agree | PASS with notes | Flow, roles and states agree with the three v1 wireframes; six mismatches found by the gate are listed in `internal/review-2026-11-02-gate.md` "Mockup mismatches" for the design pass (Desk "Retry now"; Desk free-text note; Field mandatory-slot rule now in A8; missing Harbor frames for on hold, lapsed, visit being arranged and the correction confirm; send-by shown on PROVIDER-FAILED; consent block channel). The PRD wins where they differ |
| 7 | Issues map to acceptance criteria | PASS | `internal/issue-pack.md` trace table: A1–A16 each map to S1–S5; every rule R1–R14 and every evidence record maps to a sub-issue; no layer-named slice; a script confirmed every PRD acceptance id appears in the pack and in at least one QA row |
| 8 | Older requirements are crosswalked | PASS | `internal/crosswalk.md`: 24 earlier rows, 24 mapped, 0 unmapped; `shared/prd.md#13` carries the one-line version |
| 9 | Open inputs have owners | PASS | `shared/prd.md#11` and `shared/eng-brief.md#9`: every open input names a role and a default; none forces a developer to invent policy; P-01 to P-24, D-004, D-006, D-007 logged PENDING |
| 10 | The brief separates outcomes from engineering-owned design | PASS | `shared/eng-brief.md#8` lists the decisions engineering owns; reuse locations are locations, not designs ("new — no location" where nothing exists; "location unknown" for consent channel and language); scenarios carry outcomes from PRD rules or policy rows, none "engineering to decide" |

**Open markers:** 0 `[NEEDS CLARIFICATION]` markers in the feature folder.

**`/review` verdict:** fix on v0.2 → every Critical and Major applied → approved on v1.0 — `internal/review-2026-11-02-gate.md`.

**QA trigger 1:** `Planned` rows written — `qa/harbor/test-cases.csv` (8 scenarios), `qa/desk/test-cases.csv` (12), `qa/field/test-cases.csv` (4); `qa/harbor/analytics-events.csv` (2 events), `qa/desk/analytics-events.csv` (2 events). One `P0` row per evidence record (A9, A10, A11, A12, A13, A15).

**Gate decision:** approve · **By:** product lead (ops and platform) (PENDING — default applied, P-10) · **On:** 2026-11-02 ·
**Reason:** ten checks pass; zero open markers; the brief is approved with `aligned_on: —` until engineering alignment (P-13); the issue pack is approved and not published (P-12).

Gate: approve · By: product lead (ops and platform) (PENDING — default applied) · On: 2026-11-02 · Reason: ten readiness checks pass with evidence; handover waits only for engineering alignment

## Re-check for PRD v1.1 (2026-11-04)

Inputs: `shared/prd.md` v1.1 and `shared/eng-brief.md` v1.1 after the gate in
`internal/review-2026-11-04-gate.md`; `internal/issue-pack.md` v1.1; mockups v2; data packet (40 points).

| # | Check | Result | Evidence |
|---|---|---|---|
| 1 | Objective, use cases and non-goals approved | PASS | §1 maps `POL-M1` to G1 and `VER-M2` to G2; P-27 |
| 2 | Current behaviour and reuse checked | PASS with notes | §3 unchanged; brief column names not in `context/05` are open for the alignment conversation |
| 3 | Partner- or segment-specific behaviour is configuration | PASS | R3 template per language, R5 switch per region, R9 timeout and retry limit with owners |
| 4 | Roles, permissions, regulated actions and evidence | PASS | §8 consent record and consent status split (P-33); R6 consent for the re-run |
| 5 | States covered | PASS | §8; QA rows for EMPTY, PARTIAL, MISSING, `cancelled` and the v1.1 additions |
| 6 | PRD and mockup agree | PASS with notes | Mockups v2 match v1.1 except where the gate changed the rule afterwards: Harbor S4 shows "may upload" after a missed visit (PRD: rebook or upload, window resumes); Harbor MISSING shows the reason text alone for a missing template (PRD: only the requirement line falls back); Desk has no officer-run retry control (PRD R9 until the retry queue is live). The PRD wins; redraw in v2.1 |
| 7 | Issues map to acceptance criteria | PASS | Issue pack v1.1 trace: R11 to S1 and S2; S2 and S4 summaries follow v1.1 |
| 8 | Older requirements are crosswalked | PASS | `internal/crosswalk.md` "v1.0 → v1.1" |
| 9 | Open inputs have owners | PASS | P-28 to P-33 and D-008 PENDING with owners; open: the clock-resume wording in the service-levels policy (ops lead), retention reset on an unissued case (compliance officer), which days a visit may be booked, whether "take another look" counts as a resubmission, which documents are offered after a lapse, the regulated action for a shop-address correction |
| 10 | The brief separates outcomes from engineering-owned design | PASS | §1 opens with the ask; §10 answers cite rules; retry spacing is engineering's |

Result: passed on v1.1, with the notes above.
