# Facts — the ledger

> One row per fact. Write rows through `/learn`, `/setup`, `/land`, `/review post-ship` or
> `/decide`; each shows you a diff first. Never delete a row: supersede it or mark it expired.
> Check the file with `python3 evals/memory/check_facts.py knowledge/facts.md`.
> Row examples, one per type: `templates/fact-row-template.md`.

## Column rules

| Column | Rule |
|---|---|
| ID | `F-` and four digits. The next free number. Never reused, never renumbered |
| Type | `fact` · `decision` · `metric` · `target` · `behaviour` · `outcome` · `preference` · `constraint` · `open-question` |
| Claim | One idea, in your words. A `metric` row carries one source label: `DB-verified YYYY-MM-DD`, `analytics`, `operational — unverified` or `example`. A figure with no label is refused. A target is a `target` row, never a `metric` row. A row that replaces another ends its Claim with `(supersedes F-nnnn)` |
| Source | A repository path, a URL, `chat:YYYY-MM-DD` or `you, YYYY-MM-DD`. A row with no source is refused |
| Recorded | The date the row was written, `YYYY-MM-DD` |
| Status | `current` · `superseded by F-nnnn` · `expires YYYY-MM-DD` · `expired YYYY-MM-DD` (the expiry date is kept) · `open` (open questions only) |
| Tags | At least one: `#surface`, `#topic`, `#person-role`. Recall matches on these |

## Type rules

| Type | Holds | Not this |
|---|---|---|
| `behaviour` | What a surface does in production today. Source: `/land` or a production check | A plan. A plan is a `decision` or a `target` |
| `outcome` | What happened after a release, with a labelled figure | A forecast |
| `preference` | How you work | A fact about the business |

## Ledger

| ID | Type | Claim | Source | Recorded | Status | Tags |
|---|---|---|---|---|---|---|
