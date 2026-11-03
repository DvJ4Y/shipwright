---
title: 06 — The weekly sync
type: doc
status: active
version: 1.0
supersedes: —
decision_refs: []
why: Settles how the durable context stays true without a person re-reading every file every week
last_updated: 2026-11-02
---

# 06 — The weekly sync

Read this when you need to decide how the durable context stays true without a person
re-reading every file every week.

## Why compression is not verification

Sessions write handoffs. The compressor folds handoffs into a weekly summary. A summary
keeps what happened; it does not check whether `context/` still tells the truth. Something
must re-check facts on a schedule, or the next session trusts a file that a decision
quietly made wrong. Finding a stale fact only when a session happens to open that file is
not coverage. The miner is that re-check. The interview is where the product lead confirms
or corrects what it found.

## Three prompts, one runner

| Prompt | Reads | Writes | When |
|---|---|---|---|
| `automations/compressor.md` | `sessions/daily/*.md` for the last seven days, by filename date; `sessions/latest.md` | `sessions/weekly/YYYY-WNN-summary.md`; a monthly summary on the first run of a month | Sunday 19:00 |
| `automations/miner.md` | The weekly summary; `tasks/lessons.md`; every `*.md` under `context/`, including `policies/`, `surfaces/`, `personas/` and `design/`; an optional memory directory | `sessions/weekly/YYYY-WNN-context-digest.md` | Sunday 20:00 |
| `automations/interview.md` | The newest digest; the weekly summary; the memory directory | `sessions/weekly/YYYY-WNN-interview.md`; approved edits to `context/` and memory files | Monday 10:00, by hand |

Each prompt is plain markdown with a small frontmatter. The body works pasted into any
agent that can read and write files. Nothing in it depends on an editor, a session API or
a tracker. The miner reads all of `context/`, not a short list of globs, because facts
live in persona cards and design files too.

## The runner

```bash
bash automations/run.sh compressor
bash automations/run.sh miner
bash automations/run.sh miner --memory-dir <your memory directory>
bash automations/run.sh interview               # interactive; opens a session and waits for you
bash automations/run.sh miner --dry-run         # print the command and the prompt head; no call
bash automations/run.sh miner --model <name>    # override the model for one run
bash automations/run.sh miner --as-of YYYY-MM-DD   # re-run a missed Sunday
```

`automations/run.sh` runs from the repo root. It strips the prompt's frontmatter. It
prepends a run-context block: today, ISO week, window, memory directory, mode. It calls the
Claude Code CLI in print mode. The runner limits the tools to read, search, write and edit,
and accepts writes inside the repo without a prompt. The interview opens an interactive
session instead, because it asks questions and print mode cannot. The runner pins no model
by default; pinning one for cost is the product lead's call.

Every run logs to `sessions/weekly/_runs/`. Git ignores that folder because the logs carry
the machine's absolute path.

## Schedule

| Scheduler | File | Use it when |
|---|---|---|
| cron, the documented default | `automations/schedule/crontab.example` | The machine is awake on Sunday evening |
| launchd, the macOS alternative | `automations/schedule/launchd.plist.example` | A laptop that sleeps; launchd runs a missed job at the next wake |

Both files carry install instructions in their comments. The interview is not scheduled.
Put a calendar reminder on Monday and run it by hand.

Before the first scheduled run, open `claude` in the repo once and accept the trust dialog.
Until then the CLI ignores the permission rules in the project's `.claude/settings.json`.
The project hooks still run, in print mode too (observed on a fresh clone with Claude Code
2.1.316). The runner works either way, because it passes its own tool and permission flags.

## What the digest looks like

One table, one row per context file.

| Column | Holds |
|---|---|
| Document | The file |
| Status | `STALE` — a session contradicts a fact the file states · `MINOR DRIFT` — the same fact in different words, or a recent detail the file lacks · `CURRENT` |
| Doc says | The exact line from the file |
| Sessions indicate | The exact session line, with its date and source label |
| Recommendation | What to change, and which file owns the value. The miner never applies it |

Above the table: the inputs, the counts, and the two or three session facts that cause
most of the drift. Below it: a staleness table built from each file's `Last verified` line.

| Digest label | Ladder state in `context/README.md` |
|---|---|
| `OK` | current |
| `Review` | review recommended; likely stale |
| `Critical` | critical |

Then a memory-file section when a memory directory was given. The digest proposes at most
five questions. The example digest is `sessions/weekly/2026-W44-context-digest.md`.

## The interview

Interactive, about ten minutes. The interview asks at most seven confirm-or-correct
questions: the digest's questions plus any the product lead adds. The agent shows a diff
before every edit and applies only what the product lead approves. Approved edits land in
`context/`, and the file's `Last verified` date moves. The agent updates memory files one
approved diff at a time.

## What a good week looks like

1. Sunday evening: the compressor writes the summary, under the line limit, every number
   still carrying its label.
2. Later Sunday: the miner writes the digest; every `STALE` row quotes both lines.
3. Monday: the product lead answers the questions; approved diffs land; `Last verified`
   moves on the reviewed files.
4. Nothing else changes.

If a week produces more than five questions, the problem is upstream: sessions are not
landing their facts into `context/` as they go.

## Limits

- The compressor reads filenames for dates. It skips a daily file named outside
  `YYYY-MM-DD-HHMM.md`.
- The miner marks a context file without a `Last verified` line `Review`.
- The miner judges a memory file's age from a dated line inside the file, not from the file
  system.
- Scheduled runs need `claude` on the scheduler's `PATH` and a logged-in CLI. Check the
  first run's log.
