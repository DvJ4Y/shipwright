---
name: product-discovery
description: Runs Phase 1 discovery — frames the business question, links it to an outcome metric id, gathers labelled evidence, checks what exists today, tests operational viability, prioritises with RICE or MoSCoW and returns a go, clarify or kill verdict with a written business case. Benchmark mode compares approaches across products. Use when someone says "business case", "should we build this", "is this worth building", "is X worth building?", "evaluate this idea", "prioritise", "size this", "which lever", "discovery", "why are customers dropping at…", "benchmark", "how do competitors do it", "compare approaches" or "what are others doing".
argument-hint: "<idea or question> [benchmark]"
---

# Product discovery — the business case before anything gets built

Run discovery before any PRD: interview, pull data, check what exists. Discovery is not
writing down what you already believed. Expect several rounds. An idea that reaches a PRD in
a day did not have discovery.

## Read first (if present; else name the missing file and ask)

| File | Gives you |
|---|---|
| `.agents/skills/product-loop/references/conventions.md` | Tiers, folders, decision points, gates, profile adaptation |
| `templates/discovery-template.md` · `templates/benchmark-template.md` | Output shapes |
| `context/08-strategy-and-outcomes.md` | Outcome metrics, targets, themes, where commitments live |
| `context/metrics-dictionary.csv` | Metric ids, denominators, authority, guardrails |
| `context/09-current-commitments.md` | What is committed, in build, in UAT, deployed |
| `context/surfaces/<surface>/current-behaviour.md` | What each surface does today, by row id |
| `context/01-company.md` · `context/02-service-and-lifecycle.md` | Segments by shop type; stages, sub-statuses, where the funnel leaks |
| `context/04-eligibility-and-verification.md` · `context/05-numbers-data-and-traps.md` · `context/06-teams-and-who-does-what.md` | Eligibility and rework; data traps; roles |
| `context/personas/` | Who has the problem, with evidence rows |
| `context/regulated-actions.md` | Register rows the idea may touch |
| `docs/03-the-loop.md`, `docs/07-data-and-mcp.md` (optional; skip silently if absent) | Where discovery sits; how evidence is pulled |

Apply `_profile.md`: `_experience: new` adds one line of "why" per step. A `_struggles` entry
that names data adds the population-boundary check even when `practised`.

## Questions first

One batched round; offer defaults; skip what the request already answers.

1. **Decision.** What decision does this discovery enable, and who owns it? [`_gate_owner` in `_profile.md`]
2. **Outcome.** Which metric id should move? [the closest row in `context/metrics-dictionary.csv`]
3. **Who.** Which shop type, sum-insured band or internal role has the problem? [inferred from the request; confirm]
4. **Evidence in hand.** What data, calls, ops input or research already exists? [none — I will look]
5. **Constraints.** Anything ruled out — an insurer contract, a regulated action, budget? [none]

Log a material answer as a decision point (`/decide` log mode).

## Procedure

1. **Phase check** (constitution rule 2). Discovery: in progress · PRD: not started.
2. **Frame.** One sentence: the question and the decision it enables.
   *"Should the rework item name the field that differs, so pharmacy customers resubmit once?"*
3. **Align.** Name the outcome metric id with its latest value and label. Name its target,
   labelled `target`. Name the commitment row it serves, or "none — new"; new work needs a
   PENDING decision naming the owner (`context/08-strategy-and-outcomes.md`). Say now if
   the link is weak, not at the PRD.
4. **What exists today.** Read, in order: the current-behaviour file for every surface the
   idea touches; `context/09-current-commitments.md`; the tracker through `/issue-tracker`
   if reachable (if not, say "tracker not reachable — snapshot only"); `products/` and
   `initiatives/`. Report duplicates and extensions before anything else. Most new ideas
   extend a row: "show the rule that fired to the customer" extends HUB-008 and DESK-003,
   not a new screen.
5. **Source register.** One row per source: `# | Source | Type | Date | Authority`.
6. **Evidence.** One row per finding: value, source, label, claim level. Labels are exactly
   `DB-verified <date>` · `analytics` · `operational — unverified` · `target` · `example`
   (fictional data only). Claim levels: implementation fact → measurement capability →
   descriptive movement → causal impact. **State the population boundary before any rate** —
   what the source excludes, and which metrics are therefore uncomputable. A rate from the
   SQL replica is `operational — unverified` until the BI tool agrees. Route pulls to
   `/data-analysis`.
7. **Regulated actions touched.** One line per register row the idea touches, or "none". No
   gating unless the compliance officer asks.
8. **Options.** Two to five, always including "do nothing" and "extend what exists". For
   each: pull (the effect on the metric id), cost to ops, operational viability, verdict.
9. **Operational viability test** for every new data point or step:
   - Who captures it — the customer, a support agent, a verification officer, a field verifier?
   - How long per case?
   - Can the system derive it instead? System-derived beats staff input. Staff input is one
     click at most — a pick from fields the case already holds, not free text.
   - **If it needs a training manual, it is too complex.**
   Test any new signal or classification with the ops lead before designing on it.
10. **Simplest v1.** Separate "required to run" from "nice to have for accuracy". A granular
    breakdown is a hypothesis for a pilot, not a v1 gate.
11. **Prioritise.** RICE — reach (cases per month in the population), impact (on the metric
    id), confidence (from the claim levels), effort as cost to ops, never engineering effort
    — or MoSCoW. Show the scoring, not a flat list.
12. **Decision-input register.** Every input still needed: decision point, input, owner
    (role), state. Open items become `[NEEDS CLARIFICATION: … → P-nn]`.
13. **Verdict.**

    | Verdict | When |
    |---|---|
    | **go** | Outcome linked, evidence supports the problem, a viable option exists |
    | **clarify** | One named input would change the answer — say which, and who owns it |
    | **kill** | Duplicate, no outcome link, not viable, or the evidence contradicts the problem |

    Name what you are choosing **against**.
14. **Gate.** Run the tier gate below. Hand the verdict to the owner as a PENDING decision.

### Benchmark mode

Use it instead of steps 5 to 13 when the question is "how do others do this?", or before
redesigning a flow.

1. Name the decision the benchmark informs. No decision, no benchmark.
2. Pick three to six products or approaches. Include one the customers already use — a
   personal-insurance app, a payments app, a government-services app. Include one adjacent
   market, such as a small-business current-account opening flow.
3. Fill `templates/benchmark-template.md`. The dimension × approach table puts "us today" in
   the first column. Source confidence is high (first-hand use or primary documentation),
   medium (reputable secondary) or low (marketing, a single review, inference). Then: what
   they get right; where we are stronger; where we over-split; the reframe; decisions to
   take, each with a door type.
4. Say why a pattern fits our customers, citing a persona card row. Do not copy a pattern
   built for a different customer.

## Gate

| Tier | Gate |
|---|---|
| S | Phase check · question, evidence and verdict fit on one page · writing standard |
| M | Every template section filled · population boundary stated before each rate · every number labelled · regulated-actions line present · zero open markers · the owner approves the verdict |
| L | M gate · source register added to the initiative `INDEX.md` · scope register updated |

On pass: `status: approved`, add the gate line, propose a commit.

## Output

| Tier | Path |
|---|---|
| S | `products/<code>/<feature>/internal/discovery.md` — the only file tier S writes |
| M | `products/<code>/<feature>/internal/discovery.md`; evidence pulls in `internal/evidence/` |
| L | `initiatives/<name>/features/<feature>/internal/discovery.md`; cross-feature research in `initiatives/<name>/research/<topic>.md` |
| Benchmark | beside the discovery, as `internal/benchmark-<capability>.md` |

Workstream codes: `hub` `desk` `field` `rules` `data` `comms`.

## Do not

- Do not skip to a PRD, a mockup or a tracker issue. Discovery outputs a business case.
- Do not push an unvalidated framework into the tracker or a shared document. It gains
  authority by existing there.
- Do not present a target as a baseline, or a SQL-replica or analytics rate as a headline.
- Do not estimate engineering effort, size work or set timelines.
- Do not use person names. Use roles.
- Do not conclude in one pass on a tier M or L item without the owner's input.
- Do not quote a segment split that `context/01-company.md` says is not measured.

## Hands off to

`/decide` to log the verdict PENDING → `/prd-writer` on **go**. On **clarify**, the owner of
the missing input. On **kill**, one line in `tasks/todo.md` with the revisit trigger.
