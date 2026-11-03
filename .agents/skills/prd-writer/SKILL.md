---
name: prd-writer
description: Writes and revises feature PRDs — WHAT and WHY only: objective, users and use cases, current behaviour and reuse, flow and scope, non-goals, rules and configuration, information, permissions and audit, regulated actions touched, states, observable "When… then…" acceptance, metrics with a guardrail and an anti-metric, dependencies, impact and a crosswalk to earlier requirements. Use when someone says "write a PRD", "write the PRD for…", "requirements", "feature spec", "product spec", "draft the requirements", "spec this out", "update the PRD" or "turn this discovery into requirements".
argument-hint: "<feature> [tier]"
---

# PRD writer — requirements, never solutions

Write WHAT and WHY only; leave every HOW to engineering. A PRD is the single source for
business behaviour. It makes the main use case obvious on the first page.

## Read first (if present; else name the missing file and ask)

| File | Gives you |
|---|---|
| `.agents/skills/product-loop/references/conventions.md` | Folders, frontmatter, markers, gates, the readiness checks |
| `templates/prd-template.md` | The shape |
| `internal/discovery.md` for this feature | The problem, evidence, verdict and the options rejected |
| `context/surfaces/<surface>/current-behaviour.md` — every surface the feature touches | What is live, by row id. **Read before writing any requirement** |
| `context/02-service-and-lifecycle.md` · `context/04-eligibility-and-verification.md` | Stage and sub-status names; eligibility and rework vocabulary |
| `context/06-teams-and-who-does-what.md` · `context/07-glossary.md` | Roles; one term per concept |
| `context/metrics-dictionary.csv` · `templates/metric-contract-template.md` | Metric ids and guardrail rows; how to propose a row that is missing |
| `context/policies/` | Policy values the rules section cites |
| `context/regulated-actions.md` | Register rows and the evidence each keeps |
| `qa/README.md` | The 15-column schema for the `Planned` rows |
| `templates/crosswalk-template.md` | Treatments for earlier requirements |
| Existing artifacts in the feature folder | What was already decided |
| `docs/03-the-loop.md`, `docs/11-policies-and-compliance.md` (optional; skip silently if absent) | The phase; regulated-action handling |

**No discovery?** Say so. Ask whether it happened offline. If not, offer `/product-discovery`.
Do not refuse; record the gap in the phase check.

## Questions first

One batched round; offer defaults.

1. **Primary use case.** Which single user situation must work first? [the top job in discovery]
2. **Non-goals.** What is out? [the options rejected in discovery]
3. **Configuration.** Which behaviour varies by insurer partner, product or shop type? [none until stated]
4. **Roles.** Who can see, act on and override each step? [roles in `context/06-teams-and-who-does-what.md`]
5. **Success.** Which metric id is the outcome, and which row is the guardrail? [from discovery]

## Procedure

1. **Phase check** (constitution rule 2). State it in chat and record it in
   `internal/readiness.md`, never in the shared body.
2. **Objective.** Two or three sentences: outcome, users, metric id.
3. **Users and use cases** as rows: When… I want to… so I can…. Test each: could three
   different designs satisfy it? If not, it is a solution — rewrite it. Name the shop type
   where it matters and cite the persona card. Solve for the hardest case first.
4. **Current behaviour and reuse.** One row per existing behaviour, cited by id (`HUB-008`,
   `DESK-004`, `FLD-005`), marked reused, extended or replaced. Then, **before every
   requirement row you write** — use case, rule, acceptance — ask: does an existing row
   already cover it? If yes, cite the row and do not restate it. If it extends a row, say
   how: "extends DESK-004: the verification officer also names the field that differs on
   `mismatched`".
5. **Flow and scope.** Numbered steps or a diagram. Then **non-goals**, each with where it
   goes instead.
6. **Rules and configuration.** Condition → behaviour, the policy it comes from, and whether
   it is configurable per insurer partner, product or shop type. Varying behaviour is
   configuration, not a code path. Never invent a rule to fill a gap; mark it.
7. **Information, permissions and audit.** Who provides each data point, who sees and edits
   it, the register row it serves, the evidence kept. Run the viability test on every new
   data point: who captures it, how long per case, can the system derive it. Close the
   section with one labelled line — **Regulated actions touched:** the register rows the
   feature touches ("identity verification · consent and disclosure · record retention"),
   or "none". Always present. When `_profile.md` says `_regulated: yes`, the gate checks
   the line against `context/regulated-actions.md`.
8. **States.** One row each for normal and the six strips — EMPTY · PARTIAL · MISSING ·
   RESTRICTED · PROVIDER-FAILED · REWORK. A strip that does not apply says why.
9. **Acceptance.** Observable "When …, then …" statements numbered A1 … An, each mapped to a
   use case, with no mechanism words. About eight per feature; justify more. One criterion
   per evidence record a regulated action requires.
10. **Metrics.** Outcome, guardrail and anti-metric, each with a metric id from the
    dictionary, a source and a claim level. Baseline labelled, or "not measured". Target
    labelled `target`. For the worked feature: outcome `VER-M2`; guardrails `REW-G1` and
    `VER-M1`; anti-metric: rework items raised per case — not in the dictionary, so propose
    a row with `templates/metric-contract-template.md` rather than mis-assign one.
11. **Dependencies and open inputs** with owner roles. An open input stays in this section
    only if a developer could build without inventing policy in its absence. Otherwise it
    is a marker and blocks `in-review`.
12. **Interconnections and impact.** What this feeds, depends on or conflicts with; what
    changes per layer; second- and third-order effects with who feels them and the early
    signal. The Data row names data points and their owners, never tables or storage. Scale
    it: full for a feature that changes data, workflow, another team's work or a metric;
    two lines for a small one.
13. **Crosswalk.** If earlier requirements, drafts or issues exist, fill
    `templates/crosswalk-template.md` at `internal/crosswalk.md`; every earlier row gets a
    treatment. Section 13 of the PRD lists each carried requirement in one line with its
    treatment, without paths or decision ids.
14. **Markers.** Every open point is `[NEEDS CLARIFICATION: <question> → P-nn]` with a
    PENDING row in `internal/decision-log.md`. Any open marker blocks `in-review`. Tier S
    has no feature log: its PENDING row goes to `decisions/decision-log.md`, and a second
    open marker escalates the tier.
15. **Self-contained check** for `shared/prd.md`: the body carries no dates other than the
    date inside a source label (the frontmatter keeps `last_updated` and `shipped_on`), no decision history, no `P-nn`, no local paths, no phase
    check, roles not names, capability names not vendor names. A resolved marker leaves the
    rule in the body and its reasoning in `internal/decision-log.md`.
16. **Self-review** against the gate. Set `status: in-review` and hand to `/review gate`.
17. **On approval — QA trigger 1.** Append `Planned` rows to `qa/<surface>/test-cases.csv`
    for every surface the PRD touches: one scenario per distinct behaviour, steps sketched
    from the acceptance criteria, `Build State = Planned`, `Traces To` = the PRD path, the
    acceptance id and the register row where one applies. One `P0` row per evidence record.
    One `<SURFACE>-EVT-NNN` row per event the PRD marks **new**. Scenario ids take the next
    free `<SURFACE>-<SUB>-NNN`; the test case is `-T1`. These rows are the manual acceptance
    catalog the release gate runs, owned by the product lead. They are not engineering's
    test plan.

**Customer-facing rules** (facts in `context/02-service-and-lifecycle.md` and
`context/04-eligibility-and-verification.md`): every `declined` or `rework` outcome names the
rule in plain words and a recovery path — update a document, upload a different identity proof,
book a field visit, talk to a verification officer. Never frame the customer as rejected by
an insurer or a provider. A provider failure never declines. `refer` is never shown as
declined. No numeric score reaches the customer. Customer surfaces are in the customer's
language first; internal surfaces ship in English unless the profile says otherwise.

## Gate

| Tier | Gate |
|---|---|
| S | Phase check · objective, acceptance and non-goals present · boundary check · writing standard |
| M | Every section filled or marked N/A with a reason · regulated-actions line present · zero open markers · every acceptance criterion maps to a use case · metrics labelled, with a guardrail and an anti-metric · self-contained check passed · a reader holding only this PRD can restate the feature and its impact · `/review gate` verdict **ready** |
| L | M gate · feature row in the initiative `INDEX.md` updated · crosswalk approved before anything is superseded |

On pass: `status: approved`, bump the major version, write the gate line in
`internal/readiness.md`, propose a commit, then run QA trigger 1. Never edit an approved PRD
in place — copy to the next version with `supersedes:` set.

## Output

| Tier | Path |
|---|---|
| S | `products/<code>/<feature>/shared/prd.md` — the only file tier S writes |
| M | `products/<code>/<feature>/shared/prd.md` — evidence, crosswalk, decisions, readiness and reviews in `internal/` |
| L | `initiatives/<name>/features/<feature>/shared/prd.md` |
| QA rows | `qa/<surface>/test-cases.csv` |

Statuses: `draft` · `in-review` · `approved` · `shipped` (set by `/issue-tracker release`) ·
`landed` (set by `/land`) · `superseded`. Under 200 lines; split by feature, never by
document type.

## Do not

- No API contracts, endpoints, schema changes, columns, architecture, component structure,
  state management, test strategy, rollout or feature-flag plans, technology choices,
  estimates or timelines. If asked: "This is engineering territory — an engineering brief
  instead, or a labelled strawman for discussion?"
- Do not invent a business rule or a policy value. Mark it.
- Do not restate a behaviour that a current-behaviour row already covers. Cite the row.
- Do not copy regulation text or full policy tables into the PRD. Name the register row and
  the policy.
- Do not let a mockup carry a rule the PRD does not state.
- On a revision, do not add an acceptance criterion without merging or removing one.
- Do not write `Current` QA rows. Trigger 2 flips them after a code trace.

## Hands off to

`/mockup` and `/product-copy` if the feature changes a surface → `/review gate` →
`/engineering-brief` after approval. Later, `/issue-tracker release` sets `shipped` and
`/land` sets `landed`.
