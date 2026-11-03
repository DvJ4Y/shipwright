# Context digest — Week 44 (2026-11-01)

Inputs: `sessions/weekly/2026-W44-summary.md` · `tasks/lessons.md` (1 entry in window: 2026-10-28) ·
34 context files · memory: none.

Answer the five questions below at the Monday knowledge interview, before the `/review` gate.
Result: 11 STALE · 6 MINOR DRIFT · 17 CURRENT. Two session facts cause most of the drift. The
12-hour verification service level affects 4 files. The seventh insurer partner affects 6 files.

## Findings by document
| Document | Status | Doc says | Sessions indicate | Recommendation |
|---|---|---|---|---|
| `context/policies/service-levels.md` | STALE | "\| Verification \| first outcome within 24 hours \| verification officers \| "within one working day" \| `VER-G1` \| example \|" | "Verification queue service level is 12 hours, effective 2026-10-30; it was 24 hours" (session 2026-10-30, ops lead, `operational — unverified`) | Update after the product lead confirms (Q1). This file owns the value. Hold the row as `proposed` until production configuration matches (`policies/README.md`). "within one working day" no longer fits 12 hours. Q2 asks the ops lead to re-confirm the clock rule "Rework raised → The verification clock stops" |
| `context/policies/risk-tiers-and-routing.md` | STALE | "A tier 3 case has the same 24-hour verification service level (`example`) as a tier 1 case; the ordering is what gets it worked first." | "Verification queue service level is 12 hours, effective 2026-10-30; it was 24 hours" (session 2026-10-30, `operational — unverified`) | Update after the product lead confirms. Point to `service-levels.md`; do not restate the number. Also reword "\| Inspection returns `rework` on an item \| Rework item is raised; customer is told after the officer confirms \|". Under the 2026-10-30 LOCKED rule, the officer raises the item on confirmation |
| `context/05-numbers-data-and-traps.md` | STALE | "\| Verification queue service level \| 24 hours (`policies/service-levels.md`) \| example \|" · "\| Insurer partners \| 6 \| example \|" | "Verification queue service level is 12 hours, effective 2026-10-30; it was 24 hours" (session 2026-10-30, `operational — unverified`) · "Harbor Cover has seven insurer partners; the seventh signed 2026-10-29 and requires a stock register for stock cover" (session 2026-10-29, `example`) | Update both rows after the product lead confirms. This file owns both numbers. The rework median (31 hours, `example`) and first-pass rate (61%, `example`) match. Leave the rework row until the BI tool reproduces the pull (decision 2026-10-29) and Q3 settles the boundary |
| `context/01-company.md` | STALE | "\| Insurer partners \| 6 \| example \|" | "Harbor Cover has seven insurer partners; the seventh signed 2026-10-29 and requires a stock register for stock cover" (session 2026-10-29, `example`) | Update after the product lead confirms. Or point to `05`, per the authority rule in `context/README.md` |
| `context/06-teams-and-who-does-what.md` | STALE | "\| Insurer partners \| 6 \| Carry the risk; issue the policy; settle claims \| example \|" | "Harbor Cover has seven insurer partners; the seventh signed 2026-10-29" (session 2026-10-29, `example`) | Update after the product lead confirms. The rework roles match the 2026-10-30 decision: officers raise rework; field verifiers capture replacements |
| `context/03-surfaces-and-systems.md` | STALE | "\| insurer partner APIs \| Case submission, query threads, issuance, claim status \| live for 4 of 6 partners (`example`) \| The other 2 run on email and a shared sheet (`example`) \|" · "A `declined` or `rework` outcome shows the reason in plain words and the recovery route." | "Harbor Cover has seven insurer partners; the seventh signed 2026-10-29" (session 2026-10-29, `example`) · ""rejected" replaced by a plain reason and a recovery route; land pending" (session 2026-10-28) | Update the partner row after Q5. The sessions do not name the seventh partner's channel. The Harbor bullet reads as live, but the plain-reason rework copy is not live yet. Reword it to cite HUB-005 and HUB-008. The 90-second timeout (`example`) matches |
| `context/02-service-and-lifecycle.md` | STALE | "\| `rework` \| A document was returned: unreadable, mismatched or missing \| verification officer, field verifier \| customer resubmits \|" | "Only verification officers raise a rework item; a field verifier may mark an inspection item for rework and the officer confirms; support agents add notes only — LOCKED, owner ops lead" (session 2026-10-30) | Update "Who sets it" after the product lead confirms. First-pass 61% (`example`) and the rework median of 31 hours (`example`) match. The session adds the boundary: closed items only |
| `context/04-eligibility-and-verification.md` | STALE | "The retry limit is an ops policy value and is open (`D-006`)." | "Which rework reasons a field verifier may resolve on site — D-006, PENDING, owner ops lead; leaning: unreadable and missing on site, mismatched back to the customer" (session 2026-10-30) | The decision id is wrong. `D-006` is the on-site rework question, and `decisions/decision-log.md` agrees. The retry limit has no id; it sits in `tasks/todo.md` (owner: ops lead). The rework customer paths match the D-006 leaning. The 90-second timeout, retry message, PROVIDER-FAILED flag and BI-tool source for `VER-M2` match |
| `context/personas/role-verification-officer.md` | STALE | "Held to the 24-hour queue service level (`example`) (E1)." | "Verification queue service level is 12 hours, effective 2026-10-30; it was 24 hours" (session 2026-10-30, `operational — unverified`) | Update after the product lead confirms. Point to `service-levels.md` so the card does not restate a policy value. The Authority row matches the 2026-10-30 rework decision |
| `context/personas/role-insurer-partner.md` | STALE | "One of six insurers (`example`) whose shop, stock, liability or staff-health products Harbor Cover distributes (E1)." · "\| Channel \| API for 4 partners; email and a shared sheet for 2 \| E1, E2 \|" | "Harbor Cover has seven insurer partners; the seventh signed 2026-10-29 and requires a stock register for stock cover" (session 2026-10-29, `example`) | Update after Q5. The E1 sample "4 of 6 partners" (`example`) is dated Sep 2026 and stays |
| `context/personas/role-placement-specialist.md` | STALE | "When a case passes verification, the specialist wants the appetite notes for all six partners beside the case, so the first choice is the right one. (E1)" | "Harbor Cover has seven insurer partners; the seventh signed 2026-10-29" (session 2026-10-29, `example`) | Update after the product lead confirms. "every partner" removes the restated count |
| `context/09-current-commitments.md` | MINOR DRIFT | "\| C1 \| Verification outcome and rework — plain reason and recovery route on Harbor; rework item with the rule that fired on Desk; replacement capture on Field \| …" · "\| C4 \| Identity-check retry queue on provider timeout; customer told nothing is needed \| … \| in UAT \|" · "\| C5 \| Field replacement-document capture attached to the rework item \| … \| in build \|" | "The provider-failed path stays inside this feature — LOCKED, owner product lead" (session 2026-10-31) · "Harbor shows the retry message and Desk shows PROVIDER-FAILED" (session 2026-10-30) · "field-captured replacements 9 hours median from 61 items" (session 2026-10-29, `example`) | Add the provider-failed path to the C1 scope after the product lead confirms. The C1 status `committed (at discovery)` matches the 2026-11-01 phase. C4 and C5 read as not shipped. The sessions, HUB-009, DESK-006 and FLD-005 describe their behaviour as live. Check the tracker (Q4) before any edit |
| `context/08-strategy-and-outcomes.md` | MINOR DRIFT | "\| `VER-M2` \| `Verification` \| median hours from rework raised to resubmitted, per item \| 31 hours \| example \| 18 hours \| target \|" | "Rework cycle time, Sep cohort, closed items only (412 closed, 38 open), rework raised → resubmitted per item: median 31 hours, p90 74 hours" (session 2026-10-29, `example`, `DB-verified 2026-10-29`) | Same value; no edit. Under the 2026-10-29 decision, the BI tool stays authoritative and the pull is not quoted. If Q3 shows the BI tool also drops open items, record that in the dictionary's `traps` column for `VER-M2`. 18 hours stays a `target`. `VER-M1` 61% (`example`) matches |
| `context/metrics-dictionary.md` | MINOR DRIFT | "\| Whether `VER-M2` reports the long tail (P90) beside the median \| product lead (ops and platform) \| `VER-M2` \|" | "median 31 hours, p90 74 hours" (session 2026-10-29, `example`, `DB-verified 2026-10-29`) · "Saved query for `VER-M2` not yet created in the query API — create it and record the id in the metrics dictionary" (open thread) | The D-005 row matches the 2026-10-29 decision. Note that a discovery-only P90 reading now exists to decide on. Add the saved query under "Still open" |
| `context/policies/document-checklist.md` | MINOR DRIFT | "\| Pharmacy \| Stock register extract \| stock sum insured in band B or above \| example \|" | "Harbor Cover has seven insurer partners; the seventh signed 2026-10-29 and requires a stock register for stock cover" (session 2026-10-29, `example`) · "Seventh insurer partner needs a stock register for stock cover — add to the document checklist policy" (open thread) | The file lacks a recent requirement; it states nothing the session contradicts. The checklist is per product and shop type, and Harbor shows it before the insurer is chosen. The scope therefore matters (Q5). Add a `proposed` row after the placement specialist confirms and production configuration matches |
| `context/surfaces/harbor/current-behaviour.md` | MINOR DRIFT | "\| HUB-008 \| When a rework item is raised on a case, then the customer's status page lists each returned document with its reason code and one next step, and a WhatsApp message carries the same list \| …" | "The approved Harbor "document returned" copy shows a plain reason and a recovery route and keeps the quoted premium range visible; not yet landed" (session 2026-10-28) · "WhatsApp template for a returned document still says "rejected"" (open thread) | No edit now. The file records live behaviour, and the copy is not live. Append the row through `/land` when the copy and the WhatsApp template are both live. `/land` decides whether HUB-008 becomes SUPERSEDED. HUB-009 matches "Harbor shows the retry message" (session 2026-10-30) |
| `context/surfaces/desk/current-behaviour.md` | MINOR DRIFT | "\| DESK-002 \| When a case is in the queue, then the row shows stage, sub-status, tier, time since entry against the service level, and PROVIDER-FAILED where the identity check timed out \| …" | "Identity-check provider timeout is 90 seconds; Harbor shows the retry message and Desk shows PROVIDER-FAILED, but Desk has no retry count and Field shows nothing" (session 2026-10-30) | DESK-002 matches. Add the missing retry count under "Gaps the table makes visible". No row changes |
| `context/README.md` | CURRENT | — | — | No change |
| `context/07-glossary.md` | CURRENT | — | — | No change |
| `context/regulated-actions.md` | CURRENT | — | — | No change |
| `context/policies/README.md` | CURRENT | — | — | No change |
| `context/policies/eligibility-rules.md` | CURRENT | — | — | No change |
| `context/policies/data-handling-and-retention.md` | CURRENT | — | — | No change |
| `context/surfaces/field/current-behaviour.md` | CURRENT | — | — | No change |
| `context/design/tokens.md` | CURRENT | — | — | No change |
| `context/design/voice.md` | CURRENT | — | — | No change |
| `context/personas/README.md` | CURRENT | — | — | No change |
| `context/personas/customer-arjun.md` | CURRENT | — | — | No change |
| `context/personas/customer-meera.md` | CURRENT | — | — | No change |
| `context/personas/customer-priya.md` | CURRENT | — | — | No change |
| `context/personas/role-compliance-officer.md` | CURRENT | — | — | No change |
| `context/personas/role-field-verifier.md` | CURRENT | — | — | No change |
| `context/personas/role-referral-agent.md` | CURRENT | — | — | No change |
| `context/personas/role-support-agent.md` | CURRENT | — | — | No change |

## Staleness
| Document | Last verified | Days since | Status |
|---|---|---|---|
| `context/README.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/01-company.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/02-service-and-lifecycle.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/03-surfaces-and-systems.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/04-eligibility-and-verification.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/05-numbers-data-and-traps.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/06-teams-and-who-does-what.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/07-glossary.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/08-strategy-and-outcomes.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/09-current-commitments.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/metrics-dictionary.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/regulated-actions.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/policies/README.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/policies/eligibility-rules.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/policies/document-checklist.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/policies/risk-tiers-and-routing.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/policies/service-levels.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/policies/data-handling-and-retention.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/surfaces/harbor/current-behaviour.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/surfaces/desk/current-behaviour.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/surfaces/field/current-behaviour.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/design/tokens.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/design/voice.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/personas/README.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/personas/customer-arjun.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/personas/customer-meera.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/personas/customer-priya.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/personas/role-compliance-officer.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/personas/role-field-verifier.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/personas/role-insurer-partner.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/personas/role-placement-specialist.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/personas/role-referral-agent.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/personas/role-support-agent.md` | 2026-11-02 | 0 | OK — verified after run date |
| `context/personas/role-verification-officer.md` | 2026-11-02 | 0 | OK — verified after run date |

Treat the date on the 11 STALE files as unconfirmed until their facts are re-checked. All 34 files
say they were verified on 2026-11-02, after every W44 session. Even so, 11 still state facts that
the sessions of 2026-10-29 and 2026-10-30 contradict. The ladder reads OK only because of that date.
`context/README.md` notes that the ladder cannot detect a date set without a re-check.

## Memory files
Memory: no directory given

## Questions for the product lead (max 5)
1. Is the 12-hour verification service level (`operational — unverified`) already in production configuration, so `policies/service-levels.md` can carry it as live rather than `proposed`?
2. Under the 12-hour service level, does the verification clock still stop when rework is raised, as `policies/service-levels.md` states?
3. Does the BI tool's `VER-M2` reading (31 hours, `example`) exclude open rework items, as the 2026-10-29 pull did (412 closed, 38 open, `example`)?
4. Does the tracker still show C4 `in UAT` and C5 `in build`? HUB-009, DESK-006 and FLD-005 say these behaviours landed in 2026-09, and the sessions describe them as live.
5. Does the seventh insurer partner work through an API or by email and a shared sheet, and does its stock-register requirement apply to every stock-cover case or only to cases placed with it?

## Suggested edits (not applied)
- `context/policies/service-levels.md`: "| Verification | first outcome within 24 hours | verification officers | "within one working day" | `VER-G1` | example |" → "| Verification | first outcome within 12 hours (from 2026-10-30) | verification officers | [NEEDS CLARIFICATION: customer wording; the rework re-check row uses "we will check it the same day"] | `VER-G1` | operational — unverified |" — source: session 2026-10-30, label `operational — unverified`; mark the row `proposed` until Q1 confirms production
- `context/policies/risk-tiers-and-routing.md`: "A tier 3 case has the same 24-hour verification service level (`example`) as a tier 1 case; the ordering is what gets it worked first." → "A tier 3 case has the same verification service level as a tier 1 case (`service-levels.md`); the ordering is what gets it worked first." — source: session 2026-10-30, label `operational — unverified`
- `context/policies/risk-tiers-and-routing.md`: "| Inspection returns `rework` on an item | Rework item is raised; customer is told after the officer confirms | example |" → "| Inspection returns `rework` on an item | The verification officer confirms and raises the rework item; the customer is told on confirmation | example |" — source: session 2026-10-30, label none (LOCKED, owner ops lead)
- `context/05-numbers-data-and-traps.md`: "| Verification queue service level | 24 hours (`policies/service-levels.md`) | example |" → "| Verification queue service level | 12 hours from 2026-10-30; 24 hours before (`policies/service-levels.md`) | operational — unverified |" — source: session 2026-10-30, label `operational — unverified`
- `context/05-numbers-data-and-traps.md`: "| Insurer partners | 6 | example |" → "| Insurer partners | 7 (the seventh signed 2026-10-29) | example |" — source: session 2026-10-29, label `example`
- `context/01-company.md`: "| Insurer partners | 6 | example |" → "| Insurer partners | 7 (`05-numbers-data-and-traps.md`) | example |" — source: session 2026-10-29, label `example`
- `context/06-teams-and-who-does-what.md`: "| Insurer partners | 6 | Carry the risk; issue the policy; settle claims | example |" → "| Insurer partners | 7 | Carry the risk; issue the policy; settle claims | example |" — source: session 2026-10-29, label `example`
- `context/03-surfaces-and-systems.md` (after Q5): "| insurer partner APIs | Case submission, query threads, issuance, claim status | live for 4 of 6 partners (`example`) | The other 2 run on email and a shared sheet (`example`) |" → "| insurer partner APIs | Case submission, query threads, issuance, claim status | live for [NEEDS CLARIFICATION: 4 or 5] of 7 partners (`example`) | The other [NEEDS CLARIFICATION: 3 or 2] run on email and a shared sheet (`example`) |" — source: session 2026-10-29, label `example`
- `context/03-surfaces-and-systems.md`: "- A `declined` or `rework` outcome shows the reason in plain words and the recovery route." → "- A `declined` outcome shows the rule in plain words and the recovery route (HUB-005). A `rework` outcome lists each returned document with its reason code and one next step (HUB-008)." — source: session 2026-10-28, label none
- `context/02-service-and-lifecycle.md`: "| `rework` | A document was returned: unreadable, mismatched or missing | verification officer, field verifier | customer resubmits |" → "| `rework` | A document was returned: unreadable, mismatched or missing | verification officer (a field verifier marks an inspection item; the officer confirms) | customer resubmits |" — source: session 2026-10-30, label none (LOCKED, owner ops lead)
- `context/04-eligibility-and-verification.md`: "The retry limit is an ops policy value and is open (`D-006`)." → "The retry limit is an ops policy value and is open. It has no decision id yet (owner: ops lead)." — source: session 2026-10-30 (D-006 is the on-site rework question), label none
- `context/personas/role-verification-officer.md`: "Held to the 24-hour queue service level (`example`) (E1)." → "Held to the verification queue service level (`../policies/service-levels.md`) (E1)." — source: session 2026-10-30, label `operational — unverified`
- `context/personas/role-placement-specialist.md`: "the appetite notes for all six partners beside the case" → "the appetite notes for every partner beside the case" — source: session 2026-10-29, label `example`
- `context/personas/role-insurer-partner.md`: "One of six insurers (`example`)" → "One of the insurer partners (count in `../05-numbers-data-and-traps.md`)" — source: session 2026-10-29, label `example`
- `context/personas/role-insurer-partner.md` (after Q5): "| Channel | API for 4 partners; email and a shared sheet for 2 | E1, E2 |" → "| Channel | At E1 (Sep 2026): API for 4 partners, email and a shared sheet for 2. Seventh partner: [NEEDS CLARIFICATION] | E1, E2 |" — source: session 2026-10-29, label `example`
- `context/09-current-commitments.md`: "| C1 | Verification outcome and rework — plain reason and recovery route on Harbor; rework item with the rule that fired on Desk; replacement capture on Field |" → "| C1 | Verification outcome and rework — plain reason and recovery route on Harbor; rework item with the rule that fired on Desk; replacement capture on Field; the provider-failed path on all three |" — source: session 2026-10-31, label none (LOCKED, owner product lead)
- `context/policies/document-checklist.md` (new row under "Additions by shop type", `proposed`, after Q5): "| Any shop type with stock cover | Stock register extract | [NEEDS CLARIFICATION: every stock-cover case, or only cases placed with the seventh partner; band] | example |" — source: session 2026-10-29, label `example`
- `context/metrics-dictionary.md` (new row under "Still open"): "| A saved query for `VER-M2` in the query API, with its id in `where_to_get` | product lead (ops and platform) | `VER-M2` |" — source: session 2026-10-29, label none
- `context/surfaces/desk/current-behaviour.md` (new bullet under "Gaps the table makes visible"): "- DESK-002 shows PROVIDER-FAILED but no retry count." — source: session 2026-10-30, label none
- `context/surfaces/harbor/current-behaviour.md` (through `/land`, once the copy and the WhatsApp template are live): new row "| HUB-013 | When a document is returned on a case, then the screen shows a plain reason about the document and one recovery route in the customer's language, and the quoted premium range stays visible | `products/hub/document-returned-copy/shared/copy.md` | [NEEDS CLARIFICATION: month live] |" — source: session 2026-10-28, label none
