---
name: land
description: Lands a shipped PRD into the durable layer. Reads a PRD at status shipped, appends one row per requirement to context/surfaces/<surface>/current-behaviour.md with the surface's id scheme, marks replaced rows superseded, writes the crosswalk, flips QA rows Planned to Current where the release note confirms, sets the PRD to landed with landed_into, and moves the feature folder to the archive with a "replaced by" README — one commit proposal. Use when someone says "this shipped", "this shipped last week", "merge the PRD", "merge the PRD into current behaviour", "update current behaviour", "land this", "land the PRD", or "what shipped but isn't landed".
argument-hint: "<PRD path> | list"
---

# Land — a shipped PRD becomes current behaviour

Land a shipped PRD by appending its requirements as rows to the surface's current-behaviour table. The next PRD then reads rows, not history.

## Read first (if present; else name the missing file and ask)

| File | Gives you |
|---|---|
| The PRD (`shared/prd.md`) — frontmatter, §6 rules, §7 information, §8 states, §9 acceptance | The requirement rows and the acceptance ids to land; `status` and `shipped_on` |
| `releases/<cycle>-release-note.md` that set the PRD to `shipped` | Production evidence per item; QA rows confirmed |
| `internal/review-YYYY-MM-DD-post-ship.md` | Match, gap and not-shipped per acceptance criterion |
| `context/surfaces/<surface>/current-behaviour.md` for every surface the PRD touches | The exact columns, the last id in the sequence, the SUPERSEDED convention in its header |
| `context/policies/<file>.md` named in the PRD's §6 | Where a rule requirement lands |
| `context/regulated-actions.md` | The register row a landed behaviour serves |
| `qa/<surface>/test-cases.csv` | The `Planned` rows whose `Traces To` names this PRD |
| `templates/crosswalk-template.md` | The crosswalk shape |
| `.agents/skills/product-loop/references/conventions.md` | The surface table (workstream code → surface → folders → id prefix); archive folder shape; the commit proposal |

`land list` — no PRD given: scan `products/**/shared/prd.md` for `status: shipped` with `landed_into: []` and print the paths. Then stop.

## Questions first

One batched round; defaults in brackets.

1. **Which PRD?** [the one `/session end` or `land list` reported as shipped, not landed]
2. **Which release note confirms it?** [the latest note under `releases/` that names this PRD]
3. **Production date.** [the PRD's `shipped_on`; it becomes `Landed on`]
4. **Surfaces.** Which files take rows? [one per §12 row, mapped through the surface table in conventions — never guessed]

## Procedure

1. **Check the status.** Read the PRD frontmatter. If `status` is not `shipped`, stop and say which status you found and which skill sets `shipped` (`/issue-tracker release`). If `shipped_on` is missing, stop and ask for the production date.
2. **Build the landing table in chat first.** One line per requirement row (§6, §7, §8) and per acceptance group (§9 criteria that describe one observable behaviour):

   | PRD row | Surface or policy | Proposed row (When … then …) | Replaces | Regulated action | Evidence (release note line, post-ship row) | Verdict |
   |---|---|---|---|---|---|---|

   Three verdicts. `land`: the release note confirms the behaviour. `gap — PENDING via /decide`: production contradicts the PRD; no row until the decision is LOCKED, and the crosswalk carries `deferred` with the decision point. `deferred — <decision point>`: release mode deferred the criterion through `/decide`; the crosswalk cites it. Where each PRD row lands, using the surface table in conventions:

   | PRD row | Destination |
   |---|---|
   | §12 row for `hub`, `desk` or `field` | That surface's `context/surfaces/<surface>/current-behaviour.md` (`HUB-`, `DESK-`, `FLD-`) |
   | §12 `rules` row, §6 rule | The policy file it names, cited as `context/policies/<file>.md#<condition>` |
   | §12 `comms` row | The surface where the message is seen |
   | §12 `data` row | `context/05-numbers-data-and-traps.md` |
   | §7 who sees or edits | `context/policies/data-handling-and-retention.md`, or a role-scoped surface row |
   | §7 evidence kept | The suffix "— regulated action: <register row>" on the surface row it serves |
   | §8 state that cannot occur | Crosswalk `not applicable` |
   | §9 acceptance group | A row on the surface its §12 row names |

   An item deployed with a rollout boundary (`pilot`, `limited-rollout`) lands with the boundary inside the `Behaviour` sentence and a crosswalk note; the later full-production release supersedes that row. Stop for the product lead's confirmation before writing.
3. **Append the rows.** For each `land` verdict, append one row to the surface file in its exact columns:

   | Column | Holds | Source |
   |---|---|---|
   | `ID` | The next id in the file's sequence (`HUB-`, `DESK-`, `FLD-`) | the file's last row |
   | `Behaviour` | The PRD's own "When … then …" wording, scoped to a role where the role matters; where a regulated action applies, the suffix "— regulated action: <register row>" | the PRD row; `context/regulated-actions.md` |
   | `Source PRD` | The PRD's archive path (step 9) | — |
   | `Landed on` | The production date, `YYYY-MM-DD` | the PRD's `shipped_on` |

   When a new row replaces an existing one, prefix the old row's `Behaviour` with `SUPERSEDED by <new id>` as the file header describes, and never delete or renumber. Bump the surface file's `last_updated` and leave `Last verified` to the product lead.
4. **Write the crosswalk** at `<feature folder>/internal/crosswalk.md` from `templates/crosswalk-template.md`; if readiness check 8 already wrote that file, append a "Landed" section. Earlier source = the PRD section and row. Treatment = one of the template's seven values; the template defines each. §6- and §7-derived rows are `refined`; grouped criteria are `merged`; both are confirmed in the landing table. `deferred` covers `gap` and deferred rows and carries the decision point. Destination = the row id or the policy destination. Coverage check: PRD rows = crosswalk rows, unmapped 0.
5. **Reconcile the QA rows.** Product owns the scenario (acceptance in executable form); engineering owns test data, expected result and build state. Whoever shipped set `Build State` at QA trigger 2; `land` only reconciles. Diff the `Planned` rows whose `Traces To` names this PRD against the release note's confirmed list. Where the note confirms the scenario and the CSV still says `Planned`, set `Current` and record the discrepancy in the crosswalk notes. Never set `Blocked` or `Fix-pending`. A row the code contradicts goes back to the shipper under trigger 2 and stays as it is.
6. **Set the PRD to landed.** Frontmatter: `status: landed`, `landed_into: [<row ids and policy destinations>]`, bump `last_updated`. `status`, `shipped_on`, `landed_into` and `last_updated` are the only frontmatter fields `/issue-tracker release` and `/land` set on an approved PRD; the body stays frozen. Do this before the move.
7. **Mirror the tracker.** Move the parent product issue to `Landed` through the `/issue-tracker` adapter; the adapter says whether that closes the issue.
8. **Record what did not land.** Every `gap` → a PENDING decision through `/decide`. Every `deferred` row already carries its decision point from release mode; the crosswalk cites it. `land` runs once per PRD; a deferred criterion returns as a row in a later PRD when its decision is LOCKED.
9. **Move the feature folder** to `products/<code>/archive/landed-YYYY-MM-DD/<feature>/` with a `README.md` table: file → replaced by (the row ids, the policy destination, or "deferred → todo") → why. Writing that README is the last part of the move. After the move, the skill edits nothing under `archive/`.
10. **One commit proposal** covering the surface rows, the policy file, the crosswalk, the QA flips, the PRD and the move. Use the editor's commit-proposal tool if present; otherwise show the `git` command for the product lead to approve. The commit is one unit; if the product lead does not approve it, revert every file in the list.

Example (Harbor Cover), the verification-outcome-and-rework PRD:

- Rows landed: `HUB-013` (the rework message names the field that differs and the recovery path), `DESK-012` (the rework item shows the rule that fired — regulated action: record retention), `FLD-011` (replacement capture against the item).
- Superseded row: `DESK-004` gains a successor and is prefixed `SUPERSEDED by DESK-012`.
- Deferred row: one `rework` acceptance criterion was deferred at release through `/decide`; the crosswalk carries `deferred` with that decision point, and no row is appended.

## Gate

| Check | Pass means |
|---|---|
| Status | The PRD was at `shipped` with `shipped_on` set before anything was written |
| Coverage | Every requirement row and acceptance group has a current-behaviour row, a policy destination, a `gap` decision point, or a `deferred` treatment citing its decision point |
| Columns | Every appended row has the four columns, an id that continues the sequence, a `When … then …` behaviour taken from the PRD, and a `Landed on` date in `YYYY-MM-DD` |
| Supersession | Every replaced row is prefixed, none deleted |
| Crosswalk | Rows in PRD = rows in crosswalk; unmapped 0 |
| QA | Only note-confirmed rows flipped to `Current`; no other `Build State` touched; discrepancies recorded |
| PRD | `status: landed`; `landed_into:` lists every appended id and policy destination; the product issue is at `Landed` |

## Output

- Rows appended to `context/surfaces/<surface>/current-behaviour.md` (and a policy file where a rule landed).
- `<feature folder>/internal/crosswalk.md`.
- QA rows flipped in `qa/<surface>/test-cases.csv`.
- The PRD at `status: landed`, inside `products/<code>/archive/landed-YYYY-MM-DD/<feature>/`, with the archive README.
- One commit proposal. In chat: the row ids, the `gap` and `deferred` list, the paths.

## Do not

- Do not land a PRD that is not at `shipped`. Say which status you found and stop.
- Do not edit anything already under `archive/`.
- Do not invent behaviour. A row's wording comes from the PRD; production evidence confirms it and adds nothing to it.
- Do not flip a QA row the release note does not confirm.
- Do not delete, reorder or renumber a current-behaviour row.
- Do not land an item whose commitments status is not `deployed to prod`. The tracker's `Done` is never enough.
- Do not append a row for a `gap`. Production that contradicts the PRD is a PENDING decision, not a durable fact.
- Do not land a PRD twice. There is no re-landing path; a deferred criterion comes back in a later PRD.
- Do not map a §12 row to a file by guessing. The surface table in conventions is the only mapping.
- Do not update a surface file's `Last verified` line; that is a whole-table re-check the product lead does.

## Hands off to

`/session end` (lists PRDs still at `shipped`) · `/decide` for every `gap` · `/prd-writer`, which reads the new rows before the next PRD on the surface · the weekly miner, which picks up the changed `last_updated`.
