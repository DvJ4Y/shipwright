# Invalid ledger — each row breaks one rule

Run with `--today 2026-11-04`. Expected: exit 1, 13 findings, 1 warning. All data is `example`.

| ID | Type | Claim | Source | Recorded | Status | Tags |
|---|---|---|---|---|---|---|
| F-001 | fact | Bad ID format | you, 2026-11-01 | 2026-11-01 | current | #id |
| F-0002 | fact | First use of an ID | you, 2026-11-01 | 2026-11-01 | current | #id |
| F-0002 | fact | Duplicate ID | you, 2026-11-01 | 2026-11-01 | current | #id |
| F-0003 | rumour | Type not in the set | you, 2026-11-01 | 2026-11-01 | current | #type |
| F-0004 | fact | No source | — | 2026-11-01 | current | #source |
| F-0005 | fact | No recorded date | you, 2026-11-01 | soon | current | #recorded |
| F-0006 | metric | Weekly sign-ups were 1,240 | inbox/_processed/2026-11-03/funnel.csv | 2026-11-03 | current | #acquisition |
| F-0007 | metric | Policies issued in December: 150 (target) | you, 2026-11-01 | 2026-11-01 | current | #policies-issued |
| F-0008 | fact | Superseded by a row that does not name it | you, 2026-11-01 | 2026-11-01 | superseded by F-0009 | #supersede |
| F-0009 | fact | Successor that forgot the link | you, 2026-11-02 | 2026-11-02 | current | #supersede |
| F-0010 | fact | Superseded by a missing row | you, 2026-11-01 | 2026-11-01 | superseded by F-0099 | #supersede |
| F-0011 | fact | The beta runs to 31 Oct | you, 2026-10-01 | 2026-10-01 | expires 2026-10-31 | #beta |
| F-0012 | fact | Marked expired before its date | you, 2026-10-01 | 2026-10-01 | expired 2026-12-31 | #beta |
| F-0013 | decision | Open status on a decision | you, 2026-11-01 | 2026-11-01 | open | #status |
| F-0014 | fact | No tags | you, 2026-11-01 | 2026-11-01 | current | |
| F-0015 | fact | Claims a supersede the old row does not record (supersedes F-0002) | you, 2026-11-02 | 2026-11-02 | current | #supersede |
