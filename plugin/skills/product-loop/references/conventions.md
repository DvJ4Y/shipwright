# Harness conventions — the single source

Every skill points here for the loop, tiers, folders, frontmatter, decision points,
versioning, gates, questions, labels and profile adaptation. Change a convention here, once.

## The loop

```
INTAKE → QUESTION → ALIGN → PRODUCE → GATE → REVIEW → DECIDE → HANDOFF → LAND → COMPOUND
```

| Step | Owner skill | Output |
|---|---|---|
| Intake | `/product-loop` | Verdict (go / clarify / park), tier, lane, workflow |
| Question | the producing skill | One batched round of 3–5 questions; the skill logs answers as decision points |
| Align | `/review` strategy lens, outcome check only | Outcome metric, target, commitment served; the lens flags drift |
| Produce | the specialist skill | The artifact, with `[NEEDS CLARIFICATION: … → P-nn]` markers |
| Gate | the producing skill | Tier checklist passed; zero open markers |
| Review | `/review` | Verdict, must-fix list, kill-assumptions |
| Decide | `/decide` | PENDING or LOCKED rows; propagation list |
| Handoff | `/engineering-brief`, `/issue-tracker` | Brief, issue pack, publication with read-back |
| Land | `/land` | Shipped behaviours appended to `context/surfaces/<surface>/current-behaviour.md`; PRD `landed` |
| Compound | `/session end`, `/session retro` | Handoff, lessons, memory facts, closeout checklist |

Engineering and release own two steps between Handoff and Land. `/issue-tracker release`
reconciles what reached production and sets the PRD to `shipped`. `/review post-ship`
compares what was meant with what was built.

## Tiers

| Tier | When | Artifacts | Gate |
|---|---|---|---|
| **S** (tweak) | One surface, no new data, reversible | One document | Phase check · self-review against the writing standard · boundary check |
| **M** (feature) | One coherent business capability | Feature folder | The 10 readiness checks + `/review` gate mode |
| **L** (initiative) | Several features, several sessions | Initiative folder | M gate per feature · INDEX state matrix current · crosswalk before any supersession |

**Escalate** a tier when the work touches new data, a second surface, a regulated action
(`context/regulated-actions.md`) or more than one role. **Never de-escalate** to skip a gate.

## The 10 readiness checks (tier M)

1. Objective, use cases and non-goals approved.
2. Current behaviour and reuse checked against `context/surfaces/<surface>/current-behaviour.md`.
3. Partner- or segment-specific behaviour is configuration.
4. Roles and permissions are clear.
5. Normal, empty, failure, rework and restricted states are covered.
6. PRD and mockup agree.
7. Issues map to acceptance criteria.
8. Older requirements are crosswalked.
9. Open inputs have owners.
10. The brief separates outcomes from engineering-owned design.

Record them in `templates/readiness-record-template.md`. When `_regulated: yes`, check 4
also names each regulated action touched and the evidence it keeps.

## Where things live

```
_profile.md                          who you are — read by the session-start hook
context/                             the durable layer: company, lifecycle, surfaces, policies, glossary, metrics
context/surfaces/<surface>/current-behaviour.md   what each surface does today; `/land` appends here
decisions/decision-log.md            workspace decision points, D-NNN
sessions/latest.md                   handoff, under 50 lines; sessions/daily/ holds the archive
tasks/todo.md · tasks/lessons.md     open items with no issue · every correction, as a rule
qa/<surface>/test-cases.csv          the QA catalog; `Planned` rows from the PRD, `Current` after release
products/<code>/<feature>/           tier S and M — one folder per feature
products/<code>/archive/landed-YYYY-MM-DD/<feature>/   moved by `/land`, with a "replaced by" README
initiatives/<name>/                  tier L initiative folder
```

Workstream codes: `hub` (Harbor) · `desk` · `field` · `rules` (the eligibility engine) ·
`data` · `comms`. Lanes: `customer` · `ops-platform`.

**Code → surface → files.** `land`, `prd-writer` and the QA catalogs resolve by this table,
never by guessing.

| Code | Surface | Current behaviour | QA catalogs | Row ids |
|---|---|---|---|---|
| `hub` | Harbor | `context/surfaces/harbor/current-behaviour.md` | `qa/harbor/` | `HUB-` |
| `desk` | Desk | `context/surfaces/desk/current-behaviour.md` | `qa/desk/` | `DESK-` |
| `field` | Field | `context/surfaces/field/current-behaviour.md` | `qa/field/` | `FLD-` |
| `rules` | the eligibility engine | the policy file in `context/policies/` that owns the rule | — | policy row |
| `comms` | messaging | the surface where the message is seen | that surface's | that surface's |
| `data` | data and analytics | `context/05-numbers-data-and-traps.md` | `qa/<surface>/analytics-events.csv` | `<SURFACE>-EVT-` |

**Feature folder** (tier M)

```
products/<code>/<feature>/
  shared/prd.md             shared/eng-brief.md        self-contained: no dates, no decision history, no internal IDs
  internal/discovery.md     internal/decision-log.md   internal/design-spec.md    internal/issue-pack.md
  internal/readiness.md     internal/review-YYYY-MM-DD-<mode>.md                          internal/evidence/
  mockups/<surface>-<feature>-v1.mockup.html            wireframes, hi-fi and prototypes, versioned by filename
  showcase/                 the story walkthrough and screenshots stakeholders see
  archive/superseded-YYYY-MM-DD/                        with a README: old file → replaced by → why
```

`shared/` is what engineering and outside readers get. `internal/` is the reasoning:
discovery, decisions, reviews, readiness, evidence. Tier S writes one file into `shared/` or
`internal/`, by audience. Example: `products/desk/verification-outcome-and-rework/`.

**Initiative folder** (tier L)

```
initiatives/<name>/
  INDEX.md  intake-feedback.md  decision-log.md
  features/<feature>/   (same shape as a feature folder)
  research/             archive/
```

## Frontmatter — every artifact

```yaml
status: draft          # see the status table
version: 0.1           # bump minor on edits, major on approval
supersedes: —          # path of the version this replaces
decision_refs: []      # decision points this artifact depends on
why: <one line>        # the outcome this artifact serves
last_updated: YYYY-MM-DD
```

| PRD status | Set by | Means |
|---|---|---|
| `draft` | the author | Being written; open markers allowed |
| `in-review` | the author | Zero open markers; `/review` gate requested |
| `approved` | the gate owner | Gate passed; the body is never edited in place again. `/issue-tracker release` and `/land` may still set `status`, `shipped_on`, `landed_into` and `last_updated` |
| `shipped` | `/issue-tracker release`, with `shipped_on:` | Release reconciliation shows `deployed to prod` |
| `landed` | `/land`, with `landed_into:` | Behaviours are rows in `current-behaviour.md`; folder archived |
| `superseded` | `/decide` supersede mode | Replaced; the crosswalk shows where each requirement went |

Other artifacts use `draft` · `in-review` · `approved` · `superseded`. Context files add
`> Last verified: YYYY-MM-DD` in the body. Templates in `templates/` already carry it all.

## Decision points

- Two ID series. The workspace log `decisions/decision-log.md` uses `D-001`, `D-002`, …. A
  feature or initiative log (`internal/decision-log.md`, `initiatives/<name>/decision-log.md`)
  uses `P-01`, `P-02`, …. IDs are never reused.
- Status: `PENDING` → `LOCKED` (owner confirmed) → `SUPERSEDED` (replaced by a later row).
- An open point inside an artifact is a marker: `[NEEDS CLARIFICATION: <question> → P-nn]`.
  The marker points at a PENDING row. **Any open marker blocks promotion past `draft`.**
- The author logs a recommendation PENDING. Only the named owner locks it. Example: `D-006`
  (rework reasons a field verifier may resolve on site) waits for the ops lead.
- Format: `templates/decision-log-template.md`. Longer reasoning:
  `templates/decision-record-template.md`.

## Versioning

- Edit a draft in place. **Never edit an approved file's body in place** — copy to the next
  version. The lifecycle fields `status`, `shipped_on`, `landed_into` and `last_updated` are
  the exception: `/issue-tracker release` and `/land` set them on the approved file.
- Mockups version by filename: `-v1`, `-v2`, `-v2.1`.
- Superseded files move to `archive/superseded-YYYY-MM-DD/` with a README table: old file →
  replaced by → why. Write the crosswalk (`templates/crosswalk-template.md`) **before**
  superseding anything that carried requirements.
- Landed feature folders move to `products/<code>/archive/landed-YYYY-MM-DD/` with a
  "replaced by" README naming the `current-behaviour.md` rows. Only `/land` moves them.
- Each passed gate gets a commit proposal: the editor's commit-proposal tool if one exists,
  otherwise the `git commit` command for the product lead to approve. Git is the restore point.

## Gates — approve or send back

Every gate ends with one line in the artifact or its review report:

```
Gate: <approve | send back> · By: <role> · On: YYYY-MM-DD · Reason: <one line>
```

A send-back names the failing check and the fix. The author fixes; the reviewer re-runs.
The gate owner is `_gate_owner` in `_profile.md`; by default, the lane's product lead.

## Asking questions

- One batched round, 3–5 questions, each one changing the output. Use the editor's
  structured-question tool if available; otherwise a numbered list.
- Offer a default for each. The product lead may answer "defaults".
- Reversible micro-choices: pick the default, state it in one line, move on.
- Irreversible or material choices: ask, and log the answer as a decision point.

## Source labels

Exactly five: `DB-verified <date>` · `analytics` · `operational — unverified` · `target` ·
`example` (fictional data only). Every number carries one. A target is never a baseline.

## Profile adaptation (`_profile.md`)

Every field in `_profile.md` changes how a skill behaves. The table is in
`references/profile.md` (this skill). If `_profile.md` is missing, use `practised`, tier M, and
suggest `/onboard` once.

## Reading files

Read a named file **if present**. If it is missing, name it and ask. Never invent its
contents and never continue as though it had been read. Production beats files. Stage names,
sub-statuses and policy values come from `context/02-service-and-lifecycle.md` and
`context/policies/`, which mirror production. A document that disagrees with them is wrong.
