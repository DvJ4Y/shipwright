---
title: Harbor Cover — the worked example
type: readme
status: active
version: 1.0
supersedes: —
decision_refs: []
why: Entry point to the fictional company and the one feature run through the loop end to end
last_updated: 2026-11-04
---

# Harbor Cover — the worked example

Open this folder to see what a filled Shipwright workspace looks like. Your own workspace
starts empty at the repository root; this one shows every layer after one feature has run
through the loop.

**Every figure here is invented and labelled `example`** (or `target`). Harbor Cover, its
people, personas, partners and replica tables are fiction.

## The company

Harbor Cover distributes small-business insurance in India. A shop owner gets a quote
online, answers eligibility questions, uploads documents and pays. An ops team verifies
identity and documents, applies the eligibility rules, places the policy with the best-fit
insurer and runs the claims desk. Field verifiers visit shops; referral agents bring
customers in. The full picture: `context/01-company.md`.

## Open first

| Step | Open |
|---|---|
| Who the reader is, what is in flight | `knowledge/PROFILE.md` |
| The fact ledger and the lessons | `knowledge/facts.md` · `knowledge/lessons.md` |
| The durable layer, chapter by chapter | `context/README.md` |
| What each surface does today | `context/surfaces/desk/current-behaviour.md` (also `harbor/`, `field/`) |
| The worked feature, start here | `products/desk/verification-outcome-and-rework/README.md` |
| Discovery → PRD → review → brief → issue pack | `internal/discovery.md` · `shared/prd.md` · `internal/review-2026-11-04-gate.md` · `shared/eng-brief.md` · `internal/issue-pack.md` |
| The wireframe and the story | `mockups/desk-rework-queue-v2.mockup.html` · `showcase/story-script.md` |
| What `/land` writes back | `internal/land-rehearsal.md` |
| Decisions, QA, releases, sessions | `decisions/decision-log.md` · `qa/` · `releases/` · `sessions/latest.md` |

Paths inside this folder are relative to `examples/harbor-cover/`.

## Standing facts in the example

- **Stages come from production.** `Quote` · `Eligibility` · `Documents` · `Verification` ·
  `Placement` · `Policy issued` · `Active`, then `Claim` and `Renewal`. Sub-statuses: `open` ·
  `on hold` · `rework` · `declined` · `cancelled` · `lapsed`. A `declined` outcome always
  carries a recovery path.
- **Workstream codes** `hub` (Harbor, the customer web app) · `desk` (Desk, the ops console)
  · `field` (Field, the field and partner app) · `rules` (the eligibility engine) · `data` ·
  `comms`.
- **Regulated.** The example sets `_regulated: yes`, so the compliance lens and
  `context/regulated-actions.md` run at every gate.
- **Tracker key** `HBR`. Personas: Meera, Arjun and Priya (`context/personas/`).

## Try the skills on it

Point a skill at a file here, for example "review
`examples/harbor-cover/products/desk/verification-outcome-and-rework/shared/prd.md`". The
wireframe check runs as:

```bash
python3 tools/wireframe-kit/check_wireframe_data.py examples/harbor-cover/products/desk/verification-outcome-and-rework
```

To make your own workspace, run `/setup` at the repository root. Do not copy this folder's
facts into your `knowledge/`.
