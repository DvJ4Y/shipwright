---
title: "Crosswalk: earlier requirements → PRD v1.0 (Verification outcome and rework)"
type: crosswalk
status: approved
version: 1.0
owner: product lead (ops and platform)
decision_refs: [P-04, P-06, P-08, P-19, D-004, D-006, D-007]
why: Shows where every earlier requirement for this feature went before anything is superseded, and (after the land rehearsal) where every PRD row landed
last_updated: 2026-11-02
---

# Crosswalk: earlier requirements → PRD v1.0

> A requirement is retired only when this table shows where it went. Written at readiness check
> 8, before any earlier source is marked superseded. Paths and decision ids are allowed here;
> PRD section 13 carries the one-line version without them.

| Earlier source (file#section or issue) | Requirement (one line) | Treatment | Destination | Decision point |
|---|---|---|---|---|
| `showcase/story-script.md` beat 3 | The rule that fired shown beside the reason code on the case view | refined | PRD §6 R3 (the requirement in plain words); A1, A2 | P-01 |
| `showcase/story-script.md` beat 5; open point 1 | The customer asks for a visit from the status page; both routes on one screen | refined | PRD §6 R4–R5; A5, A6 (Should); per-region switch | P-04, P-18, D-006 |
| `showcase/story-script.md` open point 2 | Show the rule name to the customer, or only the reason and the tip | refined | PRD §6 R2–R3: the requirement in plain words, never the configured name | P-01 |
| `showcase/story-script.md` beat 6 | The reason and tip on the verifier's route before the visit | refined | PRD §3 FLD row; A7: count on the route, reason and tip on the case screen | — |
| `showcase/story-script.md` beat 8 | The replacement re-checked without a search | carried | PRD §4 step 7; A8; re-check clock R7 | — |
| `showcase/story-script.md` beat 12 | End card naming every role | not applicable | — | — |
| `showcase/story-script.md` open point 3 | Demo numbers | not applicable | story props, all `example` | — |
| `context/surfaces/harbor/current-behaviour.md` gaps | HUB-008 shows the reason code but not the field that differs | carried | PRD §3; R1; A4, A5 | P-07 |
| `context/surfaces/desk/current-behaviour.md` gaps | DESK-004 lacks the field; the queue does not state a multi-item case | carried | PRD R1, R10; A1, A3 | P-07, P-15 |
| `context/surfaces/field/current-behaviour.md` gaps | Which reasons a verifier may resolve on site; the verifier's view of provider-failed; the agent and the rework reason | carried / dropped / deferred | R4, A7 (carried); §8 PROVIDER-FAILED Field "not applicable" (dropped); referral agent reason stays FLD-008 (deferred; trigger: compliance officer decision) | D-006; —; `qa/PROCESS.md` open question |
| `internal/data-packet.csv` RWK-02, RWK-03 | Field that differs; what the record says | carried | PRD §7; R1; A1, A5 | P-07 |
| `internal/data-packet.csv` RWK-10 | Resolvable on site per reason | carried | PRD §7; R4 | D-006 |
| `internal/data-packet.csv` VER-04 | Manual verification method (three values) | refined | PRD R9: default document inspection only; result values added | P-08, P-19 |
| `internal/data-packet.csv` PRV-02 | Retry attempts against the limit | carried | PRD §7; R9; A9 | D-007, P-03 |
| `internal/data-packet.csv` AUD-05 | Consent record channel and language have no path | carried | PRD §7; A12; no backfill | P-06 |
| `internal/data-packet.csv` RWK-07 | Send-by window does not run while provider-failed | refined | PRD R8: the window keeps running; only the verification clock pauses (policy) | P-17 |
| `decisions/decision-log.md` D-004 | 7-day (`example`) rework window, then on hold | carried | PRD R8; A16 | D-004 |
| `decisions/decision-log.md` D-006 | Reasons resolvable on site | carried | PRD R4; A7 | D-006 |
| `decisions/decision-log.md` D-007 | Retry limit before the officer decides | carried | PRD R9; A9, A10 | D-007, P-03 |
| `context/09-current-commitments.md` C1 | Plain reason and recovery route on Harbor; rework item with the rule on Desk; replacement capture on Field | carried | PRD §1 (commitment C1); A4, A1, A8 | — |
| `tasks/todo.md` blocking and decisions | Confirm D-006 with the ops lead; D-004; referral agent reason; retry limit | carried / deferred | D-006, D-004, D-007 applied on defaults; referral agent reason deferred | — |
| `tasks/todo.md` in flight | Priya quote check; `VER-M1` population boundary note | carried | PRD §2 U2 (interview evidence); §10 boundary paragraph | — |
| `sessions/latest.md` open threads | Same three items | merged | as above | — |
| the run brief, step 4 | Guardrail "complaints per 100 rework items"; anti-metric "items closed without a replacement" | dropped / refined | no dictionary row (dropped); enforced as R10, not measured (refined) | P-09 |

**Treatments**

| Treatment | Means |
|---|---|
| carried | Kept as written |
| refined | Kept, with changed wording or rule |
| merged | Combined with another requirement |
| moved | Lives in another feature or project |
| deferred | Kept for later, with a trigger condition |
| dropped | Not carried, with a decision point recording why |
| not applicable | Does not apply to the new structure |

**Coverage check:** 24 earlier rows = 24 rows in this table. Unmapped rows: 0.

## Landed (rehearsal 2026-11-02)

> Appended by the land rehearsal (`internal/land-rehearsal.md`). Nothing shipped; the rows
> exist in the surface files marked `rehearsal`. On a real landing the destinations cite the
> archived PRD path.

| PRD row (shared/prd.md v1.0) | Requirement (one line) | Treatment | Destination | Decision point |
|---|---|---|---|---|
| §9 A4, A5 | The rework list with the requirement, the detail and the paths | merged | HUB-013 | — |
| §9 A15 | Corrected detail: warning, re-run, identity re-check | refined | HUB-014, DESK-018 | P-16 |
| §9 A12 | Consent shown; nothing outside the consented checklist | refined | HUB-015, DESK-019 | P-06 |
| §9 A16 | On hold and lapsed messages | refined | HUB-016 | P-24, D-004 |
| §9 A9 | Provider failure: customer message; Desk row; attempt evidence | merged | HUB-017, DESK-016 | P-03, D-007 |
| §9 A14 | Accepted and second return | merged | HUB-018, DESK-021 | P-02 |
| §9 A6 | The visit path | deferred | — (returns in a later PRD or release) | P-18 |
| §9 A1 | Return `mismatched` with the field | refined | DESK-012 | P-07 |
| §9 A2 | Return `unreadable` or `missing` | carried | DESK-013 | — |
| §9 A3 | Queue row for a multi-item case | refined | DESK-014 | P-15 |
| §9 A8 | Resubmission attaches as a new version | merged | DESK-015, FLD-012 | P-15 |
| §9 A10 | Manual verification with method and result | refined | DESK-017 | P-08, P-19 |
| §9 A11, A15 | Evidence records in the audit view; the correction record | refined | DESK-018 | P-20, P-21 |
| §9 A13 | Permissions and masking | merged | DESK-020, FLD-012, FLD-013 | P-20 |
| §9 A7 | Field open items with capture allowed | refined | FLD-011 | D-006 |
| §6 R1, R4, R9 configuration lists | Field list; resolvable on site; retry limit, method and result lists | deferred | policy rows marked proposed until production matches | P-07, D-006, D-007, P-08 |
| §6 R8 pause rules | Window pauses from visit request to capture; runs on provider failure | deferred | `context/policies/service-levels.md#clock rules` | P-17 |
| §6 R12, R13 | Masking and retention | not applicable | already in `context/policies/data-handling-and-retention.md` | P-20 |
| §7 evidence kept | One suffix "— regulated action: <row>" per surface row it serves | refined | HUB-014, HUB-015, DESK-016 to DESK-020, FLD-012, FLD-013 | — |
| §8 Harbor RESTRICTED; Field PROVIDER-FAILED | Cannot occur on that surface | not applicable | — | — |
| §12 Data and events | Four new events; new data points | deferred | `context/05-numbers-data-and-traps.md` event list, after trigger 2 | P-14 |

**Coverage check (rehearsal):** 16 acceptance criteria + 6 rule and information groups + 2 state
rows + 1 data row = 25 PRD rows; 21 table rows cover them (criteria grouped where one row serves
several). Unmapped: 0. QA rows that would flip to `Current` and the three that stay `Planned`
are listed in `internal/land-rehearsal.md` section 6; the catalogs were not changed.
