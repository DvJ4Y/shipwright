---
title: "Persona: Priya — pharmacy, strict document needs"
type: persona-card
kind: customer
status: evidence-backed
version: 1.0
owner: product lead (customer)
supersedes: —
decision_refs: []
last_verified: 2026-11-02
last_updated: 2026-11-02
why: Grounds persona-panel critique of document-heavy, high-readiness customers in evidence
---

# Persona: Priya — pharmacy, strict document needs

> Last verified: 2026-11-02

> Used by the persona panel. Every claim cites an evidence row or is listed under "What we
> don't know". Panel output from this card is labelled SYNTHETIC.

## Evidence sources

| # | Source (README code) | Type | Date | Sample | Label |
|---|---|---|---|---|---|
| E1 | `CI` | interviews, pharmacy owners | Aug–Sep 2026 | 3 of 12 | example |
| E2 | `DB` | `h_rework_item` by shop type and reason code | Sep 2026 | September cases | example |
| E3 | `SR` | support calls from pharmacy customers | Sep 2026 | 6 of 40 recordings | example |
| E4 | `OI` | verification officers on pharmacy cases | Sep 2026 | 3 of 9 staff | example |

## Who

Runs a licensed pharmacy; keeps the drug licence, the stock register and the premises
documents current because inspectors ask for them (E1). Sum insured sits in the mid band;
stock cover matters because of expiry and temperature loss (E1). Has every document ready
before she starts and expects the checklist to match (E1, E2).

## Jobs

- When she starts, she wants the full checklist up front, so she uploads everything once.
  (E1, E2)
- When a document is returned, she wants the exact reason, so she can fix it in one go
  rather than guess. (E1, E2, E4)
- When the insurer has a question, she wants it asked once through one channel, so the
  pharmacy is not interrupted during trading hours. (E1, E3)
- When the policy is issued, she wants the document filed where she can find it for the next
  inspection. (E1)

## Fears and objections

- Being asked for the same document twice; she reads it as the company not reading what she
  sent. (E1, E3)
- A reviewer who does not know what a drug licence looks like will return it as
  `mismatched`. (E1, E4)
- A generic checklist that misses the pharmacy items and then surprises her later. (E1, E2)

## Channel and literacy

| Dimension | Reality | Evidence |
|---|---|---|
| Primary channel | Harbor on a phone behind the counter; WhatsApp for confirmations | E1 |
| Language | Comfortable in English and her own language; prefers her own for messages | E1 |
| Digital fluency | High; uses a pharmacy billing system daily | E1 |
| Document readiness | Very high; scans are already on her phone | E1, E2 |
| Tolerance for repeat asks | Low; one repeat and she calls support | E3 |
| Time of day | Before opening or after closing; never during trading hours | E1 |

## Quotes with provenance

> "Tell me everything you need before I begin. I have it all. Do not come back twice."
> — E1, Sep 2026, translated: yes

> "They returned the drug licence because the name had my initial. The initial is on every
> licence." — E1, Sep 2026, translated: yes

## What this means for product

The checklist is per product and shop type and is shown in full before the first upload
(`../policies/document-checklist.md`). A rework reason names the field that differs, not just
`mismatched`. Officers see a pharmacy document guide. Nothing is asked twice.

## What we don't know

- How she would react to a field verifier capturing a replacement on site — ask; it may
  read as intrusion rather than help.
- The share of pharmacy rework that is officer error versus document fault — needs
  `h_rework_item` with an officer review tag that does not exist yet.
