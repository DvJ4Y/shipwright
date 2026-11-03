---
name: onboard
description: Runs the one-day onboarding for a product lead, designer or founder. Setup and access; an interview that writes every field of _profile.md; the skills exercised on the worked example; then one small loop on real work. No separate training folder — the worked example is the sandbox. User-invoked only.
disable-model-invocation: true
argument-hint: "[setup | interview | example | loop]"
---

# Onboard — one day: set up, know the person, run the skills, ship one small thing

Default with no argument: run the four blocks in order and ask before moving to the next.
The reader can stop and resume with `/onboard <block>`.

## Read first (if present; else name the missing file and ask)

| File | Gives you |
|---|---|
| `_starter-files/ABOUT.md` | The copy command and what each starter file is for |
| `_profile.md`, else `_starter-files/_profile.md` | The fields to fill |
| `context/README.md`, `context/06-teams-and-who-does-what.md` | What exists; the two lanes |
| `context/07-glossary.md`, `context/metrics-dictionary.csv` | Terms for the vocabulary round; metric ids to offer |
| `.mcp.README.md`, `tools/query/README.md` | The two servers to authorise; the optional query variables |
| `products/desk/verification-outcome-and-rework/README.md` | The worked example and its files |

## Questions first — the interview

One batch of eight, each with a default. Use the editor's structured-question tool when one
exists. Write the answers to `_profile.md` as soon as the round closes.

| # | Ask | Default | Writes |
|---|---|---|---|
| 1 | What do you own, and in which lane? Which outcome metrics do you answer for? (offer the ids from the dictionary) | `product-lead`, lane from the surfaces named | `_role`, `_lane`, `_focus`, § Role and focus |
| 2 | Have you run product work through an agent loop before? How much process does a typical item of yours deserve? | `new`, `M` | `_experience`, `_default_tier` |
| 3 | What can you reach yourself: the tracker, event analytics, the SQL replica, a BI export? Which tracker? | all `no` until `/mcp` succeeds; tracker from `.mcp.json` | `_tools_access`, `_tracker` |
| 4 | What is the working language of your documents? In which language do your customers read the product, and is there a language pack for it? Is your product regulated? Can you review copy in the customer's language yourself? | `en`, `none`, `yes`, `no` | `_language`, `_customer_language`, `_regulated`, `_language_review` |
| 5 | Options first or a recommendation first? Tables or prose? What should the agent never do? | options first, tables | `_workstyle`, § How I work |
| 6 | Which parts of the job take longest or feel least sure: data, writing, copy in the customer's language, design, engineering conversations, stakeholders, the tracker? | — | `_struggles`, § Where I struggle |
| 7 | In your own words: the funnel, the customer types, the teams, the documents. (map each word to a glossary term and confirm) | — | § My words → our terms |
| 8 | Who approves your gates? | the lane's product lead | `_gate_owner` |

## Procedure

**Block 1 — setup.**
1. If `_profile.md`, `sessions/latest.md`, `tasks/todo.md`, `tasks/lessons.md` or
   `decisions/decision-log.md` is missing, offer the copy command from
   `_starter-files/ABOUT.md`. If the filled Harbor Cover versions are present, ask: keep
   them as the example for the first week, or replace them with blanks now.
2. `git init` if the folder is not a repository. One commit proposal at the end of the day.
3. Ask the reader to run `/mcp` and authorise the tracker and event analytics. Say plainly
   which one failed and what stops without it. No tracker: `/issue-tracker` and duplicate
   checks stop and say so. No event analytics or SQL replica: `/data-analysis` writes a BI
   export request instead of a query.
4. The query API is optional. `SQL_API_URL` and `SQL_API_KEY` live in the shell profile only
   (`tools/query/README.md`). **Never ask for, print or store a key.**
5. On Windows, or wherever symlinks misbehave: `bash scripts/link-harness.sh --copy`.

**Block 2 — the interview.** Run the eight questions. Then:
1. Write `_profile.md`: every `_` field on one line; the four sections in plain words.
2. Read back five lines: "Here is how I will work with you." Ask for corrections.
3. Pick three `context/` files for the lane and focus. Ask the reader to read them. Then ask
   for the three things they are least likely to know that will cost them a mistake.

**Block 3 — the skills, on the worked example.** `products/desk/verification-outcome-and-rework/`.
If any file below is missing, name it and ask; do not improvise the example.
1. Read its `README.md` together: the feature, the three surfaces, the six states, the
   three regulated actions, where each artifact sits.
2. `/review gate products/desk/verification-outcome-and-rework/shared/prd.md`. Read the
   verdict and the must-fix list; nothing is edited today.
3. `/persona-panel products/desk/verification-outcome-and-rework/mockups/harbor-verification-outcome-v1.mockup.html`.
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
| 1 | The five starter files exist · `/mcp` result stated per server · no key in any file |
| 2 | Every `_` field in `_profile.md` filled, no `<…>` placeholder left · the read-back accepted |
| 3 | `/review gate` verdict read · `/persona-panel` output read and labelled SYNTHETIC · surprises in `tasks/todo.md` |
| 4 | One tier-S loop closed with a handoff in `sessions/latest.md` |

## Output

- `_profile.md`, fully filled.
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
| `_regulated: yes` | The regulated-actions register is checked at every gate |
| `_customer_language: <code>` | `/localisation-copy` reads that language pack; `none` means every customer string is written in the working language and flagged |
| `_language_review: no` | Every string in the customer's language is flagged for a native reviewer |
| `_tracker` | `/issue-tracker` loads that adapter |

## Do not

- Do not assess or rate the reader. The interview shapes the agent.
- Do not write onboarding output into `products/` beyond the worked example. The real item
  in block 4 goes to its own feature folder.
- Do not store secrets anywhere in the workspace.
- Do not skip the access check. A skill that cannot reach its source must stop. The reader
  should know in advance which ones will.
- Do not edit the worked example during block 3. It is the sandbox, not the task.

## Hands off to

`/product-loop` for the first real item → `/session end` to close the day. Day two starts
with `/session start`.
