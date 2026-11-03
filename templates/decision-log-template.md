---
title: "<Workspace, initiative or feature> — decision log"
type: decision-log
status: active
owner: <role>
why: One place for every decision point, open or closed
last_updated: YYYY-MM-DD
---

# <Scope> — decision log

> **Append-only.** Never rewrite a LOCKED row. To change one, add a new row whose
> `Supersedes` names the old ID, then set the old row's status to SUPERSEDED.
> IDs are decision points. The workspace log uses `D-001`, `D-002`, …; a feature or
> initiative log uses `P-01`, `P-02`, …. A `[NEEDS CLARIFICATION: … → P-nn]` marker in a
> document points at a PENDING row here.

| ID | Date | Status | Decision point | Decision / recommendation | Why (incl. rejected alternatives) | Door | Owner | Revisit if | Propagates to | Supersedes |
|---|---|---|---|---|---|---|---|---|---|---|
| P-01 | YYYY-MM-DD | PENDING | <the question, phrased as a choice> | <recommendation — PENDING until the owner confirms> | <why; alternatives rejected; evidence with source labels> | one-way / two-way | <role> | <trigger> | <files this changes> | — |

**Status values:** `PENDING` (open or recommended, not confirmed) · `LOCKED` (owner
confirmed) · `SUPERSEDED` (replaced; see the row that names it).

**Rules:** roles, not person names. No target presented as a baseline. A decision resting on a
number cites the query or report and its source label. A decision that reaches another team,
a metric or a locked row carries a one-line consequence in `Why`. Longer reasoning goes in a
decision record (`templates/decision-record-template.md`), linked from the row.
