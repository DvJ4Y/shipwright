---
title: sessions — the session memory layer
type: readme
status: active
version: 1.0
supersedes: —
decision_refs: []
why: Explains what each session file holds and who writes it
last_updated: 2026-11-02
---

# `sessions/` — session memory

The session layer keeps the agent oriented across days without re-reading the whole
workspace. Four parts, each with one job.

| Path | Holds | Written by | Read by |
|---|---|---|---|
| `latest.md` | The handoff from the last session: focus, decisions, files changed, open threads, next action. Under 50 lines | the agent, silently, at the end of every session | the session-start hook, every session |
| `daily/YYYY-MM-DD-HHMM.md` | An archive copy of `latest.md` at the moment a session ended | the agent at session end | the weekly compressor |
| `weekly/YYYY-WNN-summary.md` and `YYYY-WNN-context-digest.md` | The week's sessions compressed; the digest lists context files the week's work contradicted (STALE) or confirmed (CURRENT) | the `session-compressor` and `context-miner` automations | the product lead, the knowledge interview |
| `monthly/YYYY-MM-summary.md` | The month's weekly summaries compressed; kept indefinitely | the monthly compressor run | long-term context |

## How it flows

```
session end  →  latest.md rewritten  →  copied to daily/
weekly       →  daily/ compressed to weekly/summary + context-digest
monthly      →  weekly/ compressed to monthly/
```

`daily/` and `weekly/` hold one example week (six handoffs, a summary and the digest the
miner produced on them). `monthly/` is created by the compressor on its first monthly run.

## Rules

- `latest.md` is rewritten, not appended. History lives in `daily/`.
- The agent updates `latest.md` after any significant decision or file creation. It does not
  ask permission.
- A handoff names the phase check and the next action. A handoff without a next action is
  incomplete.
- Nothing in `sessions/` is a source of truth for a fact. Facts live in `context/`; a session
  file records that a fact was used or found stale.
