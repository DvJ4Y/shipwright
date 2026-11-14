---
title: "PRD: Verification outcome and rework"
type: prd
status: approved
version: 1.1
tier: M
owner: product lead (ops and platform)
lane: ops-platform
supersedes: v1.0
decision_refs: [D-004, D-006, D-008, P-15, P-16, P-17, P-18, P-25, P-26, P-27, P-28, P-29, P-30, P-31, P-32, P-33]
shipped_on: —
landed_into: []
why: Tests whether a returned document fixed once lowers VER-M2 — the customer sees the detail, the requirement and one recovery path; officer and field verifier see the same item
last_updated: 2026-11-04
---

# PRD: Verification outcome and rework

## 1. Objective

Approve this PRD so that a returned document is fixed once. When verification returns a document, the customer sees which paper, which detail differs, the requirement in plain words and one recovery path. The verification officer raises one item the customer can act on. The field verifier captures a replacement on site. A provider failure is shown and never declines. Two levers, both hypotheses resting on interview evidence (`example`). The field that differs and the requirement in plain words should bring a correct resubmission sooner; the officer card lists this as untested. The visit path should let low-readiness customers who cannot re-photograph still resubmit; it serves `REW-G1` and may lengthen `VER-M2` for those items; whether Meera accepts a visit is unknown on her card.

Outcome: `VER-M2` rework cycle time, 31 hours (`example`) → 18 hours (`target`), read as descriptive movement and split by recovery path. `VER-M2` leads because it is the per-item cost of a return; `REW-G1` guards it. Fewer holds and lapses let more cases reach `Placement`, which serves `POL-M1` (goal G1); `VER-M2` itself serves goal G2. Commitment: C1. Themes: `VEF` Verification efficiency, `CTT` Customer trust and transparency, `CMP` Compliance by design.

## 2. Users and primary use cases

| # | User / role | Situation (When…) | Need (I want to…) | Outcome (so I can…) |
|---|---|---|---|---|
| U1 | Meera — small grocery, first policy (persona card E1, E3, E4) | a document comes back | know which paper, why, and what to do, in my language | have my son fix it once, without a call |
| U2 | Priya — pharmacy (persona card E1, E2, E4) | a document comes back as `mismatched` | see which detail differs and what the record says, or ask for another look | fix the document or the record in one go |
| U3 | Arjun — electronics retail, three outlets (persona card E1, E3, `example`) | something is missing on a case | see one list per case with its status | send it once and get on with the day |
| U4 | Verification officer (role card E1, E2) | I return a document | pick the reason and the field that differs, see the requirement, and see a multi-item case as one row | raise one item the customer can act on |
| U5 | Verification officer (role card E1) | the identity-check provider fails | see it plainly, wait for the retries, then verify manually and record how and what I found | never decline or lose the case |
| U6 | Field verifier (role card E1, E2, E3) | I am at the shop | see every open item on my assigned case and which I may capture | capture everything in one visit |
| U7 | Compliance officer (role card E1, E2) | the regulator asks about a case | see every regulated action with its evidence record | answer in minutes |

Hardest cases first: U1 (lowest document readiness) and U2 (lowest tolerance for a repeat ask), both from interviews (`example`). Assumption: a relative may read the message (Meera E1, E3); strings are written for that reader.

## 3. Current behaviour and reuse

| What exists today | Evidence | Reused / extended / replaced |
|---|---|---|
| Rework list on the status page and WhatsApp: document, reason code, one next step | HUB-008 | extended: the field that differs, what the record says, the requirement in plain words, the tip, accepted alternatives, the visit and take-another-look paths, the send-by window |
| Provider-failed message; language held for every message; declined and refer screens with recovery path | HUB-009, HUB-003, HUB-005, HUB-006 | extended: "talk to our team" and the combined message when items are open; language reused; declined and refer screens reused for a rules re-run after a corrected detail |
| Queue order; PROVIDER-FAILED flag on the row | DESK-001, DESK-002 | extended: clock shown as stopped or paused, open-item count, reason codes, hold date |
| Rule outcomes per case; reason code required, note optional; declined needs a rule | DESK-003, DESK-004, DESK-005 | extended: the field that differs is required on `mismatched`; the requirement is carried onto the item; the note stays internal; declined never for a provider failure |
| Replacement attached to the item; case returns at its original position | DESK-006 | extended: also for a new upload and a corrected detail; the re-check clock |
| Audit view; support agent cannot set `rework`, `refer` or `declined` | DESK-009, DESK-010 | extended audit view: rounds, captures, corrections, manual method and result, consent channel and language, delete-after date; restriction reused |
| Route with open-item count; slot text; mandatory slots; offline save; capture against an item; verifier proposes `rework`; agent sees stage and sub-status; agent told on hold | FLD-001 to FLD-006, FLD-008, FLD-009 | extended: items with reason, slot text and capture allowed; the mandatory-slot rule applied to replacement capture; offline, proposal (the officer confirms and picks the field), agent view and hold notification reused |

## 4. Flow and scope

1. The verification officer opens a case from the queue and checks identity and each document. To return one, the officer picks a reason code; for `mismatched` also the field that differs. The record value, the requirement and the tip fill in. Save creates the rework item, sets the case to `rework`, stops the verification clock and writes an evidence record.
2. The customer sees one list per case on the status page, and one line per document on WhatsApp with a link. Each item shows what happened, what it means for the policy, the requirement in plain words, the tip, the accepted alternatives, the recovery paths and the send-by window.
3. Recovery paths: a new upload; a visit (`unreadable`, `missing`); a corrected detail (`mismatched`); ask our team to take another look (`mismatched`, and any second return); talk to our team (on every message).
4. Before the customer confirms a corrected detail, the page says the premium range may change. A correction is a resubmission. It re-runs the rules and, for a name or date of birth, the identity check. The customer then sees the new range, or the refer or declined screen with its recovery path.
5. A visit request creates a replacement-capture task for the region's field verifier, or adds the item to an existing inspection task. The status page shows the expected day.
6. The field verifier sees every open item on the assigned case and captures replacements for the reasons allowed. The item shows `pending send` without network, then `replacement sent`.
7. Every resubmission attaches to the item as a new version of the same document, returns the case to the officer's queue at its original position and starts the re-check clock. The officer re-checks: `accepted` closes the item; a second return opens a new round on the same item and tells the customer what changed.
8. Provider failure: the row shows PROVIDER-FAILED, the verification clock pauses, the customer is told nothing is needed. Retries run per the limit. Then the officer records a manual verification with its method and result. Scope: steps 1–8 on Harbor, Desk, Field and WhatsApp, the evidence records for the three regulated actions, and the configuration in section 6.

## 5. Non-goals

- Changing the three reason codes, free text reaching the customer, or an automatic decline after repeated returns — reason text comes from templates; a decline needs a rule and a recovery path.
- The referral agent seeing a reason — stays as today; the compliance officer decides.
- Retry mechanics; an automated readability check (later, after the unreadable share is pulled); an officer-error tag (later; trigger `REW-A1` above 1.6, `example`); a new Desk dashboard — the rework view is a filter on the existing queue.
- Complaint handling — every message carries "talk to our team"; the complaint reference and escalation stay with the complaint-handling action; the compliance officer confirms this is enough.

## 6. Business rules and configuration

| Rule | Condition | Behaviour | Configurable? | Policy |
|---|---|---|---|---|
| R1 | Officer returns a document | Reason code required. For `mismatched` the field that differs is required, from the configured list: policyholder name · shop address · date of birth. When a field verifier proposes `mismatched` on inspection, the officer picks the field at confirmation; save is blocked until it is set | field list: new configuration | document checklist |
| R2 | Customer text is built | Templates only, per reason code and language. The officer's note stays internal. The customer never sees the configured rule name, the risk tier or an internal id. Each string has a length limit with an expansion allowance; WhatsApp carries one line per document plus the link | templates: new configuration, customer lane with a native reviewer | — (proposed) |
| R3 | The requirement shown | `mismatched`: the engine rule that fired, in plain words. `unreadable`: what must be visible on the item. `missing`: the item is on the checklist for the product and shop type, with why the insurer needs it. Every item lists the accepted alternative documents. A reason code is enabled in a language only when its approved template exists; the product lead (customer) owns that check. If a template is still missing, only the requirement line falls back to the reason-code label in the case language; the paths, the send-by window and "talk to our team" always show, and the message text version records the fallback. The product lead (customer) and the native reviewer receive the count of fallbacks weekly | per language | document checklist |
| R4 | Recovery paths per reason | As flow step 3. A visit is offered only for reasons resolvable on site; default `unreadable` and `missing`, never `mismatched` | per reason code: ops lead | risk tiers and routing |
| R5 | Visit request | Offered when the reason is resolvable on site and the region's visit switch is on. The ops lead may switch it off per region when inspection tasks pass the field inspection service level (72 hours, `example`). The task is created on request and the visit falls under that service level. An existing inspection task takes the item instead. Harbor shows the expected day; the customer may change the day once. An upload before the visit closes the task, and the Field task list tells the verifier. A visit misses its commitment when the expected day passes with no capture sent; the customer is then offered a rebooked visit, an upload and "talk to our team". A second return offers the visit path again only where the switch is on and the reason is resolvable on site; where it is off, the second return offers upload, take another look and "talk to our team" | per region: ops lead | service levels |
| R6 | Corrected detail | The customer may correct the three fields on the own case; a verification officer may correct them at the customer's request and records that. A correction is a resubmission. It re-runs the rules; a name or date-of-birth correction re-runs the identity check. The evidence keeps who, the old value, the new value and the time; a correction the officer enters also records the channel of the customer's request. The consent given on the case covers the identity re-run, and the re-run evidence cites the consent text version. A re-run `refer` or `declined` shows the eligibility screen with its recovery path | no | eligibility rules; evidence proposed, compliance officer |
| R7 | Clocks | A return stops the verification clock. A resubmission starts the re-check clock (12 hours, `example`). PROVIDER-FAILED pauses the verification clock from the first failed attempt until the provider answers or the officer starts the manual verification, as the service-levels policy states; when a return has already stopped the clock, it stays stopped. The re-check clock of an item already resubmitted keeps running during a provider failure | per queue | service levels |
| R8 | Send-by window | Per item, 7 days (`example`) from each return round; restarts on a second return; pauses from a visit request until the capture is sent, and resumes from the missed day when a visit misses its commitment; keeps running during a provider failure. A resubmission during `on hold` ends the hold and the remaining items get a fresh window. 30 days on hold (`example`): `lapsed` | per queue: ops lead (pause rules proposed) | service levels |
| R9 | Provider failure | The case is never declined for it and keeps its sub-status: `open`, or `rework` when items are open; PROVIDER-FAILED is a flag on the queue row, not a sub-status. An attempt with no answer within the provider's timeout (90 seconds, `example`) counts as failed; there are three attempts in all, the first and two retries (`example`). Until the automatic retry queue is live, the verification officer runs the two retries from the identity panel and each one writes its attempt record; after it is live, retries run without the officer. `declined` cannot be set for the provider failure, from the identity panel or the case. A provider failure never raises a rework item on the identity proof. The identity check continues while the case is `on hold`: the case stays visible in the provider-failed filter, and the officer can record the manual verification there. After the third failed attempt the officer records a manual verification: method from the configured list (default: document inspection only; video call and field visit are open inputs) and result `verified` or `not matched`. `not matched`: the identity proof is returned as `mismatched` with the field; the case is not declined for it. A re-run of the identity check after a correction starts a new set of three attempts | timeout and retry limit: ops lead; methods and results: compliance officer | — (proposed) |
| R10 | Rounds, counts and resubmissions | One rework item per document. Each return is a round with its own raised and resubmitted times. An item is open from raise until the officer records `accepted`; it is awaiting re-check once a resubmission arrives. Harbor and Field count items with no resubmission; Desk counts open items and shows how many await re-check. Only a verification officer closes an item; a hold leaves it open. A resubmission is a new upload at upload time, a field capture at send time (not capture time), or a corrected detail at confirmation. A second upload or send in the same round updates the item and sends one notification. A capture sent after the officer has recorded `accepted` is kept as a new version, is not re-checked, and the customer is not asked again | no | metrics dictionary (proposed) |
| R11 | After the case leaves `Verification`; where a case sits | `on hold`: a resubmission ends the hold and the case returns to the queue at its original position. `lapsed`: open items close as `lapsed` and count as not resubmitted; the customer re-enters at `Quote` as a new case, with documents offered for reuse within the retention period. Any later stage: the file is kept as a new version and is not re-checked; Harbor tells the customer the file is kept and nothing more is needed. `open` and `rework` stay in the verification queue at their position; the rework view is a filter of that queue; `on hold`, `lapsed`, `declined` and `cancelled` leave it, except that a provider-failed case on hold stays in the provider-failed filter | no | service levels; risk tiers and routing |
| R12 | Masking and access | The identity number is full on the Desk verification screen only, last 4 characters (`example`) elsewhere, never on Field or to the referral agent. Each view of the full value is an audit event. The field that differs is visible to the customer, the support agent, the verification officer and the assigned field verifier. After send, the field verifier cannot open any replacement capture, including the offline copy | no | data handling and retention |
| R13 | Retention per record type | Issued policy: case, documents, verification and audit events 7 years after policy end (`example`). Unissued case: 2 years after the last customer action (`example`). Provider responses: the life of the case plus 7 years (`example`). Messaging logs: 2 years (`example`). Each deletion is an audit event. The delete-after date is visible to the compliance officer | per record type | data handling and retention |
| R14 | Notifications (trigger → recipient · channel) | return raised → customer · status page and WhatsApp; visit arranged with the expected day → customer · WhatsApp; visit missed → customer · status page and WhatsApp (what happened, what it means, rebook the visit, upload, the send-by date); task closed by an upload → field verifier · Field task list; second return with what changed → customer · WhatsApp; item accepted → customer · status page; file received after the case left `Verification` → customer · WhatsApp (the file is kept, nothing more is needed); `on hold` → customer · WhatsApp (what happened, what it means, the open paths, the lapse date) and referral agent (existing); `lapsed` → customer · WhatsApp (start again; documents kept). Every customer message carries "talk to our team" | templates per language | — (proposed; ops lane leads, customer lane writes) |

## 7. Information, permissions and audit

| Data point | Who provides it | Who can see / edit | Regulated action | Evidence kept |
|---|---|---|---|---|
| Reason code and round (existing: DESK-004) | verification officer; field verifier proposes on inspection | customer, support agent, verification officer, assigned field verifier; officer edits | record retention | on the rework evidence record |
| Field that differs (new) and what the record says (derived) | verification officer, one pick; the case | as the reason code; the record value: customer, verification officer | record retention | on the rework evidence record |
| Requirement, tip, accepted alternatives (configuration; tip existing: FLD-002) | the eligibility engine; the checklist; templates per language | customer; verification officer; field verifier (tip) | consent and disclosure | message text version |
| Recovery paths, visit request, expected day, send-by window, hold date, open-item count, awaiting re-check, replacement status, document version (derived; request new; status existing: DESK-006, FLD-005) | system; customer; field verifier | customer, support agent, verification officer, assigned field verifier | record retention | replacement evidence record: actor role, time, document reference and version |
| Corrected detail (new) | customer; verification officer at the customer's request | customer, verification officer | identity verification (name, date of birth) | who, old value, new value, time |
| Resolvable on site per reason; visit switch per region (new configuration) | ops lead | field verifier (as an enabled or disabled action) | — | — |
| Provider result and attempt count (existing: DESK-002; count new) | identity-check provider; system | verification officer; customer sees the message only | identity verification | per attempt: provider response reference, result, time, officer role where an officer acted |
| Manual verification method and result (new) | verification officer | verification officer, compliance officer | identity verification | method, result, officer role, time, references of the failed attempts |
| Consent record (existing; shown to the customer new; channel and language new) | customer, at consent | customer sees what was agreed, when and on which channel; compliance officer | consent and disclosure | text version, time, channel, language |
| Delete-after date (derived, new) | system | compliance officer, ops lead | record retention | retention schedule per record; deletion audit event |
| Identity number (policy; no surface row) | identity document | full: verification officer on the verification screen; last 4 elsewhere; never on Field or to the referral agent | identity verification | each view of the full value |

**Regulated actions touched:** identity verification · consent and disclosure · record retention

## 8. States

| State | When it happens | What the user sees | What the user can do |
|---|---|---|---|
| NORMAL | Items are open; nothing has failed | Harbor: the list in flow step 2. Desk: the row with count, awaiting re-check, reasons, clock and hold date. Field: items with reason, slot text and capture allowed | Harbor: upload, visit, correct, take another look, talk to our team. Desk: open, re-check, return. Field: capture |
| EMPTY | No document has been returned | Harbor: "being checked — nothing is needed from you" with the service level. Desk rework view: an empty list with that sentence. Field: "none open — inspection only" | Harbor: wait. Field: open the inspection |
| PARTIAL | Some items await re-check; or the officer picked `mismatched` without the field | Harbor and Field: "N of M still to send". Desk: the row says what awaits re-check; the return panel says the field is outstanding | Desk: save is not permitted until the field is set |
| MISSING | A checklist item has no file; an item raised before this feature has no field; a consent record has no channel or language; a manual verification has no method | Harbor and Field: the item named with why it is needed and the tip, never a blank slot. Desk: "not recorded", never a blank cell | Upload or capture; Desk: set the field on re-check; compliance officer: no backfill |
| RESTRICTED | A role may not act or see | Harbor: not applicable; withheld values are absent, never marked. Desk: the support agent sees the row with return, refer and decline disabled; the verification officer sees own actions in the audit view; the full consent record is for the compliance officer, while the consent status (`given` or `not recorded`) shows on the case for verification officers and the ops lead; the delete-after date is for the compliance officer and the ops lead. Field: capture disabled for reasons not resolvable on site; identity number never shown; the referral agent sees stage and sub-status only | Read only |
| PROVIDER-FAILED | The identity-check provider did not answer in time | Harbor: "we could not complete the identity check; we will retry; nothing is needed from you" and "talk to our team"; combined with the open items when there are any; no send-by field when nothing is returned. Desk: PROVIDER-FAILED on the row, attempt count, clock paused (still stopped when a return stopped it), sub-status unchanged; `declined` not permitted for it. Field: not applicable | Desk: wait for the retries; after the limit, record the manual verification |
| REWORK | An item is open and a resubmission is awaited or arrived | Harbor: per item `not received`, `visit being arranged`, `received — being re-checked`, `done`. Desk: `replacement sent`, `attached`, the re-check clock. Field: `not started`, `pending send`, `replacement sent` | Desk: re-check |
| ON HOLD | The send-by window ended with an item open | Harbor and WhatsApp: what happened, what it means for the policy, the paths still open (upload, visit, talk to our team) and the lapse date. Desk: the case out of the queue. Field: the agent's hold notification | Customer: any open path ends the hold |
| LAPSED | 30 days (`example`) on hold with no customer action | Harbor and WhatsApp: start again; documents kept for reuse | Customer: re-enter at `Quote` |

Item states: `pending send` — captured on the device, not yet sent · `replacement sent` — sent, not yet attached · `attached` — on the item, awaiting re-check · `accepted` — re-check passed, item closed.

## 9. Acceptance criteria

- **A1** (U4) — When a verification officer returns a document with reason `mismatched`, then the field that differs must be chosen before save, and the rework item carries the reason code, the field, what the record says and the requirement; when a field verifier proposed it on inspection, then the officer picks the field at confirmation.
- **A2** (U4) — When a verification officer returns a document with reason `unreadable` or `missing`, then the rework item carries the reason code, the tip and the accepted alternatives, and for `missing` why the insurer needs it.
- **A3** (U4) — When a case in the verification queue has open items, then its row shows the count of open items, how many await re-check, the reason codes, the clock as stopped or paused, and the hold date, and the row keeps its position. An item raised before this feature shows "not recorded" for the field.
- **A4** (U1, U3) — When a round is raised, then the status page and the WhatsApp message list each returned document with what happened, what it means for the policy, the requirement in plain words, the tip, the accepted alternatives, the recovery paths, the send-by window and "talk to our team", in the case language; WhatsApp carries one line per document plus the link; the configured rule name and the risk tier never appear; when no template exists for the reason code and language, then only the requirement line falls back to the reason-code label, every path and "talk to our team" still show, and the fallback is counted for the product lead (customer).
- **A5** (U2, U1) — When the returned document is `mismatched`, then the customer sees which detail differs and what the record says, with the paths: a new upload, correct the detail, ask our team to take another look. When it is `unreadable` or `missing`, then the customer sees the tip with the paths: a new upload, and ask for a visit where A6 has shipped and the region's switch is on; a `mismatched` item offers no visit.
- **A6** (U1, U6; Should) — When the customer asks for a visit, then a task appears for the region's field verifier or the item joins the existing inspection task, the status page shows "visit being arranged" with the expected day and one chance to change it, the send-by window pauses until the capture is sent, and an upload before the visit closes the task and tells the verifier; when the expected day passes with no capture, then the customer is told on WhatsApp and the status page, is offered a rebooked visit and an upload, and the window resumes; when the region's switch is off, then no visit is offered, including on a second return.
- **A7** (U6) — When a field verifier opens an assigned case, then every open item is listed with the document, the reason, what the officer needs to see and whether it may be captured, and the capture action is disabled for reasons not resolvable on site (default `mismatched`).
- **A8** (U6, U4) — When a resubmission arrives by field send, new upload or corrected detail, then it attaches to the item as a new version of the same document, the case returns to the officer's queue at its original position and the re-check clock starts. A field capture shows `pending send` without network; a multi-photo item cannot be sent until every slot is filled; a duplicate in the same round sends one notification.
- **A9** (U5, U7) — When the identity-check provider does not answer within its timeout (90 seconds, `example`), then the queue row shows PROVIDER-FAILED, the case keeps its sub-status (`open`, or `rework` when items are open), the verification clock pauses or stays stopped, the customer is told nothing is needed and offered "talk to our team", `declined` cannot be set for the provider failure from the identity panel or the case, no rework item is raised on the identity proof, the case stays in the provider-failed filter even on hold, and every attempt, including a failed one, writes an evidence record with the provider response reference, the result, the time and the officer role where an officer acted — regulated action: identity verification.
- **A10** (U5, U7) — When the third attempt fails, then the verification officer can record a manual verification with its method and result, including on a case `on hold`; the evidence record holds the method, the result, the officer's role, the time and the references of the failed attempts, and `not matched` returns the identity proof as `mismatched` with the field — regulated action: identity verification.
- **A11** (U7) — When a round is raised or a replacement is captured, then an evidence record holds the actor role, the time, the document reference and version, the reason code, the field that differs, the requirement shown and the message text version, the audit view lists it, and the compliance officer sees the delete-after date — regulated action: record retention.
- **A12** (U1, U7) — When the customer views the rework list, then it shows what was agreed, when and on which channel, the message asks for nothing outside the consented checklist, the consent evidence record holds the text version, time, channel and language, and a record from before this feature shows "not recorded" for channel and language — regulated action: consent and disclosure.
- **A13** (U7) — When a support agent opens a case with open items, then return, refer and decline are disabled; when a referral agent opens it, then only stage and sub-status show; the identity number shows its last 4 characters (`example`) outside the verification screen and never on Field; each view of the full value is an audit event; after send the field verifier cannot open any capture.
- **A14** (U4, U2) — When the officer records `accepted` on re-check, then the item closes and the customer's list shows it done; when the officer returns it again, then a new round opens on the same item and the customer is told what changed, with the new requirement in plain words in the case language and the take-another-look path.
- **A15** (U2, U7) — When the customer corrects a detail, then the page says the premium range may change before confirmation; after it, the rules re-run and the customer sees the new range, or the refer or declined screen with its recovery path; a name or date-of-birth correction re-runs the identity check; the evidence keeps who, the old value, the new value and the time — regulated action: identity verification.
- **A16** (U1) — When the send-by window ends with an item open, then the case moves to `on hold`, the item stays open and the customer message gives what happened, what it means, the open paths and the lapse date; when 30 days (`example`) pass on hold, then the case is `lapsed`, its open items close as `lapsed` and the message offers to start again with documents kept; when a file arrives during `on hold`, then the hold ends and the case returns to the queue at its original position; when it arrives after the case left `Verification`, then it is kept as a new version, is not re-checked and Harbor tells the customer nothing more is needed.

Should: A6. Must: all others. Sixteen criteria: three surfaces, five evidence records, the correction path and the two hold states.

## 10. Metrics

Population boundaries. `VER-M2`: rounds raised in the week, raised → resubmitted (not accepted), read at D+14; rounds never resubmitted or resubmitted after D+14 are excluded, so the count still open at D+14 is reported beside the median, with `REW-G1`. `VER-M1`: cases quoted in the week that entered `Verification`, D+45; a first pass is the earliest officer or field outcome per case; re-runs after a correction are engine rows and are never first passes. `REW-G1`: rounds raised in the week resubmitted within 7 days (`example`) whatever the configured window, D+14. `VER-G1`: cases entering the queue in the week, D+7. `REW-A1`: cases entering `Verification` in the week, D+45; excludes cases declined before any round. Movement is read as the last four rework-raised weeks before release against the first four after, both at D+14; `VER-M1` is first read at D+45. Every reading is split by recovery path and reason code. Counts come from the case records, never from events.

| Metric ID | Role | Source | Claim level | Baseline | Target |
|---|---|---|---|---|---|
| `VER-M2` | outcome | the BI tool, rework view | descriptive movement | 31 hours (`example`) | 18 hours (`target`) |
| `VER-M1` | guardrail | the BI tool, verification view | descriptive movement | 61% (`example`) | not below the baseline |
| `REW-G1` | guardrail | the SQL replica, saved query "rework resubmission" (`operational — unverified`) | descriptive movement | 68% (`example`) | 85% (`target`) |
| `VER-G1` | guardrail | the SQL replica, saved query "verification queue age" (`operational — unverified`) | descriptive movement | 87% (`example`) | 95% (`target`) |
| `REW-A1` | anti-metric | the SQL replica, rework rounds joined to cases by case id (`operational — unverified`) | descriptive movement | 1.3 per case (`example`) | no target; above 1.6 (`example`): reason-code review and the officer-error tag discovery |
| `REW-A2` (proposed) | anti-metric | the SQL replica, rounds per item | — | not measured | no target; a dictionary row to add, owner the product lead (ops and platform) |

`VER-M1`, `REW-G1` and `VER-G1` must not fall while `VER-M2` improves. `VER-M2` and `REW-G1` count rounds, which the dictionary rows must state before release. The movement is a hypothesis test, not a causal claim.

## 11. Dependencies, open inputs and owners

| Item | Type | Owner (role) | Blocks |
|---|---|---|---|
| Policy values applied on defaults: send-by window and its pauses, retry limit, reasons resolvable on site, the visit switch per region | open input, default applied | ops lead | no |
| Regulated defaults applied: manual method list and result values, correction evidence, no consent backfill, the full-value view as the audit event, provider-response retention on an unissued case, complaint route unchanged | open input, default applied | compliance officer | no |
| The field list for `mismatched` | open input, default applied | ops lead proposes; the product lead (ops and platform) locks | no |
| Customer strings per language, with a native reviewer; the templates | dependency | the product lead (customer) with the product lead (ops and platform) | release |
| The automatic retry queue (in UAT); capture from the inspection checklist (in build) | dependency | the engineering lead | Retry queue: no — until it is live the officer runs the two retries from the identity panel (R9); capture: no, A7 and A8 extend the live capture |
| Dictionary rows: `VER-M2` and `REW-G1` count rounds; `REW-A2` added | open input | the product lead (ops and platform) | the first reading |

## 12. Interconnections and impact

**Connected features:** feeds the automatic retry queue and the inspection-checklist capture · depends on the rework list, the reason-code return, the replacement attachment and the audit view · conflicts with none.

| Layer | What changes | Existing or new | Owner (role) |
|---|---|---|---|
| Data | field that differs, round, resolvable on site, visit switch, manual method and result, attempt count, corrected detail with old and new value, consent channel and language, delete-after date | new; the rest reused | the product lead (ops and platform); the compliance officer for consent, correction and retention evidence |
| Workflow and events | visit request creates or joins a field task; a correction re-runs the rules and, for name or date of birth, the identity check; four events marked **new**: `rework_visit_requested` and `case_detail_corrected` on Harbor, `rework_item_raised` and `manual_verification_recorded` on Desk — Desk is not covered by event analytics today | new | the product lead (ops and platform) with the engineering lead |
| Communication and notifications | the rework message gains the field, the record value, the requirement, the tip, the alternatives and the paths; the notification set in R14 | extended; visit, second-return, accepted, late-file and lapsed messages new | ops lane leads; customer lane writes |
| Harbor | the rework list; the visit, correction and take-another-look paths; the premium warning; consent shown; on hold and lapsed messages | extended | the product lead (customer) reviews |
| Desk | return panel; queue row and rework filter; identity panel with manual method and result; audit view | extended | the product lead (ops and platform) |
| Field | open items with reason, slot text and capture allowed; capture as a new version; visit tasks | extended | the product lead (ops and platform) |
| Rules | re-run on a corrected detail; rule tables unchanged | existing | — |
| Other teams | field verifiers take visit requests, rebooked visits and reopened visits; verification officers pick one more field, run retries until the retry queue is live, record manual verifications and enter corrections at the customer's request; the compliance officer owns the consent, correction and retention evidence | new load | ops lead; compliance officer |
| Metrics | `VER-M2` and `REW-G1` weekly at D+14; `VER-G1` weekly at D+7; `VER-M1` at D+45; `REW-A1` read weekly for the first time; `REW-A2` added | existing; two rows change; one proposed | the product lead (ops and platform) |

| Effect | Who feels it | Early signal (source, label) |
|---|---|---|
| Visit requests add field verifier load | field verifiers, ops lead | inspection tasks past 72 hours (`example`) on the SQL replica (`operational — unverified`) |
| A corrected shop address changes location, risk tier and the premium range after the customer saw one | customer, placement specialist | `PAY-M1` falls for cases with a correction (the BI tool) |
| One more pick per `mismatched` return, manual verifications after provider failures, and re-check clock misses as resubmissions rise | verification officers, ops lead | `VER-G1` falls and re-checks past 12 hours (`example`) rise (the SQL replica, `operational — unverified`); manual share counted from the manual-verification evidence records, never from the audit metadata |
| Rounds per item rise if the requirement text is unclear | customers, support agents | `REW-A2`; support calls that quote a returned item (`operational — unverified`) |

## 13. Crosswalk to earlier requirements

- The customer asks for a visit from the status page — carried, with the ops lead's switch per region.
- The requirement beside the reason on the case view, and the replacement re-checked without a search — carried; the re-check clock is added.
- The reason and tip on the field verifier's route — refined: the count stays on the route; reason and tip are on the case screen.
- The field that differs on `mismatched`, and which reasons a verifier may resolve on site — carried as configuration, defaults applied.
- The verifier's view of a provider-failed check — dropped; the verifier does not see the identity result.
- Version 1.1 — the late file, the missing template, the missed visit and a provider failure on a case with open items are folded into A4, A6, A9 and A16 and rules R5, R7 and R9; the consent record is for the compliance officer only; no criterion is added.
