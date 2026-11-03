---
title: Policy — eligibility rules
type: policy
status: active
version: 1.0
supersedes: —
decision_refs: []
why: States the rule tables the eligibility engine runs, so every document names the same bands, tiers and recovery paths
last_updated: 2026-11-02
---

# Policy — eligibility rules

> Last verified: 2026-11-02

**Owner:** ops lead proposes; product lead (ops and platform) locks.
**Rule source:** internal underwriting appetite agreed with the insurer partners.
**What the product must do:** show the customer a premium range before these rules run,
return one outcome per case, and show a recovery path on every `declined`.

All values are invented and carry `example`.

## Sum-insured bands

| Band | Range per product | Label |
|---|---|---|
| A | up to ₹5 lakh | example |
| B | above ₹5 lakh to ₹25 lakh | example |
| C | above ₹25 lakh to ₹1 crore | example |
| D | above ₹1 crore | example |

## Tier matrix — shop type × band

| Shop type | Band A | Band B | Band C | Band D | Label |
|---|---|---|---|---|---|
| Grocery and general store | 1 | 1 | 2 | refer | example |
| Electronics retail | 1 | 2 | 2 | refer | example |
| Pharmacy | 1 | 2 | 2 | refer | example |
| Apparel and footwear | 1 | 1 | 2 | refer | example |
| Hardware and building materials | 2 | 2 | 3 | refer | example |
| Food service | 2 | 3 | 3 | refer | example |
| Any shop type not listed | refer | refer | refer | declined | example |

## Hard rules — applied after the matrix

| Condition | Outcome | Recovery path shown to the customer | Label |
|---|---|---|---|
| Shop type not listed and band D | `declined` | Choose a listed shop type if the business fits one, or ask for a manual review | example |
| Three or more claims declared in the last 3 years | `refer` | None needed; "our team will take a look" with the service level | example |
| Open storage of stock declared (any shop type) | tier raised by one; tier 3 stays 3 | — | example |
| No fire-safety evidence declared, food service | `refer` | Upload a fire-safety certificate to continue without review | example |
| Stock sum insured above band C without a stock register declared | `declined` | Lower the stock sum insured to band C, or declare and later upload the stock register | example |
| Location outside the served regions | `declined` | Join the notify list; a referral to a partner is offered where one exists | example |

Rules run in the order listed. The first `declined` stops the run; `refer` continues so the
ops lead sees every reason.

## What the customer sees per outcome

| Outcome | Customer sees |
|---|---|
| tier 1, 2 or 3 | The premium range narrows; the document checklist appears. The tier number is never shown |
| `refer` | "We need a quick look from our team" and the refer service level |
| `declined` | The rule in plain words, the recovery path above, and where to do it |

## Configuration or code

The bands, the matrix, the hard rules and the recovery-path text are configuration. How
the engine evaluates them is engineering's.

## Where to check

| Question | Where |
|---|---|
| Which rule fired on a case | Desk, rule outcomes panel (DESK-003) |
| Current configured values | production configuration, via the ops lead |
| Outcome distribution | `h_verification`, re-run outcomes; the BI tool for rates |
