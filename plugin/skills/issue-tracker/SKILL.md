---
name: issue-tracker
description: Manages the tracker for the product team through the adapter the profile names (`_tracker: linear` or `_tracker: github`). Pack mode builds the parent issue and functional product sub-issues from an approved PRD, brief and mockups — never frontend/backend splits — publishes only after approval, then reads every issue back and diffs it against the pack. Pulse mode sweeps for stale items weekly. Release mode reconciles a cycle (planned against deployed to production), applies the status vocabulary, writes impact chains for a release note and sets the PRD to shipped. Enforces the product-to-engineering link rule. Use when someone says "create tickets", "create the tickets", "create issues", "issue pack", "publish to the tracker", "sprint planning", "cycle planning", "backlog", "groom the backlog", "what's stale", "weekly pulse", "release notes", "what shipped this cycle", "what shipped", or "reconcile the cycle".
argument-hint: "[pack | publish | pulse | release] <feature folder or cycle>"
---

# Issue tracker — execution state, linked and verified

Put execution state in the tracker and the reasoning in the repo. Close a product issue only by saying where its work went.

## Read first (if present; else name the missing file and ask)

| File | Gives you |
|---|---|
| `_profile.md` → `_tracker:` | Which adapter to load: `references/adapters/linear.md` or `references/adapters/github-issues.md` |
| The adapter file | Team key, tool or command names, workflow states, label groups |
| `templates/issue-pack-template.md` | The pack shape |
| `shared/prd.md`, `shared/eng-brief.md`, `mockups/` in the feature folder | The only allowed sources of issue content |
| `internal/readiness.md` | Readiness check 7 — issues map to acceptance criteria |
| `context/09-current-commitments.md` | Committed work, to avoid duplicates; refreshed after a release |
| `context/07-glossary.md` § Delivery vocabulary | `deployed to prod` is the only state that counts as shipped |
| `references/release-mode.md` | Status vocabulary, impact chain, clarification gate, publication QA |
| `qa/<surface>/test-cases.csv` | Release mode: the `Planned` rows the release touches |

**Verify access first.** Call the adapter's cheapest read (list teams, or list issues with a limit of one). If it fails, stop and say so. Never reason about a backlog you cannot see.

## Questions first

One batched round; defaults in brackets.

1. **Mode.** pack, publish, pulse or release? [pack]
2. **Scope.** Which feature folder, or which cycle? [the active feature in `sessions/latest.md`; the cycle that just closed]
3. **Project and cycle.** Which tracker project and which cycle? [the feature's existing project; the current cycle]
4. **Engineering link.** Does an engineering issue exist yet? [no — the product issue stays below `Handed to Eng`]

## Procedure

### The model

| Side | Holds | Rule |
|---|---|---|
| Product team (key from the adapter; `HBR` in the Harbor Cover example) | Discovery, PRDs, design, research, the parent feature issue (it carries the engineering link) and its functional sub-issues | Product states and labels from the adapter; the pre-pack states exist for issues a person created by hand at intake |
| Engineering team (its own key) | Execution and engineering's own technical sub-issues | Product never creates technical sub-issues; engineering reads the repo — `shared/` is what is handed, and `context/policies/`, `context/surfaces/`, `context/05-numbers-data-and-traps.md` and `qa/` are open to it |

**Link rule.** The parent product issue carries the link to the engineering issue that implements it; sub-issues move with the parent. If engineering splits its work, each split sub-issue gets its own link. State transitions mirror. `Handed to Eng` needs the link. `Shipped` needs two things: the linked engineering issue at the engineering team's deployed-to-production state (not `Done`), and production evidence for every acceptance criterion or a `/decide` deferral for it. The adapter says how the link is set.

### Mode: pack

1. **Check readiness.** PRD `approved`; brief approved; mockups approved where the feature has screens. The pack may be drafted before engineering alignment, but it stays `draft` until the brief's `aligned_on` is set; only then can it be `approved` and published. Missing PRD or brief approval → stop and name the gap. Exception: a bug or chore the product lead asks for by name. It states the observed behaviour with evidence and the expected behaviour as a current-behaviour row id or a policy row — never new behaviour. It is published as a pack with fields and labels, and read-back applies. Anything else needs a PRD.
2. **Duplicate check.** Search both teams and `context/09-current-commitments.md` for the same outcome.
3. **Parent issue.** Problem and outcome, customers and use cases, scope and non-goals, summary acceptance, dependencies, **Links** to the PRD, brief and mockups as repo paths engineering can open (URLs once published), the list of sub-issues.
4. **Product sub-issues** — functional slices a customer can see or an operator can accept: a role's workflow, a configuration capability, a message a customer receives, a review experience. Each description has six parts: **Outcome** · **Behaviour** (with states) · **Acceptance** (the PRD's criteria copied verbatim with their ids; a When … then is added only where the PRD criterion lacks one, and the crosswalk marks it `refined`) · **Rules, permissions and evidence** (PRD §6 and §7 rows quoted by id, with the policy value or the policy-file row) · **Depends on** (`Sn`, as text in v1) · **Reference** (PRD section and mockup frame, as repo paths; URLs once published). Never a slice named Frontend, Backend, API, Database or QA. No fixed number of children.
5. **Fields and labels, not prose.** Set project, cycle, state, parent and labels as fields: Scope one, Work type one, Surface one or more. Nothing a field can hold goes into the description.
6. **Supporting-project issues** only when another team owns a real, separately trackable outcome.
7. **Trace.** Every sub-issue maps to at least one acceptance id. Every acceptance id, §6 rule and §7 evidence record maps to a sub-issue or the parent. Report gaps. Record the result as readiness check 7 in `internal/readiness.md`, with the pack path.
8. **No new requirements.** The pack adds nothing absent from the PRD, brief or mockups.
9. Save to `<feature folder>/internal/issue-pack.md`, `status: draft`. Show it in chat and stop for approval.

### Mode: publish (after the product lead approves the pack in this conversation)

0. Set the pack `status: approved` with the gate line (`Gate: approve · By: <role> · On: <date> · Reason: <one line>`).
1. Re-run the duplicate check.
2. Create the parent when the duplicate check finds none; otherwise update the found issue by id — never duplicate. Then each sub-issue, **copying text verbatim** from the pack. Set the fields; sub-issues take the parent's state. No edits during publication.
3. **Read back** every created issue and diff title, description, fields and parent against the pack. Record each in the pack's publication log: tracker id, date, "read-back matches: yes/no".
4. Any mismatch → fix in the tracker to match the pack, read back again, record.
5. Set the pack to `status: published`. Propose one commit.

Example (Harbor Cover): the verification-outcome-and-rework pack has one parent and five sub-issues — the Desk return with the field that differs and the multi-item queue row, the Harbor and WhatsApp rework list with its recovery paths and hold messages, the Field replacement capture, the Desk provider-failure and manual-verification path, and the evidence records with the audit view and masking. Each maps to acceptance ids; none is named after a layer.

### Mode: pulse (weekly, read-only)

| Signal | Rule of thumb |
|---|---|
| Stale | No update in 14 days while in `Drafting`, `In Review` or `Handed to Eng` |
| Stuck at the gate | In `In Review` more than 7 days |
| Broken link | A parent in `Handed to Eng` with no linked engineering issue (sub-issues are not flagged) |
| False ship | A parent `Shipped` while its linked issue is not at the deployed-to-production state |
| Orphan | Blocked with no owner, or no project |
| Parked without trigger | In `Backlog` with no unpark condition |
| Shipped, not landed | PRD at `status: shipped` with `landed_into: []` → suggest `/land` |

Output: a table (issue, signal, days, proposed action) and at most three recommended actions. Apply only the actions the product lead approves.

### Mode: release

Detail in `references/release-mode.md`.

1. **Window.** Cycle, dates and timezone; audience; surfaces in scope.
2. **Reconcile.** Planned (`context/09-current-commitments.md` and the cycle's issues) against actual (engineering issues at the deployed-to-production state, confirmed by product). Each item gets exactly one status from the commitments vocabulary (`committed` · `in build` · `in UAT` · `deployed to prod`), with its rollout boundary recorded beside `deployed to prod`.
3. **Clarification gate.** Ask every open status, rollout and attribution question together, with the safest reading pre-filled. No publishable text before it closes.
4. **Impact chain** per material item: engineering change → behaviour enabled → customer or operator behaviour → business consequence → evidence or measurement, with its claim level.
5. **QA trigger 2.** List the `Planned` rows the release touches. Whoever shipped confirms each against the code; the note records which rows were confirmed and which stay `Planned`.
6. **Draft** `releases/<cycle>-release-note.md` with capability names and roles. Run the publication QA.
7. **Flip the PRD.** For each parent whose linked engineering issue is `deployed to prod` and whose every acceptance criterion has production evidence or a `/decide` deferral: set `status: shipped` and `shipped_on: <production date>` (lifecycle frontmatter only; the body stays frozen); move the parent to `Shipped`; refresh the item's row in `context/09-current-commitments.md` with the mapping in the reference file. A partially shipped PRD stays `approved`, and the note lists the shipped criteria by id. A `deployed to prod` item whose PRD is not `approved` stops the run and is listed in the note as "shipped without an approved PRD". Propose one commit.

## Gate

| Mode | Gate |
|---|---|
| pack | Readiness check 7 recorded PASS in `internal/readiness.md` · zero layer-named slices · the product lead approves |
| publish | Every issue read back and matching the pack |
| pulse | Read-only; nothing changed without approval |
| release | Clarification gate closed · publication QA passes · the product lead approves the note |

## Output

- Issue pack: `<feature folder>/internal/issue-pack.md`.
- Pulse report: `sessions/daily/YYYY-MM-DD-pulse.md`, or chat only when nothing is flagged.
- Release note: `releases/<cycle>-release-note.md`; the PRD frontmatter; `context/09-current-commitments.md` rows.

## Do not

- Do not create issues before the pack is approved, except a small bug or chore asked for by name.
- Do not paste long prose into the tracker. Link the repo document.
- Do not add estimates, points or sizing.
- Do not move an item to `Handed to Eng` without a linked engineering issue.
- Do not call `Done` shipped.
- Do not import engineering's label taxonomy into the product team.
- Do not set a PRD to `shipped` from the tracker alone, or while any acceptance criterion lacks production evidence or a `/decide` deferral.

## Hands off to

Engineering's own technical planning (outside the agent) after publish → `/session retro` at handover → after release: `/review post-ship`, then `/land`.
