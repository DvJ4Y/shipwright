# Dynamic — the profile's view of the ledger

`knowledge/PROFILE.md` § Dynamic is generated. Rebuild it in full after every approved write
by `/learn` or `/setup`. Do not merge with what was there; overwrite the section.

## What goes where

Use only rows whose status is `current`, `open` or `expires` with a future date.

| Subsection | Rows | Order | At most |
|---|---|---|---|
| In flight | `decision` and `target` rows tagged with a surface or outcome in `_focus` | Newest recorded first | 6 |
| Recent decisions | `decision` rows not already listed in In flight | Newest recorded first | 5 |
| Open questions | `open-question` rows with status `open` | Oldest first | 5 |
| Latest outcomes | `outcome` rows | Newest recorded first | 3 |

## Line format

```
- <claim, shortened to one line> — F-nnnn
```

Keep each figure's label. Add `(expires YYYY-MM-DD)` when the row has a horizon.

If a subsection has no rows, write `- none`.

If more rows qualify than the limit, end the subsection with
`- +N more in knowledge/facts.md`.

## Size

The whole profile stays under 80 lines. If it would not, shorten claims first, then lower
the limits, In flight last.
