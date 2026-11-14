---
title: Policy — document checklist
type: policy
status: active
version: 1.0
supersedes: —
decision_refs: []
why: States which documents each product and shop type needs, so Harbor, Desk and Field show the same list
last_updated: 2026-11-02
---

# Policy — document checklist

> Last verified: 2026-11-02

**Owner:** ops lead.
**Rule source:** insurer partner requirements, consolidated; identity proof is also a
regulated action (`../regulated-actions.md`).
**What the product must do:** show the full checklist for the product and shop type before
the first upload, accept one item at a time, and never ask for an item twice on one case.

All values are invented and carry `example`.

## Base checklist — shop policy

| Item | Why the insurer needs it | Accepted forms | Label |
|---|---|---|---|
| Identity proof | Names the policyholder; checked by the identity-check provider | Any government-issued photo identity document | example |
| Shop licence | Proves the business trades at the address | Trade licence, or the registration certificate where the licence is informal | example |
| Address proof | Ties the shop to the location quoted | Utility bill, rent agreement, or property tax receipt for the shop address | example |
| Stock photo set | Evidences the stock and storage for the stock sum insured | Four photos: front, interior, storage, and the stock register page or billing screen | example |

## Additions by shop type

| Shop type | Adds | Condition | Label |
|---|---|---|---|
| Pharmacy | Drug licence | always | example |
| Pharmacy | Stock register extract | stock sum insured in band B or above | example |
| Food service | Fire-safety certificate | always; also lifts a `refer` | example |
| Hardware and building materials | Storage photos including open storage | always | example |
| Electronics retail | Stock valuation (purchase invoices or register) | stock sum insured in band B or above | example |

## Additions by product

| Product | Adds | Label |
|---|---|---|
| Liability | Staff count declaration | example |
| Staff health | Staff list with ages; consent from each staff member | example |
| Renewal of any product | Previous policy document; claims history declaration | example |

## What "complete at first submission" means

A submission is complete when every item for the product and shop type has one received
file. Quality is not judged at submission; that is verification. `DOC-M1` counts complete
submissions by this definition.

## Rework reasons the checklist produces

| Reason code | Meaning | What the customer is told |
|---|---|---|
| `unreadable` | The file cannot be read or the key fields are not visible | Which item, and a capture tip for that item |
| `mismatched` | A field on the document differs from the case record | Which item, which field, what the record says |
| `missing` | An item on the checklist has no file | Which item, and why the insurer needs it |

## Configuration or code

The items, conditions, accepted forms and customer explanations are configuration. How
files are stored and checked for readability is engineering's.
