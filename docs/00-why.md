---
title: 00 — Why this harness exists
type: doc
status: active
version: 1.0
supersedes: —
decision_refs: []
why: Settles whether to run product work through this harness, and what it adds to the durable-context thesis
last_updated: 2026-11-03
---

# 00 — Why this harness exists

Read this when you need to decide whether to run product work as a system with durable
context, or keep producing documents one chat at a time.

## The thesis

Agents write and check faster than people read. The human cost has moved to review:
understanding what was produced, why, and which cases it missed. Direction and judgement
stay human. Review scales only if the thing reviewed is small and stable.

So the harness treats **durable context** as the source of truth and every artifact as
regenerable from it.

| Term | Means here |
|---|---|
| Durable context | What the product should do: company, customers, lifecycle, surfaces and their current behaviour, policies, regulated actions, glossary, metrics, decisions. Lives in `context/`, `decisions/`, `qa/` |
| Artifact | A discovery, PRD, mockup, brief, issue pack or review. Produced from durable context for one change. Lives in `products/` |
| Review | A person checks intent and outcome against durable context, not every line of the artifact |

The product lead reviews a small body of context and a short change. The agent regenerates
the artifact when either changes. The gate owner freezes an approved artifact. A correction
edits the context or starts the next version
(`.agents/skills/product-loop/references/conventions.md`, Versioning).

## Four guardrail types, shifted left

Shift every check as far left as it can go: earlier in the loop, and deterministic. If a
check can run mechanically, make it a check. People follow guidance alone inconsistently.

| Type | Nature | In this harness |
|---|---|---|
| Structural | One route; the wrong route cannot be represented | One template per artifact (`templates/`); one feature folder shape; one source per fact (`context/README.md`); id series that are never reused |
| Mechanical | Deterministic pass or fail | The three hooks (`.agents/hooks/`); the chip check (`tools/wireframe-kit/check_wireframe_data.py`); the read-only SQL guard (`tools/query/run-sql.sh`); the pack check (`scripts/check-pack.sh`); the greps in `docs/10-keeping-it-current.md` |
| Judgement | A reviewer interprets a result | Six read-only reviewer agents (`.claude/agents/`) dispatched by `/review`; the weekly miner (`automations/miner.md`) |
| Guidance | Context someone should follow | The skills (`.agents/skills/`); the always-on rules (`.claude/rules/`); these docs |

The strongest guardrails span types. A reviewer finds a class of error; the lessons log
turns it into a rule; the rule becomes a check. `docs/10-keeping-it-current.md` describes
how a finding becomes a check.

## What this pack adds for product work

The thesis above comes from engineering systems, where code is the regenerable artifact.
Product work needed four additions.

**1. Four context layers, not two.** Durable and change context stay. Two more hold what
product work generates between changes.

| Layer | Holds | Where |
|---|---|---|
| Durable | The facts above | `context/`, `decisions/`, `qa/` |
| Change | One feature from discovery to issue pack, with its reviews and its `P-nn` decision log | `products/<code>/<feature>/{shared,internal}/` |
| Memory | One fact per file about how the reader works and how the tools behave | The agent's memory directory |
| Session | A handoff under 50 lines, a daily archive, todo, lessons | `sessions/`, `tasks/` |

`docs/02-context-layers.md` says what goes where.

**2. A landed step.** The framework merges change context into durable context when a
change ships, then deletes it. Product artifacts do not merge themselves. `/land` reads a
PRD at `shipped`, appends one row per requirement to the surface's current-behaviour table,
writes the crosswalk and archives the feature folder. The loop ends at LAND and COMPOUND,
not at HANDOFF (`docs/03-the-loop.md`).

**3. A current-behaviour layer per surface.** `context/surfaces/<surface>/current-behaviour.md`
holds one "When … then …" row per live behaviour. The next PRD reads rows, not history. It
cites row ids and never re-specifies a landed behaviour.

**4. A shared and an internal half of every feature.** `shared/` is what engineering and
outside readers get: the PRD and the brief, self-contained. `internal/` is the reasoning:
discovery, decisions, reviews, readiness, evidence (`docs/05-internal-vs-external.md`).

Two smaller rules follow from the product side. The boundary is explicit: product writes
WHAT and WHY, engineering writes HOW (`.claude/rules/constitution.md`, rule 1). And a
recommendation is never a decision: the agent logs it PENDING, and only the named owner
locks it.

## What stays human

Direction. Every gate approval. Every LOCKED decision. Talking to customers. Reviewing copy
in the customer's language. The agent drafts, checks and challenges.
