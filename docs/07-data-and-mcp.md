---
title: 07 — Data and MCP
type: doc
status: active
version: 1.0
supersedes: —
decision_refs: []
why: Settles which source answers a question, what label the number carries, and how the agent reaches the source without exposing a key
last_updated: 2026-11-02
---

# 07 — Data and MCP

Read this when you need to decide which source answers a question, what label the number
carries, and how the agent reaches the source without exposing a key.

## Population boundary first

Before any rate, write what the source **excludes**. Then list the metrics that are
therefore uncomputable. A table that holds only survivors — issued policies, closed rework
items — yields counts, never rates. Anchor a funnel rate on the full population by cohort;
unknowns stay in the denominator as a bucket. Compare equal maturities only. Count unique
cases, not events.

`/data-analysis` asks which decision the number feeds before it queries. With no decision,
it offers the dashboard method instead: decision → data points → representation → cadence →
build. A dashboard nobody acts on is a cost.

## Authority per source

| Source | Authoritative for | Not authoritative for |
|---|---|---|
| The BI tool | Funnel rates and the impact of a change | Ad-hoc questions |
| The SQL replica | Counts; "does this column hold anything"; case-level checks | Behaviour on a surface; a rate nobody has matched to the BI tool |
| Event analytics | Behaviour on a surface: who saw what, in what order | Case counts; business outcomes |
| The tracker | What was committed and what reached the deployed-to-production state | Anything else |

One source per number. A numerator from one source and a denominator from another is not
a rate. The worked mapping for the fictional company is in `tools/query/sources.md`.

## The five labels

| Label | Covers |
|---|---|
| `DB-verified <date>` | A count re-run on the SQL replica on that date, with the population boundary stated |
| `analytics` | A figure from event analytics or the BI tool, citing the view or insight and the export date |
| `operational — unverified` | A rate computed on the replica, or a figure read from an operational dashboard, not matched to the BI tool |
| `target` | A planned value. Never presented as a baseline |
| `example` | Fictional data. Used only inside the fictional company's files |

Every number carries one. A replica rate is never a headline until the BI tool agrees.

## Claim levels

Say the strongest thing the evidence supports, and no more.

| Level | Means |
|---|---|
| implementation fact | The column or event exists and holds data |
| measurement capability | The metric can be computed from an authoritative source |
| descriptive movement | The metric moved between two equal-maturity cohorts |
| causal impact | The movement is attributed to a change, with a comparison group |

Adding an event makes behaviour measurable. It does not show a rate improved. A PRD's
metrics table names the claim level it expects after release.

## Metrics are defined once

`context/metrics-dictionary.csv` holds every metric: numerator, denominator, cohort anchor,
maturity, authority, traps, owner. Cite the `metric_id`; never redefine it. A new metric
starts as `templates/metric-contract-template.md` and enters the dictionary through a
logged decision. `context/metrics-dictionary.md` explains the columns and the status values.

## The query runner

The query runner, `tools/query/run-sql.sh`, is the only path from the agent to the SQL
replica. It talks to the query API; the query API runs the statement on the replica. The
runner holds no data.

```bash
export SQL_API_URL="https://sql.example.com"   # in your shell profile, never in the repo
export SQL_API_KEY="your-key"
bash tools/query/run-sql.sh --sql "SELECT count(*) FROM h_case WHERE stage = 'Verification'"
bash tools/query/run-sql.sh 42                              # a saved query, by id
bash tools/query/run-sql.sh --dry-run --sql "SELECT ..."    # validate; no network, no key needed
```

| Rule | Why |
|---|---|
| The key lives only in the environment and travels in a request header | A key in a file gets committed; a key in a URL or on a command line gets logged |
| Ad-hoc SQL passes a guard: no dollar quoting, no comments, one statement, a read keyword first, no write keyword as a whole word | A comment can hide a second statement. The guard is a safety net, not permission |
| Query only a read replica, with a read-only key | The guard cannot make a write connection safe |
| Head every saved query with the decision, the boundary, the source and the metric id | A number with no decision behind it is the one most likely to be wrong |

`.claude/rules/data.md` applies these rules to every `.sql` file and to the dictionary.

## A 404 is a stop signal

If the query API answers 404, 401 or 403, the runner stops and says so. Do not try other paths,
ids or hosts. Do not substitute another source and keep the label. Solve access first, then
query. The same rule holds for the tracker and for event analytics: an agent that cannot
reach a source says so. It does not reason about data it cannot see.

## Export-request mode

When `_tools_access` in `_profile.md` lacks the source, or access fails, `/data-analysis`
writes an export request for the BI owner instead. It holds the decision; the question as
numerator and denominator; the population boundary; the cohort and maturity; the cuts; the
cadence. Nothing else. The BI tool is the only source for a headline figure.

## The two MCP servers

`.mcp.json` declares two servers under capability-named keys.

| Key | What | Transport | Authorise |
|---|---|---|---|
| `tracker` | The issue tracker's hosted MCP server, bridged to stdio | `npx -y mcp-remote <url>` | `/mcp` once; the CLI stores the token |
| `analytics` | The event-analytics MCP server | HTTP | `/mcp` once |

Tool names derive from the keys: `mcp__tracker__…`, `mcp__analytics__…`. Skills say "the
tracker" and "event analytics", so swapping the vendor behind a key changes nothing else.
`.claude/settings.json` allows the tracker's read tools and asks before each write.
`.mcp.json` holds no secrets and is committed.

Swap the tracker by replacing the entry and keeping the key; `.mcp.README.md` shows three
shapes. The `github` adapter needs no server: it uses the `gh` command, and `_profile.md`
says `_tracker: github`.

The query runner is not an MCP server. The key stays in the shell. The guard is a few lines
of bash anyone can read. The skill sees every statement it sends and stops on a 404.

Run `/mcp` before trusting either server. A server that fails to connect is a connection
failure, not a missing capability. Re-authorise, check that `npx` is on the `PATH`, and
never paste a token into a file.

## The three traps

The fictional replica has three joins that return a wrong answer without an error. They
are in `context/05-numbers-data-and-traps.md`, each with the query shape to use instead.
Your replica has its own. Write them in the same file and check them before every join. If
a query returns zero rows, suspect the query before the data.
