---
title: 05 — Internal and external
type: doc
status: active
version: 1.0
supersedes: —
decision_refs: []
why: Settles what a reader outside the workspace may see, and how to publish it so they can work from it alone
last_updated: 2026-11-02
---

# 05 — Internal and external

Read this when you need to decide what a reader outside the workspace may see, and how to
publish it so they can work from it alone.

## Two halves of every feature folder

| Folder | Holds | Who reads it |
|---|---|---|
| `shared/` | The PRD, the brief, the copy table and the strings files | Engineering, ops, a partner, a reviewer outside the team |
| `internal/` | Discovery, the `P-nn` decision log, the data packet, the design spec, reviews, readiness, the issue pack, the crosswalk, evidence | The product lead and the agent |
| `mockups/`, `showcase/` | Wireframes, prototypes, the story | Both. The story goes outside the team only after the product lead gates the look and the customer-language strings exist |

A tier S change writes one file into `shared/` or `internal/`, by audience.

## What "self-contained" means

A `shared/` file reads correctly on its own: in another repository, in a tracker
description, or printed.

| In the body | Rule |
|---|---|
| Dates | None, except inside a source label (`DB-verified <date>`) |
| Decision ids | None. The decision is applied; its id stays in `internal/` |
| Local paths | None. No user folders, no `../`, no workspace folder names |
| Phase check | None. It lives in chat and in `internal/readiness.md` |
| Tracker ids | None. The publication log in `internal/issue-pack.md` maps them |
| Crosswalk | One line per carried requirement in the PRD's last section; the full table with paths and ids is `internal/crosswalk.md` |
| Frontmatter | Keeps the mandatory fields: `status`, `version`, `supersedes`, `decision_refs`, `why`, `last_updated` |

A reader outside the workspace also gets no session jargon and no internal sequence
numbers. Roles, not names. Capability names, not vendor names. Every number labelled.

## The mechanical guard

`scripts/check-pack.sh` fails on company-word residue anywhere (vendor names outside the
adapters, the old title for the engineering lead, the old nickname for the product lead,
non-Latin script). It fails on a local path, a `P-nn` or `D-nnn` id, or a tracker prefix
inside any `shared/` folder. It also fails on person names in plans, numbers without a
label, files over the line limit, unfilled placeholders, secrets, and a `landed` PRD outside
`archive/`. Run it before any share. `scripts/pre-commit.example` wires it to git.

## What a reader outside the workspace gets

| Reader | Gets | Does not get |
|---|---|---|
| The engineering lead and developers | `shared/`; read access to `context/policies/`, `context/surfaces/`, `context/05-numbers-data-and-traps.md` and `qa/`; the issue pack as tracker issues | `internal/`, the decision logs, `sessions/`, memory |
| The ops lead, the compliance officer | The PRD's rules and evidence sections; the story once gated | Reviews, readiness |
| A partner or a board | The story, with its "vision" framing line | Anything with a rule value they could read as a commitment |
| An external reviewer (another model or tool) | A read-only copy of the folder | Write access |

The product lead agrees with the engineering lead what engineering reads beyond `shared/`.
The row above is the default. `docs/08-handoff-to-engineering.md` lists the inputs to settle.

## Publication checklist

A handover is finished when the reader can work from the tracker and the shared documents
alone.

- [ ] **One document per unit.** An overview, then one document per feature or task that
      holds its requirement, brief, sub-issues and acceptance together. Shared header and
      navigation.
- [ ] **The owner's voice.** Decided, present tense. No "draft", no version noise, no
      mistake history. One status line: decided, for engineering alignment, comments open.
- [ ] **Fields, not prose, in the tracker.** Priority, cycle, milestone and labels (lane,
      work type, surface) are fields. The description holds outcome, behaviour and states,
      acceptance criteria by id, and links. No urgency prose, no bare ids.
- [ ] **Functional sub-issues.** Slices a customer can see or an operator can accept. Never
      Frontend, Backend, API, Database or QA.
- [ ] **Acceptance-test and product-ops issues.** One acceptance-testing issue per task for
      the product team; product-ops issues (configuration, template approval, roles, data
      tagging), each with an owner.
- [ ] **The wireframe matches the locked rules.** L0 with the state strips; additions
      marked. The author updates it to the locked rules before publishing.
- [ ] **Read-back.** `/issue-tracker publish` reads every issue back against the pack and
      records the map in the publication log.
- [ ] **Phase check stated in chat.** Decisions locked and applied; no open markers.
- [ ] **`scripts/check-pack.sh` passes** on the folder.

## External reviewers

Give an external reviewer a read-only copy and a prompt that says: no file edits, no
answers to policy questions, behaviour-changing findings become PENDING decisions.
Snapshot before and verify after:

```bash
bash scripts/review-guard.sh snapshot <folder>
bash scripts/review-guard.sh verify <folder>     # exit 1 lists changed, added and removed files
bash scripts/review-guard.sh restore <folder>
```

Reviewers report. The author applies the fixes and diffs the folder.

## Sharing a story

The table above says when a story may leave the team. The framing line that names which
beats are live travels with it everywhere.
