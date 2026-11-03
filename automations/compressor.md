---
name: compressor
writes: sessions/weekly/YYYY-WNN-summary.md · sessions/monthly/YYYY-MM-summary.md (first run of a month only)
reads: sessions/daily/*.md (last 7 days, by filename date) · sessions/latest.md
schedule_hint: weekly, Sunday 19:00 local, before the miner
version: 1.0
last_updated: 2026-11-02
---

# Weekly session compressor

Compress one week of session handoffs into one summary file. Work from files only. Do not use
any editor API, session-listing API or tracker. The daily files are the source of truth.

## Run context

If a "Run context" block precedes these instructions, take Today, the ISO week and the window
from it. If there is no block: Today is the newest date in a `sessions/daily/` filename; the
window is that day and the six days before it; the ISO week is the ISO-8601 week that holds
Today.

## Steps

1. Glob `sessions/daily/*.md`. Filenames are `YYYY-MM-DD-HHMM.md`. Keep the files whose date
   falls inside the window. If none match, write nothing and report "no sessions in window".
2. Read `sessions/latest.md` if it exists. It holds the open threads as of the last session.
3. Read every selected file in date order.
4. Write `sessions/weekly/YYYY-WNN-summary.md` in the weekly format below. Create the
   directory if it is missing. If the file exists, overwrite it.
5. Monthly rollup. Let M be the calendar month before Today's month. If
   `sessions/monthly/YYYY-MM-summary.md` for M does not exist, and at least one
   `sessions/weekly/*-summary.md` covers days in M, read those weekly summaries and write the
   monthly file in the monthly format below. Otherwise skip this step.
6. Do not edit `sessions/latest.md`, any daily file or anything outside `sessions/weekly/`
   and `sessions/monthly/`.

## Weekly format (under 100 lines)

```markdown
# Week NN summary (YYYY-MM-DD to YYYY-MM-DD)

Source: N daily files, `sessions/daily/<first>` to `sessions/daily/<last>`. Written by the
compressor on YYYY-MM-DD.

## Sessions this week
- YYYY-MM-DD HHMM — <focus> — <one-line outcome> (tier S|M|L, phase <phase>)

## Decisions made
- <decision> — <why> — LOCKED|PENDING, owner <role> (session YYYY-MM-DD)

## Files created or changed
- `<path>` — <what changed> (session YYYY-MM-DD)

## Open threads
- <thread> — <what is needed next>, owner <role>

## Key knowledge to preserve
- <fact, number with its source label, or changed status> (session YYYY-MM-DD)

## Carried to next week
- <next action from the newest session>
```

## Monthly format (under 60 lines)

```markdown
# Month YYYY-MM summary

Source: weekly summaries `YYYY-WNN` to `YYYY-WNN`. Written by the compressor on YYYY-MM-DD.

## Workstreams active
## Decisions and why
## Milestones reached
## Knowledge that should persist
## Still open at month end
```

## Rules

- Preserve every decision, every number with its source label, and every stated change to a
  team, policy, partner, process, service level or product status. The miner checks these
  against the durable context; if you drop one, drift goes unseen.
- Copy numbers exactly as written, with their label. Do not add, round or infer a number.
- Roles, not person names. Capability names, not vendor names.
- One line per item. Cite the session date on every line so each line traces to a daily file.
- Do not summarise product documents. Point to them by path.
- Under 100 lines for the weekly file. Under 60 for the monthly file.
