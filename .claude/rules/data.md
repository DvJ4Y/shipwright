---
paths:
  - "**/*.sql"
  - "tools/query/**"
  - "context/metrics-dictionary.csv"
---

# Query and metric files

- **Read-only.** Never write DELETE, DROP, TRUNCATE, UPDATE, INSERT, ALTER or CREATE.
  `tools/query/run-sql.sh` refuses a write statement; do not work around it.
- Head every query with a comment block: the decision it serves, the population boundary
  (what the source excludes), the source and its authority, and the metric ID if one exists.
- Check the three traps in `context/05-numbers-data-and-traps.md` before you join.
- Use `LIMIT 100` when exploring unfamiliar data.
- Label a count re-run on the SQL replica `DB-verified <date>`, with the population boundary
  stated. Label a rate computed on the replica `operational — unverified`. Label an
  event-analytics or BI-tool figure `analytics`, citing the view and the export date. A
  replica rate is never a headline until the BI tool agrees.
- Never put an API key in a query file, a command line or a permission rule. The query API
  reads it from an environment variable and sends it in a request header.
- A metric definition lives once, in `context/metrics-dictionary.csv`. Cite its `metric_id`;
  do not redefine it.
