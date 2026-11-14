---
title: QA process — how rows get written, kept current and extended
type: qa-process
status: active
version: 1.0
supersedes: —
decision_refs: []
why: Keeps the catalog confronted with code and production, so it never passes on fiction
last_updated: 2026-11-02
---

# How QA test cases get written, kept current and extended

**Owner:** the product lead · **Applies to:** every surface under `qa/`

Schema and vocabulary live in [README.md](README.md). This file is the operating process:
who writes a row, when, and what keeps the catalog from rotting.

## The principle

**The format is not the hard part. The code trace is.**

A catalog authored only from documents drifts silently and passes every run. Two kinds of
error are normal when a document-derived catalog meets reality: the catalog asserts a
behaviour the code does not contain, and the catalog names an event that never fires. Both
pass review forever unless someone opens the source and runs the discovery query.

So the process optimises for one thing: **every row is eventually confronted with the code
and with production, not just with the PRD it came from.**

## Four triggers

Nothing here is a standing meeting. Each trigger fires off work that is already happening.

### 1. PRD approved → add `Planned` scenario rows

**Who:** whoever writes the PRD (the agent, during Phase 2).
**What:** one scenario per distinct behaviour the PRD introduces, with steps sketched from
the acceptance criteria. `Build State = Planned`. `Traces To` = the PRD path and the
acceptance id (`A3`), plus the regulated-action row where one applies.
**Why:** coverage exists before the feature does, so the release gate is never retrofitted.

Do not write `Current` rows here. If the PRD describes something already built, it still
gets `Planned` until trigger 2 confirms it against the code.

### 2. `Deployed to Prod` → code-trace pass, flip `Planned` → `Current`

**Who:** whoever ships, with repo access to the surface. There is no dedicated QA role.
**What:** for every row the release touches — open the source, confirm the behaviour, fill
in real `Test Data` and `Expected Result` values, and set `Build State`:

| Finding | Set |
|---|---|
| Confirmed working | `Current` |
| Exists in code, unreachable through the UI | `Blocked`, with a `Notes` line naming the file |
| Code contradicts the row | The row is wrong until proven otherwise. Fix the row; raise the discrepancy separately |
| Production is wrong and a fix is queued | `Fix-pending`; the row asserts the intended state |

**This is the highest-value step.** `Done` in the tracker is not the trigger. `Deployed to
Prod` is; only that state counts as shipped. The `land` skill runs after this pass and
appends the confirmed behaviours to `context/surfaces/<surface>/current-behaviour.md`.

### 3. Defect found → add a `Fix-pending` regression row

**Who:** whoever finds it, at the moment they find it.
**What:** a row asserting the intended behaviour, `Build State = Fix-pending`, `Notes`
carrying the evidence (file, observed behaviour). It fails until the fix lands; that failure
is the point. Flip to `Current` when the fix deploys.

### 4. Drift audit per surface → re-confront the catalog with reality

**Who:** the product lead with the agent.
**What:** re-run trigger 2 across the whole surface, not just the changed rows:

- rows with an empty `Traces To` — find the source or justify the row;
- `Planned` rows older than the feature they describe — did it ship without a flip?
- `Blocked` rows — is the product call still open?
- behaviours in the code or in `current-behaviour.md` with no row at all.

Cadence follows release volume, not the calendar. A surface that shipped nothing needs no
audit; Harbor during an active cycle needs one per cycle.

## What a good row looks like

The tester is a technical non-developer. That sets the bar for every column.

- **`Action` is something a person does**, not a code path. "Open Harbor from a WhatsApp
  link" — not a route with parameters.
- **Enumerations are steps, not cases.** Six shop types, four products, three reason codes:
  one case, several steps, one setup.
- **`Expected Result` passes or fails without judgement.** "Sub-status shows `rework`" — not
  "handled correctly".
- **Open questions are not test cases.** A row titled "Clarify whether X exists" is a tracker
  item wearing a test case's clothes.
- **`Notes` carries evidence, never assertions.** If the tester must read `Notes` to know
  whether the step passed, the step is written wrong.
- **No event-payload assertions in a UI catalog.** "Does the customer see it" and "did the
  event fire with the right properties" are different altitudes with different owners.
- **Regulated actions get a `P0` row per evidence record** the feature creates.

## Adding a surface

1. Create `qa/<surface>/test-cases.csv` with the 15 standard columns.
2. Pick the organizing axis for `Screen` (README table). Always include
   `Global / all screens`.
3. Allocate a surface prefix and sub-module codes in the README's ID scheme.
4. Seed from triggers 1 and 2, in that order — PRDs first for breadth, then a code-trace
   pass for truth. For any surface with analytics, run the production discovery query
   before writing a single event row.
5. Wire it into the release gate. A surface with no rows referenced by the gate is a catalog
   nobody runs.

**Role-based surfaces (Desk, Field) need a sixth step.** Where the same screen behaves
differently per role, scope `Screen` to the role — but only after confirming the behaviour
differs. Write the **negative** permission cases: what a role must not see or do is where
wrong-person data exposure hides, and it is `P0`.

## Open questions

Parked here, not as rows. Resolve, then add rows or close.

| Question | Owner | State |
|---|---|---|
| Should the referral agent's Field view ever show a rework reason? | compliance officer | open; no row until decided |

**A finding is not automatically a test case.** Three outcomes: explained (keep a low-priority
row that records why), out of scope (delete the row and say so here), or a gap QA cannot fix
(move it to a findings note; asserting missing instrumentation only produces a permanently
red row).
