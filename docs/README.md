---
title: Docs — reading order
type: readme
status: active
version: 1.0
supersedes: —
decision_refs: []
why: Lists every document and the decision it unblocks
last_updated: 2026-11-02
---

# Docs — reading order

Read this when you need to decide which document to open for the decision in front of you.

Each document opens with the decision it unblocks. Read the one that settles your question.
Do not read all of them at once.

| # | Document | Read it to decide |
|---|---|---|
| 00 | `00-why.md` | Whether to run product work as a system with durable context, or document by document |
| 01 | `01-folder-structure.md` | Where a file goes, and who may write it |
| 02 | `02-context-layers.md` | Where a fact, a decision, a preference or work in flight belongs |
| 03 | `03-the-loop.md` | What happens next on a piece of work, how much process it deserves, who approves |
| 04 | `04-visual-method.md` | Which visual a feature needs, and how to prove it is complete |
| 05 | `05-internal-vs-external.md` | What an outside reader may see, and how to publish it |
| 06 | `06-weekly-sync.md` | How the durable context stays true without re-reading it |
| 07 | `07-data-and-mcp.md` | Which source answers a question, what label it carries, how the agent reaches it |
| 08 | `08-handoff-to-engineering.md` | What engineering receives, in what form, and what counts as shipped |
| 09 | `09-running-your-agent.md` | How to install the harness and what each part does |
| 10 | `10-keeping-it-current.md` | Whether a file is still true, and when requirements become durable |
| 11 | `11-policies-and-compliance.md` | How a rule or an obligation enters a feature, and who decides it |
| — | `lessons.md` | Which habits to adopt on day one |

## Suggested first reads

| Moment | Read |
|---|---|
| Day one | `00-why.md`, `03-the-loop.md`, `09-running-your-agent.md`, `lessons.md`, then run `/onboard` |
| First feature | `02-context-layers.md`, `04-visual-method.md`, `08-handoff-to-engineering.md` |
| First release | `08-handoff-to-engineering.md`, `10-keeping-it-current.md` |
| First month | `06-weekly-sync.md`, `11-policies-and-compliance.md` |

## How these docs relate to the rest

| Layer | Holds | Where |
|---|---|---|
| Procedure | The steps, the questions, the gate | `.agents/skills/` |
| Craft | How to do good work, and why | `docs/`, this folder |
| Facts | The business, the product, the numbers | `context/` |

Skills point here for the craft. These docs point to the skills for the procedure and to
`context/` for every fact. A fact never lives here.
