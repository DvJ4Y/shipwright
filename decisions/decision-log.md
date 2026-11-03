---
title: Workspace decision log
type: decision-log
status: active
owner: product lead (ops and platform)
why: One place for every decision point that is not inside a feature folder
last_updated: 2026-11-02
---

# Workspace decision log

> Append-only. Format and rules: `templates/decision-log-template.md`. Workspace IDs run
> `D-001`, `D-002`, … and are never reused; feature-level logs use `P-nn`. `/decide` writes
> here. Every value below is a Harbor Cover example.

| ID | Date | Status | Decision point | Decision / recommendation | Why (incl. rejected alternatives) | Door | Owner | Revisit if | Propagates to | Supersedes |
|---|---|---|---|---|---|---|---|---|---|---|
| D-001 | 2026-09-02 | LOCKED | Where do stage and sub-status names come from? | Production (`h_case.stage`, `h_case.sub_status`). Files describe them; no file renames them | Three planning files disagreed on names; only production is run. Rejected: a "canonical" planning file, because it drifts | two-way | product lead (ops and platform) | production renames a stage | `context/02-service-and-lifecycle.md`, `context/07-glossary.md`, every PRD | — |
| D-002 | 2026-09-08 | LOCKED | How is the Desk verification queue ordered? | Risk tier (3 first), then time since entering the queue | Service-level misses concentrated in tier 3 (`operational — unverified`, Aug). Rejected: oldest-first only, because tier 3 cases waited behind tier 1 volume | two-way | ops lead | `VER-G1` falls below 85% (`target`) for two weeks | `context/surfaces/desk/current-behaviour.md` DESK-001, `context/policies/risk-tiers-and-routing.md` | — |
| D-003 | 2026-09-10 | LOCKED | Does Harbor show a premium range before eligibility? | Yes. Shop type, sum insured and location give a range before any eligibility question | Customer interviews: "show me the price first" (`example`, CI). Rejected: range after eligibility, because the drop-off was at the first question | two-way | product lead (customer) | `QUO-M1` does not move by the next cohort | `context/surfaces/harbor/current-behaviour.md` HUB-001 | — |
| D-004 | 2026-10-14 | PENDING | How long may a rework item stay open before the case goes `on hold`? | 7 days, then `on hold`; 30 days on hold, then `lapsed` (recommendation) | Median resubmission is 31 hours (`example`); a 7-day window covers the long tail without holding the queue open. Rejected: 3 days, because field visits take up to 72 hours (`example`) | two-way | ops lead | `REW-G1` shows the window is too short or too long | `context/policies/service-levels.md`, Harbor and WhatsApp hold messages | — |
| D-005 | 2026-10-19 | LOCKED | Which source is authoritative for each kind of number? | The BI tool for funnel rates and impact; the SQL replica for counts; event analytics for behaviour. Replica rates are `operational — unverified` | Two dashboards gave different first-pass rates from different denominators. Rejected: the replica as authority, because it has no cohort view | two-way | product lead (ops and platform) | the BI tool loses a view the dictionary depends on | `context/05-numbers-data-and-traps.md`, `context/metrics-dictionary.md` | — |
| D-006 | 2026-11-02 | PENDING | Which rework reasons may a field verifier resolve on site? | `unreadable` and `missing` on site; `mismatched` goes back to the customer because the record, not the document, may be wrong (recommendation) | A verifier cannot judge a mismatch against the case record from the shop floor. Rejected: all reasons on site, because it moves an officer decision to the field | two-way | ops lead | verifiers report `mismatched` items they could have fixed on site | the worked feature PRD, `context/surfaces/field/current-behaviour.md` FLD-005 | — |
| D-007 | 2026-11-02 | SUPERSEDED | How many times does the identity check retry on a provider timeout before a rework item is raised? | Two automatic retries 90 seconds apart, then the officer decides (recommendation) | The provider timeout is 90 seconds (`example`); most timeouts clear on the first retry (`operational — unverified`). Rejected: unlimited retries, which hide an outage | two-way | ops lead | Provider error rates change | `context/04-eligibility-and-verification.md`; the worked feature's PRD | — |
| D-008 | 2026-11-04 | PENDING | How many times does the identity check retry on a provider timeout, and what happens after the last retry? | Three attempts in all, the first and two retries (`example`); an attempt with no answer within the provider's 90-second timeout (`example`) counts as failed, and the spacing of retries is engineering's; the verification clock pauses from the first failed attempt until the provider answers or manual verification starts, or stays stopped if a return already stopped it; after the last retry fails the verification officer records a manual verification; a provider failure never raises a rework item (recommendation) | PRD v1.1 R7 and R9: a provider failure is a flag, not a sub-status, and never declines or raises a rework item; D-007 named a rework item as the outcome after the retries. Rejected: an officer-triggered retry, because the retries are automatic | two-way | ops lead | Provider error rates change; the clock-resume point is set in the service levels policy | `context/04-eligibility-and-verification.md`; the worked feature's PRD R7, R9; `qa/desk/test-cases.csv` DESK-QUE-002, DESK-QUE-006 | D-007 |

**Status values:** `PENDING` (open or recommended, not confirmed) · `LOCKED` (owner
confirmed) · `SUPERSEDED` (replaced; see the row that names it).
