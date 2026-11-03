---
title: "Copy: document returned message (Harbor)"
type: copy
status: approved
version: 1.0
tier: S
owner: product lead
lane: customer
supersedes: —
decision_refs: []
why: The returned-document message named the rule, not the reason; customers called support to ask what to do
last_updated: 2026-10-28
---

# Copy: document returned message (Harbor)

Tier S change, one file. Strings in the working language; the customer-language pack is not
set (`_customer_language: none`), so every string is flagged for a native reviewer.

| key | context | source | source chars | limit | flag |
|---|---|---|---|---|---|
| `hub.rework.title` | status page, returned item | We need one document again | 26 | 40 | native review: needed |
| `hub.rework.reason.unreadable` | reason line | The photo of your identity proof is too blurred to read. | 56 | 90 | native review: needed |
| `hub.rework.reason.missing` | reason line | Your shop licence was not in the upload. | 40 | 90 | native review: needed |
| `hub.rework.reason.mismatched` | reason line | The name on the document differs from the one on your quote. | 61 | 90 | native review: needed |
| `hub.rework.action.upload` | primary button | Upload again | 12 | 20 | native review: needed |
| `hub.rework.action.visit` | secondary button | Book a shop visit | 17 | 20 | native review: needed |
| `hub.rework.next` | helper text | Nothing else is on hold. We check the new document within one working day. | 74 | 90 | native review: needed |

Every refusal carries a next step. No rule name, tier or band is shown to the customer
(`context/design/voice.md`). Landed as HUB-010 (`context/surfaces/harbor/current-behaviour.md`).
