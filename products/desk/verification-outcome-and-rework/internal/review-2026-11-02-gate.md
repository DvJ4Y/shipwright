---
title: "Review: shared/prd.md — gate"
type: review-report
mode: gate
artifact: products/desk/verification-outcome-and-rework/shared/prd.md (version 0.2)
lenses: [strategy, customer, engineering-readiness, data, writing, compliance]
verdict: fix
date: 2026-11-02
why: Records what the six reviewers found on v0.2, so the approval of v1.0 has evidence
---

# Review: shared/prd.md — gate

**Verdict:** fix — eleven Critical findings, every one a policy gap or a missing state with a clear
fix; no root cause called for a rethink. All Critical and Major findings are applied in v1.0; the
gate is approved on that version with the product lead's default (P-10).

> Reviewers report; they never edit. Six read-only lenses ran in parallel on v0.2 and the three
> mockups; the compliance lens ran because `_profile.md` says `_regulated: yes`. Findings are
> merged and deduplicated; where two lenses flagged one thing the higher grade stands.
> **Grades:** Critical (blocks the gate) · Major (fix before handover) · Minor (fix when
> convenient) · Outdated (the artifact drifted from production or a newer decision).

Counts on v0.2 — Critical 11 · Major 47 · Minor 53 · Outdated 6 (before merging). Missing inputs
reported by the engineering-readiness lens: `shared/eng-brief.md`, `internal/issue-pack.md`,
`internal/readiness.md` (written after this gate).

## Must-fix

| # | Grade | Lens | Location (file#section) | Finding | Fix (applied in v1.0) |
|---|---|---|---|---|---|
| 1 | Critical | readiness, compliance | prd#4 step 3, #6 R3, #9 | The "correct the detail" path had no policy: who may correct which field, whether it is a resubmission, whether identity verification re-runs, what evidence it keeps, what the customer sees after a re-run | R6, A15, flow step 4; evidence who, old, new, time; premium warning before confirm; P-16 |
| 2 | Critical | readiness | prd#6 R7, #9 A3 | Send-by window undefined per item or case, on a second return, during a visit, after a hold | R8 as service-level configuration with defaults; P-17 |
| 3 | Critical | readiness, strategy | prd#11, #6 R5, #13 | Customer-requested visit had no default, no gate rule and no task lifecycle; added field verifier work unstated | R5 default on, per-region switch with a capacity trigger, lifecycle; §12 effects; P-18 |
| 4 | Critical | readiness | prd#8 PROVIDER-FAILED | Desk "retry now" had no use case, rule or criterion; the mockup shows it enabled | Removed; R9 says the officer does not trigger retries; mockup mismatch listed for the design pass |
| 5 | Critical | readiness, compliance | prd#6 R8, #7, #9 A11 | Manual verification recorded no result; no not-matched path; no link to failed attempts; clock resume unstated | R9 result values and the not-matched path; A10 evidence; R7 resume condition; P-19 |
| 6 | Critical | readiness | prd#6 R2, #9 A4, A12 | "The rule that fired" undefined for `unreadable` and `missing`; no lookup or fallback | R3 per reason, with the template fallback |
| 7 | Critical | readiness, compliance | prd#6 R12 | Provider-response retention contradicted the data-handling policy | R13 per record type from the policy; P-21 |
| 8 | Critical | readiness, compliance | prd#6 R11, #7 | "Each view of a masked value" and "each view of the full value" both appeared | One sentence: full-value views; R12, §7, A13; P-20 |
| 9 | Critical | readiness | prd#12 Notifications, #4 step 7 | Notification list incomplete; channels unstated | R14 trigger → recipient · channel; owner pairing |
| 10 | Critical | customer, compliance | prd#6 R7, #8, #12 | `on hold` and `lapsed` had no state row, criterion, message or recovery path | §8 ON HOLD and LAPSED; A16; R14 messages; P-24 |
| 11 | Critical | compliance | prd#6 R3, #4 step 3 | A corrected name or date of birth, or a replacement identity proof, did not say whether identity verification re-runs or what evidence the correction keeps | R6; A15; P-16 (same root as #1) |
| 12 | Major | strategy, data | prd#1, #10 | No stated path from the change to `VER-M2`; a second return left the counted unit undefined; survivors-only median unstated; no population boundaries; `VER-G1` absent | §1 levers as hypotheses; §10 boundary paragraph, rounds as the unit, cohorts named, `VER-G1` row, `REW-A2` proposed; P-15 |
| 13 | Major | strategy | prd#1, #11 | No commitment row named | C1 in §1; C4 and C5 in §11 and §12 |
| 14 | Major | data | prd#4, #6 R3–R5, #9 | Which action sets the resubmitted time for a correction or an offline capture was unstated | R10: upload time, send time, confirmation; P-15 |
| 15 | Major | readiness | prd#6 R8 | Methods "video call" and "field visit" contradict HUB-009 and the capture-only rule | R9 default document inspection only; the other two are open inputs; P-08 reworded |
| 16 | Major | readiness, writing | prd#6 R9, #8 | "Open" against "awaiting re-check" undefined; the mockups count an item awaiting re-check as done; item states undefined | R10 definitions and counts per surface; item-state line under §8 |
| 17 | Major | readiness | prd#9 A9 | A Harbor upload and a detail correction had no criterion for what happens next | A8 covers field send, new upload and corrected detail; DESK-006 marked extended |
| 18 | Major | readiness | prd#6 R6, R7, R9, R12 | Rules with no observable criterion | Merged into A3, A8, A9, A11, A14, A16 |
| 19 | Major | readiness | prd#6 R6, R8; #9 A3 | Where a case sits per sub-status undefined; "keeps its position" against DESK-006 "returns" | R11 per sub-status; rework view is a filter of the queue |
| 20 | Major | readiness | prd#8 PROVIDER-FAILED, #6 R6 | Combined provider-failed and open-items message contradicted itself; the send-by pause contradicted the policy | §8 combined message; R8 window keeps running (policy); P-17 |
| 21 | Major | readiness, compliance | prd#6 R2, R3, R4, R8 | Policies cited that do not exist in the index | Real policy names; "— (proposed)" with an owner where new |
| 22 | Major | readiness, compliance | prd#7 | Field-that-differs visibility contradicted the data-handling access table; "resolvable on site" had two owners | §7 and R12 aligned with the policy row; ops lead owns the setting |
| 23 | Major | readiness, compliance | prd#8 MISSING, RESTRICTED; #9 A13, A14 | MISSING omitted consent records without channel or language and pre-feature manual verifications; RESTRICTED omitted audit-view limits and the referral agent; A13 disagreed with the Harbor mockup on consent fields | §8 rows extended; A12 shows what was agreed, when and on which channel; A13 covers the agent |
| 24 | Major | readiness, compliance | prd#6 R8, #8, #9 A10 | "Decline disabled" said three ways; the case-level action was not covered | One statement: `declined` cannot be set for the provider failure, from the identity panel or the case (R9, §8, A9) |
| 25 | Major | readiness | prd#6 R1 | FLD-006 lets a verifier propose `mismatched`; who picks the field was unstated | R1: the officer picks the field at confirmation; A1 |
| 26 | Major | readiness, customer, compliance | prd#6 R2 | Desk free-text note reached the customer outside the templates | R2: templates only; the note stays internal; P-22 |
| 27 | Major | readiness | prd#3 | Rows marked "reused" that add behaviour; DESK-002 clock display; consent display and masking marked existing with no row | §3 rows re-marked; "policy; no surface row" where true |
| 28 | Major | compliance | prd#7, #9 A10 | Provider-attempt evidence lacked the officer role; no criterion that each attempt writes a record | A9 and §7 per attempt |
| 29 | Major | compliance | prd#6 R8 | The manual-method list is a regulated choice with no owner or policy | Owner compliance officer; "proposed" against the data-handling policy; P-08 |
| 30 | Major | compliance, customer | prd#5, #8 | The flow can produce a complaint but offered no route | "Talk to our team" on every message; complaint handling named as a non-goal for the compliance officer to confirm; P-23 |
| 31 | Major | compliance | prd#6 R11 | Capture-only did not cover the offline `pending send` copy | R12: after send the verifier cannot open any capture |
| 32 | Major | customer | prd#8 PROVIDER-FAILED, #9 A4 | No route to a person on a provider failure; message length and expansion unaddressed; no premium warning before a correction | "Talk to our team"; R2 string limits and one WhatsApp line per document; A15 premium warning |
| 33 | Major | customer (SYNTHETIC — Meera E1, E4; Priya E1, E3) | prd#6 R3, #9 A5 | No accepted-alternatives list on a returned item; no "take another look" path on a disputed `mismatched` | R3 alternatives on every item; A5 and A14 take-another-look; P-24 |
| 34 | Major | customer | prd#9 A7 | After "ask for a visit" no state, expected day or window pause | A6; `visit being arranged` in §8 REWORK; R8 pause |
| 35 | Major | writing | prd#6 R9, #6 R11, #9 A14, #2 U3, #8 PARTIAL | "`pass`" used as a sub-status; unlabelled numbers (last 4 characters, three outlets, 1 of 2) | "After the case leaves `Verification`"; `example` labels; "N of M" |

## Other findings

| # | Grade | Lens | Location | Finding (applied unless marked) |
|---|---|---|---|---|
| 36 | Minor | strategy | prd#10, #1, #5, #12 | `VER-G1` row; `VER-M1` threshold not below baseline; `why` as a hypothesis; `POL-M1` link; provider-failed scope serves `CMP`; Must/Should tags; non-goal "no automatic decline"; `REW-A1` consequences; `PAY-M1` early signal; one owner pairing for strings — all applied |
| 37 | Outdated | strategy | internal/decision-log.md P-10, P-03, P-07, P-08 | P-10 recorded approval before the gate; propagation pointers named old rule numbers — reworded and repointed |
| 38 | Minor | data | prd#10, #12 | Cohorts named; `REW-G1` fixed at 7 days whatever the window; `operational — unverified` on replica rates; `VER-M1` first read at D+45; signals carry a source and label; four events marked **new** with surface; engine rows never first passes; end point "resubmitted, not accepted"; hardest-case claim as interview evidence; durations labelled — all applied. The query-sources file mismatch on `VER-M2` was fixed in `tools/query/sources.md` |
| 39 | Minor | readiness | prd#9 A8, #2 U6, #8 EMPTY | "disabled for reasons not resolvable on site (default `mismatched`)"; "capture everything in one visit"; Desk EMPTY sentence — applied |
| 40 | Minor | writing | prd#1, #4, #6, #9 | Long sentences split where a table row allowed; "route" → "recovery path" except the verifier's route; one term "send-by window"; "verification officer" in full in §7 and §9; owners as roles; `VER-G1` in §10; end-card crosswalk line cut; §9 count line now adds up. Not applied: every sentence under 25 words inside dense rule rows — the rows carry several conditions each and were kept as one row per rule |
| 41 | Outdated | customer | prd#1, #2, #10 | The visit path is a hypothesis for Meera; who reads the message is unknown; the plain-words requirement is the hypothesis under test — stated in §1 and §2 |
| 42 | Minor | customer | prd#9 A4 | "What it means for the policy" and the status-page link; "Why" and "The rule" merged into the requirement; staff words in customer strings are a copy task for the customer lane (mockup notes for the design pass) |
| 43 | Minor | compliance | prd#9 A11, A14, A10; #6 R9, R12 | Field that differs and message text version on the rework evidence; `P0` QA rows for A9–A12 and A15; second-return message names the new requirement in the case language; "nothing is needed from them"; "within the retention period"; message retention with its deletion record — applied |

## Kill-assumptions (red-team mode, ranked)

Not run — gate mode.

## Pre-mortem (red-team mode)

Not run — gate mode. P-03 and P-16 carry pre-mortems for the two one-way doors.

## Intended vs built (post-ship mode)

Not run — gate mode.

## Understanding check (engineering-readiness, on v1.0)

Holding only the PRD: three surfaces change (the rework list and paths on Harbor; the return
panel, queue row, identity panel and audit view on Desk; the item list and capture on Field),
one engine behaviour is reused (re-run on a corrected detail), two dictionary rows change meaning,
and five evidence records are added. The three questions the engineering lead would ask are in
the brief's anticipated questions: which action sets the resubmitted time, where consent channel
and language live while the audit metadata is empty, and how a visit request joins an existing
inspection task. The first two have product answers; the third is engineering's.

## Mockup mismatches found (for the design pass; mockups not edited)

Desk S2 "Retry now" enabled · Desk S2 free-text "Note to the customer" shown as customer text ·
Field S2 applies the mandatory-slot rule without a PRD rule (now R-level in A8) · Harbor frames
missing for `on hold`, `lapsed`, `visit being arranged` and the correction confirm · Harbor
PROVIDER-FAILED shows a send-by field with nothing returned · Harbor consent block shows channel
without a path.

## Gate decision

**Decision:** approve v1.0 · **By:** product lead (ops and platform) (PENDING — default applied,
P-10) · **Reason:** every Critical and Major applied; zero open markers; understanding check passed.

Gate: approve · By: product lead (ops and platform) (PENDING — default applied) · On: 2026-11-02 · Reason: v0.2 verdict fix, all Critical and Major findings applied in v1.0
