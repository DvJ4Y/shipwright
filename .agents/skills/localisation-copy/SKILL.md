---
name: localisation-copy
description: Writes, transcreates and reviews copy in the customer's language for every surface — customer app, internal console, field app, messaging, voice script, training and regulatory documents — from a language pack picked by the profile. Picks the register for the surface, replaces bookish or machine-translated wording with spoken wording, enforces the pack's lexicon, and returns every option with a back-translation and a romanisation so a reviewer who cannot read the script can judge meaning. Batch mode takes an app-strings CSV in and returns one out. Use when someone says "translate", "translate this", "translate into the customer's language", "localise", "localisation", "transcreate", "in the customer's language", "review this translation", "is this translation okay", "sounds bookish", "make it colloquial", "make it sound spoken", "language pack", "app strings", "strings file", "review the strings export", "back-translation", or pastes text in another language or a strings export.
argument-hint: "[write | options | review | batch] [language code] <text or CSV path>"
---

# Localisation copy — written from the intent, judged from the back-translation

Write the target from the intent. Return it with a back-translation and a romanisation.

## Read first (if present; else name the missing file and ask)

| File | Gives you |
|---|---|
| `_profile.md` | `_customer_language` picks the pack; `_language` is the working language; `_language_review` decides the flag |
| `references/language-packs/README.md` | How a pack is built and what each file settles |
| `references/language-packs/<code>/register.md` | Register by surface: person, address, sentence shape |
| `references/language-packs/<code>/lexicon.md` | Term · approved wording · romanisation · banned wording · note |
| `references/language-packs/<code>/patterns.md` | Bookish against spoken, the code-mixing rule, expansion limits, numbers, romanisation scheme |
| `references/language-packs/<code>/app-strings.md` | The batch contract and the pack's string rules |
| `context/design/voice.md` | The four rules, the message shape and the Never list; they hold in every language |
| `context/07-glossary.md`, `context/personas/<card>.md` | The source terms; who reads this and how |
| The copy table or mockup from `/product-copy` | Key, source string, context, limit |

**Pack selection.** `_customer_language: <code>` in `_profile.md` names the folder
`references/language-packs/<code>/`. A language code in the request overrides it. If the
value is `none` or the folder does not exist, say so in the first line. Then write every
string in the working language, flag each one `no pack — written in the working language`,
and offer to start the pack from `references/language-packs/_template/`. Never invent pack
content.

## Questions first

One batched round; defaults in brackets.

1. **Surface and register.** Customer app, internal console, field app, messaging, voice script, training or regulatory document? [from the copy table]
2. **Language.** Which pack? [`_customer_language` in `_profile.md`]
3. **Mode.** Write one string, options, review pasted text, or batch a CSV? [options for new strings; review for pasted text; batch for a file]
4. **Options.** How many per string? [2]
5. **Reader.** Which persona, and will someone read it aloud? [the primary persona; read-aloud for guided flows]

## Registers by surface

| Surface | Register is for | Marks |
|---|---|---|
| Customer app | A business owner deciding, often on a phone, sometimes read aloud | Spoken, second person, one action per screen, numbers before explanations |
| Internal console | Staff working a queue | Neutral, dense, the rule name and the field |
| Field app | A verifier on site, one hand, sunlight; voice input in the verifier's language | Short imperatives, nouns the verifier says aloud |
| Messaging | One WhatsApp or SMS message a customer or referral agent reads once | Four parts, one action, say where a link goes |
| Voice script | A sentence a person or a voice assistant speaks | Spoken rhythm, numbers repeated once, no abbreviations |
| Training | Staff and referral agents learning a procedure | Plain, stepwise, the same term every time |
| Regulatory documents | Consent, disclosure, cooling-off and complaint text the compliance officer approves | Complete and exact; the pack's formal register; no softening |

The pack's `register.md` holds the language-specific traits of each row.

## Procedure

1. **Pick the pack and the register.** Read the four pack files. Name the register in the output.
2. **Take the intent, not the sentence.** What happened · what it means · what to do · where.
   Write the target from the intent. A word-for-word rendering of the source is a fault.
3. **Apply the lexicon.** Every term in `lexicon.md` uses its approved wording. A banned
   wording never appears. When the string needs a term the lexicon lacks, propose a row in
   chat with the six columns of `lexicon.md` § Proposed rows. Mark the string `lexicon: proposed`.
4. **Apply the patterns.** Spoken over correct-but-bookish. The code-mixing rule decides
   which source-language words stay and in which script. The expansion limit per element
   decides the length. Over the limit, shorten the string, never the font.
5. **Return options** (default 2). Each carries: target · back-translation (literal, into the
   working language) · romanisation (the pack's scheme) · one line on register and trade-off.
6. **Five tests on every string.** Read-aloud: would a person say it? · The back-translation
   matches the intent · The lexicon is clean · The string is within the expansion limit ·
   The string passes the Never list in `context/design/voice.md`, and a refusal carries its
   next step.
7. **Review mode.** For pasted text, mark each sentence `spoken` · `bookish` ·
   `machine-translated` · `wrong term`. Give the rewrite with back-translation and romanisation.
8. **Batch mode.** Input CSV `key,source,context` at
   `products/<code>/<feature>/shared/strings-source.csv`. Output CSV
   `key,source,context,target,back-translation,romanisation,flag`. Keys verbatim; one row per
   key; placeholders such as `{name}` and `{amount}` unchanged; order preserved.
9. **Flag.** `_language_review: no` → every string `native review: needed — <role>`. The role
   is a native speaker on the support team, the designer or the content owner.
   `_language_review: yes` → the product lead reviews and marks `native review: done — <role>, YYYY-MM-DD`.
10. **Regulated text.** Consent, disclosure, cooling-off and complaint strings carry
    `regulated — compliance officer approves`. Write them; do not block on them.

## Gate

| Tier | Gate |
|---|---|
| S | Every string has a target, a back-translation, a romanisation and a flag · lexicon clean · within limit or flagged |
| M | S gate · native review `done` before the PRD reaches `approved` · the batch file round-trips: every input key appears exactly once in the output |

## Output

```
| key | source | target | back-translation | romanisation | flag |
```

- Single strings and options: the table in chat. `/product-copy` copies the target into its
  own table; the back-translation and romanisation stay here and in the batch file.
- Batch: `products/<code>/<feature>/shared/strings-<code>.csv`.
- Proposed lexicon rows: in chat, for the pack owner. The skill never edits a pack.

**Flag vocabulary** — defined here once; `/product-copy` and the pack files point to it.
Several flags on one row are separated by `;`.

| Flag | Means |
|---|---|
| `native review: needed — <role>` | A native reviewer has not read the string |
| `native review: done — <role>, YYYY-MM-DD` | A native reviewer accepted the string |
| `over limit` | Longer than the element's expansion limit; a shorter form is proposed |
| `lexicon: proposed` | The string uses a term not yet in the pack; the row is proposed in chat |
| `regulated — compliance officer approves` | Consent, disclosure, cooling-off or complaint text |
| `no pack — written in the working language` | `_customer_language` is `none` or the pack folder is missing |
| `source only` | The string has no target by design (staff surface in the working language) |

## Do not

- **Never mark machine-written text as final.** It is a draft until a native reviewer marks it `done`.
- Do not translate word for word. Write from the intent.
- Do not return a target without its back-translation and romanisation.
- Do not invent a pack, a lexicon row or a register trait. Propose; the pack owner adds.
- Do not write any natural-language script into `_template/`. The shipped pack is language-neutral.
- Do not mix registers on one surface.
- Do not use a word from the voice "Not" column in any language.
- Do not reorder, rename or drop a key in batch mode.

## Hands off to

`/product-copy` to place the strings in its table → `/mockup` to check expansion in the
layout → `/persona-panel` for questions to test → `/review` customer and writing lenses.
