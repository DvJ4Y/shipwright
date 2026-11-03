---
name: engineering-brief
description: Writes the engineering brief from an approved PRD, addressed to the engineering lead — the capability, reuse locations, invariants, configuration, state, failure and integration scenarios, dependencies, regulated evidence, observability, the decisions engineering owns, open inputs and anticipated questions. Never writes the HOW and never estimates. Use when someone says "engineering brief", "prepare the engineering brief", "handoff to eng", "hand this to engineering", "what areas are touched", "what does engineering need to know", "prepare for eng alignment", "brief the engineering lead", or asks for a technical spec or implementation plan (this skill reframes it as a brief).
argument-hint: "<feature>"
---

# Engineering brief — what product needs and where it touches the system

Write the brief for the engineering lead: outcomes and constraints, no design. The brief
opens engineering alignment. Address it to the engineering lead. State outcomes and
constraints precisely enough that no developer has to invent business policy. Leave every
design decision to engineering.

**Asked for a technical spec, an implementation plan or an API design?** Say: "This is
engineering territory. The brief gives the engineering lead what the spec needs; I will
write the brief." Then run this skill.

## Read first (if present; else name the missing file and ask)

| File | Gives you |
|---|---|
| The approved `shared/prd.md`, and `mockups/` if any | The behaviour to hand over |
| `internal/data-packet.csv`, `internal/design-spec.md`, `shared/copy.md` (if present) | Data points with provenance and disposition; the chosen design; strings per outcome and language |
| `templates/eng-brief-template.md` | The shape |
| `.agents/skills/product-loop/references/conventions.md` | Readiness check 10, gates, folders |
| `context/03-surfaces-and-systems.md` | What exists, its status, integrations by capability name |
| `context/05-numbers-data-and-traps.md` | SQL replica tables, the events that exist, the three traps |
| `context/04-eligibility-and-verification.md` | What is configuration and what is code; the provider-failed rules |
| `context/surfaces/<surface>/current-behaviour.md` | Reuse rows by id |
| `context/regulated-actions.md` | The evidence each register row keeps, and the surfaces where it is visible |
| `context/policies/service-levels.md` · `decisions/decision-log.md` | Hold, lapse and resubmission windows; which policy values are PENDING |
| `context/09-current-commitments.md`; the tracker through `/issue-tracker` if reachable | Work in flight on the same area |
| `docs/08-handoff-to-engineering.md` (optional; skip silently if absent) | The handover method |

**No approved PRD?** Stop. Offer `/prd-writer`. A brief from an unapproved PRD hands
engineering a moving target.

## Questions first

One batched round; offer defaults.

1. **Known reuse.** Which existing capability do you expect this to extend? [I will search the current-behaviour rows and `context/03-surfaces-and-systems.md`]
2. **Hard constraints.** A regulated action, an insurer contract or a policy value engineering must hold? [the register rows the PRD names]
3. **Coupled behaviours.** Which behaviours must appear together for every invariant to hold? [none beyond the invariants]
4. **Overlap.** Is engineering already working on this area? [I will read `context/09-current-commitments.md` and the tracker]

## Procedure

1. **Phase check.** State it in chat and record it in `internal/readiness.md`, never in the
   shared body.
2. **Capability.** Three to five lines: what is added or changed, for whom, for which
   outcome metric id. Point to the PRD's non-goals and permissions sections by title. Give
   known volumes as labelled counts, never as sizing.
3. **Reuse.** One row per data point or screen: the existing capability, the reuse location,
   existing or new, how product extends it in product terms. A location is a name from
   `context/05-numbers-data-and-traps.md` (`h_verification.outcome`, `h_rework_item`,
   `h_audit_event`), an event name, a screen, a current-behaviour row id, or a `point_id`
   from `internal/data-packet.csv`. **A location says where something exists today. It
   never says what to add.** A new data point has no location. If the file does not name
   it, write "location unknown" — never guess a table or column name. Name the trap when a
   location is a trap table. Example, worked feature:
   *Rework reason code | `h_rework_item` (reason code); DESK-004 | existing, unchanged.*
   *Field that differs on `mismatched` | new — no location | shown on the rework item,
   chosen from fields the case already holds.*
4. **Invariants.** Rules that hold in every state and every slice. Examples from the worked
   feature: a provider failure never sets `declined`; every `declined` or `rework` outcome
   carries a recovery path; `refer` is never shown as declined; one rework item per
   document; a regulated action is not complete without its evidence record.
5. **Configuration** — a second table in the Reuse section. One row per item product or
   ops change without a release: the item (reason codes, checklist items, message
   templates, service levels), who changes it, where it is configured today
   (`context/04-eligibility-and-verification.md`), existing or new.
6. **Scenarios.** One row each — type (state, failure, integration), scenario, required
   outcome in product terms, acceptance id. Cover the six strips where they apply, and the
   four below; an absent one says why it does not apply. **The required outcome comes from
   the PRD's rules or a policy row.** If neither states it, write the outcome as
   `open input — owner: <role>`, list it under Open inputs, and it blocks handover.
   - **provider timeout** — the provider this feature depends on does not answer inside its
     timeout. Worked feature (90 seconds, `example`): sub-status stays `open`; the check is
     retried without customer action; the customer is told nothing is needed; the
     verification officer sees PROVIDER-FAILED; after the retry limit — a policy value,
     PENDING today and owned by the ops lead — the verification officer verifies manually
     from the uploaded identity proof, and the method is recorded in the evidence record.
   - **duplicate submission** — the same submission arrives twice. Worked feature: the
     customer uploads twice, or a field capture is sent twice after a sync — one item, one
     replacement, one notification.
   - **resubmission after close** — a submission arrives after the case left the state that
     asked for it. Worked feature: a document arrives after the case went `on hold`,
     `lapsed`, or left `Verification` with outcome `pass` — the outcome per case state, from
     the PRD's rules or `context/policies/service-levels.md`.
   - **concurrent action** — two roles act on the same item. Worked feature: a verification
     officer and a field verifier — which action stands, what the second person sees, and
     both appear in the audit view.
7. **Dependencies and constraints.** Owner, status, the constraint each adds. External
   providers — the identity-check provider, the payment provider, the WhatsApp BSP, insurer
   partner integrations — are dependencies with an owner and a status; name the capability,
   not the vendor. An internal dependency names the surface.
8. **Regulated actions and evidence.** One row per register row the PRD names: the evidence
   the product must keep, from the register's "Evidence kept" column, and where it is
   visible, from the register's "Surfaces" column (worked feature: the Desk audit view,
   DESK-009). State the WHAT — "an evidence record exists with the provider response
   reference, result, time and the verification officer's role" — never how it is stored.
9. **Observability.** Events by name from `context/05-numbers-data-and-traps.md`. A new
   event is marked **new**, described as what happened and from which screen, and gets a
   `Planned` `<SURFACE>-EVT-NNN` row under QA trigger 1; engineering owns its properties.
   Then the counts and reconciliations product must read after release, with metric ids
   (`VER-M2`, `REW-G1`) and where (the BI tool, the SQL replica).
10. **Decisions engineering owns.** Schema, APIs, component design, migration, rollout
    mechanics, test plan, estimates, technical breakdown, and the feature-specific
    mechanics — retries and timeouts, queues, de-duplication, storage, masking. The rules
    stay in Invariants, Configuration, Scenarios and Regulated actions: which screens show
    the full identity number, one item per duplicate. Only the mechanism is engineering's.
    Say it so nobody waits for product.
11. **Open inputs.** Owner (role) and the test: would a developer have to invent policy
    without this? Yes → it blocks handover, and the PRD gets its marker back. A PENDING
    policy value that production already runs is cited with its label and does not block.
    A PENDING value with no production value is an open input and blocks.
12. **Anticipated questions.** Three to six the engineering lead will ask, each with
    product's answer or "engineering to decide". "Engineering to decide" is allowed only
    for a HOW question. A WHAT question with no answer is an open input.
13. **Tier L only — data-handover registers.** Empty registers engineering fills during
    alignment: data points (business meaning, owner), states and transitions, integration
    outcomes (provider, outcome, failure behaviour). Product writes the business columns.
14. **Self-contained check** for `shared/eng-brief.md`: the body carries no dates other
    than the date inside a source label, no decision ids, no phase check, no local path
    other than the sibling `prd.md`, roles not names, capability names.
15. **Self-review** against the gate, then `/review gate` with the engineering-readiness lens.

## Gate

| Tier | Gate |
|---|---|
| S | Usually no brief. If one is needed: capability, reuse and open inputs only |
| M | Every section filled · every data point marked existing or new, with a location or "location unknown" · configuration table present · the four named scenarios present, or each absent one says why it does not apply · every scenario carries an acceptance id and an outcome from a rule, a policy or a named open input · one evidence row per register row · zero open inputs that force a developer to invent policy · no estimate anywhere · readiness check 10 passes · `/review gate` engineering-readiness lens |
| L | M gate · data-handover registers present · linked from the initiative `INDEX.md` |

On pass: `status: approved`, gate line in `internal/readiness.md`, commit proposal. The
product lead shares the brief with the engineering lead. **Stop and wait for engineering
input.**

## Output

| Tier | Path |
|---|---|
| S | Usually none. If needed, `products/<code>/<feature>/shared/eng-brief.md` |
| M | `products/<code>/<feature>/shared/eng-brief.md`; the gate line in `internal/readiness.md` |
| L | `initiatives/<name>/features/<feature>/shared/eng-brief.md` |

Keep it short. It is a conversation starter, not a second PRD.

## Do not

- No API contracts, endpoint definitions, schema definitions (columns to add, types,
  indexes, migrations), architecture, service interactions, component structure, state
  management, test plans or test cases, rollout or feature-flag plans, technology choices.
  The scenarios are required outcomes, not tests.
- **No estimates, sizing, task counts or dates.**
- Do not turn a location into a design. "The reason code exists on `h_rework_item`" is a
  location; "add a column to `h_rework_item`" is design.
- Do not resolve an open input by guessing. Name the owner.
- Do not repeat the PRD. Reference it by title and point to its sections.
- Do not propose a new dashboard or screen where an existing one can be extended. Name what
  is extended.
- Do not create tracker issues from the brief. Issues come after alignment, from the issue
  pack.

## Hands off to

Engineering alignment (a conversation between the product lead and the engineering lead) →
`/issue-tracker` pack mode → the readiness record → `/review gate`.
