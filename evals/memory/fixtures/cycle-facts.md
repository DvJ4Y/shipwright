# Cycle ledger — two rows supersede each other

Run with `--today 2026-11-04`. Expected: exit 1, with a `cycle` finding. All data is `example`.

| ID | Type | Claim | Source | Recorded | Status | Tags |
|---|---|---|---|---|---|---|
| F-0001 | fact | Rework goes to the desk (supersedes F-0002) | you, 2026-11-01 | 2026-11-01 | superseded by F-0002 | #rework |
| F-0002 | fact | Rework goes to the field verifier (supersedes F-0001) | you, 2026-11-01 | 2026-11-01 | superseded by F-0001 | #rework |
