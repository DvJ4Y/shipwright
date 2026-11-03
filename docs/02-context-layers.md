---
title: 02 — Context layers
type: doc
status: active
version: 1.0
supersedes: —
decision_refs: []
why: Settles where a fact, a decision, a preference or a piece of work in flight belongs
last_updated: 2026-11-02
---

# 02 — Context layers

Read this when you need to decide where a fact, a decision, a preference or a piece of
work in flight belongs.

Four layers. Each holds a different kind of thing. The agent or the product lead writes
each at a different moment.

| Layer | Holds | Written when | Where |
|---|---|---|---|
| Durable | What the product should do, and what is true about the business | When a fact changes, and at `/land` | `context/`, `decisions/`, `qa/` |
| Change | One feature from discovery to issue pack, with its reviews and decisions | During the loop | `products/<code>/<feature>/`; for tier L also `initiatives/<name>/` |
| Memory | How the reader works; standing corrections; how tools behave | At `/session end`, and on "remember this" | The agent's memory directory |
| Session | What happened, what is open, what is next | At every session end | `sessions/`, `tasks/` |

## Kind of thing → home

| Kind of thing | Home |
|---|---|
| A stage, sub-status or policy value | `context/02-service-and-lifecycle.md`, `context/policies/` — from production, never from a plan |
| A number | `context/metrics-dictionary.csv` for a metric; `context/05-numbers-data-and-traps.md` for everything else |
| A term | `context/07-glossary.md` |
| What a surface does today | `context/surfaces/<surface>/current-behaviour.md` |
| A regulated obligation | `context/regulated-actions.md` |
| A workspace decision | `decisions/decision-log.md` (`D-nnn`) |
| A decision inside one feature | `products/<code>/<feature>/internal/decision-log.md` (`P-nn`) |
| A requirement for a change | `products/<code>/<feature>/shared/prd.md` |
| The reasoning behind a change | `products/<code>/<feature>/internal/` |
| A test scenario | `qa/<surface>/test-cases.csv` |
| A correction about the work | `tasks/lessons.md`, as a rule |
| A correction about the reader's preferences | A memory file, type `feedback` |
| How a tool behaves | A memory file, type `reference` |
| An open item with no tracker issue | `tasks/todo.md` |
| What happened this session | `sessions/latest.md` |
| What shipped this cycle | `releases/<cycle>-release-note.md` |

The test for memory against repo: if a colleague forking the repo should inherit it, it is
a context fact or a lesson. If only this reader's agent needs it, it is a memory.

## The durable layer

### One source per fact

A fact lives in one file. Other files point to it. If two files state the same figure, the
owner file in the `context/README.md` table is right. The other file gets a pointer, not a
corrected copy.

### The current-behaviour layer

Each surface has one table: `ID | Behaviour | Source PRD | Landed on`. One row per
observable "When … then …" behaviour that is live. `/land` appends rows; nothing deletes
them. `/land` prefixes a replaced row with `SUPERSEDED by <new id>`. A PRD reads the table
before it specifies anything and cites row ids under "Current behaviour and reuse".

### The `Last verified` ladder

Every `.md` in `context/` carries `> Last verified: YYYY-MM-DD`. The session-start hook and
the weekly miner read it.

| Age (days) | State | The agent |
|---|---|---|
| under 21 | current | uses the fact as written |
| 21 to 30 | review recommended | uses it; the weekly digest lists the file |
| 30 to 45 | likely stale | flags the file when it reads it; proceeds |
| over 45 | critical | caveats every citation from the file, in chat and in documents |

Refresh a file by re-checking its facts against production, the BI tool or the owner, then
updating the date. Updating the date without re-checking defeats the ladder.

### Production beats files

Stage names, sub-statuses, workflows and policy values come from production. A file
describes them. A document that disagrees with production is wrong.

## The change layer

One folder per feature. `shared/` holds the PRD and the brief. It is self-contained: no
dates except inside a source label, no decision ids, no local paths, no phase check.
`internal/` holds discovery, the `P-nn` log, the data packet, the design spec, reviews,
readiness, the issue pack, the crosswalk and evidence. `docs/05-internal-vs-external.md`
has the rule.

A feature leaves the change layer through `/land`. Its requirements become
current-behaviour rows, and the folder moves to `products/<code>/archive/landed-YYYY-MM-DD/`.
Nothing in the change layer is a source of truth after that.

## The memory layer

Rules from `.agents/skills/session/references/memory.md`:

1. One fact per file. Split a file that states two.
2. Each file has a `Why` line (the decision, correction or evidence, with an absolute date)
   and a `How to apply` line ("When …, then …").
3. `MEMORY.md` is the index: one line per fact under `## User`, `## Feedback`, `## Project`,
   `## Reference`. Keep it under 60 lines; merge or delete past that.
4. Update, do not duplicate. Delete a wrong memory outright, with no tombstone.
5. Never store what the repo records. Delete a `project` memory the day its fact lands in
   `context/`.
6. When a memory and a file disagree, the file wins on the business and the work. The
   memory wins on how the reader works.

`_memory_dir` in `_profile.md` says where the facts live: `default` is the project memory
directory Claude Code keeps; a Codex user names a folder. The weekly miner reads either
with `--memory-dir`.

## The session layer

| File | Rule |
|---|---|
| `sessions/latest.md` | Rewritten, not appended, at every session end. Under 50 lines. Ends with the phase check and a next action |
| `sessions/daily/` | The previous handoff, copied before overwrite |
| `tasks/todo.md` | Open items with no issue. Anything with a tracker key belongs in the tracker |
| `tasks/lessons.md` | Every correction, as a rule. Three occurrences of one rule → promote it (`docs/10-keeping-it-current.md`) |

Nothing in `sessions/` is a source of truth for a fact. A session file records that a fact
was used or found stale. The weekly sync (`docs/06-weekly-sync.md`) reads the session layer
to find drift in the durable layer.

## Where the layers meet the tracker

The tracker holds execution state: which issue is where. The repo holds the reasoning. An
issue links to the repo document; it does not restate it (`docs/08-handoff-to-engineering.md`).
