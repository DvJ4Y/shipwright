---
title: Context — the chapters behind your facts
type: context-index
status: active
version: 1.0
supersedes: —
decision_refs: []
why: Names the chapters that hold longer reference material, so a fact row has one place to point to
last_updated: 2026-11-04
---

# Context — the chapters

> Last verified: 2026-11-04

This folder starts empty. Short facts live as rows in `knowledge/facts.md`; who you are and
what the product is live in `knowledge/PROFILE.md`. A topic that outgrows a few fact rows
becomes a chapter here, and its rows point to the chapter. `/learn` proposes a chapter when
a topic outgrows its rows. The chapter is the one source for its detail.

A filled set lives in `examples/harbor-cover/context/`.

## The chapters, when you need them

Create a chapter only when a decision needs it. Skills read a chapter if it is present and
ask you when it is missing.

| File | What it settles |
|---|---|
| `01-company.md` | What you sell, to whom, the segments and how you position it |
| `02-service-and-lifecycle.md` | The production stage names, sub-statuses, stage owners and where the funnel leaks |
| `03-surfaces-and-systems.md` | Each surface and system, its status, and every integration by capability name |
| `04-<domain-rules>.md` | How your core decision works (eligibility, pricing, matching), WHAT only |
| `05-numbers-data-and-traps.md` | Which source is authoritative, the tables, and the queries that fail silently |
| `06-teams-and-who-does-what.md` | Roles, the product lanes, who decides what, what nobody owns |
| `07-glossary.md` | One term per concept |
| `08-strategy-and-outcomes.md` | The headline metric, targets, outcome metrics per journey, themes |
| `09-current-commitments.md` | A dated snapshot of committed work and its delivery state |
| `metrics-dictionary.csv` | Every metric, defined once (`templates/metric-contract-template.md`) |
| `personas/` | Customer and role cards with evidence (`templates/persona-card-template.md`) |
| `surfaces/<surface>/current-behaviour.md` | What each surface does today, one row per landed behaviour (`templates/current-behaviour-template.md`) |
| `policies/` | Internal rules as condition → outcome tables (`templates/policy-template.md`) |
| `regulated-actions.md` | Only when `_regulated: yes`: each regulated action and the evidence it keeps |
| `design/tokens.md`, `design/voice.md` | Palette and type per surface; the voice for product copy |

## The authority rule — one source per fact

A fact lives in one place. If a chapter exists for it, the chapter owns the detail and the
fact row points to it. If two files state the same figure, the owner file wins and the
other file gets a pointer, not a corrected copy.

| Kind of fact | Owner |
|---|---|
| Stage and sub-status names | `02-service-and-lifecycle.md`, from production |
| A metric | `metrics-dictionary.csv` |
| A policy value | the policy file under `policies/` |
| A regulated obligation | `regulated-actions.md` |
| A term | `07-glossary.md` |

## The staleness ladder

Every `.md` here carries `> Last verified: YYYY-MM-DD`. The session-start hook and the weekly
miner read it.

| Age since `Last verified` | State | What the agent does |
|---|---|---|
| under 21 days | current | Uses the fact as written |
| 21 to 30 days | review recommended | Uses it; the weekly digest lists the file |
| 30 to 45 days | likely stale | Flags the file when it reads it; still proceeds |
| over 45 days | critical | Caveats every citation from the file in chat and in documents |

Refresh a chapter by re-checking its facts against production, the BI tool or the owner,
then updating the date. Updating the date without re-checking defeats the ladder.

## Source labels

Exactly five: `DB-verified <date>` · `analytics` · `operational — unverified` · `target` ·
`example`. A target is never presented as a baseline.
