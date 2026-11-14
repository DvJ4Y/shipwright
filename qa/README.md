---
title: QA test-case catalog — schema and vocabulary
type: qa-index
status: active
version: 1.0
supersedes: —
decision_refs: []
why: One schema for every surface's test cases, so the release gate has a bank to draw from
last_updated: 2026-11-02
---

# QA test-case catalog

**Owner:** the product lead · **Applies to:** every surface you add here, and the analytics layer

This folder is the test-case catalog a technical non-developer executes row by row. It is
the bank of cases the release gate draws from. The gate (`issue-tracker release`
reconciliation) decides whether a release counts as `deployed to prod`; this catalog is
what the gate runs.

**Objective:** a complete set of manually executable scenarios covering every case each
surface can produce. A subset is automatable later; the format serves manual testers first.

**How rows get written and kept current is [PROCESS.md](PROCESS.md)** — four triggers, the
code-trace rule, and how to add a surface. Read it before adding rows.

```
qa/
├── README.md                 # this file — schema and vocabulary
├── PROCESS.md                # how rows get written, maintained, extended
└── <surface>/
    ├── test-cases.csv        # the surface's behaviour, by screen (scoped to role where it differs)
    └── analytics-events.csv  # the events the surface emits
```

The folder starts with no surface catalogs. `PROCESS.md` § Adding a surface creates one. A
filled set for three surfaces lives in `examples/harbor-cover/qa/`.

The CSVs are the source of truth. Nothing generates them; every row is hand-written and
confronted with the code and with production.

## One schema, one axis column per surface

All catalogs share the same 15 columns. The one column that changes meaning per surface is
the organizing axis:

| Surface type | Axis | Column reads |
|---|---|---|
| Screen-based UI (a customer app, an ops console, a field app) | the screen the user is on | `Screen` |
| Rules engine (the decision engine) | decision node or module | `Module` |
| Measurement layer (analytics) | the screen the event fires from, plus `Event` as an extra column | `Screen` + `Event` |

Always include a **`Global / all screens`** bucket for cross-cutting behaviour: back
navigation, language switch, network loss, generic field validation, permission denial.
Cross-cutting behaviour is where defects concentrate.

## Columns

`Test Case ID | Scenario ID | Screen | Title | Test Type | Priority | Build State |
Precondition (Description) | Precondition (Ref) | Step # | Action | Test Data |
Expected Result | Traces To | Notes`

**One row = one executable step.** A test case spans consecutive rows sharing a
`Test Case ID`; the case-level columns repeat on every step so the file survives sorting.

| Column | Holds |
|---|---|
| `Scenario ID` | The behaviour covered, `<SURFACE>-<SUB>-NNN`. The traceability anchor; never renumbered |
| `Test Case ID` | `<Scenario ID>-T<n>`. Derived, never invented. `-T2` adds coverage without disturbing `-T1` |
| `Screen` | The organizing axis. On a role-based surface, scope to the role where behaviour differs: `Queue (<role>)` |
| `Title` | What the case proves, in one line of business language |
| `Test Type` | `Functional` · `Validation` · `Negative` · `Boundary` · `E2E` · `Integration` · `State` (idempotency, navigation, resume). `Positive` is not a value; use `Functional` |
| `Priority` | `P0` · `P1` · `P2` (below) |
| `Build State` | `Current` · `Planned` · `Blocked` · `Fix-pending` (below) |
| `Precondition (Description)` | The state the user or system must be in before step 1; `none` if cold |
| `Precondition (Ref)` | The `Test Case ID` that establishes that state, optionally narrowed `(through step 2)`; `-` if none |
| `Step #` | 1-based, contiguous within a case |
| `Action` | One thing the tester does, in plain language. Not a code path or component name. Enumerations are successive steps in one case, not separate cases |
| `Test Data` | `key=value; …` for that step only; `-` if none; placeholders in angle brackets |
| `Expected Result` | What the tester observes, specific enough to pass or fail without judgement. Data assertions as data: `sub_status=<value>` |
| `Traces To` | Semicolon-separated upstream references: PRD path and acceptance id, current-behaviour row id, regulated-action row, tracker issue. Empty means genuinely new coverage, which is itself a drift signal |
| `Notes` | Code-trace findings, open questions, discrepancies. Carries evidence, never an assertion |

## `Build State`

| Value | Meaning | Runner behaviour |
|---|---|---|
| `Current` | Built and in production; should pass today | Fail = real defect |
| `Planned` | Designed, not yet built; written from the PRD so coverage exists on day one | Skip until the feature ships; no defect |
| `Blocked` | Exists in code but unreachable through today's UI | Skip and report as blocked; needs a product call |
| `Fix-pending` | Asserts the intended state of a behaviour that is wrong in production and being fixed | Expected to fail until the fix lands; not a new defect |

## Priority

| Priority | Definition | Typical rows |
|---|---|---|
| `P0` | Core journey unavailable; wrong-person data exposure; irreversible corruption; a regulated action without its evidence record | Entry and consent; the core journey spine; a refusal always shows its recovery path; a provider failure never ends the journey; every evidence record |
| `P1` | Major journey broken with no safe workaround | Validation gates; resume; language switch; queue ordering; required reasons; permission negatives |
| `P2` | Degraded with a safe workaround | Copy, secondary status surfaces, display rounding |

## ID scheme

- Scenario: `<SURFACE>-<SUB>-NNN` — for example `APP-DOC-004`, `OPS-QUE-012`
- Test case: `<Scenario ID>-T<n>` — always derived
- Analytics: `<SURFACE>-EVT-NNN`
- Rules engine: `RUL-<SUB>-NNN`

**Scenario IDs are append-only.** Retiring a behaviour deletes its rows; the number is never
reused. New coverage on an existing behaviour takes the next `-T<n>`.

### Sub-module codes

| Surface | Codes |
|---|---|
| `<SURFACE>` | `<SUB>` three-letter code · what it covers |

In the example (`examples/harbor-cover/qa/README.md`), the customer app uses `ENT`, `QUO`,
`DOC`, `REW` and more; the ops console scopes codes by role.

Define each new code in this table when you add it. Keep codes to three letters.

## Analytics catalogs

`qa/<surface>/analytics-events.csv` carries the same 15 columns plus `Event` (16). One
`<SURFACE>-EVT-NNN` row per event the surface emits. A PRD that adds an event writes its
`Planned` row here under trigger 1; trigger 2 confirms it against the event store.
