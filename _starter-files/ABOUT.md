---
title: _starter-files — blank starters
type: readme
status: active
version: 1.0
supersedes: —
decision_refs: []
why: Explains how to copy the blank starter files into a new workspace
last_updated: 2026-11-02
---

# `_starter-files/`

Copy these into your workspace root once, on day one. This file is named `ABOUT.md` so it
never overwrites the repo's `README.md`.

```bash
cp -r _starter-files/* .
mkdir -p sessions/daily sessions/weekly products
```

The repo root already holds a filled version of each file for the Harbor Cover example.
Copying from here replaces them with blanks. Keep the filled versions open in another window
for the first week; they show what a good one looks like.

| File | Read by | Purpose |
|---|---|---|
| `_profile.md` | the session-start hook, every skill | Who you are; which tracker adapter to load; how much the skills explain |
| `sessions/latest.md` | the session-start hook, `/session` | The handoff — under 50 lines |
| `tasks/todo.md` | the session-start hook, `/session` | Open items with no tracker issue yet |
| `tasks/lessons.md` | `/session`, every skill at start | Every correction, as a rule |
| `decisions/decision-log.md` | the session-start hook, `/decide` | Workspace decision points, `D-001` onward |

If these files are missing, the hook says so at every session start and the loop has nothing
to read. `/onboard` copies them for you if you prefer.
