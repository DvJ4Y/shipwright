---
status: active
version: 1.0
supersedes: none
decision_refs: none
why: Let the data-analysis skill run a read-only query without ever exposing a key
last_updated: 2026-11-02
---

# `run-sql.sh` — read-only SQL on the SQL replica, through the query API

Set two environment variables once, then run `bash tools/query/run-sql.sh --sql "SELECT ..."`.
The script talks to the query API (Redash-compatible). The query API runs the statement on
the SQL replica. The script creates a temporary query, runs it, polls the job, prints a
markdown table and deletes the temporary query. The script is a client of the query API; it
is not the replica and holds no data.

## 1. Set the two variables in your shell profile

```bash
# ~/.zshrc or ~/.bashrc
export SQL_API_URL="https://sql.example.com"   # base URL of the query API, no trailing slash
export SQL_API_KEY="your-key"                  # your personal API key
export SQL_DS_ID=1                             # optional: default data source id
```

Then `source ~/.zshrc`. Rules the script enforces:

| Rule | Why |
|---|---|
| The key lives only in the environment | A key in a file in the repo gets committed |
| The key is sent in the `Authorization: Key …` header, passed to `curl` as a config on stdin | A key in a URL is logged by proxies and servers; a key as a `curl` argument shows in the process list and shell history |
| Never type the key on a command line or in a permission rule | Permission rules match command prefixes and are written into settings |

## 2. Run

```bash
bash tools/query/run-sql.sh --sql "SELECT count(*) FROM h_case WHERE stage = 'Verification'"
bash tools/query/run-sql.sh --sql "SELECT ..." --ds 3        # another data source
bash tools/query/run-sql.sh 42                              # fresh run of saved query 42
bash tools/query/run-sql.sh --dry-run --sql "SELECT ..."    # validate; no network, no key needed
```

Output is a markdown table on stdout. Progress and errors go to stderr. `jq` and `curl` are
required for a real run; the dry run only warns if `jq` is missing.

## 3. The read-only guard

Ad-hoc SQL passes four checks before anything is sent. Saved queries skip the guard; they
are reviewed where they are saved.

| Check | Rejects |
|---|---|
| No dollar quoting | any `$$` — it hides statements |
| No comments | any `--` or `/*` outside a string literal — a comment can hide a second statement from the guard |
| One statement | a `;` anywhere except at the very end |
| Read keyword first | anything that does not start with `SELECT`, `WITH`, `EXPLAIN`, `SHOW`, `VALUES` or `TABLE` |
| No write keyword as a whole word | `DELETE DROP TRUNCATE UPDATE INSERT ALTER CREATE MERGE GRANT REVOKE CALL COPY EXECUTE EXEC DO INTO LOCK VACUUM REINDEX REFRESH SET RESET BEGIN COMMIT ROLLBACK PREPARE DEALLOCATE` |

`'String literals'` are removed before the other checks, so `WHERE action = 'update'` passes,
and keywords match whole words only, so `updated_at` passes. Keep notes about a query in the
document that cites it, not in the SQL. A rejected statement exits with code 3 and the message
`write operations are not allowed`. The guard is a safety net, not permission: query only a
read replica, and only with a read-only key.

## 4. A 404 is a stop signal

If the API answers 404, the script stops and says so. Do not try other paths, ids or hosts.
Fix the URL or the query id, or ask the owner of the replica for access. The same applies to
401 and 403: solve access first, then query. Guessing around an access error produces numbers
nobody can trace.

## 5. Dry run for the gate

```bash
unset SQL_API_URL SQL_API_KEY
bash tools/query/run-sql.sh --dry-run --sql "UPDATE h_case SET status='x'"   # exit 3, read-only error
bash tools/query/run-sql.sh --dry-run --sql "SELECT count(*) FROM h_case"    # exit 0, prints the plan
```

The dry run needs neither variable. It prints the mode, whether the URL and key are set, the
endpoints it would call and the statement that passed the guard.

## Where this fits

`sources.md` in this folder says which source is authoritative for which kind of question.
The `data-analysis` skill reads that file before choosing a source, then calls this script.
