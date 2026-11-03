---
title: "Issue pack: <feature>"
type: issue-pack
status: draft            # draft | approved | published
version: 0.1
owner: <role>
prd: <path>
brief: <path>
mockup: <path or —>
decision_refs: []
why: Copy source for the parent issue and its product sub-issues
last_updated: YYYY-MM-DD
---

# Issue pack: <feature>

> Copy source for publication. Introduces **no requirement** that is not in the approved
> PRD, mockup or brief. Sub-issues are **functional slices** a user can see or an operator
> can accept — never "Frontend", "Backend", "API", "Database" or "QA". Engineering creates
> its own technical sub-issues after handover.

## Parent issue

**Title:** <outcome-first title>

**Description**

- **Problem and outcome:** <2 lines>
- **Users and use cases:** <U1, U2 from the PRD>
- **Scope:** <in> · **Non-goals:** <out>
- **Acceptance (summary):** <A1, A2 … from the PRD>
- **Dependencies:** <issues or teams>
- **Links:** PRD <path> · Brief <path> · Mockup <path>
- **Sub-issues:** <list below>

## Product sub-issues

### S1 — <functional slice title>

- **Outcome:** <who can do what>
- **Behaviour and states:** <included states>
- **Acceptance criteria:** <the PRD's criteria copied verbatim with their ids; a When…then added only where the PRD lacks one, marked `refined`>
- **Depends on:** <parent / Sn>
- **Rules, permissions and evidence:** <PRD §6 and §7 rows by id, each with its policy value or policy-file row>
- **Reference:** PRD §<n> · mockup frame <name> (paths engineering can open in the repo)

## Supporting-project issues (only if another team owns a real outcome)

| Title | Owning team / project | Outcome | Link to parent |
|---|---|---|---|

## Publication log

| Item | Tracker id | Published | Read-back matches pack? |
|---|---|---|---|
