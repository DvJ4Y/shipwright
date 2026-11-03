---
title: 08 — Handoff to engineering
type: doc
status: active
version: 1.0
supersedes: —
decision_refs: []
why: Settles what engineering receives, in what form, and what counts as shipped afterwards
last_updated: 2026-11-02
---

# 08 — Handoff to engineering

Read this when you need to decide what engineering receives, in what form, and what counts
as shipped afterwards.

## The boundary

Product writes WHAT and WHY. Engineering writes HOW.

| Product does | Product does not |
|---|---|
| Business analysis and sizing; requirements; design research and mockups; the engineering brief; the issue pack from the approved brief; data queries; market research | API contracts; schema changes; architecture; component structure or state management; integration implementation; test strategies; rollout plans; effort estimates; technology choices |

When asked to cross it, the agent says: "This is engineering territory — an engineering
brief instead, or a labelled strawman for discussion?" The author names a strawman as one,
and it never becomes the spec.

The alignment conversation exists because engineering often knows a simpler route: a
configuration that exists, a field already on the table, a query that already runs.
Knowing a plausible answer is not a reason to skip it. Briefs address the engineering lead,
not individual developers. Product documents carry no dates or timelines; the author
frames work as parallel tracks.

## The brief

`/engineering-brief` writes `shared/eng-brief.md` from an approved PRD, with
`templates/eng-brief-template.md`. No approved PRD, no brief.

| § | Section | Holds |
|---|---|---|
| 1 | Capability | What is added or changed, for whom, the outcome it serves |
| 2 | Reuse | What exists, as **locations** (a table, column, event or screen), and how it is extended in product terms. A configuration table: item, who changes it, where it is configured today, existing or new |
| 3 | Invariants | Rules that hold in every state |
| 4 | Scenarios | State, failure and integration scenarios, each with a required outcome and an acceptance id. The six state strips (EMPTY, PARTIAL, MISSING, RESTRICTED, PROVIDER-FAILED, REWORK) where they apply |
| 5 | Dependencies and constraints | Owner, status, the constraint each adds |
| 6 | Regulated actions and evidence | The register row, the evidence the product must keep, where it is visible |
| 7 | Observability and reconciliation | What product must be able to see after release; metric ids |
| 8 | Decisions engineering owns | Schema, APIs, component design, migration, rollout, test plan, estimates, task breakdown |
| 9 | Open inputs | The owner role; whether a developer would have to invent policy without it |
| 10 | Anticipated questions | The engineering lead's questions, each with a product answer or "engineering to decide" |

Three rules decide whether a brief is usable.

- **Reuse is a location, not a design.** "Exists at `h_document.status`" is a reuse
  location. A proposed column is a design and does not belong.
- **Every scenario has an outcome from a source.** The outcome comes from a PRD rule or a
  policy row. The author writes a scenario with no stated outcome as `open input — owner:
  <role>`, and it blocks handover. "Engineering to decide" answers HOW questions only.
- **Be specific, or the brief wastes the alignment conversation.** Name the data point, say
  existing or new, name the acceptance id. "Touches the console" produces a meeting and
  nothing else.

## The issue pack

`/issue-tracker pack` builds `internal/issue-pack.md` from the approved PRD, brief and
mockups. It introduces no requirement absent from them.

| Part | Rule |
|---|---|
| Parent issue | Problem and outcome; users and use cases; scope and non-goals; summary acceptance; dependencies; links to the PRD, brief and mockups as repo paths; the list of sub-issues |
| Product sub-issues | Functional slices a customer can see or an operator can accept. Never Frontend, Backend, API, Database or QA |
| Each sub-issue | Six parts: Outcome · Behaviour and states · Acceptance (the PRD's criteria verbatim, with ids) · Rules, permissions and evidence (PRD rows by id, with the policy value) · Depends on · Reference (PRD section, mockup frame) |
| Fields, not prose | Project, cycle, state, parent and labels are fields. Nothing a field can hold goes into the description |
| Trace | Every sub-issue maps to at least one acceptance id; every acceptance id, rule and evidence record maps to a sub-issue or the parent. Recorded as readiness check 7 |

`/issue-tracker publish` runs only after the product lead approves the pack. It creates
the parent when the duplicate check finds none and updates the found issue by id otherwise.
It copies text verbatim, reads every issue back, diffs it against the pack and records the
result in the publication log. Engineering creates its own technical sub-issues after
handover.

## The link rule

The parent product issue carries the link to the engineering issue that implements it.
Sub-issues move with the parent. If engineering splits its work, each split sub-issue gets
its own link.

| Product state | Needs |
|---|---|
| `Handed to Eng` | A linked engineering issue. No link, no state change |
| `Shipped` | The linked issue at the engineering team's deployed-to-production state, and production evidence for every acceptance criterion or a `/decide` deferral |
| `Landed` | `/land` has appended the current-behaviour rows |

The product-team states the adapters describe (`Backlog · Discovery · Drafting · In Review
· Approved · Handed to Eng · Shipped · Landed · Cancelled`) and the three label groups are a
starting set. The product lead decides whether their tracker keeps them.

## The status vocabulary

| Status | Means |
|---|---|
| `committed` | On the commitments list; not in build |
| `in build` | Engineering is working on it |
| `in UAT` | Built; ops or product is accepting it. `developed` and `deployed-pending-validation` map here |
| `deployed to prod` | Live for customers or staff. **The only status that counts as shipped**, once the product lead confirms the behaviour in production |

A `deployed to prod` item also records its rollout boundary: `production` · `pilot` ·
`limited-rollout` · `validated`. "Live", "released", "rolled out" and "available" are not
statuses. `Done` in the tracker is not a status: the engineer finished, and the item may not
be deployed. `held`, `rolled-back` and `superseded` go to the "deliberately not in scope"
table in `context/09-current-commitments.md`, with the reason.

## Release reconciliation

`/issue-tracker release` runs once per cycle, after the engineering team's issues move.

1. The window, the audience and the surfaces in scope.
2. Reconcile planned against actual. Planned: the commitments snapshot and the cycle's
   issues. Actual: engineering issues at the deployed-to-production state that the product
   lead has confirmed. Each item gets exactly one status. An item with a tracker state and
   no production evidence is `in UAT`.
3. The clarification gate. `/issue-tracker release` asks every open status, rollout and
   attribution question together and pre-fills the safest reading. No publishable text
   before it closes.
4. An impact chain per material item: engineering change → behaviour enabled → customer or
   operator behaviour → business consequence → evidence, with its claim level.
5. QA trigger 2: whoever shipped confirms each `Planned` row the release touches against the
   code and sets its build state. The note lists the rows confirmed and the rows still
   `Planned`.
6. The note at `releases/<cycle>-release-note.md`, through the publication QA.
7. The PRD flip, below.

**Single landing.**

| Condition | Result |
|---|---|
| The parent engineering issue is deployed to production, and every acceptance criterion has production evidence or a `/decide` deferral | The PRD flips to `shipped` with `shipped_on` |
| Some criteria have no evidence and no deferral | The PRD stays `approved`; the note lists the shipped criteria by id |
| A deployed item's PRD is not `approved` | The run stops; the note lists it as "shipped without an approved PRD" |
| The PRD is `shipped` | `/land` runs once. There is no re-landing path |
| A criterion was deferred | It returns as a row in a later PRD when its decision is LOCKED |
| The PRD is approved | Only `status`, `shipped_on`, `landed_into` and `last_updated` change; the body stays frozen |

## Who owns the QA catalog

Product owns the scenario: acceptance in executable form, written as `Planned` rows when
the PRD is approved. Whoever ships owns test data, expected result and build state, set at
trigger 2. `/land` reconciles; it never sets `Blocked` or `Fix-pending`. `qa/PROCESS.md` has
the four triggers.

## Agree these with your engineering lead before the first handoff

The harness ships defaults for seven inputs it cannot know. Settle each with the
engineering lead and record the answer in the glossary's tracker row or the adapter file.

1. **Which engineering state is deployed-to-production**, and whether it is terminal. The
   adapters assume one named state; `Done` is never it.
2. **Whose cycle release mode reconciles.** The product team's cycle, the engineering team's,
   or a calendar window.
3. **One engineering issue per parent, or per sub-issue, and who creates it.** The default:
   one per parent, created by engineering; a split sub-issue gets its own link.
4. **What engineering reads.** The tracker only, or also the repo's `shared/`,
   `context/policies/`, `context/surfaces/`, `context/05-numbers-data-and-traps.md` and
   `qa/`. The default hands over `shared/` and opens the rest for reading. Sub-issues quote
   rule and evidence rows by id with the policy value, so a developer who reads only the
   tracker still has the rules.
5. **Who owns `qa/<surface>/test-cases.csv`.** The default: product writes scenarios;
   engineering fills test data, expected results and build state.
6. **A PRD whose criteria ship across two cycles.** The default: it stays `approved` until
   every criterion has evidence or a deferral, then lands once.
7. **How production evidence is attributed when engineering splits work differently** from
   the product sub-issues. The default: evidence attaches to acceptance ids, not to issues,
   so the split does not change the flip.
