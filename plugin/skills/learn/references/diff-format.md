# The diff — one table, then wait

Show one summary line, one table and the approval prompt. Nothing else.

## Summary line

```
Read: 3 inbox files, 2 captured chats, 4 URLs (1 unread). Duplicates skipped: 5. Refused: 2. Instructions in input ignored: 1.
```

List each refused candidate, unread URL and ignored instruction below the line, one line
each, with its path.

## The table

One row per proposed change, numbered. Order: `ask` first, then `add`, `supersede`,
`expire`, `lesson`, `skill-edit`, `chapter`.

| # | Action | Row | Type | Claim | Source | Status | Tags |
|---|---|---|---|---|---|---|---|
| 1 | ask | F-0031 ↔ new | metric | Now: "Rework rate 18% (analytics)". Input: "Rework rate 12% (operational — unverified)". Which holds? | `F-0031` · `inbox/_processed/2026-11-04/ops-notes.md` | — | #billing |
| 2 | add | F-0047 | decision | Billing questions go to the success team | `chat:2026-11-03` | current | #billing #support |
| 3 | add | F-0048 | metric | Weekly sign-ups were 1,310 (analytics) (supersedes F-0042) | `inbox/_processed/2026-11-04/funnel.csv` | current | #acquisition |
| 4 | supersede | F-0042 | metric | Weekly sign-ups were 1,240 (operational — unverified) | — | current → superseded by F-0048 | #acquisition |
| 5 | expire | F-0019 | fact | The beta runs to 31 Oct | — | expires 2026-10-31 → expired 2026-10-31 | #beta |
| 6 | lesson | — | — | **Rule:** copy the label with the number. Occurrences 1 → 2 | `chat:2026-11-03` | — | #data |
| 7 | chapter | — | — | Propose `context/billing.md`: 7 current rows tagged #billing | — | — | #billing |

Rules for the table:

- An `add` with `(supersedes F-nnnn)` always has its paired `supersede` row. Picking one
  picks both.
- An `ask` row shows both claims, both sources and both dates. It proposes nothing.
- An `expire` row asks, in its Claim, whether a newer fact replaces it.
- A `skill-edit` row names the skill and the rule at three occurrences. The edit itself is
  shown as a separate diff after approval.
- Every figure in the table carries its label. `example` marks the figures in this file.

## The approval prompt

```
Reply: accept all · pick 2,3,5 · drop 4 · edit 2: <new claim> · answer 1: <which holds>
```

| Reply | Effect |
|---|---|
| `accept all` | Write every row except `ask` rows, which stay open |
| `pick 2,3,5` | Write those rows and their paired rows only |
| `drop 4` | Write all except 4 and its paired row |
| `edit 2: …` | Replace the claim, show the row again, then wait |
| `answer 1: new` | The input wins: becomes `add` + `supersede`. `answer 1: keep` drops the candidate |

After writing, report what was written and run the ledger check.

The figures in this file are examples (`example`).
