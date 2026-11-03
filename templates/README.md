---
title: Templates — index
type: readme
status: active
version: 1.0
supersedes: —
decision_refs: []
why: Lists every template and the artifact it produces
last_updated: 2026-11-02
---

# Templates

One template per artifact type. Copy it, fill it, keep the frontmatter. Filled examples live
in `context/`, `decisions/` and the worked feature folder — not beside the templates.

| Template | Use it for |
|---|---|
| `discovery-template.md` | Phase 1 — the business case with a go / clarify / kill verdict |
| `benchmark-template.md` | A comparison of approaches or products that informs one decision |
| `prd-template.md` | Phase 2 — WHAT and WHY; observable acceptance; states; metrics; impact |
| `design-spec-template.md` | What was chosen in a mockup round and why the other options were not |
| `screen-contract-template.md` | Tier L only — one agreed statement of a screen several features share |
| `eng-brief-template.md` | Phase 2.5 — what product needs and where it touches the system, for the engineering lead |
| `issue-pack-template.md` | The parent issue and functional sub-issues, as copy source for the tracker |
| `readiness-record-template.md` | The product-to-engineering handover gate, with evidence per check |
| `review-report-template.md` | What the reviewers found: gate, red-team or post-ship mode |
| `crosswalk-template.md` | Where every earlier requirement went before a file is superseded |
| `decision-log-template.md` | The append-only table of decision points: `D-nnn` workspace, `P-nn` feature |
| `decision-record-template.md` | The longer reasoning behind one decision point |
| `intake-feedback-template.md` | The owner's running direction, newest on top |
| `initiative-index-template.md` | Tier L — the entry point, state matrix and task packets for an initiative |
| `impact-matrix-template.md` | One page of features × layers, shown in chat before files are written |
| `metric-contract-template.md` | One metric, defined once, before its row enters the dictionary |
| `persona-card-template.md` | A customer or role card with an evidence table |
| `memory-fact-template.md` | One fact per file for the agent's memory: the fact, Why, How to apply |
| `current-behaviour-template.md` | The per-surface table of landed behaviours that `land` appends to |
| `story-script-template.md` | The beats of a product story or demo: time, screen, what happens, caption |
| `policy-template.md` | An internal rule as a condition → outcome table with owner, source and evidence |

## Conventions every template shares

- Frontmatter carries `status`, `version`, `supersedes`, `decision_refs`, `why`,
  `last_updated`. Context files add `> Last verified: YYYY-MM-DD` in the body.
- Roles, not names. Capability names, not vendor names. Every number carries a label.
- Open points are `[NEEDS CLARIFICATION: <question> → P-nn]` and block promotion past `draft`.
- No dates or timelines in requirements. Parallel tracks, not phases with weeks.
- Under 200 lines. Split by feature if longer.
