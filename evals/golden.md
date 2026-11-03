# Golden shapes — what a correct artifact looks like

Short, illustrative rows for the worked feature, `products/desk/verification-outcome-and-rework/`.
Every figure is invented and labelled `example`. Use these to judge an output's shape, not its
wording. The full artifacts live in the feature folder.

## 1. Intake verdict block (`/product-loop`)

```
Verdict: go — outcome and owner named; serves commitment C1; extends HUB-008, DESK-004, FLD-005
Tier: M — one capability across Harbor, Desk and Field; new data points; three regulated actions
Lane: ops-platform — the customer lane reviews the rework message and its strings
Outcome: VER-M2 — rework cycle time, 31 hours (`example`) → 18 hours (`target`); guardrails VER-M1, REW-G1
Workflow: /product-discovery → /decide → /prd-writer → /review gate → /engineering-brief → /issue-tracker pack → readiness → /land
Phase check: Discovery Done — internal/discovery.md · PRD Done — shared/prd.md · Engineering alignment Not yet
Sessions: 5 — discovery and decisions · PRD and QA rows · review gate · brief and issue pack · readiness and land rehearsal
```

Must have: a verdict with its reason, a tier with its reason, an outcome metric id, the
workflow, the phase check, a session map. Must not have: a produced artifact.

## 2. PRD section 9 — one acceptance row

```
- **A10** (U5) — When the identity-check provider does not answer within its timeout, then the
  queue row shows PROVIDER-FAILED, the case stays `open`, the verification clock pauses, the
  customer is told nothing is needed and offered "talk to our team", `declined` cannot be set
  for the provider failure, and no rework item is raised on the identity proof.
```

Must have: an id, the use case it serves, one observable "When … then …" sentence, production
stage and sub-status names. A row that performs a regulated action ends with
"— regulated action: <register row>". Must not have: a mechanism, an endpoint, a table name.

## 3. Engineering brief — one scenario row

| # | Type (state / failure / integration) | Scenario | Required outcome | Acceptance id |
|---|---|---|---|---|
| S4 | failure | The identity-check provider does not answer within 90 seconds (`example`) | The case stays `open`; the queue row shows PROVIDER-FAILED; no `declined` is possible from the identity panel; the attempt is an evidence record with the provider response reference | A10, A17 |

Must have: a type, the scenario as a condition, the outcome as behaviour, the acceptance id it
traces to. Must not have: how the timeout is implemented, a retry strategy, an estimate.

## 4. Review — the findings table

| # | Grade | Lens | Location (file#section) | Finding | Fix |
|---|---|---|---|---|---|
| 1 | Major | data | `shared/prd.md#10` | `VER-M2` cites the median without its population boundary; engine re-runs are not excluded | State the boundary from `context/metrics-dictionary.csv` and name the exclusion |
| 2 | Minor | writing | `shared/prd.md#4` | "resubmission" and "re-upload" both appear; the glossary term is `rework` | One term per concept |

Then the gate line: `Decision: send back · By: product lead · Reason: one Major open`.
Must have: a grade, a lens, a location, a fix the author can apply. Must not have: an edit to
the artifact; a finding without a location.

## 5. Landing table (`/land`, built in chat before any write)

| PRD row | Surface or policy | Proposed row (When … then …) | Replaces | Regulated action | Evidence (release note line, post-ship row) | Verdict |
|---|---|---|---|---|---|---|
| A4 | Harbor → `HUB-013` | When a round is raised, then the status page lists each returned document with the reason in plain words and one recovery route | — | consent and disclosure | release note item 2; post-ship A4 match | land |
| A3 | Desk → `DESK-012` | When a case has open rework items, then the queue row shows the count, the reason codes and the rule that fired — regulated action: record retention | DESK-004 | record retention | release note item 1; post-ship A3 match | land |
| A7 | Harbor | When the customer asks for a visit, then a task appears for the region's field verifier | — | — | not in the release note | deferred — P-09 |

Must have: one line per requirement row and acceptance group, a verdict from the three
(`land`, `gap — PENDING via /decide`, `deferred — <decision point>`), the replaced row where
one exists. Must not have: a row appended for a `gap`; a renumbered or deleted row.
