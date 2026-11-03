---
title: <Surface> — current behaviour
type: current-behaviour
surface: <surface code>
status: active
version: 0.1
supersedes: —
decision_refs: []
why: One durable statement of what <Surface> does today, so no PRD re-specifies a landed behaviour
last_updated: YYYY-MM-DD
---

# <Surface> — current behaviour

> Last verified: YYYY-MM-DD

This table is the durable requirements layer for <Surface>. One row per observable behaviour
that is live. The `land` skill appends rows here when a PRD reaches `shipped`, then sets the
PRD to `landed` with `landed_into:` pointing at the row ids. Rows are never deleted; a
replaced behaviour gets a new row and the old row's `Behaviour` is prefixed `SUPERSEDED by
<PREFIX>-nnn`.

**Before writing a PRD for this surface, read this table.** Most "new" behaviour is an
extension of a row below. Cite the row id in the PRD's "Current behaviour and reuse" section.

| ID | Behaviour | Source PRD | Landed on |
|---|---|---|---|
| <PREFIX>-001 | When <situation>, then <observable result> | <PRD path, or `pre-pack`> | <YYYY-MM-DD> |

## Reading the columns

| Column | Holds |
|---|---|
| `ID` | `<PREFIX>-nnn`, append-only |
| `Behaviour` | One observable "When … then …" sentence. No mechanism, no component names. Scoped to a role where the role matters. A behaviour that performs a regulated action ends with "— regulated action: <register row>" |
| `Source PRD` | The PRD path under `products/<code>/…/shared/`; `pre-pack` for behaviour that predates this repo |
| `Landed on` | The date the behaviour reached production (`YYYY-MM-DD`, written by `land`; pre-pack rows may carry a month) |

## Gaps the table makes visible

- <A behaviour that is live but has no row, or a row that a committed feature extends.>
