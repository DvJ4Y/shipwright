---
title: "Crosswalk: <old structure> → <new structure>"
type: crosswalk
status: draft
version: 0.1
owner: <role>
decision_refs: []
why: Shows where every earlier requirement went before anything is superseded
last_updated: YYYY-MM-DD
---

# Crosswalk: <old structure> → <new structure>

> A requirement is retired only when this table shows where it went. Write the crosswalk
> **before** marking any older file superseded.

| Earlier source (file#section or issue) | Requirement (one line) | Treatment | Destination | Decision point |
|---|---|---|---|---|
| | | carried / refined / merged / moved / deferred / dropped / not applicable | PRD section, issue, later feature, or — | P-nn or — |

**Treatments**

| Treatment | Means |
|---|---|
| carried | Kept as written |
| refined | Kept, with changed wording or rule |
| merged | Combined with another requirement |
| moved | Lives in another feature or project |
| deferred | Kept for later, with a trigger condition |
| dropped | Not carried, with a decision point recording why |
| not applicable | Does not apply to the new structure |

**Coverage check:** <rows in source> = <rows in this table>. Unmapped rows: <0>.
