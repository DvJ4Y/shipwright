# Valid ledger — every rule kept

Run with `--today 2026-11-04`. Expected: exit 0, 0 findings. All data is `example`.

| ID | Type | Claim | Source | Recorded | Status | Tags |
|---|---|---|---|---|---|---|
| F-0001 | metric | Weekly sign-ups were 1,240 (operational — unverified) | inbox/_processed/2026-10-20/funnel.csv | 2026-10-20 | superseded by F-0004 | #acquisition |
| F-0002 | target | Policies issued in December: 150 (target) | you, 2026-11-01 | 2026-11-01 | expires 2026-12-31 | #policies-issued |
| F-0003 | fact | The beta runs to 31 Oct | you, 2026-10-01 | 2026-10-01 | expired 2026-10-31 | #beta |
| F-0004 | metric | Weekly sign-ups were 1,290 (analytics) (supersedes F-0001) | inbox/_processed/2026-10-27/funnel.csv | 2026-10-27 | superseded by F-0005 | #acquisition |
| F-0005 | metric | Weekly sign-ups were 1,310 (DB-verified 2026-11-03) (supersedes F-0004) | chat:2026-11-03 | 2026-11-03 | current | #acquisition |
| F-0006 | open-question | Does the insurer partner accept a scanned signature? | chat:2026-11-02 | 2026-11-02 | open | #documents |
| F-0007 | behaviour | The desk shows the rework reason on the case header | releases/2026-10-30-rework-reason.md | 2026-10-30 | current | #desk #rework |
