---
name: product-copy
description: Writes the words on a product surface — labels, helper text, buttons, errors, empty states, notifications and refusal-with-recovery messages — in the brand voice from context/design/voice.md, customer's language first. Outputs a source + target-language table (key, source, target, character counts, flag) with a native-review flag when the profile says the product lead cannot review the customer's language. The target-language wording comes from /localisation-copy; every refusal carries a next step; the customer is never framed as rejected by a partner or a provider. Use when someone says "write the copy", "microcopy", "what should the button say", "what should this say", "button label", "error message wording", "helper text", "empty state text", "notification text", "WhatsApp message text", "how do we tell the customer no", "resubmission message", "declined message", or "rejection message".
argument-hint: "<mockup or PRD path> [screen | whatsapp | voice]"
---

# Product copy — plain, dignified, a next step on every refusal

Write every string from its intent in the brand voice, with a next step on every refusal.
Read `context/design/voice.md` first.

## Read first (if present; else name the missing file and ask)

| File | Gives you |
|---|---|
| `knowledge/PROFILE.md`, `knowledge/facts.md` (if present) | `_language` (the source language), `_customer_language` (the pack), `_language_review`, `_struggles`, `_regulated` — read these first |
| `context/design/voice.md` (if present) | The four rules, the words we use and do not, the message shape, the Never list, the tone per audience |
| `references/voice.md` (this skill) | How the voice lands on each element type, with examples from `examples/harbor-cover/` |
| `context/07-glossary.md` (if present) | One term per concept; stage and sub-status names |
| `context/personas/<card>.md` (if present) | Who reads this, in what language, on which channel, with what literacy |
| `context/regulated-actions.md` (only when `_regulated: yes`, if present) | Consent, disclosure, cooling-off and complaint wording the compliance officer owns |
| The mockup or PRD | Where each string appears and its length limit |

## Questions first

One batched round; defaults in brackets.

1. **Surface and moment.** Where does the reader see this, and what just happened? [from the mockup]
2. **Reader.** Which persona, and will someone read it aloud to them? [the primary persona; assume read-aloud for guided flows]
3. **Length limits.** Characters per element, from the layout? [labels 24 · buttons 18 · helper text 90 · notification 160]
4. **Recovery routes.** For any refusal, which routes exist in the product today? [the routes the PRD names — for example: replace the document · an agent captures it on a visit · upload a different proof · talk to a person]
5. **Channel.** Screen, WhatsApp or voice script? [screen]

## Procedure

1. **List every string** on the surface: key, context, element type, limit. Keys follow
   `<surface>.<screen>.<element>` (example, `examples/harbor-cover/`:
   `hub.rework.item.unreadable`).
2. **Write the intent first**, not the sentence. Apply the message shape from
   `context/design/voice.md`. A customer message with no "what to do next" is not written.
3. **Write the source string** in the working language from the intent. Apply the four rules
   and check every word against the "Not" column in `context/design/voice.md`.
4. **Hand the source strings to `/localisation-copy`** when `_customer_language` is not
   `none`. Pass the key, the source string, the context and the limit. Never translate word
   for word yourself. Read each returned back-translation against the intent from step 2.
   Send back any string that drifted. The back-translation and romanisation stay in
   `/localisation-copy`'s output; this skill's table carries the target only.
5. **Refusal with recovery.** A decline, a returned item, an on-hold and a provider failure each end
   with a next step and where to take it. Offer only the routes from question 4. Apply the
   Never list from `context/design/voice.md`: the rules did not fit the information, and
   the information can change.
6. **Count characters** for source and target. Flag any string over its limit and propose a
   shorter string. Never propose a smaller font.
7. **Read-aloud test** for guided flows. If a question sounds like a form label, rewrite it
   as something a person would ask.
8. **Flag for review.** When `_language_review: no`, every target string carries
   `native review: needed — <role>`. The role is a native speaker on the support team, the
   designer or the content owner. When `yes`, the product lead reviews and marks `done`.
9. **Glossary check.** Stage names exactly as in `context/07-glossary.md`. Never show an internal risk
   tier or band to a customer. Give a reason code its plain-words reason.
10. **Regulated wording.** When `_regulated: yes`: consent text, disclosure screens, cancellation
    notices and complaint responses are regulated actions. Write the draft and flag the row
    `regulated — compliance officer approves`. Do not block the work on that approval.

## Gate

| Tier | Gate |
|---|---|
| S | Every string within limit or flagged · every refusal names a next step and a place · native review flagged where needed |
| M | S gate · native review `done` before the PRD reaches `approved` · the customer and writing lenses of `/review` run |

## Output

A table at `products/<code>/<feature>/shared/copy.md`, or appended to the design spec for a
Tier S change:

```
| key | context | source | target | source chars | target chars | limit | flag |
```

The `flag` vocabulary is defined once, in `/localisation-copy` § Output. This table uses the
same values, including `lexicon: proposed` and `source only`. Several flags on one row are
separated by `;`. The back-translation and romanisation of each target live in
`products/<code>/<feature>/shared/strings-<code>.csv`, written by `/localisation-copy`.

In chat: the table, the strings that broke their limit with the shorter form proposed, and
the refusal messages with their recovery routes called out.

## Do not

- **Never mark machine-written text in the customer's language as final.** It is a draft
  until a native reviewer marks it `done`.
- Do not write "rejected", "failed", "invalid", "not eligible" or "the partner said no".
- Do not show an internal risk tier, band or numeric score on a customer surface.
- Do not shrink the font to fit the customer's language. Shorten the string.
- Do not invent a recovery route. Offer only the routes that exist today.
- Do not name a staff member in customer copy. Use the role: "our team".
- Do not translate a source draft word for word. `/localisation-copy` writes the target from
  the intent.

## Hands off to

`/localisation-copy` for the target-language wording → `/mockup` to place the strings →
`/persona-panel` for questions to test → `/review` customer and writing lenses.
