---
title: "Discovery: Verification outcome and rework"
type: discovery
status: approved
version: 1.0
tier: M
owner: product lead (ops and platform)
lane: ops-platform
theme: VEF
supersedes: —
decision_refs: [P-01, P-02, P-03, P-04, P-09, D-004, D-006, D-007]
why: Decides whether to extend the rework path so one returned document is fixed once, moving VER-M2
last_updated: 2026-11-02
---

# Discovery: Verification outcome and rework

> Phase 1. Output is a business case with a recommendation, not a solution.

## The question

Should the rework path name the field that differs, the rule in plain words and one recovery
route per document, so a returned document is fixed once? Owner: product lead (ops and
platform); the ops lead locks the policy values it rests on.

## Outcome alignment

**Outcome metric:** `VER-M2` rework cycle time, 31 hours (Sep, `example`) · **Target:** 18 hours
(`target`) · **Guardrails:** `VER-M1` 61% (Sep cohort, `example`), `REW-G1` 68% (Sep, `example`) ·
**Anti-metric:** `REW-A1` 1.3 items per case (Sep cohort, `example`) · **Commitment it serves:**
C1 in `context/09-current-commitments.md` (committed at discovery). Themes `VEF` Verification
efficiency, `CTT` Customer trust and transparency, `CMP` Compliance by design.

## Who has this problem

| Who | Card | The problem, with evidence |
|---|---|---|
| First-policy grocery owner (Meera) | `context/personas/customer-meera.md` | Low document readiness; a relative handles uploads; "they still called asking for the same paper" (E3). Hardest case: informal licence, address proof in a spouse's name (E1, E4) |
| Pharmacy owner (Priya) | `context/personas/customer-priya.md` | One repeat ask and she calls support (E3); a `mismatched` reason without the field reads as the company not reading what she sent (E1, E4) |
| Multi-outlet electronics owner (Arjun) | `context/personas/customer-arjun.md` | Wants one list per case and status without a call (E1, E3) |
| Verification officer | `context/personas/role-verification-officer.md` | A reason the customer cannot act on produces a second rework (E1, E2); provider failures once showed as blanks and some cases were declined by mistake (E1) |
| Field verifier | `context/personas/role-field-verifier.md` | Discovers an open rework item after leaving the shop (E1, E3) |
| Compliance officer | `context/personas/role-compliance-officer.md` | Consent evidence lacks channel and language since the audit metadata went empty (E1, E2); card is `thin` |

Volume: 5 verification officers and 9 field verifiers across 3 regions (`example`). Segment shares are not measured.

## Source register

| # | Source | Type | Date | Authority |
|---|---|---|---|---|
| S1 | `context/02-service-and-lifecycle.md`, `context/04-eligibility-and-verification.md` | lifecycle, rework vocabulary | 2026-11-02 | governing |
| S2 | `context/metrics-dictionary.csv`, `context/08-strategy-and-outcomes.md` | metric definitions and readings | 2026-11-02 | governing |
| S3 | `context/surfaces/{harbor,desk,field}/current-behaviour.md` | what is live, by row | 2026-11-02 | governing |
| S4 | `context/personas/` | interview and shadowing evidence (`CI`, `SR`, `OI`, `FV`) | Sep 2026 | evidence |
| S5 | `showcase/story-script.md`, `internal/data-packet.csv` | the design pass: one case end to end; data points | 2026-11-02 | evidence |
| S6 | `decisions/decision-log.md` D-004, D-006, D-007 | PENDING policy values | 2026-11-02 | governing (PENDING) |

## Evidence

**Population boundary first.** `VER-M1` counts cases quoted in the week that entered `Verification`
by D+45; engine re-runs are excluded through `outcome_source`; cases that never reached
`Verification` are outside it. `VER-M2` is per rework item and excludes items never resubmitted, so
it is a survivor median; `REW-G1` is reported beside it. `REW-A1` counts cases that entered
`Verification` and excludes cases declined before any item. The share of rework caused by officer
judgement is not computable: no tag exists (Priya card, "What we don't know").

| # | Finding | Value | Source | Label | Claim level |
|---|---|---|---|---|---|
| E1 | Verification first pass, Sep cohort | 61% (541 → 330) | the BI tool, `VER-M1` | example | measurement capability |
| E2 | Rework cycle time, median per item | 31 hours | the BI tool, `VER-M2` | example | measurement capability |
| E3 | Rework items resubmitted within 7 days | 68% | the SQL replica, `REW-G1` (proxy) | example | measurement capability |
| E4 | Rework items raised per case | 1.3 | the SQL replica, `REW-A1` (proposed) | example | measurement capability |
| E5 | Checklist complete at first submission | 54% | the BI tool, `DOC-M1` | example | measurement capability |
| E6 | A reason the customer cannot act on produces a second rework | officer interviews, 3 of 9 staff | `OI` | example | descriptive (interview) |
| E7 | Customers still call after an upload: "they still called asking for the same paper" | 14 of 40 recordings from first-policy customers | `SR` | example | descriptive (interview) |
| E8 | Provider failures showed as blank rows before the retry queue; some declined by mistake | officer interviews | `OI` | example | descriptive (interview) |
| E9 | Verifiers discover open items after leaving the shop | 6 inspections in 2 regions | `FV` | example | descriptive (shadowing) |

No causal claim is made. Whether showing the rule changes resubmission speed is the hypothesis
this feature tests (officer card, "What we don't know").

## What already exists

| Row | What is live | This feature |
|---|---|---|
| HUB-008 | Status page and WhatsApp list each returned document with its reason code and one next step | extends: the field that differs, what the record says, the rule in plain words, the capture tip, the visit route |
| HUB-009 | Provider-failed message; `declined` never shown | reuses; adds the paused window |
| DESK-003, DESK-004 | Rule outcomes on the case; reason code required on return | extends: the field that differs required on `mismatched`; the rule carried onto the item |
| DESK-002, DESK-006 | PROVIDER-FAILED flag; replacement attached, case keeps its queue position | reuses; adds the manual-verification method and the re-check clock |
| DESK-009 | Audit view lists every regulated action with its evidence | extends: rework item, replacement capture, manual method, consent channel and language |
| FLD-001, FLD-005 | Route shows the open-item count; capture against an item from the case screen | extends: reason, what the officer needs to see, and whether the item may be captured on site |
| C4 (in UAT), C5 (in build) | Automatic retry queue; capture from the inspection checklist | depends on; this feature states the behaviour after the retry limit |

Tracker not reachable in this run — snapshot only (`context/09-current-commitments.md`).

## Regulated actions touched

Identity verification — the provider-failed path and manual verification with the method recorded.
Consent and disclosure — the rework message names the rule and asks nothing new without consent.
Record retention — every rework item, replacement capture and manual verification is an evidence record.

## Options

| Option | Pull on `VER-M2` | Cost to ops | Operational viability | Verdict |
|---|---|---|---|---|
| O1 Do nothing | none; one rework keeps becoming two (E6) | none | — | reject |
| O2 Extend HUB-008, DESK-004, FLD-005: field that differs, record value, rule in plain words, tip, routes; multi-item queue row; reasons resolvable on site; provider failure never declines, manual method recorded; evidence records | fewer second rounds; `REW-G1` up | one pick per `mismatched` return; one pick per manual verification | officer picks from three case fields; the system derives the record value, rule and tip | **go** |
| O3 Add to O2: the customer asks for a field visit from the status page for `unreadable` and `missing` items | `REW-G1` up for low-readiness customers (Meera E1, E4) | field verifier visits inside the 72-hour inspection service level (`example`) | a task, not a call; depends on D-006 | go, gated by the ops lead (P-04) |
| O4 Officer-error tag on each re-check | diagnostic only (`REW-A1` cause) | one pick per re-check | viable; not required to run | defer — trigger: `REW-A1` above 1.6 (`example`) |
| O5 Automated readability check before the officer sees an upload | `VER-M1` up | none | engineering capability unknown; the unreadable share is not pulled yet | defer — needs a data pull |

**Operational viability test.** Field that differs: officer, one pick from three fields the case
holds; the record value is derived. Resolvable on site: configuration per reason code, no per-case
input. Manual method: officer, one pick, only after the retry limit. Retry attempts, consent
channel and language, delete-after date: system-derived. Customer reason text: configuration per
reason code and language, written once by the customer lane with a native reviewer. Nothing needs a
training manual.

## Prioritisation (MoSCoW)

| Must | Should | Could | Won't (this feature) |
|---|---|---|---|
| Field that differs and record value on `mismatched` · rule in plain words and tip · one list per case with routes · multi-item queue row · provider failure never declines, manual method recorded · evidence records for the three register rows · retention date on the audit view · reasons resolvable on site as configuration | Customer-requested visit (O3) · re-check clock shown to officer and customer · consent shown on the rework list | Officer-error tag (O4) | Automated readability check (O5) · referral agent sees the reason (compliance officer, FLD-008) · `Renewal` · insurer-side upload |

## Decision inputs

| Decision point | Input needed | Owner | State |
|---|---|---|---|
| Customer-safe reason text separate from the internal rule catalogue | confirm the split | product lead (ops and platform) | P-01 PENDING, default applied |
| Who may close a rework item | confirm officer-only close | ops lead | P-02 PENDING, default applied |
| Provider timeout: retry before any rework or manual step | retry limit (D-007) | ops lead | P-03 PENDING, default applied |
| Customer-requested field visit | field verifier capacity | ops lead | P-04 PENDING, default applied |
| Which reasons the verifier may resolve on site | D-006 | ops lead | PENDING, default applied |
| Rework window | D-004; production runs 7 days (`example`) | ops lead | PENDING, production value used |

## Recommendation

**Go:** O2 plus O3 under the ops lead's gate. Choosing against a new Desk rework dashboard (extend
the queue and case view), free-text reasons (a pick from case fields), and any automatic decline
after repeated `unreadable` uploads (a decline needs a rule and a recovery path).

## Open questions

- Does the consent evidence for records created before this feature need backfill? — compliance officer → P-06
- Which case-record fields may differ on `mismatched`? — ops lead proposes, product lead locks → P-07
- What may the officer record as a manual verification method? — compliance officer → P-08

## Phase check

- Discovery: done — this file
- PRD: not started at this point; written next as `shared/prd.md`
- Engineering alignment: N/A at this phase

Gate: approve · By: product lead (ops and platform) (PENDING — default applied, P-09) · On: 2026-11-02 · Reason: outcome linked, evidence supports the problem, O2 is viable
