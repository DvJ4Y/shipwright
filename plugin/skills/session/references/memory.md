# Memory — one fact per file, with a Why and a How to apply

Keep memory and the repo apart. Memory holds how the reader works, standing corrections and
preferences, and how the tools behave. The repo holds the business and the work.

## Where the memory directory is

| Agent | Memory directory | Index |
|---|---|---|
| Claude Code | the project memory directory (`~/.claude/projects/<project>/memory/`) | `MEMORY.md` in it, loaded every session |
| Codex | a `memory/` folder the reader names in `_profile.md` | `MEMORY.md` in it, read at `/session start` |

The weekly miner automation (`bash automations/run.sh miner --memory-dir <path>`) reads the
same directory. The weekly knowledge interview updates it, one approved diff at a time.

## Memory or the repo?

| Belongs in memory | Belongs in the repo |
|---|---|
| How the reader works: options first, short answers, mornings for decisions | Facts about the business: stages, policies, numbers → `context/` |
| A standing correction about the reader's preferences | A correction about the work, as a rule → `tasks/lessons.md` |
| A preference `_profile.md` does not carry yet | Decisions → `decisions/decision-log.md`, a feature's `internal/decision-log.md` |
| How a tool behaves: the query API returns an empty table, not an error, on a wrong data source id | Work in flight → `products/`, `sessions/latest.md`, `tasks/todo.md` |
| A fact the reader stated that no file records yet (type `project`; see rule 6) | Anything a `context/` file already states |

Test: if a colleague forking this repo should inherit it, it is a lesson or a context fact,
not a memory. If only this reader's agent needs it, it is a memory.

## One fact per file

Copy `templates/memory-fact-template.md`. The filename is the `name` slug.

```yaml
name: options-first-then-stop
description: The product lead wants two or three options with trade-offs, then silence
type: user            # user | feedback | project | reference
```

| Type | Holds | Example |
|---|---|---|
| `user` | How the reader works | "Options first, short answers; chat before files" |
| `feedback` | A standing correction from the reader | "Never quote the October target (300, `target`) as a run-rate" |
| `project` | A fact about the company or the work that the repo does not record yet | "The customer lane reviews every rework message before it ships" |
| `reference` | How a tool or system behaves | "The tracker's list call hides cancelled issues unless asked" |

Body: the fact in two to four lines, present tense, every number labelled, roles not names.
Then two mandatory lines.

- **Why:** the decision, correction or evidence it comes from, with an absolute date —
  `D-nnn`, `P-nn`, a file, or "session 2026-10-24".
- **How to apply:** a rule, "When …, then …". What the agent does differently.

Example — `target-is-not-a-baseline.md`:

```
---
name: target-is-not-a-baseline
description: Copy the label with the number; a target is never quoted as a measured value
type: feedback
---
# A target is never quoted as a baseline

The October policies-issued figure (300) is a `target`, not a run-rate. The last measured
month is September (240, `example`).

**Why:** Correction from the product lead, session 2026-10-21. `tasks/lessons.md` holds the rule.

**How to apply:** When quoting a figure from a table that mixes measured values and targets,
then copy the row's label with the number or leave the number out.

Related: options-first-then-stop.md
```

## The index — `MEMORY.md`

One line per memory, loaded every session. Group the lines under `## User`, `## Feedback`,
`## Project`, `## Reference`.

```
## User
- [options first, then stop](options-first-then-stop.md) — two or three options with trade-offs; chat before files
## Feedback
- [target is not a baseline](target-is-not-a-baseline.md) — copy the label with the number
```

Keep the index under 60 lines. Past that, merge or delete facts; never start a second index.

## Rules

1. **One fact per file.** Split a file that states two facts.
2. **Update, do not duplicate.** Search the index before writing. A new finding about an
   existing fact edits that file and its `Why` date.
3. **Delete wrong memories.** Remove the file and its index line. No tombstone, no "formerly".
4. **Absolute dates.** Convert "last week", "yesterday" and "this quarter" to `YYYY-MM-DD`
   or `YYYY-MM` before writing. The miner judges a memory's age from that date.
5. **Link related memories.** End the body with `Related: <file>, <file>` when another fact
   changes how this one applies.
6. **Never store what the repo records.** If `context/`, `decisions/`, `tasks/lessons.md`
   or a PRD states it, point there in chat; do not copy it. Delete a `project` memory the
   day its fact lands in `context/`.
7. **Facts, not history.** Write what is true now. The backstory is the `Why` line.
8. **Follow the writing standard.** Roles, not names; capability names, not vendor names;
   every number labelled.
9. **Write memory at `/session end`** (step 5) and when the reader says "remember this".
   Confirm in one line what was written.
10. **Read memory at `/session start`** through the index. Open a fact file only when its
    line applies to today's focus.

## When a memory and a file disagree

The file wins for facts about the business and the work. The memory wins for how the reader
works. If a `project` or `reference` memory contradicts `context/`, flag it in chat and
delete or update the memory once the reader confirms.
