---
name: onboard
description: Runs the one-day onboarding for a product lead, designer or founder. Setup and access; the profile through /setup; the skills exercised on the worked example in examples/harbor-cover/; then one small loop on real work. No separate training folder — the worked example is the sandbox. User-invoked only.
disable-model-invocation: true
argument-hint: "[setup | profile | example | loop]"
---

# Onboard — one day: set up, know the person, run the skills, ship one small thing

Default with no argument: run the four blocks in order and ask before moving to the next.
The reader can stop and resume with `/onboard <block>`.

## Read first (if present; else name the missing file and ask)

| File | Gives you |
|---|---|
| `knowledge/PROFILE.md`, `knowledge/facts.md` | Whether `/setup` has run; what is already known |
| `context/README.md` | The chapter names; the root `context/` starts empty |
| `context/06-teams-and-who-does-what.md` (if present) | The lanes and who decides what |
| `.mcp.README.md`, `tools/query/README.md` | The two servers to authorise; the optional query variables |
| `examples/harbor-cover/README.md` | The worked example and where each file sits |

## Questions first

One batch, each with a default. Use the editor's structured-question tool when one exists.

| # | Ask | Default |
|---|---|---|
| 1 | Run all four blocks, or start at one? | all four, in order |
| 2 | Has `/setup` run? If not, how do you want to start it: your documents in `inbox/`, one description, or a short interview? | the interview |
| 3 | Which real, small item will you bring to block 4? | ask again at block 4 |

The profile questions belong to `/setup`. Do not ask them here.

## Procedure

**Block 1 — setup.**
1. The workspace root holds the blank scaffold: `sessions/latest.md`, `tasks/todo.md`,
   `decisions/decision-log.md` and an empty `context/`. If one is missing, name it and ask.
   `knowledge/` is created by `/setup`. The filled example stays in `examples/harbor-cover/`;
   never copy it over the root.
2. `git init` if the folder is not a repository. One commit proposal at the end of the day.
3. Ask the reader to run `/mcp` and authorise the tracker and event analytics. Say plainly
   which one failed and what stops without it. No tracker: `/issue-tracker` and duplicate
   checks stop and say so. No event analytics or SQL replica: `/data-analysis` writes a BI
   export request instead of a query.
4. The query API is optional. `SQL_API_URL` and `SQL_API_KEY` live in the shell profile only
   (`tools/query/README.md`). **Never ask for, print or store a key.**
5. On Windows, or wherever symlinks misbehave: `bash scripts/link-harness.sh --copy`.

**Block 2 — the profile.** Hand off to `/setup` on the path from question 2. It writes
`knowledge/PROFILE.md` and the seed rows in `knowledge/facts.md`. Then:
1. Read back five lines: "Here is how I will work with you." Ask for corrections; route them
   through `/setup`.
2. Ask for the three things the reader is least likely to know that will cost them a
   mistake. Each becomes an `open-question` row proposal for `/learn`.

**Block 3 — the skills, on the worked example.** The fictional company in
`examples/harbor-cover/`; its feature is
`examples/harbor-cover/products/desk/verification-outcome-and-rework/`.
If any file below is missing, name it and ask; do not improvise the example.
1. Read `examples/harbor-cover/README.md` and the feature `README.md` together: the
   feature, its surfaces, its states, its regulated actions, where each artifact sits.
2. `/review gate examples/harbor-cover/products/desk/verification-outcome-and-rework/shared/prd.md`.
   Read the verdict and the must-fix list; nothing is edited today. The example profile says
   `_regulated: yes`, so the compliance lens runs there.
3. `/persona-panel` on `examples/harbor-cover/products/desk/verification-outcome-and-rework/mockups/harbor-verification-outcome-v1.mockup.html`.
   Note that the output is SYNTHETIC and becomes questions for research.
4. Ask what surprised the reader. Each surprise becomes a line in `tasks/todo.md`.

**Block 4 — one tier-S loop on real work.** The reader brings one real, small item.
`/product-loop` → the producing skill it names → gate → `/review` → `/session end`.
Pass when the phase check is stated, the gate line is recorded, `/review` returns **ready**
and the handoff is written.

**The onboarding backlog.** Write every file, access or fact the agent flags as missing
during the day to `tasks/todo.md`, one line each. That list is the reader's backlog for week
one. It is not a fault.

## Gate

| Block | Pass when |
|---|---|
| 1 | The root scaffold exists · `/mcp` result stated per server · no key in any file |
| 2 | `/setup` passed its gate: every `_` field in `knowledge/PROFILE.md` filled · the read-back accepted |
| 3 | `/review gate` verdict read · `/persona-panel` output read and labelled SYNTHETIC · surprises in `tasks/todo.md` |
| 4 | One tier-S loop closed with a handoff in `sessions/latest.md` |

## Output

- `knowledge/PROFILE.md` and seed rows in `knowledge/facts.md`, written by `/setup`.
- `tasks/todo.md` with the onboarding backlog.
- One line in `sessions/latest.md`: the date, the real item shipped, the next item.
- A commit proposal; the reader commits.

## How the profile changes the agent

| Profile content | Effect in every skill |
|---|---|
| `_struggles` names an area | Slow down there: one line of why, an extra check, an offer to explain |
| § My words → our terms | The reader's words in chat; the glossary term in documents |
| `_workstyle` | Match the presentation: options first, short answers, tables |
| `_experience: practised` | No step explanations, except in `_struggles` areas |
| `_regulated: yes` | The regulated-actions register is checked at every gate; `/review` adds the compliance lens |
| `_regulated: no` | The default. No register check, no compliance lens |
| `_customer_language: <code>` | `/localisation-copy` reads that language pack; `none` means every customer string is written in the working language and flagged |
| `_language_review: no` | Every string in the customer's language is flagged for a native reviewer |
| `_tracker` | `/issue-tracker` loads that adapter |

## Do not

- Do not assess or rate the reader. The interview shapes the agent.
- Do not write onboarding output into `examples/`. The real item in block 4 goes to its own
  feature folder under `products/`.
- Do not store secrets anywhere in the workspace.
- Do not skip the access check. A skill that cannot reach its source must stop. The reader
  should know in advance which ones will.
- Do not edit the worked example during block 3. It is the sandbox, not the task.

## Hands off to

`/setup` in block 2 · `/product-loop` for the first real item → `/session end` to close the day. Day two starts
with `/session start`.
