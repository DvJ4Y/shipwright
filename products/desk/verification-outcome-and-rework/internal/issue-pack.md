---
title: "Issue pack: Verification outcome and rework"
type: issue-pack
status: approved
version: 1.0
owner: product lead (ops and platform)
prd: products/desk/verification-outcome-and-rework/shared/prd.md
brief: products/desk/verification-outcome-and-rework/shared/eng-brief.md
mockup: products/desk/verification-outcome-and-rework/mockups/ (three L0 wireframes, v1)
decision_refs: [P-12, P-13]
why: Copy source for the parent issue and its product sub-issues
last_updated: 2026-11-02
---

# Issue pack: Verification outcome and rework

> Copy source for publication. Introduces **no requirement** that is not in the approved PRD,
> mockups or brief. Sub-issues are functional slices a user can see or an operator can accept.
> Engineering creates its own technical sub-issues after handover. **Not published:** the pack
> is approved on the product lead's default (P-12); publication waits for engineering alignment
> (P-13) and the engineering link. No tracker call was made in this run.

**Fields (set on publish, not in prose):** team `HBR` · project "Verification outcome and rework" ·
cycle: the next product cycle · state `Approved` · labels `lane:ops-platform`, `feature`, and the
surfaces per issue below. Engineering link: none yet; the parent stays below `Handed to Eng`.

## Parent issue

**Title:** A returned document is fixed once — reason, detail, requirement and one recovery path across Harbor, Desk and Field

**Description**

- **Problem and outcome:** one rework becomes two because the customer sees a reason code without the detail that differs or the requirement; `VER-M2` is 31 hours (`example`), target 18 hours (`target`); guardrails `VER-M1`, `REW-G1`, `VER-G1`; anti-metrics `REW-A1`, `REW-A2`.
- **Users and use cases:** U1–U7 in the PRD — Meera, Priya, Arjun; verification officer (return, provider failure); field verifier; compliance officer.
- **Scope:** PRD flow steps 1–8 on Harbor, Desk, Field and WhatsApp; the evidence records for identity verification, consent and disclosure, record retention · **Non-goals:** PRD section 5.
- **Acceptance (summary):** A1–A16 in the PRD; A6 is Should, the rest Must.
- **Dependencies:** automatic retry queue (C4, in UAT); capture from the inspection checklist (C5, in build); customer strings per language with a native reviewer; dictionary rows restated to count rounds.
- **Links:** PRD `products/desk/verification-outcome-and-rework/shared/prd.md` · Brief `products/desk/verification-outcome-and-rework/shared/eng-brief.md` · Mockups `products/desk/verification-outcome-and-rework/mockups/`
- **Sub-issues:** S1–S5 below.

Labels: `hub`, `desk`, `field`, `comms`, `data`.

## Product sub-issues

### S1 — Desk: return a document with the field that differs and the requirement; the queue row for a multi-item case

- **Outcome:** a verification officer raises one item the customer can act on and sees a case with several rounds as one row.
- **Behaviour and states:** PRD §8 NORMAL, EMPTY (rework view), PARTIAL (field outstanding), MISSING (pre-feature item), REWORK (re-check).
- **Acceptance criteria:** A1, A2, A3, A14 — text in PRD §9; the published issue copies it verbatim.
- **Depends on:** parent.
- **Rules, permissions and evidence:** R1 (field list: policyholder name · shop address · date of birth), R3 (requirement per reason; document checklist policy), R7 (re-check 12 hours, `example`; service levels policy), R10 (rounds, counts, resubmission times), R11 (where a case sits; rework view is a filter), §7 rows "Reason code and round", "Field that differs".
- **Reference:** PRD §4 steps 1 and 7, §6, §8 · mockup `mockups/desk-rework-queue-v1.mockup.html` frames S1 and S2.
- Labels: `desk`.

### S2 — Harbor and WhatsApp: the rework list with the requirement, the recovery paths, the correction path and the hold messages

- **Outcome:** the customer sees which paper, which detail, the requirement and one recovery path per document, in the case language, and is never shown a rule name, a tier or a decline on a provider failure.
- **Behaviour and states:** PRD §8 NORMAL, EMPTY, PARTIAL, MISSING, RESTRICTED (not applicable on Harbor), PROVIDER-FAILED (customer message), REWORK (item states), ON HOLD, LAPSED.
- **Acceptance criteria:** A4, A5, A6 (Should), A14, A15, A16 — text in PRD §9; the published issue copies it verbatim.
- **Depends on:** parent; S1 (the round carries the field and the requirement).
- **Rules, permissions and evidence:** R2 (templates only; string limits; one WhatsApp line per document), R3, R4 (visit only for `unreadable`, `missing`), R5 (visit request lifecycle; 72-hour service level, `example`; per-region switch), R6 (correction: premium warning, re-run, evidence who/old/new/time), R8 (send-by window 7 days, `example`; pauses; 30 days to `lapsed`, `example`), R14 (notification set), §7 rows "Requirement, tip, accepted alternatives", "Corrected detail", "Consent record".
- **Reference:** PRD §4 steps 2–5, §6, §8 · mockup `mockups/harbor-verification-outcome-v1.mockup.html` frame S1 (frames for on hold, lapsed, visit being arranged and the correction confirm are missing in v1 and are listed for the design pass).
- Labels: `hub`, `comms`.

### S3 — Field: open items with the reason and the slot text; replacement capture on site as a new version

- **Outcome:** a field verifier sees every open item on an assigned case, knows which may be captured, and captures once.
- **Behaviour and states:** PRD §8 NORMAL, EMPTY, PARTIAL, MISSING, RESTRICTED (capture disabled; identity number never shown), REWORK (`not started`, `pending send`, `replacement sent`); PROVIDER-FAILED not applicable.
- **Acceptance criteria:** A7, A8 — text in PRD §9; the published issue copies it verbatim.
- **Depends on:** parent; S1 (rounds exist); C5 is not a blocker.
- **Rules, permissions and evidence:** R4 (resolvable on site: default `unreadable`, `missing`), R5 (visit task joins or creates; upload-first closes it), R10 (field capture is a resubmission at send time), R12 (capture-only after send, including the offline copy; the field that differs visible on assigned items), §7 rows "Open-item count … document version", "Resolvable on site per reason".
- **Reference:** PRD §4 steps 5–7, §6, §8 · mockup `mockups/field-replacement-capture-v1.mockup.html` frames S1 and S2.
- Labels: `field`.

### S4 — Desk: provider failure shown and never declined; manual verification with method and result

- **Outcome:** a verification officer sees a provider failure plainly, waits for the automatic retries, and after the limit records a manual verification with its method and result; the case is never declined for the failure.
- **Behaviour and states:** PRD §8 PROVIDER-FAILED (Desk and the customer message), MISSING (manual verification without a method), REWORK (`not matched` → identity proof returned as `mismatched`).
- **Acceptance criteria:** A9, A10 — text in PRD §9; the published issue copies it verbatim.
- **Depends on:** parent; C4 (automatic retries and the attempt count; otherwise A9 ships with today's by-hand retry).
- **Rules, permissions and evidence:** R7 (clock pauses until the provider answers or the limit is reached), R9 (retry limit two, `example`; no officer-triggered retry; `declined` not for the failure; method default document inspection; result `verified` · `not matched`), §7 rows "Provider result and attempt count", "Manual verification method and result"; evidence per attempt and per manual verification (brief section 6).
- **Reference:** PRD §4 step 8, §6, §8 · mockup `mockups/desk-rework-queue-v1.mockup.html` frames S1 PROVIDER-FAILED and S2 PROVIDER-FAILED (the "Retry now" action in v1 is removed by R9).
- Labels: `desk`, `hub`.

### S5 — Desk and Harbor: evidence records, the audit view, permissions and masking

- **Outcome:** the compliance officer answers a regulator from the audit view: every round, capture, correction, provider attempt, manual verification and consent record with its evidence; roles see only what the access table allows.
- **Behaviour and states:** PRD §8 MISSING (consent without channel or language), RESTRICTED (officer's own actions; compliance-only fields; support agent; referral agent; identity number masked).
- **Acceptance criteria:** A11, A12, A13 — text in PRD §9; the published issue copies it verbatim.
- **Depends on:** parent; S1, S3, S4 (the actions that write the records).
- **Rules, permissions and evidence:** R12 (masking; full-value views are audit events; field-that-differs visibility per the data-handling policy row), R13 (retention per record type; delete-after date; deletion audit event), §7 every row's "Evidence kept" column; register rows identity verification, consent and disclosure, record retention.
- **Reference:** PRD §7, §8 · mockup `mockups/desk-rework-queue-v1.mockup.html` frame S3 · `mockups/harbor-verification-outcome-v1.mockup.html` consent block.
- Labels: `desk`, `hub`, `data`.

## Trace — acceptance ids, rules and evidence to sub-issues

| Acceptance id | Sub-issue | | Rule or evidence | Sub-issue |
|---|---|---|---|---|
| A1, A2, A3 | S1 | | R1, R3, R7, R10, R11 | S1 |
| A4, A5, A6, A15, A16 | S2 | | R2, R3, R4, R5, R6, R8, R14 | S2 |
| A7, A8 | S3 | | R4, R5, R10, R12 (capture-only) | S3 |
| A9, A10 | S4 | | R7, R9; attempt and manual evidence | S4 |
| A11, A12, A13 | S5 | | R12, R13; round, capture, correction, consent evidence | S5 |
| A14 | S1, S2 | | — | — |

Every acceptance id maps to a sub-issue; every rule and every evidence record maps to a sub-issue; no slice is named after a layer. Recorded as readiness check 7.

## Supporting-project issues (only if another team owns a real outcome)

| Title | Owning team / project | Outcome | Link to parent |
|---|---|---|---|
| Restate `VER-M2` and `REW-G1` to count rounds; add `REW-A2` | product lead (ops and platform) — metrics dictionary | the first reading after release uses the new unit | parent |
| Customer strings per reason code and language, native-reviewed | product lead (customer) — customer lane | templates exist for every reason code and language before release | parent |

## Publication log

| Item | the tracker ID | Published | Read-back matches pack? |
|---|---|---|---|
| parent, S1–S5 | — | not published (no tracker call in this run) | — |

Gate: approve · By: product lead (ops and platform) (PENDING — default applied, P-12) · On: 2026-11-02 · Reason: every acceptance id, rule and evidence record maps to a functional slice; no layer-named slice; nothing added beyond the PRD, brief and mockups
