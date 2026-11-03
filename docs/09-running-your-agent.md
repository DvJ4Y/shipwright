---
title: 09 — Running your agent
type: doc
status: active
version: 1.0
supersedes: —
decision_refs: []
why: Settles how to install the harness, what each part does, and what to change with judgement rather than by accident
last_updated: 2026-11-02
---

# 09 — Running your agent

Read this when you need to decide how to install the harness, what each part of it does,
and what to change with judgement rather than by accident.

## Three layers, no duplication

| Layer | Holds | Lives in |
|---|---|---|
| Procedure | The steps, the questions, the gate, where output goes | `.agents/skills/` |
| Craft | How to do good work, and why | `docs/` |
| Facts | The business, the product, the numbers | `context/` |

Skills point to docs and context; they do not copy them. When something changes, update
one file.

## Skills load when the task matches

A skill's instructions arrive only when its description matches what you asked. That is
why there are 16 focused skills instead of one long instruction file: a long instruction
file loses rules, because the agent stops following them. Every skill has one job, a short
"Do not" list, and conditional reads: "read this if present; if it is missing, name it and
ask." An agent whose first read fails does not stop; it improvises. That line turns a
silent failure into a question.

`/session` and `/onboard` are user-invoked only. Everything else triggers from your words;
`AGENTS.md` has the routing table.

## Hooks for guarantees, prompts for judgement

| Hook | Does | Why a hook |
|---|---|---|
| SessionStart (startup, resume, clear, compact) | Prints the `_` lines of `_profile.md`, the handoff head, the top todo items, open PENDING decision points, and PRDs at `shipped` not yet landed | The session loop works only if it runs every time |
| Stop | If artifacts changed and `sessions/latest.md` did not, asks once for `/session end` | A handoff that depends on remembering does not happen |
| PreToolUse on Edit and Write | Denies edits to files headed `GENERATED — do not hand-edit`; asks before writing under `archive/` | Generated files and history must not drift by accident |

Python standard library only. A hook failure never blocks a session.

## Permissions: curated, never secret

`.claude/settings.json` allows read-only git, `ls`, `wc`, the query runner, the tracker's
read tools and web search. It asks before tracker writes, the build and link scripts, `git
commit` and `git push`. It denies reading `.env` files and `printenv`. Personal additions go
to `.claude/settings.local.json`, which git ignores. Never put a secret in a permission
rule: rules match command prefixes, so a key in a command is written into the settings
file.

**Permissions apply only once the workspace is trusted.** The first interactive run of
`claude` in the repo shows a trust dialog. Accept it. Until then the CLI ignores the
project's permission list. The project hooks still run, in print mode too (observed on a
fresh clone with Claude Code 2.1.316). Accept the dialog before relying on the permission list.

## Two agents, one layout

`.agents/skills/` and `AGENTS.md` are the source of truth. `.claude/` and `.codex/` wrap
them.

| | Claude Code | Codex |
|---|---|---|
| Instructions | `CLAUDE.md`: `@AGENTS.md` plus Claude-only lines | `AGENTS.md`, read directly |
| Skills | `.claude/skills`, a symlink to `.agents/skills` | `.agents/skills/` |
| Reviewers | `.claude/agents/*.md` | `.codex/agents/*.toml` |
| Rules | `.claude/rules/`, always-on and path-scoped | The condensed rules inside `AGENTS.md` |
| Hooks | `.claude/settings.json` → `.agents/hooks/` | `.codex/hooks.json` → `.agents/hooks/` |
| MCP | `.mcp.json` | `.mcp.json`, or the command the adapter gives |
| Memory | The project memory directory (`_memory_dir: default`) | The folder `_memory_dir` names |

If `/skills` shows nothing in Claude Code, run `bash scripts/link-harness.sh`. On Windows,
or wherever the platform does not follow symlinks, run it with `--copy` and rerun after
editing a skill. The script moves a hand-made `.claude/skills` that differs to
`.claude/_retired/`.

### Codex: documented, not verified

These behaviours come from the public docs and are unverified on a Codex install:

- `.codex/hooks.json` loading, the trust flow through `/hooks`, and the `description` key at
  the top of the file. Drop the key if Codex rejects unknown keys.
- The edit guard is inert on Codex. The hook reads `tool_input.file_path`, which the
  `apply_patch` tool does not send. Only the instruction protects generated files until the
  hook learns that input shape.
- `.codex/agents/*.toml` carry `name`, `description` and `developer_instructions` only.
  Read-only behaviour is by instruction, not by a tool-policy field.
- `plugin/.codex-plugin/plugin.json` field acceptance, and `${CLAUDE_PLUGIN_ROOT}` expansion
  in plugin hooks.
- The upper size limit on `AGENTS.md`. The file stays under 32 KiB by rule.

## Plugin or clone, never both in one repo

| Route | When | How |
|---|---|---|
| Clone | You want the whole system: context, the worked example, tools, automations | `git clone`, then `claude`, then `/onboard` |
| Plugin | You have a project and want the skills, reviewers and hooks inside it | `/plugin marketplace add DvJ4Y/shipwright`, then `/plugin install shipwright@shipwright` |

Installing the plugin inside a clone of this repo runs every hook twice: once from
`.claude/settings.json`, once from the plugin. Pick one.

`bash scripts/build-plugin.sh` generates `plugin/` from `.agents/skills/`, `.claude/agents/`,
`.agents/hooks/` and `.mcp.json`. `--check` exits non-zero when `plugin/` is out of date.
The plugin holds no `context/`. A plugin user builds their own durable layer with
`templates/` and `context/README.md` as the guide.

**Two marketplace files.** `.claude-plugin/marketplace.json` follows the Claude Code schema
and passes `claude plugin validate`. `.agents/plugins/marketplace.json` follows the Codex
schema (`source.local`, `policy`, `interface`). The Claude validator rejects it by design.
Codex also reads the Claude file as a fallback, so Codex users have two routes.

## Reviewers report; they never edit

`/review` dispatches read-only agents, one lens each, in fresh contexts. An agent asked to
"review and improve" rewrites more than intended, and concurrent agents editing one file
collide. The author applies the fixes and runs `/review` again.

## The profile

Every skill reads `_profile.md` at the start. `/onboard` fills it on day one.

| Field | Effect |
|---|---|
| `_role`, `_lane`, `_focus` | Who the reader is; the default lane and reviewers; the first place intake looks for fit |
| `_experience` | `new` adds one line of "why" per step; `practised` adds nothing |
| `_default_tier` | The starting tier when intake is ambiguous |
| `_tools_access` | Which sources `/data-analysis` may query; otherwise it writes an export request |
| `_tracker` | `linear` or `github`: the adapter `/issue-tracker` loads |
| `_language` | The working language of the documents |
| `_customer_language` | The language-pack code for customer copy, or `none` |
| `_memory_dir` | Where the agent keeps memory facts: `default`, or a folder path |
| `_regulated` | `yes`: intake reads the register, every gate checks it, `/review` adds the compliance lens |
| `_language_review` | `no`: every customer-language string is flagged for a native reviewer |
| `_workstyle`, `_struggles` | How to present; where skills slow down and add a check |
| `_gate_owner` | The role that approves gates |

`/onboard` runs on the blank starters in `_starter-files/` and the worked example in
`products/desk/verification-outcome-and-rework/`. There is no separate training folder;
the worked example is the sandbox.

## Context hygiene

One topic per session. `/clear` between unrelated work. Delegate reads of more than five
files to a read-only explore agent and keep its conclusion. `/session checkpoint` when the
context is more than half used, then `/compact` with the focus line it prints. A fresh
session per phase.

## If you take four things

1. Write every correction into `tasks/lessons.md` from day one.
2. Make every file read conditional: if present; otherwise name it and ask.
3. Let the tier size the process.
4. Reviewers report; owners decide.
