---
title: 01 — Folder structure
type: doc
status: active
version: 1.0
supersedes: —
decision_refs: []
why: Settles where a file goes and who is allowed to write it
last_updated: 2026-11-03
---

# 01 — Folder structure

Read this when you need to decide where a file goes, or who is allowed to write it.

The tables below list every top-level entry: what lives there, who writes it, and whether
a script generates it. "Person" means the product lead or a teammate by hand. "Skill"
means an agent skill writes it during the loop. "Script" means a command regenerates it.

## Root files

| Path | What lives there | Written by | Generated |
|---|---|---|---|
| `AGENTS.md` | The agent's instructions: the loop, skill routing, the knowledge table, standing facts, the always-on rules. Codex reads it directly; Claude Code reads it through `CLAUDE.md` | person | no |
| `CLAUDE.md` | `@AGENTS.md` plus Claude Code-only lines: rules, hooks, the skills link, what to preserve on compaction | person | no |
| `README.md` | The front door | person | no |
| `_profile.md` | Who the reader is. One per person. The session-start hook prints every `_` line | `/onboard`, then the person | no |
| `.mcp.json` | The two MCP servers under capability-named keys, `tracker` and `analytics`. `.mcp.README.md` explains each entry and how to swap one | person | no |
| `.gitignore` | Excludes personal settings, secrets, run logs and eval results | person | no |
| `LICENSE` | MIT | person | no |
| `CHANGELOG.md` | What each release added | person | no |
| `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md` | How to report, propose and contribute; the code of conduct | person | no |
| `PRIVACY.md` | What the pack does with data: nothing leaves your machine except through the services you configure. The plugin manifest links to it | person | no |
| `.github/` | Three issue templates and the pull-request checklist | person | no |
| `assets/` | The plugin icon: `icon.svg` is the source, `icon.png` the render the plugin builder copies | person | no |

## Agent configuration

| Path | What lives there | Written by | Generated |
|---|---|---|---|
| `.agents/skills/<name>/SKILL.md` | The 16 skills, the canonical tree shared by Claude Code and Codex. A skill's `references/` folder holds what it reads | person | no |
| `.agents/hooks/*.py` | The three hooks: session start, stop, edit guard. Python standard library only | person | no |
| `.agents/plugins/marketplace.json` | The Codex marketplace entry | person | no |
| `.claude/skills` | A symlink to `.agents/skills`. `scripts/link-harness.sh --copy` makes it a real copy where the platform does not follow symlinks | script | yes |
| `.claude/agents/*.md` | The six read-only reviewers | person | no |
| `.claude/rules/*.md` | Always-on rules (the constitution, the writing standard) and path-scoped rules (data, mockups, PRDs) | person | no |
| `.claude/settings.json` | Curated permissions and the hook wiring. Personal additions go to `.claude/settings.local.json`, which git ignores | person | no |
| `.claude-plugin/marketplace.json` | The Claude Code marketplace entry | person | no |
| `.codex/agents/*.toml` | The same six reviewers for Codex | person | no |
| `.codex/hooks.json` | The same three hooks in the Codex shape | person | no |
| `plugin/` | The installable plugin: skills, agents, hooks, manifests. Headed `GENERATED — do not hand-edit`; the guard hook denies edits | `scripts/build-plugin.sh` | yes |

## The durable layer

| Path | What lives there | Written by | Generated |
|---|---|---|---|
| `context/` | Company, lifecycle, surfaces, eligibility, numbers and traps, teams, glossary, strategy, commitments; `context/metrics-dictionary.csv`; `personas/`; `policies/`; `context/regulated-actions.md`; `design/` | person; the weekly interview applies approved diffs | no |
| `context/surfaces/<surface>/current-behaviour.md` | One row per live behaviour, per surface | person seeds; `/land` appends | no |
| `decisions/decision-log.md` | Workspace decision points, `D-001` onward, append-only | `/decide` | no |
| `qa/` | The schema (`qa/README.md`), the process (`qa/PROCESS.md`), one test-case catalog and one analytics catalog per surface | `/prd-writer` adds `Planned` rows; whoever ships confirms them; `/land` flips confirmed rows | no |

## The change layer

| Path | What lives there | Written by | Generated |
|---|---|---|---|
| `products/<code>/<feature>/shared/` | The PRD, the brief, the copy table and the strings files. Self-contained; handed to engineering | `/prd-writer`, `/engineering-brief`, `/product-copy`, `/localisation-copy` | no |
| `products/<code>/<feature>/internal/` | Discovery, the `P-nn` decision log, the data packet, the design spec, reviews, readiness, the issue pack, the crosswalk, evidence | the producing skills | no |
| `products/<code>/<feature>/mockups/` | Wireframes and prototypes, versioned by filename | `/mockup` | no |
| `products/<code>/<feature>/showcase/` | The story script, screen fragments, storyboard, story HTML and video | `/mockup`; `tools/story-builder/build_story.py` builds the HTML | partly |
| `products/<code>/archive/landed-YYYY-MM-DD/<feature>/` | Landed feature folders with a "replaced by" README | `/land` only | no |
| `initiatives/<name>/` | Tier L: index, intake feedback, decision log, `features/`, `research/`, `archive/`. Created on the first tier L piece of work | `/product-loop` | no |
| `releases/<cycle>-release-note.md` | One note per cycle after reconciliation; the source `/land` reads | `/issue-tracker release` | no |

Workstream codes: `hub` (Harbor) · `desk` · `field` · `rules` · `data` · `comms`. The code →
surface → files table is in `.agents/skills/product-loop/references/conventions.md`.

## Memory and session layers

| Path | What lives there | Written by | Generated |
|---|---|---|---|
| The agent's memory directory | One fact per file plus the `MEMORY.md` index. Outside the repo (`.agents/skills/session/references/memory.md`) | `/session end`; the weekly interview | no |
| `sessions/latest.md` | The handoff, under 50 lines, rewritten at every session end | `/session`, silently | no |
| `sessions/daily/` | Archive copies of each handoff | `/session end` | no |
| `sessions/weekly/`, `sessions/monthly/` | Summaries and context digests. Git ignores the run logs under `sessions/weekly/_runs/` | `automations/run.sh` | yes |
| `tasks/todo.md` | Open items with no tracker issue | `/session`, every skill | no |
| `tasks/lessons.md` | Every correction, as a rule | `/session end` | no |

## Tools, automations, templates, starters, docs

| Path | What lives there | Written by | Generated |
|---|---|---|---|
| `tools/wireframe-kit/` | The L0 kit (`tools/wireframe-kit/kit.md`) and the chip check | person | no |
| `tools/story-builder/` | Script → storyboard → hi-fi → video | person | no |
| `tools/query/` | The read-only SQL runner and the source authority table | person | no |
| `tools/prompts/` | Standalone prompts: a UX audit, a competitor video analysis | person | no |
| `automations/` | The three weekly prompts, the runner, the schedule examples | person | no |
| `templates/` | One template per artifact type (`templates/README.md`) | person | no |
| `_starter-files/` | Blank profile, handoff, todo, lessons and decision log; `_starter-files/ABOUT.md` says how to copy them | person | no |
| `scripts/` | `scripts/link-harness.sh`, `scripts/build-plugin.sh`, `scripts/review-guard.sh`, `scripts/check-pack.sh`, `scripts/substitutions.csv` | person | no |
| `evals/` | Trigger prompts and golden references for the skills | person | results are gitignored |
| `docs/` | These documents | person | no |

## Three rules the layout enforces

1. **One file per fact.** A fact lives in the file the `context/README.md` table names; other
   files point to it.
2. **Nobody hand-edits a generated folder.** `plugin/` and the weekly outputs come from
   scripts. The guard hook denies edits to anything headed `GENERATED — do not hand-edit`.
3. **Only `/land` and supersession write to `archive/`.** The guard hook asks before any
   other write under it.
