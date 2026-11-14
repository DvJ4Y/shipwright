---
title: "Language pack {{code}} — lexicon"
type: language-pack
language: "{{code}}"
status: draft
version: 0.1
owner: "{{native reviewer role}}; the compliance officer for regulated terms"
supersedes: —
decision_refs: []
why: One approved wording per term, so every surface says the same thing the same way
last_updated: YYYY-MM-DD
---

# {{Language name}} — lexicon

> Last verified: YYYY-MM-DD

Glossary terms from `context/07-glossary.md` first, then the product's everyday words that
reach a customer, agent or partner. Fill every `{{...}}`. Add rows; never overwrite one. The
first row is a worked line in the working language: it records a decision about a loanword.
Replace it with the pack's own line.

| Term (source) | Approved wording | Romanisation | Banned wording | Note (why) |
|---|---|---|---|---|
| policy | The source word kept as a loanword, written in the pack's script | policy | The formal legal term for the contract | Customers say the source word in conversation; the formal term is understood only in writing (`example`, from `examples/harbor-cover/`) |
| {{price term}} | {{approved}} | {{romanisation}} | {{banned}} | {{why}} |
| your {{product}} | {{approved}} | {{romanisation}} | {{banned: "the product", "the plan"}} | {{why}} |
| {{amount term}} | {{approved}} | {{romanisation}} | {{banned}} | {{plain wording; an internal band is never shown}} |
| {{core service event}} | {{approved}} | {{romanisation}} | {{banned}} | {{why}} |
| returned (send again) | {{approved}} | {{romanisation}} | {{banned: rejected, failed, invalid}} | A document is fixable; see `context/design/voice.md` |
| not available for … right now (declined) | {{approved}} | {{romanisation}} | {{banned: ineligible, does not qualify}} | Describes the outcome, not the person |
| on hold | {{approved}} | {{romanisation}} | {{banned}} | {{what is waited for is always named}} |
| we could not complete the identity check (provider-failed) | {{approved}} | {{romanisation}} | {{banned: verification failed}} | The provider failed, not the customer |
| {{regulated term, e.g. cancellation window}} | {{approved}} | {{romanisation}} | {{banned}} | Only when `_regulated: yes`; compliance officer approves |
| identity proof | {{approved}} | {{romanisation}} | {{banned}} | {{the everyday word for the document}} |
| {{a domain document}} | {{approved}} | {{romanisation}} | {{banned}} | {{the word customers use}} |
| address proof | {{approved}} | {{romanisation}} | {{banned}} | {{...}} |
| our team | {{approved}} | {{romanisation}} | {{banned: a person name, a job title}} | A role, in plain words |
| {{visiting agent}} (a visit) | {{approved}} | {{romanisation}} | {{banned}} | {{...}} |
| {{referral partner}} | {{approved}} | {{romanisation}} | {{banned}} | {{...}} |
| partner | {{approved}} | {{romanisation}} | {{banned}} | Never framed as the party who refused |
| within one working day | {{approved}} | {{romanisation}} | {{banned: SLA, TAT, 24 hrs}} | A commitment, not a code |
| one-time code | {{approved}} | {{romanisation}} | {{banned}} | {{keep the abbreviation if customers say it}} |
| WhatsApp | {{kept as the product name}} | WhatsApp | — | Product names stay as the customer sees them |

## Proposed rows

Rows `/localisation-copy` proposed and the pack owner has not yet accepted. Move a row up
when accepted. Delete it when refused, with the reason in the note.

| Term (source) | Proposed wording | Romanisation | Seen banned | Proposed by | Note |
|---|---|---|---|---|---|
| {{term}} | {{wording}} | {{romanisation}} | {{banned}} | `/localisation-copy`, YYYY-MM-DD | {{why}} |
