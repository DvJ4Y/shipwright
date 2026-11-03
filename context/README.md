---
title: Context — the durable layer for Harbor Cover
type: context-index
status: active
version: 1.0
supersedes: —
decision_refs: [D-001, D-005]
why: One entry point to every fact the agent and the product lead rely on across sessions
last_updated: 2026-11-02
---

# Context — the durable layer

> Last verified: 2026-11-02

Read the file that settles the question you have. Do not read all of them at once.

**All Harbor Cover data is fictional.** Every figure in this folder carries the label
`example`. Replace the figures and the labels when you adapt the pack to your own company
(`scripts/substitutions.csv` lists the names to swap).

## What each file settles

| # | File | What it settles |
|---|---|---|
| 01 | `01-company.md` | What Harbor Cover sells, to whom, and how we position it |
| 02 | `02-service-and-lifecycle.md` | The production stage names, sub-statuses, stage owners and where the funnel leaks |
| 03 | `03-surfaces-and-systems.md` | Harbor, Desk, Field, the eligibility engine, data and messaging, and every integration by capability name |
| 04 | `04-eligibility-and-verification.md` | How the eligibility engine decides, what verification checks, what rework means |
| 05 | `05-numbers-data-and-traps.md` | Which source is authoritative, the replica tables, and the three silent traps |
| 06 | `06-teams-and-who-does-what.md` | Roles, headcounts, the two product lanes, and what nobody owns |
| 07 | `07-glossary.md` | One term per concept |
| 08 | `08-strategy-and-outcomes.md` | The headline metric, targets, outcome metrics per journey, themes |
| 09 | `09-current-commitments.md` | A dated snapshot of committed work with its status |
| — | `metrics-dictionary.csv` + `.md` | Every metric, defined once |
| — | `personas/` | Customer and role cards with evidence tables |
| — | `surfaces/<surface>/current-behaviour.md` | What each surface does today, one row per landed behaviour |
| — | `policies/` | Internal rules as condition → outcome tables |
| — | `regulated-actions.md` | The six regulated actions and what the product must do for each |
| — | `design/tokens.md`, `design/voice.md` | Palette and type per surface; brand voice for product copy |

## The authority rule — one source per fact

A fact lives in one file. Other files point to it; they do not restate it. If you find the
same figure in two files, the file named in the table above owns it, and the other file is
wrong. Fix the pointer, not the number.

| Kind of fact | Owner file |
|---|---|
| Stage and sub-status names | `02-service-and-lifecycle.md` (from production) |
| Any number | `metrics-dictionary.csv` for metrics; `05-numbers-data-and-traps.md` for everything else |
| A policy value (service level, retention period) | the policy file under `policies/` |
| A regulated obligation | `regulated-actions.md` |
| A term | `07-glossary.md` |

## The staleness ladder

Every `.md` in this folder carries `> Last verified: YYYY-MM-DD`. The session-start hook and
the weekly miner read it.

| Age since `Last verified` | State | What the agent does |
|---|---|---|
| under 21 days | current | Uses the fact as written |
| 21 to 30 days | review recommended | Uses it; the weekly digest lists the file |
| 30 to 45 days | likely stale | Flags the file when it reads it; still proceeds |
| over 45 days | critical | Caveats every citation from the file in chat and in documents |

Refresh a file by re-checking its facts against production, the BI tool or the owner, then
updating the date. Updating the date without re-checking is the one thing this ladder cannot
detect; do not do it.

## Source labels

Exactly five, from the writing standard: `DB-verified <date>` · `analytics` ·
`operational — unverified` · `target` · `example`. A target is never presented as a baseline.
