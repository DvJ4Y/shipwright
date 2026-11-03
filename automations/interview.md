---
name: interview
writes: sessions/weekly/YYYY-WNN-interview.md · edits to context/** and memory files, each only after the product lead approves its diff
reads: the newest sessions/weekly/*-context-digest.md · the week's sessions/weekly/*-summary.md · an optional memory directory
schedule_hint: weekly, Monday 10:00 local — interactive, started by hand
version: 1.0
last_updated: 2026-11-02
---

# Weekly knowledge interview

Run a ten-minute conversation with the product lead to confirm or correct what the miner
flagged, then apply only the edits the product lead approves. Work from files only. Do not use
any editor API, session-listing API or tracker.

## Run context

If a "Run context" block precedes these instructions, take Today, the ISO week and the memory
directory from it. If there is no block: Today is the current date; the digest to use is the
newest `sessions/weekly/*-context-digest.md`.

## Before asking

1. Read the newest `sessions/weekly/*-context-digest.md`. If none exists, say "no digest
   found; run the miner first" and stop.
2. Read the matching `sessions/weekly/*-summary.md`. Note which domains (below) it covers
   and how many sessions touched each.
3. If a memory directory is given, read `MEMORY.md` in it.
4. Prepare at most 7 questions in total across Part A and Part B. Overflow carries to next
   week.

## Part A — confirm or correct (3 to 4 items)

Take the `STALE` rows first, then `MINOR DRIFT`, then the digest's own questions. Present
each as one statement the product lead can answer in a word:

> From this week's sessions and the context files, confirm or correct:
> 1. "<statement as the sessions have it>" — Confirm / Correct: ___

Prefer items where the file is wrong and the right answer changes upcoming product work.

## Part B — domain scan (2 to 3 items)

Six domains. Ask only about a domain that fewer than two sessions touched this week.

| # | Domain | Question shape |
|---|---|---|
| 1 | Customer journey and the customer surface | Any change to a step, screen, copy or recovery path? |
| 2 | Internal operations | Any change to queues, service levels, roles, team size or process? |
| 3 | Rules, verification and regulated actions | Any rule, check, consent or retention change? |
| 4 | Data and metrics | Any metric definition, source or analytics change? |
| 5 | Partners and external parties | Any partner, provider or referral change? |
| 6 | Strategy and commitments | Any shift in priority, scope or commitment? |

## After the product lead answers

1. For each confirmed change, draft the exact edit: path, old line, new line. Show the diff.
   Apply only after the product lead says yes to that diff. Never batch unrelated diffs.
2. Set `Last verified: <Today>` on every context file the product lead reviewed, including
   files confirmed current. Show that diff too.
3. Memory. If a memory directory is given, draft a new or updated fact file for each
   significant confirmed fact. Show the diff first. Update `MEMORY.md` if files were added
   or removed.
4. Write `sessions/weekly/<ISO week>-interview.md` (under 60 lines): questions asked, answers,
   edits applied (path and line), edits declined, questions carried to next week.
5. If the product lead reports a change too large for this format, do not capture it here.
   Add one line to `tasks/todo.md` under the backlog heading: "Dedicated session: <topic>".
   Show the diff first.

## Rules

- At most 7 questions. One batched round when the questions are independent.
- If the product lead says "skip this week", write the interview file with every question
  marked carried, and stop.
- Never edit a file without showing its diff and receiving a yes.
- Roles, not person names. Capability names, not vendor names.
- Keep the conversation short. The product lead should finish in ten minutes.
