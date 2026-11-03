---
title: "Engineering brief: Verification outcome and rework"
type: eng-brief
status: approved
version: 1.1
tier: M
owner: product lead (ops and platform)
audience: engineering lead
prd: prd.md v1.1
aligned_on: —
supersedes: v1.0
decision_refs: [D-004, D-006, D-008, P-25, P-26, P-27, P-28, P-29, P-30, P-31, P-32, P-33]
why: Lets the engineering lead design the rework, correction, visit and provider-failure paths without inventing a business rule
last_updated: 2026-11-04
---

# Engineering brief: Verification outcome and rework

> WHAT product needs and WHERE it touches the system. Never HOW. The PRD "Verification outcome and rework" is the single source for behaviour; this brief points at its sections and adds locations, invariants, scenarios, evidence and open inputs.

## 1. Capability

Use this brief to propose the design for the rework, correction, visit and provider-failure paths, and bring the questions in section 10 to the alignment conversation.

A returned document is fixed once. The verification officer returns a document with a reason code and, on `mismatched`, the field that differs; the item carries the requirement in plain words. The customer sees one list per case with the detail, the requirement, the accepted alternatives and recovery paths: a new upload, a corrected detail, a field visit, a second look, a person. The field verifier captures replacements on site for the reasons allowed. A provider failure is shown, never declines, and ends in a recorded manual verification. Outcome `VER-M2`, 31 hours (`example`) → 18 hours (`target`); guardrails `VER-M1`, `REW-G1`, `VER-G1`; anti-metrics `REW-A1`, `REW-A2`. See the PRD's "Non-goals" and "Information, permissions and audit". Volumes: 5 verification officers, 9 field verifiers across 3 regions, 240 policies issued in one month (`example`).

## 2. Reuse — what exists

| Existing capability | Where (reuse location) | Existing or new | Extended how (product terms) |
|---|---|---|---|
| Case stage and sub-status | `h_case.stage`, `h_case.sub_status`; DESK-002 | existing, unchanged | `rework`, `on hold`, `lapsed` as the PRD's rules R8, R11 state |
| Rework item with reason code | `h_rework_item` (reason code, raised by, resubmitted at); DESK-004, HUB-008 | existing | each return is a round with its own raised and resubmitted times (R10); the customer list shows the latest round |
| Field that differs; what the record says | new — no location; derived from the case field named | new | chosen from policyholder name · shop address · date of birth (R1); the record value is read, never stored twice |
| Rule that fired | `h_verification.rules_fired` (jsonb); DESK-003 | existing | carried onto the round; shown to the customer as the plain-words template, never the configured name (R2–R3) |
| Capture tip; why the insurer needs the item; accepted alternatives | configuration — the Field slot text (FLD-002); the document checklist policy columns | existing configuration | the same text on the Harbor item and in the Desk return panel (R3) |
| Customer message templates | configuration — message templates per stage and language | existing configuration | new templates per reason code and language, with length limits; one WhatsApp line per document plus the link (R2, R14) |
| Next step per reason; resolvable on site | `h_rework_item.next_step`; resolvable-on-site: new configuration | existing; new | per reason code (R4); the visit switch per region is new configuration (R5) |
| Visit request and field task | Field inspection task (FLD-001); request: new — no location | existing; new | a request creates a replacement-capture task or joins the existing inspection task (R5) |
| Corrected detail | new — no location; the case fields themselves exist on `h_case` and `h_customer` | new | a correction is a resubmission; evidence keeps who, old value, new value, time (R6) |
| Replacement status and document version | `h_rework_item.replacement_status`; `h_document` (reference, version); FLD-004, FLD-005, DESK-006 | existing | a resubmission of any kind attaches as a new version; the re-check clock starts (R7, A8) |
| Queue clocks and the send-by window | derived — `h_verification` queued time and `h_rework_item` raised time against the service levels | existing (derived) | stopped, paused and running states as R7–R8 state; the window per round |
| Open-item count on the queue row | derived — open `h_rework_item` rows per case; FLD-001 shows it | existing (derived) | the Desk row adds the count and how many await re-check (R10, A3) |
| Provider result and attempts | `h_verification.provider_result`; attempt count: new — no location; HUB-009, DESK-002 | existing; new | PROVIDER-FAILED on the row; attempt count shown to the officer (R9) |
| Manual verification method and result | new — no location | new | one pick each after the retry limit (R9) |
| Audit events and evidence references | `h_audit_event` (action, actor role, time, evidence reference); DESK-009 — **trap:** `metadata` has been empty since an earlier release (`example`) | existing | new actions: round raised, replacement captured, correction, manual verification, each provider attempt, full-value identity views (section 6) |
| Consent record | `h_audit_event` rows with the consent action; channel and language: location unknown (the metadata trap) | existing; channel and language new | shown to the customer as what was agreed, when, on which channel (A12) |
| Identity number and masking | `h_customer.identity_number`; the data-handling policy | existing | full on the verification screen only; each full-value view is an audit event (R12) |
| Delete-after date | derived — policy end plus the retention period; unissued cases: last customer action plus the period | new (derived) | visible to the compliance officer in the audit view (R13) |

**Configuration** (readiness check 3 — partner- or segment-specific behaviour is configuration):

| Item | Who changes it | Where it is configured today | Existing or new |
|---|---|---|---|
| Reason codes `unreadable` · `mismatched` · `missing` | product lead (ops and platform) | the eligibility and verification context, "Configuration or code" | existing |
| Field-that-differs list | ops lead proposes; the product lead (ops and platform) locks | nowhere today | new |
| Reasons resolvable on site; visit switch per region | ops lead | nowhere today | new |
| Message templates per reason code and language, with length limits | the product lead (customer), native reviewer | message templates per stage and language | existing set; new entries |
| Capture tip, insurer reason, accepted alternatives per checklist item | ops lead | the document checklist policy; the Field slot text | existing |
| Service levels, send-by window and pause rules, hold and lapse | ops lead | the service levels policy; production configuration | existing; pause rules new |
| Identity-check retry limit | ops lead | nowhere today; default two (`example`) | new |
| Manual verification method and result lists | compliance officer | nowhere today; default document inspection; `verified` · `not matched` | new |
| Retention period per record type; masking rule | compliance officer | the data-handling and retention policy | existing |

## 3. Invariants — must not break

- A provider failure never sets `declined`, never raises a rework item on the identity proof, and never shows the word "declined" to the customer.
- Every `declined`, `rework`, `on hold`, `lapsed` or provider-failed outcome shown to the customer carries a recovery path and "talk to our team".
- `refer` is never shown as declined; a re-run after a correction uses the eligibility screens.
- One rework item per document; one open round at a time; only a verification officer closes an item.
- A regulated action is not complete without its evidence record; each provider attempt, manual verification, round, capture, correction and full-value identity view has one.
- The customer never sees the configured rule name, the risk tier, an internal id or the full identity number; Field never shows the identity number.
- A replacement capture is capture-only after send, including the offline copy.
- Customer text comes from templates in the case language; the officer's note stays internal.
- Counts for `VER-M2`, `REW-G1`, `REW-A1` and `REW-A2` come from the case records, never from events.

## 4. Scenarios

| # | Type | Scenario | Required outcome (from the PRD rule or policy row) | Acceptance id |
|---|---|---|---|---|
| 1 | state | EMPTY — no document returned | Harbor and Desk show "nothing is needed" with the service level; Field shows "none open" (PRD §8) | A3, A4 |
| 2 | state | PARTIAL — some items await re-check; `mismatched` picked without the field | "N of M still to send"; save not permitted until the field is set (R1, R10) | A1, A3 |
| 3 | state | MISSING — pre-feature item without a field; consent without channel or language; manual verification without a method | "not recorded", never a blank; no backfill (R1, A12, §8) | A3, A12 |
| 4 | state | RESTRICTED — support agent, referral agent, officer's audit view, Field | Actions disabled per DESK-010; stage and sub-status only for the agent; own actions only; capture disabled for `mismatched` (R12, §8) | A7, A13 |
| 5 | state | PROVIDER-FAILED — with and without open rounds, and on hold | Row flag; the verification clock pauses from the first failed attempt until the provider answers or manual verification starts, or stays stopped when a return stopped it; sub-status unchanged; the case stays in the provider-failed filter on hold; combined customer message; no decline; attempt evidence (R7, R9, R11) | A9, A10 |
| 6 | state | REWORK — item states per surface | `pending send` → `replacement sent` → `attached` → `accepted` (PRD §8 item states) | A8, A14 |
| 7 | state | ON HOLD and LAPSED | Window ends → `on hold`, item stays open, four-part message with the lapse date; 30 days (`example`) → `lapsed`, start again with documents kept (R8, R11, R14) | A16 |
| 8 | failure | **provider timeout** — no answer within 90 seconds (`example`) | Counts as a failed attempt; three attempts in all; until the automatic retry queue is live the officer runs the two retries from the identity panel, after it is live they run without the officer; customer told nothing is needed; after the third failure the officer records method and result; `not matched` → identity proof returned as `mismatched` (R9) | A9, A10 |
| 9 | failure | **duplicate submission** — the customer uploads twice, or a capture is sent twice after a sync, in the same round | One item, one version update, one notification (R10) | A8 |
| 10 | failure | **resubmission after close** — a file arrives after `on hold`, `lapsed`, or after the case left `Verification` | `on hold`: hold ends, case returns at its original position; `lapsed`: re-enter at `Quote`, documents offered for reuse; later stage: kept as a new version, not re-checked, customer told (R11) | A16, A8 |
| 11 | failure | **concurrent action** — the officer records `accepted` while a field capture is being sent for the same item | The item stays closed; the capture is kept as a new version, is not re-checked, and the customer is not asked again; both actions appear in the audit view (R10) | A8, A11, A14 |
| 12 | failure | A template for the reason code and language is missing | Only the requirement line falls back to the reason-code label in the case language; every path, the send-by window and "talk to our team" still show; the message text version records the fallback; the product lead (customer) receives the weekly count (R3) | A4 |
| 13 | failure | The visit path is switched off for the region, or the visit misses its expected day | Switch off: no visit is offered, including on a second return. Missed: the customer is told on WhatsApp and the status page, offered a rebooked visit and an upload, and the send-by window resumes from the missed day (R5, R8, R14) | A5, A6 |
| 14 | failure | A corrected address changes the tier, or the re-run returns `refer` or `declined` | Premium warning before confirmation; the eligibility screens with the recovery path after (R6, HUB-005, HUB-006) | A15 |
| 15 | integration | identity-check provider — a correction to name or date of birth | The identity check runs again with its own attempts and evidence (R6, R9) | A15, A9 |
| 16 | integration | WhatsApp BSP — the rework, visit, second-return, hold and lapse messages | One line per document plus the link; templates per language; every message carries "talk to our team" (R2, R14) | A4, A16 |
| 17 | integration | Field task — a visit request when an inspection task already exists | The item joins the existing task; an upload first closes the task and tells the verifier (R5) | A6 |

## 5. Dependencies and constraints

| Dependency | Owner | Status | Constraint it adds |
|---|---|---|---|
| identity-check provider | the engineering lead | live; 90-second timeout (`example`); automatic retry queue in UAT | retries and the attempt count depend on C4; without it A9 ships with today's by-hand retry |
| WhatsApp BSP | the engineering lead | live; templates per stage and language | new templates per reason code; one line per document plus the link |
| Field inspection tasks; capture from the checklist | the engineering lead | live; checklist capture in build | visit requests join or create a task; A7 and A8 extend the live capture (FLD-005) |
| the eligibility engine re-run on verified data | the engineering lead | live | a correction re-runs it; engine rows are never first passes |
| event analytics on Desk | the engineering lead | not covered today | two Desk events are new instrumentation |
| the BI tool rework and verification views | the product lead (ops and platform) | live | readings split by recovery path and reason code; two dictionary rows restated to count rounds |
| customer strings per language | the product lead (customer), native reviewer | open | release dependency |

## 6. Regulated actions and evidence

| Register row | Evidence the product must keep (as an outcome) | Where it is visible |
|---|---|---|
| Identity verification | Per attempt: provider response reference, result, time, officer role where an officer acted. Manual verification: method, result, officer role, time, references of the failed attempts. Correction of name or date of birth: who, old value, new value, time. Each full-value identity view | Desk audit view (DESK-009); the SQL replica |
| Consent and disclosure | Consent text version, time, channel, language; the message text version shown per round; nothing asked outside the consented checklist | Harbor (what was agreed); Desk audit view, compliance officer only |
| Record retention | Per round and per capture: actor role, time, document reference and version, reason code, field that differs, requirement shown; the retention schedule per record and the delete-after date; a deletion audit event | Desk audit view, compliance officer; the SQL replica |

## 7. Observability and reconciliation

Events that exist and stay: `verification_outcome_viewed`, `rework_resubmitted`. Events marked **new**, each with a `Planned` row in the analytics catalog: `rework_visit_requested` (Harbor status page, one per request), `case_detail_corrected` (Harbor, at confirmation), `rework_item_raised` (Desk, per saved round), `manual_verification_recorded` (Desk). Engineering owns their properties. After release product reads: `VER-M2` and `REW-G1` weekly at D+14 from the BI tool and the replica, split by recovery path and reason code; `VER-G1` weekly at D+7; `VER-M1` at D+45; `REW-A1` and `REW-A2` from the replica. Reconciliations: every round has an evidence record; every provider attempt has one; the count of rounds still open at D+14 beside the median; the count of reason-code and language pairs with a missing template; manual verifications by method, counted from the evidence records, never from the audit metadata.

## 8. Decisions engineering owns

Schema · APIs · component design · migration · rollout mechanics · test plan · estimates · technical breakdown. Feature-specific: how retries, the attempt count and the retry limit are implemented; how a visit request joins an existing task; de-duplication within a round; where consent channel and language live while the audit metadata is empty; how document versions are stored; how masking is enforced; how the rework view filters the queue; how the premium-range warning gets the new range. The rules stay in sections 3, 4 and 6.

## 9. Open inputs

| Input | Owner (role) | Does a developer need to invent policy without it? |
|---|---|---|
| Send-by window pause rules; retry limit; reasons resolvable on site; visit switch per region | ops lead | No — each has a stated default in the PRD; production runs the 7-day window (`example`) |
| Manual method and result lists; correction evidence; no consent backfill; full-value views as the audit event; provider-response retention on an unissued case; complaint route unchanged | compliance officer | No — defaults stated in the PRD rules R6, R9, R12, R13 and the non-goals |
| Field-that-differs list | ops lead proposes; the product lead (ops and platform) locks | No — default of three fields stated in R1 |
| Customer strings per language | the product lead (customer), native reviewer | No — the message parts and limits are stated; the words are a release dependency |
| Dictionary rows restated to count rounds; `REW-A2` added | the product lead (ops and platform) | No — the counted unit and timestamps are stated in R10 |

## 10. Anticipated questions

| Question the engineering lead will ask | Product answer, or "engineering to decide" |
|---|---|
| Which action sets the resubmitted time for a correction or an offline capture? | Upload time; field send time (not capture time); correction confirmation (R10) |
| Where do consent channel and language live while the audit metadata is empty? | Engineering to decide; the outcome is the four-part consent record (section 6) |
| How does a visit request join an existing inspection task? | Engineering to decide; the outcome is one task per case with the item listed (R5) |
| What is "the same round" for de-duplication? | From the raise until the officer records a re-check outcome on that round (R10) |
| Does an identity re-run after a name correction count toward the retry limit? | No — a re-run starts a new set of three attempts with its own evidence (R6, R9) |
| May the officer open the return panel while the identity result is provider-failed? | Yes for any other document. Not for the provider failure itself; the identity proof is returned only after a manual `not matched` (R9) |
| Is the rework view a saved filter or a new state? | Engineering to decide; it must show the same rows as the queue (R11) |
| What does the customer see when the region's visit switch is off? | Upload, take another look where it applies, and "talk to our team"; the visit path is absent, not disabled, also on a second return (R5) |
| Who retries the identity check before the automatic retry queue is live? | The verification officer, from the identity panel, twice; each retry writes its attempt record; manual verification opens after the third failure (R9) |
