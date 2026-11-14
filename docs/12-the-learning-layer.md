---
title: 12 — The learning layer
type: doc
status: active
version: 1.0
supersedes: —
decision_refs: []
why: Settles where what the agent learns lives, how it gets there, and how it is kept true
last_updated: 2026-11-04
---

# 12 — The learning layer

Read this when you need to decide where something the agent learned belongs, how it gets
there, and how it stays true.

Shipwright keeps what it learns in plain markdown files in your repository. No database, no
account, no service. Claude Code and Codex read the same files, so both agents learn from
the same place.

```
inbox/                anything you drop in: notes, PRDs, transcripts, exports, urls.md
inbox/sessions/       chats captured at the end of each session (git-ignored)
   │  /learn          extracts typed facts with a source, finds contradictions and expiry,
   │                  proposes a diff, writes only what you approve
   ▼
knowledge/PROFILE.md  read at every session start: who you are, the product, how you work
knowledge/facts.md    the ledger: one row per fact, with type, source, date and status
knowledge/lessons.md  corrections, as rules
   ▲
   │  /land, /review post-ship   write what shipped and what happened
your work             every skill reads knowledge/ first and never asks for what it holds
```

## The three files

| File | Holds | Written by | Size |
|---|---|---|---|
| `knowledge/PROFILE.md` | The `_` settings the skills adapt to; **Static** — you, the product, users, surfaces, business model, constraints; **Dynamic** — what is in flight, recent decisions, open questions | `/setup` creates it; `/learn` regenerates Dynamic from `facts.md` | Under 80 lines, because it is injected every session |
| `knowledge/facts.md` | One row per fact (format below) | `/learn`, `/land`, `/review post-ship`, `/decide` | Grows; old rows are never deleted |
| `knowledge/lessons.md` | Every correction, as a rule and its reason | `/session end`, `/learn` | Three occurrences of one rule → promote it into the skill |

Longer reference material — a surface's current behaviour, a policy, the glossary, the
metrics dictionary — lives in `context/` as chapters. A fact row points to its chapter; the
chapter is the one source for its detail. `/learn` proposes a chapter when a topic outgrows
a few rows.

## The fact row

```
| F-0042 | metric | Weekly sign-ups were 1,240 (operational — unverified) | inbox/2026-11-03-funnel.csv | 2026-11-04 | current | #acquisition |
```

| Column | Rule |
|---|---|
| ID | `F-` and four digits, never reused |
| Type | `fact` · `decision` · `metric` · `target` · `behaviour` (what a surface does today) · `outcome` (what happened after a release) · `preference` (how you work) · `constraint` · `open-question` |
| Claim | One idea, in your words. A `metric` row carries one of the five source labels; a figure with no label is refused. A `target` row is never a `metric` row |
| Source | A repository path, a URL, `chat:YYYY-MM-DD`, or `you, YYYY-MM-DD`. A row with no source is refused |
| Recorded | The date the row was written |
| Status | `current` · `superseded by F-nnnn` · `expires YYYY-MM-DD` · `expired` · `open` (for open questions) |
| Tags | `#surface`, `#topic`, `#person-role` — what recall matches on |

## How learning stays true

1. **Nothing is written without a source and your approval.** `/learn` shows the diff first.
2. **Contradictions are surfaced, not overwritten.** A new row that disagrees with a current
   row is proposed with `supersedes F-nnnn`; on approval the old row becomes
   `superseded by F-nnnn`. Rows are never deleted, so the history stays readable.
3. **Facts expire.** A row with a horizon ("launch is next week", "the beta runs until
   March") carries `expires YYYY-MM-DD`. `/learn` and the weekly sync mark it `expired` and
   ask whether a newer fact replaces it.
4. **Production beats files.** A `behaviour` row comes from what shipped (`/land`), not from
   a plan. A plan is a `decision` or a `target`.
5. **The profile is a view, not a second source.** Dynamic is regenerated from current
   rows; editing it by hand is overwritten on the next `/learn`.

## The hooks

| Hook | When | Does |
|---|---|---|
| Session start | Every new or resumed session | Prints `PROFILE.md` (Static, Dynamic, settings), the handoff head, open decisions, and how many captured chats wait for `/learn` |
| Prompt recall | Every prompt of four words or more | Matches the prompt's words against current rows in `facts.md` and the rules in `lessons.md`; adds the best matches (at most eight rows) to the context. Plain text matching, no embeddings |
| Session end | When a session stops | Writes the session's conversation — your messages and the agent's replies, not tool output — to `inbox/sessions/YYYY-MM-DD-<id>.md`. Git ignores that folder; nothing leaves your machine |

Every hook fails silently: a broken hook never blocks a session.

## What it does not do

It does not embed, index or call a model in the background. `/learn` runs when you ask, on
the model you are already using. It does not decide for you: every write is a proposal
until you say yes.
