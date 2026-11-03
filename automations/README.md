---
status: active
version: 1.0
supersedes: none
decision_refs: none
why: Keep the durable context true without a person re-reading every file every week
last_updated: 2026-11-02
---

# Weekly sync — three prompts, one runner, a schedule

Run `bash automations/run.sh miner` once a week and read the digest it writes. That is the
minimum. Everything else here explains why and how.

## Why this exists

Sessions write handoffs. Handoffs compress into weekly summaries. Compression is not
verification: a summary keeps what happened, it does not check whether `context/` still
tells the truth. Something must re-check facts against the durable context on a schedule,
or the next session trusts a file that a decision quietly made wrong. The sync does that.

## What runs

| Prompt | Reads | Writes | When |
|---|---|---|---|
| `compressor.md` | `sessions/daily/*.md` for the last 7 days (by filename date), `sessions/latest.md` | `sessions/weekly/YYYY-WNN-summary.md`; `sessions/monthly/YYYY-MM-summary.md` on the first run of a month | Sunday 19:00 |
| `miner.md` | the weekly summary, `tasks/lessons.md`, every `context/*.md`, `context/policies/*.md`, `context/surfaces/*/current-behaviour.md`, an optional memory directory | `sessions/weekly/YYYY-WNN-context-digest.md` | Sunday 20:00 |
| `interview.md` | the newest digest, the weekly summary, the memory directory | `sessions/weekly/YYYY-WNN-interview.md`; approved edits to `context/**` and memory files | Monday 10:00, by hand |

Each prompt is a plain markdown file with a small frontmatter (`name`, `writes`, `reads`,
`schedule_hint`). The body works pasted into any agent that can read and write files. Nothing
in them depends on an editor, a session API or a tracker.

The digest marks every context file `STALE`, `MINOR DRIFT` or `CURRENT`, carries a staleness
table from each file's `Last verified` line (0–20 days OK · 21–44 Review · 45+ Critical),
reports memory-file status when a memory directory is given, and asks at most 5 questions.
The three staleness labels map onto the ladder in `context/README.md`: `OK` is "current",
`Review` covers "review recommended" and "likely stale", `Critical` is "critical".
The interview asks the product lead at most 7 confirm-or-correct questions and shows a diff
before every edit.

## Run it by hand

```bash
bash automations/run.sh compressor
bash automations/run.sh miner
bash automations/run.sh miner --memory-dir ~/.claude/projects/<your-project>/memory
bash automations/run.sh interview            # interactive; opens a session and waits for you
bash automations/run.sh miner --dry-run      # print the command and the prompt head; no call
bash automations/run.sh miner --model sonnet # override the model for one run
bash automations/run.sh miner --as-of 2026-11-01   # re-run a missed Sunday: sets the week and the 7-day window
```

`run.sh` runs from the repo root, strips the prompt's frontmatter, prepends a run-context
block (today, ISO week, 7-day window, memory directory, mode), and calls the Claude Code CLI
in print mode with `--tools` and `--allowedTools` set to `Read,Grep,Glob,Write,Edit`,
`--permission-mode acceptEdits` so writes inside the repo do not prompt, and a `--max-turns`
cap per prompt. The interview runs the CLI interactively instead of in print mode, because
it asks questions. `--memory-dir` adds `--add-dir` so the agent may read that directory.

Every run writes `sessions/weekly/_runs/<name>-<date>.log` and, for print-mode runs, the
composed prompt next to it as `<name>-<date>.prompt.md`. Interactive runs log start and end
only; the interview writes its own record file.

## Schedule it

- `automations/schedule/crontab.example` — Sunday 19:00 compressor, Sunday 20:00 miner. The
  documented default. The Monday interview is interactive, so it is not scheduled; put a
  calendar reminder on Monday 10:00 and run it by hand.
- `automations/schedule/launchd.plist.example` — the macOS alternative for machines that
  sleep; one plist for the compressor, with a comment on duplicating it for the miner.

Both files carry install instructions in their comments. Scheduled runs need `claude` on the
`PATH` the scheduler uses and a logged-in CLI; check the first scheduled run's log.

Trust the workspace once before the first scheduled run: open `claude` interactively in the
repo and accept the trust dialog. Until then the CLI ignores the permission rules in the
project's `.claude/settings.json`. The project hooks still run, in print mode too (observed
on a fresh clone with Claude Code 2.1.316). The runner works either way, because it passes
its own `--tools`, `--allowedTools` and `--permission-mode`.

## What a good week looks like

1. Sunday 19:00 — summary written, under 100 lines, every number still carrying its label.
2. Sunday 20:00 — digest written; at least every `STALE` row quotes both lines.
3. Monday 10:00 — the product lead answers up to 7 questions; approved diffs land in
   `context/`; `Last verified` moves on the reviewed files.
4. Nothing else changes. If a week produces more than 5 questions, the problem is upstream:
   sessions are not landing their facts into `context/` as they go.

## Limits

- The compressor reads filenames for dates. A daily file named outside `YYYY-MM-DD-HHMM.md`
  is skipped.
- The staleness table depends on a `Last verified: YYYY-MM-DD` line in each context file. A
  file without one is marked `Review`.
- The miner judges memory-file age from a dated line inside the file, not from the file
  system.
