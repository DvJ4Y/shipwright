---
title: "Verification outcome and rework story — script"
type: story-script
status: draft            # draft | approved | built
version: 0.1
owner: product lead (ops and platform)
format: auto-playing loop, about 75 seconds, landscape for review, vertical for the deck
storyboard: storyboard-v1.mockup.html
company: Harbor Cover
supersedes: —
decision_refs: [D-006]
why: Gives the ops lead, the engineering lead and the insurer-partner manager one case to agree on before the PRD is read
last_updated: 2026-11-02
---

# Verification outcome and rework story — script

**Ask:** approve or change the 12 beats below, and answer the three open points. Next comes
the hi-fi build (`story-v1.html`) and the video (`story-v1.mp4`).

**Framing.** Product vision, not shipped. Beats 1, 2, 4, 7, 9, 10 and 11 show live
behaviour (HUB-001, HUB-004, HUB-007, HUB-009, HUB-010, HUB-011, DESK-002, DESK-007,
FLD-004, FLD-005). Beats 3, 5, 6, 8 and 12 are not live: the rule that fired shown beside
the reason code (3), the customer asking for a visit from the status page and both states
on one screen (5), the rework reason and tip on the verifier's route (6), the replacement
re-checked without a search (8), and the end card (12). Any slide that uses this story must
say "vision".

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
| verification officer | Opens the case in Desk, returns the identity proof as `unreadable`, sees the identity-check provider fail, re-checks the replacement |
| field verifier | Captures the replacement identity proof at the shop against the open rework item |
| placement specialist | Chooses the insurer partner from the appetite notes and sends the payment link |
| insurer partner | Accepts the verified case and issues the policy |
| ops lead | Owns the verification queue and its 24-hour service level; does not appear on screen |
| compliance officer | Owns the evidence records the case writes; the audit view is named, not shown |

Case `CASE-0417`. Premium range ₹3,800–₹4,600 a year. Final premium ₹4,250 a year.
Identity-check provider timeout 90 seconds. Verification service level 24 hours.
Cooling-off 15 days. The clock on each screen is the demo clock; the case takes three days.

## Beats

| # | Time (s) | Screen | What happens | Caption |
|---|---|---|---|---|
| 1 | 0–6 | Harbor · quote | Day 1, 7:40 PM. Shop type, sum insured and location are filled in. The premium range appears before any question is asked. One button: see if the shop fits | The price comes before the questions. |
| 2 | 6–12 | Harbor · documents | 8:05 PM. The checklist for a shop policy: four items, each with the reason the insurer needs it. Her son uploads the identity proof; the thumbnail is dark. The item shows received | One paper at a time, each with the reason it is needed. |
| 3 | 12–19 | Desk · case view | Day 2, 9:15 AM. The officer opens CASE-0417. The identity proof preview shows no readable name or number. The officer picks the reason `unreadable`; the capture tip and the rule that fired fill in. Return document | The officer names the reason once, with the tip that fixes it. |
| 4 | 19–26 | Desk · verification queue | 9:19 AM. The identity check runs against the registry. The provider does not answer in 90 seconds; the retry times out too. The row shows PROVIDER-FAILED; the clock pauses; the case stays open | When the provider fails, the queue says so. The case is never declined for it. |
| 5 | 26–33 | Harbor · status page | 9:20 AM. Meera's status page: the identity proof is returned with the reason and a capture tip, and two routes — upload a new photo, or ask for a visit. A second line says the identity check will be retried and nothing is needed from her. The same message arrives on WhatsApp. She taps "Ask for a visit" | A plain reason and a route she can choose, in her language. |
| 6 | 33–38 | Field · route | Day 3, 10:50 AM. The verifier's day lists Meera's shop with one open rework item, the reason and the tip, before the visit starts | The visit knows what is open before the verifier arrives. |
| 7 | 38–45 | Field · replacement capture | 11:25 AM. The capture slot states what the officer needs to see. The photo is taken flat, in daylight. The network is weak: pending send, then replacement sent | The slot says what the officer needs to see. Captured once. |
| 8 | 45–52 | Desk · case view | 11:40 AM. The replacement is attached to the rework item and the case is back at its original queue position. The identity check answers in seconds: verified. Every item accepted; the rules re-run confirm the tier; outcome pass. The evidence record is written | The replacement lands on the item. The check passes. No search. |
| 9 | 52–57 | Desk · placement | 12:30 PM. The placement specialist sees each insurer partner's appetite for a grocery in this band. Partner A fits at ₹4,250. Submit; accepted; payment link sent | The verified record goes to the best-fit insurer. |
| 10 | 57–63 | Harbor · payment | 12:45 PM. Meera sees the insurer, the cover, the final premium and what it includes and leaves out, and that Harbor Cover's commission is paid by the insurer. She consents to share her verified details and pays ₹4,250 | She sees the insurer and the final premium, and pays where she already is. |
| 11 | 63–69 | Harbor · policy issued | 4:10 PM. Policy issued. The policy document is on the page, the cooling-off period is stated in plain words, and one tap reaches the team. The WhatsApp message carries the same | The policy is real, the cooling-off is stated, and she knows who to call. |
| 12 | 69–75 | End card | Who touched the case: Meera and her son, the verification officer, the field verifier, the placement specialist, the insurer partner, the ops lead's queue, the compliance officer's evidence records. The loop restarts | One paper. Fixed once. One visit. One policy. |

Each beat is one screen and one change. A caption states the outcome, not the feature. The
whole loop runs 75 seconds.

## Open for the owner

1. **Beat 5 — the visit route.** The status page offers "ask for a visit" beside "upload a
   new photo". Keep both routes, or show the visit only after a second unreadable upload?
   (`D-006` decides what a field verifier may resolve on site.)
2. **Beat 3 — the rule that fired.** The case view shows the rule beside the reason code.
   Show the same rule name to the customer on beat 5, or keep the customer side to the
   reason and the tip?
3. **Demo numbers.** Premium range ₹3,800–₹4,600, final premium ₹4,250, sum insured
   ₹4,00,000, three days end to end. Confirm, or set the numbers the deck already uses.
