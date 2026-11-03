# Language packs

Build one pack per language from `_template/` with a native speaker. A pack is four files for
one language at `references/language-packs/<code>/`. `/localisation-copy` reads the pack named
by `_customer_language:` in `_profile.md`. The repo ships `_template/` only; it is
language-neutral.

## Start a pack

1. Pick the code. Use the language tag your team already uses. A two-letter code is enough.
   Add a region suffix (`xx-YY`) only when the variety changes the wording.
2. Copy the template: `cp -r .agents/skills/localisation-copy/references/language-packs/_template
   .agents/skills/localisation-copy/references/language-packs/<code>`.
3. Fill the `{{...}}` placeholders with a native speaker. Each file carries one worked line in
   the working language. Replace it with the pack's own line.
4. Set `_customer_language: <code>` in `_profile.md`. The next `/localisation-copy` run reads
   the pack.

## The four files

| File | Settles | Filled by |
|---|---|---|
| `register.md` | Person, address and sentence shape per surface: customer app, internal console, field app, messaging, voice script, training, regulatory documents | native speaker with the product lead |
| `lexicon.md` | One approved wording per term, its romanisation, the banned wording seen in production or support, and the reason | native speaker; the compliance officer for regulated terms |
| `patterns.md` | Bookish against spoken; the code-mixing rule and script for loanwords; text-expansion limits per element; numbers, currency and dates; the romanisation scheme | native speaker with the designer |
| `app-strings.md` | The batch contract (CSV in, CSV out) and the pack's rules for placeholders, plurals and line breaks | native speaker with the engineering lead |

## How the skill behaves

| Situation | Behaviour |
|---|---|
| `<code>/` exists with all four files | Reads them; writes from the intent; returns options with back-translation and romanisation |
| `<code>/` exists but a file is missing | Names the file and asks; does not guess its content |
| `_customer_language` is `none`, or `<code>/` does not exist | Says so first; writes in the working language; flags every string `no pack — written in the working language`; offers to start the pack |
| A term is not in the lexicon | Proposes a row in chat with the six columns of `lexicon.md` § Proposed rows; marks the string `lexicon: proposed`; never edits the pack |

The flag vocabulary is defined once, in `/localisation-copy` § Output.

## Keep a pack honest

- Every lexicon row has a note that says why. The pack owner deletes a row without a reason
  at the next review.
- Banned wording lists what was seen in production, support calls or a strings export. It
  does not list what someone imagined.
- Add rows; do not overwrite them. When an approved wording changes, add a new row and mark
  the old row `superseded by <row>`.
- Each file carries `> Last verified: YYYY-MM-DD`. Update it only after a native speaker
  re-reads the file.
- The reviewer is a role: a native speaker on the support team, the designer or the content
  owner. Never a person name.

## What a pack is not

- Not a glossary. Terms and their meanings live in `context/07-glossary.md`; the pack holds
  the wording in one language.
- Not a style guide for the working language. That is `context/design/voice.md`.
- Not a translation memory. Approved strings live with the feature at
  `products/<code>/<feature>/shared/copy.md` and `strings-<code>.csv`.
