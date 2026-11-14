---
title: "Verification outcome and rework story — script"
type: story-script
status: draft            # draft | approved | built
version: 0.2
owner: product lead (ops and platform)
format: auto-playing loop, about 75 seconds, landscape for review, vertical for the deck
storyboard: storyboard-v2.mockup.html
company: Harbor Cover
supersedes: —
decision_refs: [D-006, D-007]
why: Gives the ops lead, the engineering lead and the insurer-partner manager one case to agree on before the PRD is read
last_updated: 2026-11-03
---

# Verification outcome and rework story — script

**Ask:** approve or change the 12 beats below, and confirm the demo numbers (the one open
point). Version 0.2 aligns the beats with PRD v1.0. The build is `story-v2.html` and the
video `story-v2.mp4`; the v1 files stay as the record.

**Framing.** Product vision, not shipped. The beats follow PRD v1.0 (`shared/prd.md`);
where a beat simplifies it, the PRD wins. Beats 1, 2, 6, 9, 10 and 11 show live behaviour
(HUB-001, HUB-004, HUB-007, HUB-010, HUB-011, DESK-007, FLD-001). Beats 4 and 7 add to
live screens. In beat 4 the queue order and the PROVIDER-FAILED flag are live (DESK-001,
DESK-002); the attempt count, the automatic retries and the stopped clock on the row are
not. In beat 7 the slot text, the capture against the item, pending send and replacement
sent are live (FLD-002, FLD-004, FLD-005); the open item listed with its reason and tip on
the case screen is not. Beats 3, 5, 8 and 12 are not live: the rule that fired shown beside
the reason code (3), the full returned item with the visit path and the identity-check line
on one screen (5), the replacement as a new version and the manual verification (8), and
the end card (12). Any slide that uses this story must say "vision".

**Look baseline.** The three surface palettes and type scales in `context/design/tokens.md`
(Harbor teal, Desk navy, Field green), the shared neutral scale, and the components the
current-behaviour files describe. Nothing is taken from another mockup or a vendor's brand.

**Language.** Harbor screens and every customer message are in the customer's language,
chosen at entry. The build shows them in English with a `[customer language]` tag so staff
can review the beats; the strings are written in the customer's language before the story
is shown outside the team. Desk and Field are in English.

## Demo case

One case, end to end. Fictional names; every number is a demo number (`example`).

| Who | Role in the story |
|---|---|
| Meera | The customer. Runs a small grocery and general store; first shop policy; sum insured ₹4,00,000; price is her first question. Her son handles the upload in the evening |
| verification officer | Opens the case in Desk, returns the identity proof as `unreadable`, sees the identity-check provider fail, re-checks the replacement and records a manual verification |
| field verifier | Captures the replacement identity proof at the shop against the open rework item |
| placement specialist | Chooses the insurer partner from the appetite notes and sends the payment link |
| insurer partner | Accepts the verified case and issues the policy |
| ops lead | Owns the verification queue and its 24-hour service level; does not appear on screen |
| compliance officer | Owns the evidence records the case writes; the audit view is named, not shown |

Case `CASE-0417`. Premium range ₹3,800–₹4,600 a year. Final premium ₹4,250 a year.
Identity-check provider timeout 90 seconds, two retries: three attempts. Verification
service level 24 hours. Send-by window 7 days. Cooling-off 15 days. The clock on each screen is the demo clock; the case takes three days.

## Beats

| # | Time (s) | Screen | What happens | Caption |
|---|---|---|---|---|
| 1 | 0–6 | Harbor · quote | Day 1, 7:40 PM. Shop type, sum insured and location are filled in. The premium range appears before any question is asked. One button: see if the shop fits | The price comes before the questions. |
| 2 | 6–12 | Harbor · documents | 8:05 PM. The checklist for a shop policy: four items, each with the reason the insurer needs it. Her son uploads the identity proof; the thumbnail is dark. The item shows received | One paper at a time, each with the reason it is needed. |
| 3 | 12–19 | Desk · case view | Day 2, 9:15 AM. The officer opens CASE-0417. The identity proof preview shows no readable name or number. The officer picks the reason `unreadable`; the capture tip and the rule that fired fill in. Return document | The officer names the reason once, with the tip that fixes it. |
| 4 | 19–26 | Desk · verification queue | 9:16 AM. The identity check runs against the registry. The first attempt and both retries time out, 90 seconds each. At 9:20 AM the row shows PROVIDER-FAILED with 3 of 3 attempts. The verification clock stopped at the return in beat 3 and stays stopped. The case stays in the queue | When the provider fails, the queue says so. The case is never declined for it. |
| 5 | 26–34 | Harbor · status page | 9:21 AM. Meera's status page. The identity proof is returned: the reason and what must be visible in plain words, the tip, the accepted alternatives, the send-by window, and two paths — upload a new photo or ask for a visit. The identity-check line says nothing is needed from her. "Talk to our team" is on the page. WhatsApp carries the same, one line per document plus the link. She taps "Ask for a visit" | A plain reason and a route she can choose, in her language. |
| 6 | 34–38 | Field · route | Day 3, 10:50 AM. The verifier's day lists Meera's shop with a count of one open item, before the visit starts. The reason and the tip are on the case screen | The visit knows what is open before the verifier arrives. |
| 7 | 38–45 | Field · case screen and capture | 11:25 AM. The case screen lists the open item: the identity proof, returned as unreadable, what the officer needs to see and the tip; capture allowed. The photo is taken flat, in daylight. The network is weak: pending send, then replacement sent | The case screen says what the officer needs to see. Captured once. |
| 8 | 45–52 | Desk · case view | 11:40 AM. The replacement attaches to the item as version 2, and the case is back at its original queue position. The officer re-checks: accepted. The identity check reached its retry limit on day 2, so the officer records a manual verification: method document inspection, result verified. The rules re-run confirm the tier; outcome pass. The evidence records are written | The replacement lands on the item. The case passes. No search. |
| 9 | 52–57 | Desk · placement | 12:30 PM. The placement specialist sees each insurer partner's appetite for a grocery in this band. Partner A fits at ₹4,250. Submit; accepted; payment link sent | The verified record goes to the best-fit insurer. |
| 10 | 57–63 | Harbor · payment | 12:45 PM. Meera sees the insurer, the cover, the final premium and what it includes and leaves out, and that Harbor Cover's commission is paid by the insurer. She consents to share her verified details and pays ₹4,250 | She sees the insurer and the final premium, and pays where she already is. |
| 11 | 63–69 | Harbor · policy issued | 4:10 PM. Policy issued. The policy document is on the page, the cooling-off period is stated in plain words, and one tap reaches the team. The WhatsApp message carries the same | The policy is real, the cooling-off is stated, and she knows who to call. |
| 12 | 69–75 | End card | Who touched the case: Meera and her son, the verification officer, the field verifier, the placement specialist, the insurer partner, the ops lead's queue, the compliance officer's evidence records. The loop restarts | One paper. Fixed once. One visit. One policy. |

Each beat is one screen and one change. A caption states the outcome, not the feature. The
whole loop runs 75 seconds.

## Open for the owner

1. **Beat 5 — the visit route.** Resolved: both routes stay. An `unreadable` item offers a
   new upload and a visit (PRD A5; `D-006`).
2. **Beat 3 — the rule that fired.** Resolved: the customer sees the reason and the
   requirement in plain words, never the rule name (PRD R2). The rule name stays on the
   Desk case view.
3. **Demo numbers.** Premium range ₹3,800–₹4,600, final premium ₹4,250, sum insured
   ₹4,00,000, three days end to end, three identity-check attempts of 90 seconds, a 7-day
   send-by window. Confirm, or set the numbers the deck already uses.
