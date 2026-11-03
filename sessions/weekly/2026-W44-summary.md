# Week 44 summary (2026-10-26 to 2026-11-01)

Source: 6 daily files, `sessions/daily/2026-10-27-1745.md` to `sessions/daily/2026-11-01-1100.md`.
Written by the compressor on 2026-11-01.

## Sessions this week
- 2026-10-27 1745 — Intake of "Verification outcome and rework" — verdict GO, tier M, ops and platform lane, three ops questions raised (tier M, phase intake)
- 2026-10-28 1830 — Copy fix on Harbor, "document returned" screen — "rejected" replaced by a plain reason and a recovery route; land pending (tier S, phase approved)
- 2026-10-29 1915 — Data pull, rework cycle time by reason — median 31 hours, unreadable the largest reason; seventh insurer partner noted (tier M, phase discovery)
- 2026-10-30 1700 — Meeting with the ops lead — service level cut to 12 hours; who raises rework settled; provider-failed gaps on Field and Desk named (tier M, phase discovery)
- 2026-10-31 1630 — Discovery for the feature — proposed verdict GO, MoSCoW, six states, three regulated actions; gate pending (tier M, phase discovery)
- 2026-11-01 1100 — Decision points framed PENDING and first compressor run — nothing locked; `/review` gate next (tier M, phase discovery)

## Decisions made
- "Verification outcome and rework" is one tier-M feature across Harbor, Desk and Field, ops and platform lane, owned at `products/desk/verification-outcome-and-rework/` — Desk raises the rework item — LOCKED, owner product lead (session 2026-10-27)
- Harbor "document returned" copy: plain reason about the document plus one recovery route, customer's language first, native-speaker review flagged — "rejected" framed the customer as at fault — LOCKED, owner product lead (session 2026-10-28)
- The `VER-M2` pull supports discovery only; per D-005 the BI tool stays authoritative for the outcome row and the pull is not quoted to stakeholders until reproduced — LOCKED, owner product lead (session 2026-10-29)
- Verification queue service level is 12 hours, down from 24 hours, effective 2026-10-30 — the September risk-tier reorder cleared the backlog — LOCKED, owner ops lead (session 2026-10-30)
- Only verification officers raise a rework item; a field verifier may mark an inspection item for rework and the officer confirms; support agents add notes only — LOCKED, owner ops lead (session 2026-10-30)
- Which rework reasons a field verifier may resolve on site — D-006, PENDING, owner ops lead; leaning: unreadable and missing on site, mismatched back to the customer (session 2026-10-30)
- The provider-failed path stays inside this feature — LOCKED, owner product lead (session 2026-10-31)
- Direction, rule-that-fired and recovery-path rules framed as three decision points — PENDING, owner product lead, after the `/review` gate (session 2026-11-01)

## Files created or changed
- `products/desk/verification-outcome-and-rework/shared/intake.md` — verdict, tier, lane, session map (session 2026-10-27)
- `products/hub/document-returned-copy/shared/copy.md` — EN and customer-language copy table, three reasons (session 2026-10-28)
- `products/desk/verification-outcome-and-rework/internal/data-rework-cycle-time.md` — statement, boundary, results, sanity checks (session 2026-10-29)
- `meetings/2026-10-30-ops-lead-verification-rework.md` — notes and routed outcomes (session 2026-10-30)
- `products/desk/verification-outcome-and-rework/shared/discovery.md` — business case, proposed verdict (session 2026-10-31)
- `products/desk/verification-outcome-and-rework/internal/persona-panel.md` — SYNTHETIC critique (session 2026-10-31)
- `tasks/todo.md` — ops questions closed; three decision points under "Decisions someone else owns" (sessions 2026-10-27, 2026-10-30, 2026-11-01)

## Open threads
- `/review` gate on the discovery doc, then the product lead confirms direction — owner product lead
- Does the verification clock still stop on rework at the 12-hour service level? `policies/service-levels.md` says it stops; confirm with the ops lead before the PRD cites it
- D-006: which rework reasons a field verifier may resolve on site — owner ops lead; shapes the Field scope
- Harbor "document returned" row not yet landed in `context/surfaces/harbor/current-behaviour.md` — land through `/land` once the copy is live and the WhatsApp template matches, owner product lead
- WhatsApp template for a returned document still says "rejected" — carry the three approved lines into the comms template, owner product lead
- Saved query for `VER-M2` not yet created in the query API — create it and record the id in the metrics dictionary, owner product lead
- Seventh insurer partner needs a stock register for stock cover — add to the document checklist policy; placement onboarding with the placement specialist
- Compliance officer's view on a returned-document reason as a disclosure — one line in the PRD if yes, owner product lead
- Field route availability within the same week in all three regions — confirm with the field verifiers' schedule owner
- Events for the recovery route chosen and for rework reasons — name in the PRD, do not design

## Key knowledge to preserve
- Verification queue service level is 12 hours, effective 2026-10-30; it was 24 hours (ops lead, `operational — unverified`; session 2026-10-30)
- Harbor Cover has seven insurer partners; the seventh signed 2026-10-29 and requires a stock register for stock cover (placement specialist, `example`; session 2026-10-29)
- Rework cycle time, Sep cohort, closed items only (412 closed, 38 open), rework raised → resubmitted per item: median 31 hours, p90 74 hours; unreadable 22 hours, mismatched 38 hours, missing 41 hours; field-captured replacements 9 hours median from 61 items (`example`, `DB-verified 2026-10-29`; session 2026-10-29)
- Unreadable is 54% of closed rework items (`example`; session 2026-10-29)
- Verification first-pass rate 61%, Sep cohort (`example`; session 2026-10-27)
- Identity-check provider timeout is 90 seconds; Harbor shows the retry message and Desk shows PROVIDER-FAILED, but Desk has no retry count and Field shows nothing (session 2026-10-30)
- Record retention is 7 years after policy end; three regulated actions touched by the feature (session 2026-10-31)
- Only verification officers raise a rework item; field verifiers mark inspection items and capture replacements on site (session 2026-10-30)
- The approved Harbor "document returned" copy shows a plain reason and a recovery route and keeps the quoted premium range visible; not yet landed (session 2026-10-28)

## Carried to next week
- Monday 10:00: knowledge interview, then the `/review` gate on the discovery doc; the product lead confirms direction before `/prd-writer` starts
- Land the 12-hour service level and the seventh insurer partner into `context/` after the interview confirms them
