---
name: product-loop
description: Routes a new piece of product work. Returns an intake verdict (go, clarify or park), a tier (S, M or L), a lane, the workflow of skills to run, the phase check and a session map. Tier L runs initiative mode — source register, scope register, phases and parallel-session task packets. Use when someone says "I want to work on…", "where do I start", "where do I start on…", "new request", "what's the process for this", "plan this feature", "plan this initiative", "pick this up", "what's next on this", "is this ready for engineering", "is the … feature ready", or brings an idea, a surface or a feature name without saying which artifact they need.
---

# Product loop — intake and routing

Decide what this work is, how much process it deserves, and which skills run in which
order. Produce nothing else until the product lead agrees the verdict.

## Read first (if present; else name the missing file and ask)

| File | Gives you |
|---|---|
| `references/conventions.md` (this skill) | Loop, tiers, folders, frontmatter, decision points, gates, profile fields |
| `_profile.md` | Role, lane, focus, experience, default tier, tool access, `_regulated`, gate owner |
| `context/08-strategy-and-outcomes.md` | Outcome metrics, targets, themes, where commitments live |
| `context/09-current-commitments.md` | What is already committed — the most common duplicate |
| `context/metrics-dictionary.csv` | The metric ID the outcome maps to |
| `context/surfaces/<surface>/current-behaviour.md` | What the surface does today; most "new" work extends a row |
| `context/regulated-actions.md` | Read when `_regulated: yes`; a touched row escalates the tier |
| `sessions/latest.md`, `tasks/todo.md` | What is already in flight here |
| `decisions/decision-log.md` (or the initiative's log) | Open decision points that may block this |

If the tracker is reachable through `/issue-tracker`, search it for the same outcome before
giving a verdict. If it is not reachable, say so; do not reason about a backlog you cannot see.

## Questions first

Ask one batched round. Offer the default in brackets; the product lead may reply "defaults".

1. **Outcome.** Which customer or operational outcome does this move, and which metric ID?
   [the closest metric in `context/metrics-dictionary.csv`]
2. **Trigger.** Where did this come from — data, ops, a customer, a partner, leadership, a
   meeting? [as stated in the request]
3. **Scope.** One surface or several? Any new data captured? Any regulated action?
   [inferred from the request and `context/regulated-actions.md`]
4. **Owner.** Who decides at the gates? [`_gate_owner` in `_profile.md`]
5. **Already exists?** Is any of this live, committed or in the tracker? [checked by you]

Skip any question the request already answers. Never ask more than five.

## Procedure

1. **Duplicate check.** Search `context/09-current-commitments.md`, the tracker through
   `/issue-tracker` (if reachable), `products/` and `initiatives/` for the same outcome.
   Report hits with paths or issue keys.
2. **Verdict.**

   | Verdict | When |
   |---|---|
   | **go** | Outcome named, owner named, not a duplicate |
   | **clarify** | Outcome or owner missing, or the request is a solution with no problem |
   | **park** | Duplicate of committed work, no outcome link, or blocked by a PENDING decision |

   For **park**, add one line to `tasks/todo.md` with the reason and the revisit trigger.
3. **Tier.** Apply the tier table in `references/conventions.md`, including its escalation
   rule. State the reason in one line. If unclear, use `_default_tier` from `_profile.md`.
4. **Lane.** `customer` or `ops-platform`. Cross-lane work names both lanes and one owner.
   The rework message is the standing example: Desk raises it, Harbor shows it.
5. **Workflow.** Pick from the table below. Adjust only with a stated reason.
6. **Phase check.** State it (constitution rule 2).
7. **Alignment brief** (tier M and L). Before you write any file, give one page in chat.
   It lists: the outcome and metric · the features in scope (3 to 5) · the impact matrix
   (`templates/impact-matrix-template.md`) · the top open decisions · the proposed order.
   The product lead confirms it in chat. For a UI-heavy feature, sketch the two or three
   riskiest flows at L0 before the PRD gate. A wireframe exposes scope a PRD hides.
8. **Session map** (tier M and L). One topic per session; a fresh session per phase.
   List each session with its skill, inputs, output file and gate.
9. **Confirm.** Ask the product lead to confirm verdict, tier and workflow in one prompt.
   Then hand off to the first skill.

### Workflows

| Request shape | Tier | Workflow |
|---|---|---|
| Copy or label change | S | `/product-copy` → self-review → `/session end` |
| Small UI tweak | S | `/mockup` (L0 or L1) → self-review → `/session end` |
| A data question | S | `/data-analysis` |
| A choice between options | S | `/decide` |
| Meeting notes | S | `/meeting-processor` |
| A shipped feature to fold back | S | `/review post-ship` → `/land` |
| New or changed feature | M | `/product-discovery` → `/decide` → `/prd-writer` → `/mockup` + `/product-copy` (if UI) → `/review gate` → `/engineering-brief` → `/issue-tracker` (pack mode) → readiness record → `/review gate` → handoff |
| Competitive question | S or M | `/product-discovery` benchmark mode → `/decide` |
| Several features under one outcome | L | Initiative mode (below) → the M workflow per feature |

After handoff, every M feature continues: `/issue-tracker release` (PRD → `shipped`) →
`/review post-ship` → `/land` (PRD → `landed`). Every workflow ends with `/session end`.
Every feature closes with `/session retro`.

### Initiative mode (tier L)

Use when several features share one outcome and the work spans sessions.

1. **Create the folder** `initiatives/<name>/` from templates:
   `initiative-index-template.md` → `INDEX.md`, `intake-feedback-template.md` →
   `intake-feedback.md`, `decision-log-template.md` → `decision-log.md`. Add `features/`,
   `research/`, `archive/`.
2. **Source register.** List every input document. Classify each:

   | Authority | Means |
   |---|---|
   | governing | Current, approved; this initiative follows it |
   | evidence | Useful requirements or data; not a structure to satisfy |
   | historical | Explains an earlier decision only |

   Source precedence: confirmed objective and current decisions → current behaviour and
   live evidence → approved feature decisions → reference inputs → historical drafts.
3. **Scope register.** Each scope item: in, out or deferred (with a trigger), its feature,
   and its decision point.
4. **Feature selection.** A feature is a coherent business capability. It has: an outcome ·
   a current problem · a flow the owner can demonstrate · bounded roles, rules and states ·
   testable acceptance · a release boundary. Boundaries come from the capability.
5. **Phases.** Name each phase with its goal and exit gate. Phases follow dependency and
   value.
6. **Task packets** for parallel sessions. Each packet lists the files it owns, the files it
   reads, its dependencies and its gate. **Two sessions never own the same file.** The
   coordinating session owns `INDEX.md` and `decision-log.md`. **Cut packets by feature,
   not by document type** (constitution rule 15). One owner drafts a feature's PRD, rules,
   screens and acceptance. An integrator session checks the links between features.
7. **State matrix.** Keep the INDEX feature matrix current after every gate.
8. **Supersession.** Before you supersede an older file, write the crosswalk
   (`templates/crosswalk-template.md`) and get it approved. Then archive with a "replaced
   by" README.

## Gate

The intake gate passes when the product lead confirms verdict, tier, lane and workflow.
Record it in `sessions/latest.md` (tier S and M), in the feature folder's `README.md` (tier M) and in `INDEX.md` (tier L).

## Output

- Tier S and M: the verdict block in chat, one line in `sessions/latest.md`.
- Tier L: the initiative folder, with `INDEX.md` filled.

Verdict block format, filled for a Harbor Cover request:

```
Verdict: go — outcome and owner named; extends DESK-004, not a duplicate of C1
Tier: M — one capability on Desk and Harbor; touches a regulated action (identity verification)
Lane: ops-platform — customer lane reviews the rework message
Outcome: VER-M2 — rework cycle time, 31 hours (`example`) → 18 hours (`target`)
Workflow: /product-discovery → /decide → /prd-writer → /mockup → /review gate → /engineering-brief → /issue-tracker
Phase check: Discovery Not done · PRD N/A · Engineering alignment N/A at this phase
Sessions: 4 — discovery · PRD · mockup and copy · brief and issue pack
```

## Do not

- Do not produce the artifact here. Route to the skill that owns it.
- Do not give **go** to work with no outcome link or no owner.
- Do not start an initiative folder for one feature. That is tier M.
- Do not quote a target as a baseline when naming the outcome.
- Do not open files for a tier M or L piece before the product lead confirms the alignment
  brief in chat.
- Do not write one PRD per phase for a multi-feature initiative. Write one requirement per
  feature. If the product lead still wants one PRD per phase, state the cost: shallow
  feature requirements.
- Do not treat a `Done` issue as shipped. Only `deployed to prod` counts.

## Hands off to

The first skill in the workflow. For tier L, the first feature's `/product-discovery`.
For a shipped feature, `/land`.
