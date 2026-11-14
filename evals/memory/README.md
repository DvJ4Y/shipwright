# evals/memory — checks for the learning layer

Run the ledger check before you commit a change to `knowledge/facts.md`. It needs Python 3
and nothing else. It calls no model and gives the same answer every time for a fixed date.

```
python3 evals/memory/check_facts.py knowledge/facts.md
python3 evals/memory/check_facts.py --today 2026-11-04 evals/memory/fixtures/*.md
```

Exit 0: every file passes. Exit 1: at least one finding. Exit 2: a usage error.
Warnings print but do not change the exit code. `--today` pins the date for expiry checks.
`--quiet` prints one verdict line per file.

## What it checks

| Check | Finding when |
|---|---|
| `header` | The file has no ledger table (`ID · Type · Claim · Source · Recorded · Status · Tags`) |
| `columns` | A ledger row does not have seven cells |
| `id` | An ID is not `F-` and four digits, or appears twice |
| `type` | The type is not one of the nine allowed types |
| `claim` | The claim is empty |
| `source` | The source is empty or a dash |
| `recorded` | The recorded date is not `YYYY-MM-DD`, or is after today |
| `metric-label` | A `metric` row carries no source label, or two |
| `target-as-metric` | A `metric` row is labelled `target`, or a `target` row carries a measured label |
| `status` | The status is not one of the five forms, or `open` is used outside `open-question` |
| `expiry` | An `expires` date has passed, or an `expired` date is still in the future |
| `supersede` | `superseded by` names a missing row or itself; the successor does not say `(supersedes F-x)`; a `supersedes` claim is not recorded on the old row; the successor is older; the chain cycles or ends in an invalid status |
| warning `tags` | A row has no `#tag`, so recall cannot match it |
| warning `expiry` | `expired` without its date, or a supersede chain that ends in an expired row |

## Fixtures

| File | Expected with `--today 2026-11-04` |
|---|---|
| `fixtures/valid-facts.md` | exit 0, 0 findings |
| `fixtures/invalid-facts.md` | exit 1, 13 findings, 1 warning — one broken rule per row |
| `fixtures/cycle-facts.md` | exit 1, 2 `cycle` findings |

A change to `check_facts.py` keeps these three results. A new check adds a row to
`invalid-facts.md` and raises the expected count here.

## What it does not check

The script checks the ledger's shape. It cannot judge whether a claim is true, whether a
duplicate was missed, or whether `/learn` obeyed an instruction hidden in an inbox file.
`cases.md` covers those, as eight scenarios a person runs against the model.
