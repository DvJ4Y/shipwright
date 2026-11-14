---
title: 01 — Company, customer and what we sell
type: context
status: active
version: 1.0
supersedes: —
decision_refs: []
why: Settles what Harbor Cover does, who buys it and how we talk about it
last_updated: 2026-11-02
---

# 01 — Company, customer and what we sell

> Last verified: 2026-11-02

## What Harbor Cover is

Harbor Cover distributes small-business insurance in India. A shop owner gets a quote
online, answers eligibility questions, uploads documents and pays. An ops team verifies
identity and documents, applies the eligibility rules, places the policy with the best-fit
insurer and runs the claims desk. Field verifiers visit shops for inspection photos. Local
referral agents bring customers in and track status.

| Fact | Value | Label |
|---|---|---|
| Products | shop (building and contents), stock, liability, staff health | example |
| Insurer partners | 6 | example |
| Revenue | commission from insurer partners on issued policies | example |
| Currency | ₹ | — |
| Shape of the business | ops-heavy, document-heavy, partner-dependent, regulated | — |

Harbor Cover is the distributor. The insurer partner carries the risk and issues the policy.
Harbor Cover owns the customer relationship, the verification and the claims desk.

## Customer segments — by shop type

Shop type drives three things: the documents we must collect, the eligibility tier the
engine assigns, and how much hand-holding the customer needs. Design for the hardest case
in each column; the others follow.

| Shop type | Typical sum insured | Document load | What it means for product |
|---|---|---|---|
| Grocery and general store | low band | light; shop licence often informal | First-policy customers; price is the first question; forms are unfamiliar |
| Electronics retail | mid to high band | medium; stock value proof matters | Multi-outlet owners; status without calls; some have a prior claim |
| Pharmacy | mid band | heavy; drug licence and stock register are mandatory | High document readiness; low tolerance for repeat asks |
| Apparel and footwear | low to mid band | light | Seasonal stock; sum-insured changes at renewal |
| Hardware and building materials | mid band | medium; open storage raises the tier | Field inspection is the norm |
| Food service | mid band | medium; fire-safety evidence | Elevated tier by default; often referred |

The first three rows rest on customer interviews (`CI`, `example`). The last three rest on
ops interviews only (`OI`, `example`); treat their "what it means" cells as assumptions until
a customer interview covers them. Shares by segment are not measured. Do not quote a split.

## Three personas

Full cards with evidence tables live in `personas/`. The one-line versions:

| Persona | Shop | What drives them |
|---|---|---|
| Meera | small grocery, first policy | Price-anxious. Uses WhatsApp daily. Financial forms are unfamiliar. |
| Arjun | electronics retail, three outlets | Time-poor. Has had a claim. Wants status without making a call. |
| Priya | pharmacy | Strict document needs. High readiness. Low tolerance for repeat asks. |

Two things hold across the interviewed customers (`CI`, `example`). Each already held some
cover (vehicle, personal health, a bank-linked policy), so insurance is not new to them; a
documented, multi-insurer shop policy is. And family or staff may handle the paperwork, so
the person on WhatsApp may not be the policyholder; who reads the messages is an open
question on the Meera card.

The customer's language is whichever the customer chooses at entry. For some, such as
Arjun on screen, it is English.

## How we position this

> **The process is complex. We make it simple.**

The home truth is that a shop policy with the right sum insured, from the right insurer, with
documents the insurer will accept, is hard to get alone. Harbor Cover's product carries that
complexity: multi-insurer comparison with the best-fit offer, a journey that is self-serve
where possible and assisted where needed, communication in the customer's language, and
transparency on premium, cover, exclusions and process.

**Never frame the customer as rejected by insurers.** A declined case is a case whose
current information does not fit the rules. Every decline carries a recovery path (`02`).

Support agents, verification officers, field visits and referral agents are means. They are
not the pitch. The direction is to let the product carry more of the journey where it can.

## To the other two audiences

| Audience | What Harbor Cover gives them |
|---|---|
| Insurer partners | Verified identity, complete documents, inspection photos, a case that fits their appetite |
| Referral agents | Commission on every issued policy, a simple way to add a referral, and status they can see |

## Vision wording

Geography and shop type are the only anchors in a vision statement. No turnover caps, no
owner-age filters, no "digitally savvy" qualifiers. Specifics belong in persona cards.
