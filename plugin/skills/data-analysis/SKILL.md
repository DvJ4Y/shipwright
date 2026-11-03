---
name: data-analysis
description: Answers product questions with data, decision first — decision, question, population boundary (what the source excludes), source authority, read-only query through the query API, sanity checks, claim level, interpretation with a source label. Metrics mode looks up a metric in the metrics dictionary or defines a new one as a metric contract. Export-request mode writes a precise export ask for the BI tool when direct access is missing. Use when someone says "pull the data", "pull the numbers", "pull the cycle time", "query this", "run a query", "check the database", "funnel numbers", "what's the conversion", "how many cases", "is this field populated", "define a metric", "what does this metric mean", "build a dashboard", or "sanity-check this number".
argument-hint: "[question] | metrics <metric name or id> | export <question>"
---

# Data analysis — decision first, then the number

Name the decision the number feeds before you query; then state the boundary, the source and the label.

## Read first (if present; else name the missing file and ask)

| File | Gives you |
|---|---|
| `context/05-numbers-data-and-traps.md` | Source authority, the replica tables, the events that exist, the three traps |
| `tools/query/sources.md` | Which source answers which kind of question, and the label each one carries |
| `context/metrics-dictionary.csv` and `.md` | Metric definitions, claim levels, status values |
| `context/02-service-and-lifecycle.md` | Exact production stage and sub-status strings |
| `tools/query/README.md` and `references/query-api.md` | The runner, its guard, and the query API shape |
| `.claude/rules/data.md` | The comment block every saved query file carries |
| `_profile.md` | `_tools_access` — which sources this person may query; `_struggles` |

## Questions first

One batched round; defaults in brackets.

1. **Decision.** What decision does this number feed, and who acts on it? [the requester]
2. **Population.** Which cases, which period, which surface or channel? [`Quote`-week cohort, last full cycle, all channels]
3. **Maturity.** How long after the cohort anchor are outcomes counted? [the dictionary's maturity for the metric; D+7 for a funnel step with no row]
4. **Authority needed.** Internal exploration, or a figure someone will quote? [internal exploration]
5. **Metric.** An existing `metric_id`, or a new definition? [look it up first]

## Procedure

1. **Decision.** One line. No decision → offer the dashboard method instead: decision → data points → representation → cadence → build. Name who reads it and what they do differently.
2. **Question.** Rewrite the ask as one answerable question with a numerator and a denominator.
3. **Population boundary.** Write what the source **excludes**. List the metrics that are therefore uncomputable. A survivors-only source (`h_policy`, closed rework items) gives counts, never rates.
4. **Source authority.** Pick from `tools/query/sources.md`: the SQL replica for counts and "does this column hold anything"; event analytics for behaviour on a surface; the BI tool for funnel rates and impact. One source per number — a numerator from one and a denominator from another is not a rate.
5. **Access check.** If `_tools_access` lacks the source, or the source answers 401, 403 or 404, switch to **export-request mode**. Do not guess around an access error, and do not substitute another source while keeping the label.
6. **Query.** Read-only, always. Run `bash tools/query/run-sql.sh --sql "<statement>"`, or `bash tools/query/run-sql.sh <saved query id>`. Use `--dry-run` first on an unfamiliar statement and `LIMIT 100` while exploring. Keep the header block (decision, boundary, source, metric id) in the saved `.sql` file and pass the bare statement. The runner rejects comments. Any other call follows `references/query-api.md`.
7. **Sanity checks** — all of them, every time:

   | Check | Fail means |
   |---|---|
   | Zero rows | Suspect the query before the data; check the three traps first |
   | Survivors-only | No rate from this source |
   | Cross-source ratio | Needs proven containment on shared case ids; "close to expected" is not proof |
   | Cohorts | Compare equal maturities only |
   | Units | Unique cases or items, not events, files or engine runs |
   | Target vs baseline | Never label a target as a measurement |
   | Schema traps | `h_case.contacts` is bare ids; `h_audit_event.metadata` is empty — read `h_case.reasons`; `h_verification` engine re-runs add rows — take the earliest officer or field row |
   | Stage strings | Exact production strings from `context/02-service-and-lifecycle.md`, case and spacing |
   | Magnitude | Compare with the last labelled figure; explain a large jump before reporting it |

8. **Claim level.** State the strongest level the evidence supports: implementation fact → measurement capability → descriptive movement → causal impact. Timing alone never supports causal impact.
9. **Interpret.** Lead with the answer to the decision. Then numerator, denominator, rate and change. Then caveats. Unknowns stay in the denominator as a visible bucket. Each figure carries the label `tools/query/sources.md` assigns its source; the five labels are defined in `.claude/rules/writing-standard.md` rule 8.

Example (Harbor Cover): "pull the rework cycle time for September" → decision: whether the 7-day rework window (`D-004`) is the right length · question: median hours from raised to closed for items raised in September (`VER-M2`) · boundary: closed items only, so report the open count beside the median (`REW-G1`) · source: the SQL replica, `h_rework_item` · label: `operational — unverified` until the BI tool's rework view agrees.

### Metrics mode

1. Search `context/metrics-dictionary.csv` by id or meaning. If found, return the row, its traps and its `status`. If `status` is `target`, say which value is the target and which is measured.
2. If not found, draft a contract with `templates/metric-contract-template.md`; the template defines every field. The numerator is unique cases, the denominator is the full eligible population, and the owner is a role. Mark unknowns `unknown`.
3. `status: proposed` until the product lead approves through `/decide`. Then append the row. Never edit `metric_id` or `meaning` of an existing row; retire it and add a new id.

### Export-request mode (no direct access)

```
Export request — <the decision it serves>
Source: the BI tool — <view, if known>
Cohort: <anchor, window, maturity D+n>
Cuts: <shop type, sum-insured band, surface, region — only the ones the decision needs>
Measures: <metric ids, with numerator and denominator as the dictionary states>
Grain: one row per case, with the case id, so containment can be proven
Cadence: <once | weekly | per cycle>
Needed by: <role who acts on it>
```

## Gate

| Tier | Gate |
|---|---|
| S | Boundary stated · every sanity check run · label and claim level on every figure |
| M | S gate · `/review` data lens on any figure that enters a PRD, a brief or a release note |

## Output

- Query files: `<feature folder>/internal/data/<question>.sql`, or `products/<code>/data/` for tier S.
- Findings: in the artifact that asked (discovery, PRD, release note), or `<feature folder>/internal/data/<question>.md`.
- Metric contracts: `<feature folder>/internal/data/metric-<id>.md`, then the dictionary row.
- In chat: the answer, the label, the claim level, the boundary — in that order.

## Do not

- No writes. Never DELETE, DROP, TRUNCATE, UPDATE, INSERT, ALTER or CREATE; the runner refuses them anyway.
- Never put an API key in a URL, a command line, a file in the repo or a permission rule.
- Never headline a replica or analytics figure. The BI tool is the headline source.
- Never present a target as a baseline.
- Never mix two sources in one rate.
- Never build a dashboard with no decision owner.
- Never continue past a 404, a 401 or a 403. Solve access first.

## Hands off to

The skill that asked: `/product-discovery`, `/prd-writer`, `/decide` or `/review` (data lens). `/issue-tracker release` for the measurement behind an impact chain.
