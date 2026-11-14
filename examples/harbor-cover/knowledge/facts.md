# Facts — Harbor Cover example

> The ledger: one row per fact, with type, source, date and status. Format and rules:
> `docs/12-the-learning-layer.md`. `/learn`, `/land`, `/review post-ship` and `/decide`
> write rows after approval; rows are never deleted. Source paths are relative to
> `examples/harbor-cover/`. Every figure is invented and labelled `example` or `target`.

| ID | Type | Claim | Source | Recorded | Status | Tags |
|---|---|---|---|---|---|---|
| F-0001 | fact | Harbor Cover distributes small-business insurance; the insurer partner carries the risk and issues the policy; Harbor Cover owns the customer, verification and the claims desk | context/01-company.md | 2026-11-02 | current | #company |
| F-0002 | fact | Revenue is commission from insurer partners on issued policies | context/01-company.md | 2026-11-02 | current | #company #business-model |
| F-0003 | metric | Insurer partners: 6 (example) | context/01-company.md | 2026-11-02 | current | #partners |
| F-0004 | decision | Stage and sub-status names come from production; files describe them and never rename them (D-001) | decisions/decision-log.md | 2026-11-02 | current | #lifecycle |
| F-0005 | constraint | Every `declined` outcome carries a recovery path; a decline without one is a defect | context/02-service-and-lifecycle.md | 2026-11-02 | current | #lifecycle #dignity |
| F-0006 | constraint | `refer` is not `declined`: a referred case is open, and a referred customer never sees a decline | context/04-eligibility-and-verification.md | 2026-11-02 | current | #rules #hub |
| F-0007 | decision | The BI tool is authoritative for funnel rates and impact, the SQL replica for counts, event analytics for behaviour (D-005) | decisions/decision-log.md | 2026-11-02 | current | #data |
| F-0008 | constraint | Three replica traps return a wrong answer without an error: bare-id `contacts`, empty `metadata` since August, engine re-runs in `h_verification` | context/05-numbers-data-and-traps.md | 2026-11-02 | current | #data #replica |
| F-0009 | metric | Verification first-pass rate, September cohort: 61% (example) | context/08-strategy-and-outcomes.md | 2026-11-02 | current | #desk #VER-M1 |
| F-0010 | metric | Rework cycle time, median: 31 hours (example) | context/05-numbers-data-and-traps.md | 2026-11-02 | current | #desk #VER-M2 |
| F-0011 | metric | Policies issued: Jul 180 · Aug 205 · Sep 240 (example) | context/08-strategy-and-outcomes.md | 2026-11-02 | current | #headline #POL-M1 |
| F-0012 | target | Policies issued in October: 300 (target, set by the founders) | context/08-strategy-and-outcomes.md | 2026-11-02 | current | #headline #POL-M1 |
| F-0013 | target | Rework cycle time, median: 18 hours (target) | context/08-strategy-and-outcomes.md | 2026-11-02 | current | #desk #VER-M2 |
| F-0014 | metric | Documents complete at first submission, September cohort: 54% (example) | context/08-strategy-and-outcomes.md | 2026-11-02 | current | #hub #DOC-M1 |
| F-0015 | behaviour | HUB-001: the quote page shows a premium range before any eligibility question | context/surfaces/harbor/current-behaviour.md | 2026-11-02 | current | #hub #quote |
| F-0016 | behaviour | DESK-001: the verification queue is ordered by risk tier (3 first), then oldest first within a tier | context/surfaces/desk/current-behaviour.md | 2026-11-02 | current | #desk #queue |
| F-0017 | behaviour | FLD-005: a field verifier captures a replacement document against an open rework item from the case screen | context/surfaces/field/current-behaviour.md | 2026-11-02 | current | #field #rework |
| F-0018 | behaviour | HUB-009: a provider-failed identity check tells the customer nothing is needed and never shows `declined` | context/surfaces/harbor/current-behaviour.md | 2026-11-02 | current | #hub #identity-check |
| F-0019 | constraint | Cooling-off is 15 days after `Policy issued` (example), set by the regulator | context/regulated-actions.md | 2026-11-02 | current | #compliance #cooling-off |
| F-0020 | decision | Identity check: two automatic retries 90 seconds apart, then the officer decides (D-007) | decisions/decision-log.md | 2026-11-02 | superseded by F-0021 | #desk #identity-check |
| F-0021 | decision | Identity check: three attempts in all; after the last fails the officer records a manual verification; a provider failure never raises a rework item (D-008, PENDING) (supersedes F-0020) | decisions/decision-log.md | 2026-11-04 | current | #desk #identity-check |
| F-0022 | fact | Verification outcome and rework PRD approved at v1.0 | products/desk/verification-outcome-and-rework/archive/superseded-2026-11-03/prd-v1.0.md | 2026-11-02 | superseded by F-0023 | #desk #C1 |
| F-0023 | fact | Verification outcome and rework PRD approved at v1.1 after the gate of 2026-11-04 (supersedes F-0022) | products/desk/verification-outcome-and-rework/shared/prd.md | 2026-11-04 | current | #desk #C1 |
| F-0024 | fact | C1: brief and issue pack approved; the pack is not published; engineering alignment not yet | products/desk/verification-outcome-and-rework/README.md | 2026-11-04 | current | #desk #C1 #delivery |
| F-0025 | fact | C4 automatic retry queue on provider timeout is in UAT | context/09-current-commitments.md | 2026-11-02 | expires 2026-11-30 | #desk #C4 #delivery |
| F-0026 | fact | C5 replacement capture from the inspection checklist is in build | context/09-current-commitments.md | 2026-11-02 | current | #field #C5 #delivery |
| F-0027 | fact | C8 renewal reminders are committed with no PRD; work starts at discovery | context/09-current-commitments.md | 2026-11-02 | current | #hub #C8 #renewal |
| F-0028 | decision | Rework item open 7 days → `on hold`; 30 days on hold → `lapsed` (example; D-004, PENDING) | decisions/decision-log.md | 2026-11-02 | current | #desk #rework |
| F-0029 | constraint | Verification queue service level: first outcome within 24 hours (example) | context/policies/service-levels.md | 2026-11-02 | current | #desk #service-level |
| F-0030 | constraint | Do not propose a new dashboard on Desk; extend the queue and the case view | context/03-surfaces-and-systems.md | 2026-11-02 | current | #desk |
| F-0031 | fact | Workstream codes: `hub` (Harbor) · `desk` · `field` · `rules` · `data` · `comms` | context/03-surfaces-and-systems.md | 2026-11-02 | current | #conventions |
| F-0032 | preference | Give two or three options with what each trades away, then stop | knowledge/PROFILE.md | 2026-11-02 | current | #product-lead |
| F-0033 | preference | Iterate in chat and short markdown; one artifact at the end; never write a file not asked for | knowledge/PROFILE.md | 2026-11-02 | current | #product-lead |
| F-0034 | open-question | Who reads the WhatsApp messages when family or staff handle the paperwork — it changes who the copy is for | context/personas/customer-meera.md | 2026-11-02 | open | #hub #comms #copy |
| F-0035 | open-question | Why customers leave after the premium range; "price shock" is a hypothesis until the BI tool has a view | context/02-service-and-lifecycle.md | 2026-11-02 | open | #hub #quote #QUO-M1 |
| F-0036 | fact | Gate review on PRD v1.1: verdict fix, applied before approval; 2 Critical and 14 Major findings | products/desk/verification-outcome-and-rework/internal/review-2026-11-04-gate.md | 2026-11-04 | current | #desk #C1 #review |
