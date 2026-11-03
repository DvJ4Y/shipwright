---
title: Wireframe kit — when to use L0 and how to check it
type: tool
status: active
version: 1.0
supersedes: —
decision_refs: []
why: Tells the product lead when an L0 wireframe is the right artifact and how to prove it is data complete
last_updated: 2026-11-02
---

# Wireframe kit

Use this kit when a feature needs a wireframe that engineering can read as a data contract.
The kit is `kit.md` (conventions and the style block) and `check_wireframe_data.py` (the
check). The worked example is `products/desk/verification-outcome-and-rework/mockups/`.

## When to use L0

| Moment | Use L0 when |
|---|---|
| Discovery | You need to show a flow across surfaces before anyone has agreed on it |
| PRD | The "Information" section needs a picture; every field on the screen must trace to a data point |
| Engineering brief | The brief names reuse locations; the wireframe shows them in place, with the gaps marked `none` |
| Review | A reviewer asks "which of these fields exists today?" — the chips answer without a meeting |

Pick L1 (hi-fi in the surface palette) only after the L0 has passed the check and the
product lead has chosen the option. Pick L2 (clickable) when the flow, not the data, is the
question.

## What an L0 is not

- Not a source of business rules. The PRD and the policy files hold the rules; the wireframe
  shows where a rule's outcome appears.
- Not a design. Greyscale, no palette, no brand. Colour comes later from
  `context/design/tokens.md`.
- Not evidence that an integration works. A provider value in a wireframe is a labelled
  fixture.
- Not a schema. `current storage` names a location that exists today, or says `none`. It
  never proposes a column.

## The data packet

Each feature keeps `internal/data-packet.csv` with the columns
`point_id,label,type_unit,provenance,current_storage,disposition,surface,notes`.
One row per data point the feature shows, captures or derives. Twenty to thirty rows is
normal for one feature across three surfaces. Vocabulary for `provenance` and `disposition`
is in `kit.md` section 2.

## Running the check

```
python3 tools/wireframe-kit/check_wireframe_data.py products/<code>/<feature>
python3 tools/wireframe-kit/check_wireframe_data.py products/<code>/<feature> --prototypes
```

Standard library only; no install. The first form reads `internal/data-packet.csv` and
every `*.mockup.html` under `mockups/` and runs five checks.

| # | Check | Fails when |
|---|---|---|
| 1 | Chip resolves | A chip's point id is not a packet row, the chip has other than five segments, or its provenance is not one of the row's origins |
| 2 | One chip per field | A `<div class="f">` block carries zero or two or more chips |
| 3 | Strip vocabulary | A `<div class="strip">` label is not one of EMPTY, PARTIAL, MISSING, RESTRICTED, PROVIDER-FAILED, REWORK |
| 4 | Disposition agrees | The chip's last segment differs from the packet's `disposition` |
| 5 | Storage claim agrees | The chip says `none …` for a point whose packet row has a path, or quotes a path for a point whose row says `none` |

The storage segment is not string-compared, because chips abbreviate long paths. Only the
claim class must agree. The packet itself is validated too: required columns, unique ids,
and vocabulary on `disposition` and `provenance`.

`--prototypes` reads `*.prototype.html` instead and asserts that every `data-pt="ID"`
attribute resolves to the packet. Prototypes carry no chips, so checks 2, 4 and 5 do not
apply to them.

| Exit code | Meaning |
|---|---|
| 0 | Pass. One summary line per file, then `PASS` |
| 1 | At least one finding, each printed as `file:line: message` on stderr |
| 2 | Usage error: folder, packet or `mockups/` not found, or no mockup files |

The check prints which of the six strips each file shows. A file that lacks a strip is not
a failure; the kit asks for all six, so treat the line as a prompt to add the strip or the
`not applicable on this screen` note.

## Compile check

`python3 -m py_compile tools/wireframe-kit/check_wireframe_data.py` must pass before the
script is committed.
