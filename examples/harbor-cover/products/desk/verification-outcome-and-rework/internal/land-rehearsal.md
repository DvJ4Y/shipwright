---
title: "Land rehearsal: Verification outcome and rework"
type: land-rehearsal
status: rehearsal
version: 1.0
owner: product lead (ops and platform)
decision_refs: [P-18, D-004, D-006, D-008]
why: Shows what /land writes when this PRD ships, so the durable layer's shape is visible before anything is deployed
last_updated: 2026-11-04
---

> The pretend release note this rehearsal reads is written out at
> `releases/example-release-note.md`.


# Land rehearsal: Verification outcome and rework

**Nothing has shipped.** This note pretends a release note confirmed production and walks the
`/land` procedure. The three surface files carry the rows below marked `Landed on: rehearsal
2026-11-02`; the QA catalogs stay `Planned`; the folder is not archived. A rehearsal never
prefixes a row. The rehearsal ran on PRD v1.0 (approved); PRD v1.1 is in review, and its folded
behaviours are listed in `internal/crosswalk.md` section "v1.0 → v1.1".

## 1. Status check — what `/land` would say today

The PRD is at `status: in-review` (v1.1), not `shipped`, and `shipped_on` is `—`. A real run stops here
and names `/issue-tracker release` as the skill that sets `shipped`. The rehearsal continues on a
pretend release note.

## 2. The pretend release note

`releases/example-release-note.md` (the example note; a real landing reads the cycle's own note):
parent issue at `deployed to prod`, rollout boundary `production`; A1–A5 and A7–A16 confirmed
with screens and a replica query per evidence record; **A6 deferred through `/decide`** — the
visit path waits for the ops lead's per-region switch (P-18), so the crosswalk carries `deferred`
and no row is appended for it. QA rows confirmed by the note: every `Planned` scenario except
HUB-REW-003, FLD-RTE-001 and HUB-EVT-001.

## 3. Landing table (built before writing; the product lead's confirmation applied on the default)

| PRD row | Surface or policy | Proposed row | Replaces | Regulated action | Evidence | Verdict |
|---|---|---|---|---|---|---|
| A4, A5 | Harbor | HUB-013 the rework list | replaces HUB-008 (prefix SUPERSEDED on a real landing) | — | note: screens | land |
| A15 | Harbor | HUB-014 corrected detail | — | identity verification | note: screens, evidence query | land |
| A12 | Harbor | HUB-015 consent shown | — | consent and disclosure | note: screens | land |
| A16 | Harbor | HUB-016 on hold and lapsed | — | — | note: screens | land |
| A9 (customer part) | Harbor | HUB-017 provider-failed message | extends HUB-009 | identity verification | note: screens | land |
| A14 | Harbor | HUB-018 accepted and second return | — | — | note: screens | land |
| A6 | Harbor, Field | — | — | — | deferred at release | deferred — P-18 |
| A1 | Desk | DESK-012 return `mismatched` with the field | replaces DESK-004 (prefix SUPERSEDED on a real landing) | — | note | land |
| A2 | Desk | DESK-013 return `unreadable` or `missing` | — | — | note | land |
| A3 | Desk | DESK-014 queue row | extends DESK-002 | — | note | land |
| A8 | Desk | DESK-015 resubmission attaches | replaces DESK-006 (prefix SUPERSEDED on a real landing) | — | note | land |
| A9 | Desk | DESK-016 provider failure | extends DESK-002 | identity verification | note: evidence query | land |
| A10 | Desk | DESK-017 manual verification | — | identity verification | note: evidence query | land |
| A11, A15 | Desk | DESK-018 evidence records in the audit view | extends DESK-009 | record retention; identity verification | note: evidence query | land |
| A12 | Desk | DESK-019 consent record | extends DESK-009 | consent and disclosure | note: evidence query | land |
| A13 | Desk | DESK-020 support agent and masking | extends DESK-010 | identity verification | note | land |
| A14 | Desk | DESK-021 accepted and second return | — | — | note | land |
| A7 | Field | FLD-011 open items | replaces FLD-005 (prefix SUPERSEDED on a real landing) | — | note | land |
| A8, A13 | Field | FLD-012 capture as a new version, capture-only | replaces FLD-005 (prefix SUPERSEDED on a real landing) | record retention | note | land |
| A13 | Field | FLD-013 identity number never on Field | — | identity verification | note | land |
| §6 R1 field list; R4 resolvable on site; R9 retry limit, method and result lists | `context/policies/document-checklist.md`, `risk-tiers-and-routing.md`, the eligibility and verification context | policy rows "proposed" until production configuration matches | — | — | configuration not yet in production | gap — PENDING via P-07, D-006, D-008, P-08 |
| §6 R8 pause rules | `context/policies/service-levels.md#clock rules` | pause from visit request to capture; window keeps running on provider failure | — | — | no production value | gap — PENDING via P-17 |
| §6 R12, R13 | `context/policies/data-handling-and-retention.md` | no change: the policy already states masking and retention; the full-value reading is P-20 | — | — | — | refined, no row |
| §12 Data and events | `context/05-numbers-data-and-traps.md` | four new events join the event list; the new data points are named in the brief | — | — | event store check at trigger 2 | land (not written in the rehearsal) |
| §8 Harbor RESTRICTED; Field PROVIDER-FAILED | — | cannot occur on that surface | — | — | — | not applicable |

## 4. Rows appended (done in the rehearsal)

Appended to `context/surfaces/harbor/current-behaviour.md` (HUB-013 to HUB-018),
`context/surfaces/desk/current-behaviour.md` (DESK-012 to DESK-021) and
`context/surfaces/field/current-behaviour.md` (FLD-011 to FLD-013), each with `Source PRD`
`products/desk/verification-outcome-and-rework/shared/prd.md` and `Landed on` `rehearsal
2026-11-02`. The surface files' frontmatter and `Last verified` lines are untouched.

**Not done in the rehearsal, done on a real landing:** prefix SUPERSEDED on HUB-008, DESK-004,
DESK-006 and FLD-005 — they remain live today; bump each file's `last_updated`;
cite the archived PRD path in `Source PRD`; add the four events to `context/05`.

## 5. Crosswalk

A "Landed (rehearsal)" section is appended to `internal/crosswalk.md`: §6- and §7-derived rows
`refined`, grouped criteria `merged`, A6 `deferred — P-18`, configuration rows `deferred` with their
decision points, the two not-applicable states `not applicable`. Coverage: every PRD row and
acceptance group has a destination.

## 6. QA rows — what would flip

On a real landing, after trigger 2 confirms each row against the code, `Planned` → `Current` for:
HUB-REW-001, HUB-REW-004, HUB-REW-005, HUB-STS-001, HUB-REW-006,
HUB-EVT-002; DESK-REW-001 to DESK-REW-004, DESK-QUE-001 to DESK-QUE-003, DESK-VER-001,
DESK-VER-002, DESK-AUD-001, DESK-AUD-002, DESK-PRM-001, DESK-EVT-001, DESK-EVT-002; FLD-CAP-001,
FLD-CAP-002, FLD-PRM-001. Stay `Planned`: HUB-REW-003, FLD-RTE-001, HUB-EVT-001, and HUB-REW-002 and HUB-STS-002, whose
expected results list the visit path (A6 deferred).
Rows added on 2026-11-04 for the §8 states and PRD v1.1 follow the same rule. Would flip:
HUB-REW-007, HUB-REW-008, HUB-STS-001-T2, HUB-STS-003 to HUB-STS-005, DESK-QUE-004 to
DESK-QUE-007, DESK-AUD-003, FLD-CAP-003, FLD-CAP-004. Stay `Planned`: HUB-REW-009 to
HUB-REW-011 (A6 deferred).
**The catalogs were not changed:** nothing shipped.

## 7. PRD, tracker and archive — not done

On a real landing: `status: landed`, `landed_into: [HUB-013 … FLD-013, the policy destinations]`,
`last_updated` bumped; the parent product issue moved to `Landed`; the folder moved to
`products/desk/archive/landed-<date>/verification-outcome-and-rework/` with a "replaced by"
README; one commit proposal covering rows, crosswalk, QA flips, PRD and the move. The rehearsal
leaves the PRD's status unchanged with `landed_into: []`, makes no tracker call and moves nothing.

## 8. What did not land, and why

| Item | Verdict | Returns when |
|---|---|---|
| A6 — the visit path | deferred — P-18 | the ops lead locks the per-region switch; a later PRD or release carries it |
| R1, R4, R9 configuration lists | gap — PENDING (P-07, D-006, D-008, P-08) | production configuration matches the policy rows |
| R8 pause rules | gap — PENDING (P-17) | the ops lead adds the rule to the service levels policy |
