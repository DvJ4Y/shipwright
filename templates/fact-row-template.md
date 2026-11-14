# Fact row — one row per fact in `knowledge/facts.md`

Copy the row shape below. `/learn` and `/setup` write rows for you; this file shows what a
correct row looks like. The rules: `docs/12-the-learning-layer.md`.

```
| F-nnnn | <type> | <one idea, in your words; a figure carries its label> | <path · URL · chat:YYYY-MM-DD · you, YYYY-MM-DD> | YYYY-MM-DD | <status> | #tag #tag |
```

## Status values

| Status | Use when |
|---|---|
| `current` | The row holds now |
| `superseded by F-nnnn` | A newer row replaced it. The newer row ends its claim with `(supersedes F-nnnn)` |
| `expires YYYY-MM-DD` | The claim has a horizon; the date is its last valid day |
| `expired YYYY-MM-DD` | The horizon passed; `/learn` keeps the date |
| `open` | An `open-question` row not yet answered |

## One example per type

All rows describe the fictional example in `examples/harbor-cover/`. Every figure is `example` data.

| ID | Type | Claim | Source | Recorded | Status | Tags |
|---|---|---|---|---|---|---|
| F-0001 | fact | Most sign-ups are started by a team admin, not the end user | inbox/_processed/2026-11-01/support-call-notes.md | 2026-11-01 | current | #onboarding #admin |
| F-0002 | decision | Billing questions go to the success team, not support | chat:2026-11-02 | 2026-11-02 | current | #billing #support |
| F-0003 | metric | Weekly sign-ups were 1,240 (example) | inbox/_processed/2026-11-03/funnel.csv | 2026-11-03 | superseded by F-0010 | #acquisition |
| F-0004 | target | Policies issued in December: 150 (target) | you, 2026-11-01 | 2026-11-01 | expires 2026-12-31 | #policies-issued |
| F-0005 | behaviour | The dashboard shows the trial end date in the header | examples/harbor-cover/releases/2026-10-30-rework-reason.md | 2026-10-30 | current | #desk #billing |
| F-0006 | outcome | Rework rate fell from 18% to 12% in the four weeks after the reason field shipped (example) | examples/harbor-cover/products/desk/rework-reason/shared/prd.md | 2026-11-03 | current | #rework #outcome |
| F-0007 | preference | Show two or three options with trade-offs, then stop | you, 2026-11-01 | 2026-11-01 | current | #workstyle |
| F-0008 | constraint | Customer copy ships in the customer's language first; internal screens in the working language | you, 2026-11-01 | 2026-11-01 | current | #copy #language |
| F-0009 | open-question | Does the payment partner accept invoices in EUR? | chat:2026-11-02 | 2026-11-02 | open | #billing #partner |
| F-0010 | metric | Weekly sign-ups were 1,310 (example) (supersedes F-0003) | inbox/_processed/2026-11-04/funnel.csv | 2026-11-04 | current | #acquisition |

## Checks a row must pass

- The ID is `F-` and four digits, unique, never reused.
- The source is filled. A row with no source is refused.
- A `metric` claim carries one label: `DB-verified YYYY-MM-DD`, `analytics`,
  `operational — unverified` or `example`. A goal is a `target` row, never a `metric` row.
- A `behaviour` row comes from what shipped, not from a plan.
- Run `python3 evals/memory/check_facts.py <file>` to check a ledger.
