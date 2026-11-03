---
title: Regulated actions register
type: context
status: active
version: 1.0
supersedes: —
decision_refs: []
why: Names every action an outside rule governs and what the product must do for each, so compliance is designed in
last_updated: 2026-11-02
---

# Regulated actions register

> Last verified: 2026-11-02

**Owner:** compliance officer. A feature that touches a row below names the row in its PRD
and keeps the evidence stated. Rule sources are named generically; the compliance officer
holds the exact references.

Harbor Cover is the regulated distributor. The insurer partner is the regulated insurer.
This register covers the distributor's obligations only.

| Action | Rule source | What the product must do | Evidence kept | Surfaces |
|---|---|---|---|---|
| **Identity verification** | the insurance regulator's distribution rules; the anti-money-laundering rules | Verify the policyholder's identity before placement using the identity-check provider; never decline on a provider failure; allow manual verification with the method recorded; mask the identity number outside the verification screen | Provider response reference, result, time, officer role; manual method where used | Harbor (upload), Desk (verification), Field (replacement capture) |
| **Consent and disclosure** | the insurance regulator's distribution rules; the data-protection law | Obtain explicit consent before the identity check and before sharing data with an insurer; show the premium, cover, exclusions and Harbor Cover's commission basis before payment; use the customer's language | Consent text version, time, channel, language; disclosure screen version shown | Harbor, WhatsApp templates, Desk (consent status) |
| **Cooling-off and cancellation** | the insurance regulator's policyholder-protection rules | Tell the customer the cooling-off period (15 days, `example`) at `Policy issued`; accept a cancellation request on any channel inside it; confirm the refund path with the insurer | Request time and channel, confirmation sent, refund reference | Harbor, WhatsApp, Desk (placement) |
| **Claim acknowledgement** | the insurance regulator's conduct rules | Acknowledge every claim with a reference and the service level (48 hours, `example`) at the moment it is opened; show the claim's stage to the customer | Claim reference, opened time, acknowledgement time and channel | Harbor, Desk (claims) |
| **Complaint handling** | the insurance regulator's grievance rules | Log every complaint with a reference; send a first response within the service level (3 working days, `example`); offer the escalation route in the customer's language | Complaint reference, channel, first-response time, outcome | Desk (compliance view), WhatsApp, email |
| **Record retention** | the insurance regulator's record-keeping rules; the data-protection law | Keep case, document, verification and audit records for 7 years after the policy ends (`example`); delete on schedule; record the deletion | Retention schedule per record; deletion audit event | Desk (audit view), the SQL replica |

## How a feature uses this register

| Step | What to do |
|---|---|
| Discovery | Name the rows the idea touches. One line each; no gating unless the compliance officer asks |
| PRD | Section "Information, permissions and audit" names the evidence per row |
| Brief | Lists the evidence record as a required outcome, not a mechanism |
| QA | One `P0` row per evidence record the feature creates |
| Land | The `current-behaviour.md` row names the regulated action it serves |

## The worked feature

`products/desk/verification-outcome-and-rework/` touches identity verification (the
provider-failed case and manual verification), consent and disclosure (the rework message
names the rule that fired and asks nothing new without consent) and record retention (every
rework item and replacement capture is an audit event).

## What is not here

Insurer-side obligations (underwriting, policy wording, claim settlement) belong to the
partner. Tax and invoicing rules are the finance lead's and are not product obligations.
