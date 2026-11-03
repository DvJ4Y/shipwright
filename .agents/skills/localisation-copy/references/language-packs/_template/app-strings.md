---
title: "Language pack {{code}} — app strings"
type: language-pack
language: "{{code}}"
status: draft
version: 0.1
owner: "{{native reviewer role}} with the engineering lead"
supersedes: —
decision_refs: []
why: One batch contract, so a strings export goes out and comes back without a key lost
last_updated: YYYY-MM-DD
---

# {{Language name}} — app strings (batch mode)

> Last verified: YYYY-MM-DD

Batch mode localises a whole strings export in one pass. The contract below is the same for
every pack. The pack-specific rules at the end are yours to fill.

## Contract

| Direction | Columns | Rule |
|---|---|---|
| In | `key,source,context` | One row per key. `context` names the surface, the element type and the limit |
| Out | `key,source,context,target,back-translation,romanisation,flag` | Same keys, same order, one row each. `source` and `context` copied verbatim |

Files live with the feature: in at `products/<code>/<feature>/shared/strings-source.csv`,
out at `products/<code>/<feature>/shared/strings-{{code}}.csv`.

## Rules every pack shares

| Rule | Why |
|---|---|
| Keys verbatim; never renamed, reordered or dropped | The export round-trips into the build |
| Placeholders (`{name}`, `{amount}`, `{date}`) unchanged; their position may move | The sentence order of the pack language decides where a value sits |
| Line breaks written as `\n` | A raw line break splits the CSV row |
| One string per row; no two options in one cell | Options go in chat; the file carries the chosen string |
| A quote inside a string is doubled (`""`) | CSV quoting |
| Every row carries a flag; several flags are separated by `;` | A reviewer filters on it |

The flag vocabulary is defined once, in `/localisation-copy` § Output.

## Worked line

The template line, then one worked line. The worked line shows the no-pack case. The skill
produces that case until this pack is filled.

```csv
key,source,context,target,back-translation,romanisation,flag
{{key}},{{source string}},{{surface; element; limit}},{{target}},{{literal back-translation}},{{romanisation}},{{flag}}
hub.rework.item.unreadable,"Returned: we could not read the photo. Take it again in daylight, flat on a table.","Harbor; helper text; limit 90","Returned: we could not read the photo. Take it again in daylight, flat on a table.",—,—,"no pack — written in the working language; native review: needed — native speaker on the support team"
```

## Pack-specific rules

| Topic | Rule for {{language name}} |
|---|---|
| Plurals | {{how a count changes the noun or verb; what the product does with `{count}`}} |
| Gendered forms | {{what the product does when the reader's gender is unknown}} |
| Placeholder order | {{which placeholders move, and the shape they move into}} |
| Abbreviations | {{which abbreviations are read aloud as words}} |
| Truncation | {{what to cut first when a string must be shortened}} |
| Script and font | {{rendering notes for the device font: conjuncts, diacritics, line height}} |

## Review flow

1. `/localisation-copy batch <in.csv>` writes the out file with every row flagged.
2. The native reviewer reads the back-translation and romanisation columns first, then the
   target. The reviewer changes the flag to `native review: done — <role>, YYYY-MM-DD` row by row.
3. Rows still `needed` do not ship. The PRD stays below `approved` until every row is
   `native review: done`.
