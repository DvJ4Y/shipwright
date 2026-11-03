# The query API — shape, keys and stop signals

Run every query through `tools/query/run-sql.sh`. This file describes the API the runner talks to. A reader can check what the runner does, or make a direct call when the runner is unavailable. The API is Redash-compatible: one shape, any provider that follows it.

## Two environment variables

| Variable | Holds | Where it lives |
|---|---|---|
| `SQL_API_URL` | Base URL of the query API, no trailing slash | the shell profile |
| `SQL_API_KEY` | A personal, read-only API key | the shell profile — never a file in the repo, a URL, a command-line literal or a permission rule |

The key travels in the `Authorization: Key …` header. The runner passes it to `curl` as a config on stdin, so it never appears in the process list or the shell history. A key in a URL is logged by proxies and servers.

## The calls the runner makes

| Step | Call | Returns |
|---|---|---|
| Fresh run of a saved query | `POST /api/queries/<id>/results` with `{"max_age": 0}` | a `job` |
| Ad-hoc statement | `POST /api/queries` with `query`, `data_source_id` and a temporary `name`, then the fresh-run call above on the new id | a query id, then a `job` |
| Poll | `GET /api/jobs/<job_id>` until `status` is `3` (done); `4` means failed | `query_result_id` |
| Fetch | `GET /api/query_results/<result_id>` | columns and rows |
| Clean up | `DELETE /api/queries/<id>` for the temporary query | — |

The data source id comes from `SQL_DS_ID` (default `1`) or `--ds`. The replica owner reviews saved queries where they are saved. Ad-hoc statements pass the runner's read-only guard first.

## A direct call, when the runner is not available

```bash
# header from the environment; the key never appears on the command line
printf 'header = "Authorization: Key %s"\n' "$SQL_API_KEY" | \
  curl -s -K - -X POST -H "Content-Type: application/json" \
  -d '{"max_age": 0}' "$SQL_API_URL/api/queries/<id>/results"
```

Poll and fetch the same way. Delete any temporary query you created.

## Read-only

Send only `SELECT`, `WITH`, `EXPLAIN`, `SHOW`, `VALUES` or `TABLE` statements, one at a time, with no comments and no dollar quoting. The guard in the runner is a safety net, not permission. Query only a read replica, and only with a read-only key.

## Stop signals

A 404 or an empty result from a system you expected to answer is a stop signal. So are 401 and 403. Do not try other paths, ids or hosts, and do not substitute another source while keeping the label. Say what failed, then fix the URL or the query id, or ask the owner of the replica for access. Guessing around an access error produces numbers nobody can trace.

An empty result on a known table means the statement is wrong until proven otherwise. Check the three traps in `context/05-numbers-data-and-traps.md` before reporting a zero.

## Dry run

`bash tools/query/run-sql.sh --dry-run --sql "<statement>"` needs neither variable. It prints the mode, whether the URL and key are set, the calls it would make and the statement that passed the guard. Use it before a real run on an unfamiliar statement.
