# Release mode — reconcile, status, impact chain, publication QA

Give every item in the cycle exactly one status from the table below, backed by production evidence, before any release note goes out. Run this once per cycle, after the engineering team's issues move.

## Status vocabulary — exactly one per item

Item status is the commitments vocabulary from `context/07-glossary.md`: `committed` · `in build` · `in UAT` · `deployed to prod`. Only `deployed to prod` counts as shipped. A `deployed to prod` item also records its rollout boundary.

| Rollout boundary, beside `deployed to prod` | Meaning |
|---|---|
| `production` | Live for everyone |
| `pilot` | Live for a confirmed cohort — name it |
| `limited-rollout` | Live under configuration, percentage, region or group — name the boundary |
| `validated` | Live and confirmed through the required checks |

| Engineering or release wording | Item status |
|---|---|
| `developed`; `deployed-pending-validation` (a required check remains) | `in UAT` — clarify before the note |
| `planned`; approved or proposed future work | `committed` |
| `held`, `rolled-back`, `superseded` | Not a status. The "Deliberately not in scope" table in `context/09-current-commitments.md`, with the reason |

"Live", "released", "rolled out" and "available" are not statuses; name the boundary. `Done` in the tracker is not a status here.

## Reconciliation table

| Item | Planned (source) | Engineering issue | Tracker state | Production evidence | Status | PRD |
|---|---|---|---|---|---|---|
| C-row or feature | `context/09-current-commitments.md` row, cycle | id | the engineering team's state | screen, replica query, release tag | item status, plus the boundary when `deployed to prod` | path and current `status` |

Production evidence is the product lead's own confirmation of the behaviour, not the tracker state. An item with a tracker state and no evidence is `in UAT`, not `deployed to prod`.

## Atomic release record — one per item

Status · customer or operator · visible change · enabling engineering work · failure prevented · business relevance · rollout boundary · evidence · owner role (only at the confirmed level) · dependencies · supersedes · audience notes.

## Impact chain

```
Engineering change
→ system behaviour made possible or protected
→ customer or operator behaviour affected
→ business consequence
→ evidence or measurement enabled (metric id, claim level)
```

Take the engineering change from the engineering issue's own wording; ask at the clarification gate if it is vague. State the claim level (`context/metrics-dictionary.md`). Do not force a business claim when the evidence supports only a technical or operational outcome.

## Grouping

- Keep an item distinct when a customer or operator can see or accept it on its own.
- Group enabling work under the capability it serves.
- Keep minor fixes out of the headline but in the feature index.
- Omit internal-only code changes with no effect a reader would notice.
- Consolidate by capability, not by repository. Build the atomic inventory first, then merge.

## Clarification gate — ask together, pre-filled

Window and timezone · audience and format · surfaces in scope · item status and rollout boundary per item · whether pending validations passed · owner roles at the confirmed level · the business meaning of vague issue titles · rollout boundary · supersession · intentional omissions · the claim level of each metric claim (implementation fact, measurement capability, descriptive movement or causal impact).

## QA trigger 2

Product owns the scenario (acceptance in executable form); engineering owns test data, expected result and build state. Take every `Planned` row in `qa/<surface>/test-cases.csv` whose `Traces To` names an acceptance id of a shipped item. Whoever shipped opens the code and confirms the behaviour. They fill real `Test Data` and `Expected Result`, then set `Build State` to `Current`, `Blocked` or `Fix-pending`, or correct the row. The release note lists the rows confirmed and the rows that stay `Planned`, with the reason. `/land` reads this list.

## Flipping the PRD to shipped

After reconciliation, for each `deployed to prod` item whose every acceptance criterion has production evidence or a `/decide` deferral:

```yaml
status: shipped
shipped_on: YYYY-MM-DD      # the production date from the evidence column
```

Bump `last_updated`. `status`, `shipped_on`, `landed_into` and `last_updated` are the only frontmatter fields `/issue-tracker release` and `/land` set on an approved PRD; the body stays frozen. A partially shipped PRD stays `approved`; the note lists the shipped criteria by id. A `deployed to prod` item whose PRD is not `approved` stops the run and is listed as "shipped without an approved PRD". Move the parent product issue to `Shipped`. Refresh the item's `Status` in `context/09-current-commitments.md` with the item status from the vocabulary above, the boundary in the Capability cell, and update its `Last verified` line. One commit proposal covers the note, the PRD frontmatter and the commitments file.

## Release note shape — `releases/<cycle>-release-note.md`

Frontmatter (`status`, `version`, `supersedes`, `decision_refs`, `why`, `last_updated`) · window and scope · highlights (one line per material item with its impact chain) · feature index (every item with its status, boundary and evidence) · QA rows confirmed and still `Planned` · PRDs set to `shipped`, with shipped criteria by id where a PRD stays `approved`.

## Publication QA

- [ ] Window and scope explicit.
- [ ] Every shipped item is `deployed to prod` with its rollout boundary and evidence.
- [ ] Pending work excluded from shipped claims.
- [ ] No missing-information placeholders remain.
- [ ] Owner roles confirmed for this window; omit an item rather than publish "owner not specified".
- [ ] Restricted rollouts name the restriction.
- [ ] Superseded items use the latest confirmed state.
- [ ] Duplicates across repositories consolidated.
- [ ] Enabling work retained with its effect.
- [ ] Metrics sourced, labelled, with the claim level stated.
- [ ] Capability names, not vendor names; roles, not person names.
- [ ] Highlights and feature index agree.

Two layers, one inventory: short highlights for leadership, the full feature index beneath. Removing the inventory makes the note impossible to verify.
