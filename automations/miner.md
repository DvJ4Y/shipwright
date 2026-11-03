---
name: miner
writes: sessions/weekly/YYYY-WNN-context-digest.md
reads: sessions/weekly/YYYY-WNN-summary.md (fallback sessions/daily/*.md in the window) · tasks/lessons.md · every *.md under context/ (context/*.md, context/policies/*.md, context/surfaces/*/current-behaviour.md, context/personas/*.md, context/design/*.md) · an optional memory directory
schedule_hint: weekly, Sunday 20:00 local, after the compressor
version: 1.0
last_updated: 2026-11-02
---

# Weekly context miner

Find drift between the durable context and what this week's sessions say. Compression is not
verification: the compressor keeps what happened, this pass re-checks facts against the files
the next session will trust. Work from files only. Do not use any editor API, session-listing
API or tracker. Write one file and stop.

## Run context

If a "Run context" block precedes these instructions, take Today, the ISO week, the window and
the memory directory from it. If there is no block: Today is the newest date in a
`sessions/daily/` filename; the window is that day and the six days before it; no memory
directory is given.

## Steps

1. Read `sessions/weekly/<ISO week>-summary.md`. If it does not exist, read every
   `sessions/daily/*.md` whose filename date is inside the window instead. If neither exists,
   write a digest that says "no session input" and stop.
2. Read `tasks/lessons.md` if it exists. Note entries dated inside the window.
3. Glob `context/**/*.md` and read every file. This covers `context/*.md`,
   `context/policies/*.md`, `context/surfaces/*/current-behaviour.md`, `context/personas/*.md`
   and `context/design/*.md`. Read each file once, in full. If no file matches, write a digest
   that says "context/ is empty" and stop.
4. Compare. For each context file, list the facts the sessions state that the file also
   covers: counts, service levels, partner numbers, team sizes, stage names, product status,
   process steps, policy values, owners. Mark the file:
   - `STALE` — the file states a fact the sessions contradict: a different value, status or
     owner, or something the sessions report as added or retired.
   - `MINOR DRIFT` — the same fact with different wording or scope, or a recent detail the
     file lacks. No contradiction.
   - `CURRENT` — no contradiction found, or the sessions do not touch the file's facts.
5. Staleness table. Find each file's `Last verified: YYYY-MM-DD` line. Days since is
   Today minus that date. Bands: 0 to 20 days `OK` · 21 to 44 days `Review` (add "likely
   stale" from 30) · 45 days or more `Critical`. A file with no `Last verified` line is
   `Review` with the note "no Last verified line". If the date is after Today (a run with an
   earlier as-of date), write 0 days and the note "verified after run date".
6. Memory. If a memory directory is given, read `MEMORY.md` in it and every file it links.
   Mark each file `Current`, `Needs update` or `Archive candidate`, with one reason. Judge age
   from a `last_updated` or dated line inside the file; write "undated" if there is none. If
   no directory is given, write "Memory: no directory given".
7. Questions. At most 5, each answerable in one sentence, ordered by impact on upcoming
   product work. Ask only what the files cannot settle.
8. Write `sessions/weekly/<ISO week>-context-digest.md` in the format below. Do not edit any
   context, memory, session or task file. The digest is the only output.

## Digest format

```markdown
# Context digest — Week NN (YYYY-MM-DD)

Inputs: `<summary path>` or <N> daily files · `tasks/lessons.md` (<n> entries in window) ·
<N> context files · memory: <directory or none>.

## Findings by document
| Document | Status | Doc says | Sessions indicate | Recommendation |
|---|---|---|---|---|
| `context/<file>.md` | STALE | "<exact line>" | "<exact line>" (session YYYY-MM-DD) | Update after the product lead confirms |
| `context/<file>.md` | MINOR DRIFT | "<exact line>" | "<exact line>" (session YYYY-MM-DD) | Reword; no fact changes |
| `context/<file>.md` | CURRENT | — | — | No change |

## Staleness
| Document | Last verified | Days since | Status |
|---|---|---|---|

## Memory files
| File | Status | Reason |
|---|---|---|

## Questions for the product lead (max 5)
1. <question>

## Suggested edits (not applied)
- `<path>`: "<old line>" → "<new line>" — source: session YYYY-MM-DD, label <source label>
```

## Rules

- Flag genuine contradictions only. A wording difference is `MINOR DRIFT` at most.
- Quote the file's exact line and the session's exact line with its date. The interview
  shows these as a diff.
- Every context file gets one row. `CURRENT` rows stay on one line.
- Keep source labels as written in the sessions (`example`, `target`, `operational —
  unverified`, `DB-verified <date>`, `analytics`). Never upgrade a target to a baseline.
- You recommend; the product lead decides. Never write "fixed" or "updated".
- Roles, not person names. Capability names, not vendor names.
