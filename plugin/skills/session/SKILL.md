---
name: session
description: Runs the session loop and context hygiene. Modes — start (read the handoff, todo, lessons and the memory index; propose today's focus), checkpoint (save state and compact near 60% context), end (rewrite the handoff; update todo, lessons and memory; list shipped PRDs not yet landed; archive), retro (feature closeout checklist and lessons). User-invoked only.
disable-model-invocation: true
argument-hint: "start | checkpoint | end | retro [feature path]"
---

# Session — the loop that makes the next session start where this one ended

Four modes. Default to `start` when no mode is given.

## Read first (if present; else name the missing file and ask)

| File | Gives you |
|---|---|
| `sessions/latest.md` | Last focus, decisions, open threads, next action |
| `tasks/todo.md`, `tasks/lessons.md` | Open items with no issue; every correction as a rule |
| `_profile.md` | How the product lead works; `_struggles`; My words → our terms |
| `MEMORY.md` in the memory directory | One line per standing fact about the reader and the tools (`references/memory.md`) |
| `.agents/skills/product-loop/references/conventions.md` | Folders, statuses, commit proposals |
| The feature folder named in `retro` | Artifacts whose status the closeout checks |

If `sessions/`, `tasks/` or `_profile.md` is missing, name it once and suggest copying
`_starter-files/` to the workspace root.

## Questions first

One question only, by mode.

- **start:** today's focus. [the handoff's "next action"]
- **checkpoint, end:** none. Write, then say it is written.
- **retro:** which feature folder. [the feature in `sessions/latest.md`]

## Procedure

**Hygiene — always**

- One topic per session. Unrelated work → `/clear` first, or a new session.
- A fresh session per phase for tier M and L work (discovery, PRD, mockup, brief).
- Delegate wide reads. Reading more than 5 files to answer one question → use a read-only
  explore sub-agent and keep only its conclusion.
- Checkpoint near 60% context. Run `/session checkpoint`, then `/compact <focus>`.
- After a compact, re-read the active artifact and its frontmatter before editing.

**start**

1. Read the files above.
2. Summarise in at most 8 lines: last focus · open threads · blocking todo items · PENDING
   decision points · the newest 3 lessons · memory facts that apply to today's focus.
3. Flag staleness. If the handoff is older than 7 days or contradicts a newer file, say so.
   If a context file is past its `Last verified` ladder (`context/README.md`), say so when
   you read it.
4. Ask the one question: today's focus.
5. New work → hand to `/product-loop`.

**checkpoint**

1. Write the current state to `sessions/latest.md` (format below), marked `checkpoint`.
2. List: active artifact path, tier, phase, open decision points, files modified.
3. Give the exact compact command:
   `/compact Preserve: <artifact path>, tier <T>, phase <P>, open <P-ids>, files <list>`.

**end**

1. **Handoff.** Rewrite `sessions/latest.md`, under 50 lines:

   ```
   # Session handoff — YYYY-MM-DD
   **Focus:** <one line>
   **Tier / phase:** <T> / <phase> · Phase check: Discovery <…> · PRD <…> · Engineering alignment <…>
   ## Decisions (with decision-point IDs)
   ## Files created or changed
   ## Open threads (owner role, next step)
   ## Next action
   ```

2. **Archive.** Copy the previous handoff to `sessions/daily/YYYY-MM-DD-HHMM.md` before
   overwriting, unless you archived it already.
3. **Todo.** Update `tasks/todo.md`: close done items, add new ones with no issue yet.
   Anything with an issue key belongs in the tracker, not here.
4. **Lessons.** For every correction this session, append to `tasks/lessons.md`:

   ```
   ## YYYY-MM-DD — <topic>
   **Mistake:** <one line>
   **Rule:** <what to do instead, phrased to prevent recurrence>
   ```

   Count matching rules. Three occurrences of the same rule → propose a skill edit (show
   the diff; apply only with approval).
5. **Memory.** Write or update one fact file and its index line for each correction or
   preference about how this reader works (`references/memory.md`). Corrections about the
   work stay in `tasks/lessons.md`. Delete any memory the session proved wrong.
6. **Shipped, not landed.** List every `products/**/shared/prd.md` with `status: shipped`.
   For each, suggest `/land` with the path. If there are none, say so in one line.
7. **Gate failures.** A send-back at any gate is also a lesson.
8. **Commit.** If artifacts changed, propose a commit
   (`.agents/skills/product-loop/references/conventions.md`, Versioning).

Do not ask permission to write the handoff. Write it, then say it is written.

**retro** (feature closeout) — run when the product lead hands a feature to engineering, or
when it ships, lands or stops.

| # | Check | Result |
|---|---|---|
| 1 | Every artifact in the feature folder has a final `status` | |
| 2 | Zero open `[NEEDS CLARIFICATION]` markers | |
| 3 | Every PENDING decision point is LOCKED, SUPERSEDED or handed to an owner | |
| 4 | Superseded files are in `archive/superseded-YYYY-MM-DD/` with a README | |
| 5 | The INDEX state matrix is current (tier L) | |
| 6 | The issue pack's publication log shows read-back matches | |
| 7 | The outcome metric has a named source and review date | |
| 8 | Post-ship review scheduled (`/review post-ship`) and `/land` run | |

Then ask three questions, one line each: what slowed us down, what we would repeat, what
the harness should do differently. Write the answers to `tasks/lessons.md`. Harness changes
go to `tasks/todo.md` tagged `harness`.

## Gate

- start: the summary names the next action and the product lead confirms the focus.
- checkpoint and end: `sessions/latest.md` is within the handoff limit and ends with a next action.
- end: every correction is in `tasks/lessons.md`; you gave the shipped-not-landed list.
- retro: every row has a result; a failed row has an owner role and a next step.

## Output

| Mode | Writes |
|---|---|
| start | Nothing; the 8-line summary in chat |
| checkpoint | `sessions/latest.md` (marked `checkpoint`); the compact command in chat |
| end | `sessions/latest.md`, `sessions/daily/…`, `tasks/todo.md`, `tasks/lessons.md`, memory files; a commit proposal |
| retro | The checklist in chat; `tasks/lessons.md`; `tasks/todo.md` (`harness` items) |

Example end-of-session line for Harbor Cover: "Shipped, not landed:
`products/desk/verification-outcome-and-rework/shared/prd.md` — run `/land`."

## Do not

- Do not let the handoff exceed 50 lines. Cut history; keep decisions and next action.
- Do not record person names. Use roles.
- Do not write a lesson as history ("we got X wrong"). Write the rule.
- Do not store in memory what the repo already records (`references/memory.md`).
- Do not treat a `Done` issue as shipped. Only `deployed to prod` sets `shipped`.

## Hands off to

`/product-loop` for new work · `/land` for each shipped PRD not yet landed ·
`/review post-ship` first, when the post-ship review has not run.
