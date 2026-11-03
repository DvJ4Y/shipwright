---
title: "Review: shared/prd.md v1.1 and shared/eng-brief.md v1.1 — gate"
type: review-report
mode: gate
artifact: products/desk/verification-outcome-and-rework/shared/prd.md (version 1.1) · shared/eng-brief.md (version 1.1)
lenses: [strategy, customer, engineering-readiness, data, writing, compliance]
verdict: fix
date: 2026-11-04
why: Records what the six reviewers found on v1.1, and how each finding was treated before approval
---

# Review: PRD and brief v1.1 — gate

**Verdict:** fix. Two Critical findings and fourteen Major. Each was a missing rule or a
contradiction with a clear fix; none called for a rethink. All Critical and Major findings
are applied in v1.1 before approval. The policy choices they needed are logged PENDING with
their defaults applied (P-28 to P-33, D-008).

> Reviewers report; they never edit. Six read-only lenses ran in two parallel groups on v1.1
> and its diff from v1.0; the compliance lens ran because `_profile.md` says
> `_regulated: yes`. Duplicates are merged; the higher grade stands.

## Critical

| # | Lenses | Finding | Treatment |
|---|---|---|---|
| 1 | customer, compliance | A missing template showed "the reason text alone": no paths, no window, no "talk to our team" | R3, A4, brief scenario 12: only the requirement line falls back; a reason code is enabled per language only with an approved template; weekly count to the product lead (customer). P-28 |
| 2 | engineering-readiness | Without the automatic retry queue, nothing said who retries or when manual verification opens | R9, brief scenario 8 and §10: the officer runs the two retries from the identity panel until the queue is live; manual verification after the third failure. P-31 |

## Major — all applied

| Area | Finding | Treatment |
|---|---|---|
| Visit | Missed visit had no trigger, channel or window rule | R5, R8, R14, A6: missed = expected day passed with no capture sent; WhatsApp and status page; rebook or upload; window resumes. P-29 |
| Visit | A second return read as overriding the region's switch | R5, A6, brief §10: the switch wins. P-30 |
| Visit | A5 (Must) offered a visit fulfilled only by A6 (Should) | A5: the visit path shows where A6 has shipped and the switch is on |
| Clock | R7's resume point disagreed with the service-levels policy | R7: pause from the first failed attempt until the provider answers or manual verification starts, as the policy states |
| Provider | "90 seconds" (`example`) meant timeout in R9 and spacing in D-008 | R9 and D-008: 90 seconds (`example`) is the provider's timeout; spacing is engineering's |
| Provider | A provider-failed case could go on hold and leave the identity check unfinished | R9, R11, A9, A10: the case stays in the provider-failed filter on hold; the officer completes the check. P-31 |
| Correction | No rule on consent for the identity re-run, or on the channel of an officer-entered correction | R6: the case consent covers the re-run, cited in the evidence; the request channel is recorded. P-33 |
| Lapse | Open items never closed on a lapsed case | R11, A16: items close as `lapsed` and count as not resubmitted; re-entry is a new case. P-32 |
| Concurrency | Capture after `accepted` had no rule | R10, brief scenario 11: kept as a new version, not re-checked, customer not asked again. P-32 |
| Brief | Three answers in §10 were not in the PRD, one contradicted R9 | Moved into R9 and R10; the return-panel answer corrected |
| Brief | Opening did not state the ask | §1 opens with the ask to the engineering lead |
| Issue pack | Drifted from v1.1 in four places; still approved v1.0 | Issue pack v1.1: S2 and S4 summaries, R11 traced to S2, mockups v2, decision refs; v1.0 archived |
| Readiness | Approved v1.0, not v1.1 | Re-check section added to `internal/readiness.md` |

## Minor and Outdated — treatment

| Finding | Treatment |
|---|---|
| Consent status removed from Desk, which the register lists | §8: the full record stays with the compliance officer; status shows to officers and the ops lead. P-33 |
| Internal codes and month names in shared documents | Removed from both documents |
| Front matter `decision_refs` empty | Filled on both documents |
| §12 missed the new officer and field load | "Other teams" row extended |
| Brief column names not in `context/05` | Open: listed for the alignment conversation; engineering confirms the locations |
| Retention reset on an unissued case by a late file or a visit request | Open for the compliance officer |
| `context/04` and `context/08` still carry v1.0 wording (case "stays `open`"; `VER-M2` per item) | Propagate at landing |
| Glossary: "resubmission", "file", "provider failure" | Open: a glossary pass, not a requirement change |

## Understanding check

The engineering-readiness lens restated the feature in three sentences: a returned document
carries its reason, the field that differs and the requirement in plain words; the customer
gets one list with a recovery path per document on Harbor and WhatsApp, the field verifier
captures on site, and every resubmission returns to the officer's queue at its original
position for a timed re-check; a provider failure only flags the row, pauses the clock and
ends in a recorded manual verification, never a decline. Its three questions for the
engineering lead are now answered in R9, R11 and R10.

Gate: approve · By: product lead (ops and platform) — default applied, PENDING P-10 · On: 2026-11-04 · Reason: every Critical and Major finding applied in v1.1; open items have owners
