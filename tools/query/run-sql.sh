#!/usr/bin/env bash
# tools/query/run-sql.sh — read-only SQL runner. Sends one statement to the query API, which runs
# it on the SQL replica, and prints the result as a markdown table (see tools/query/README.md).
#
# Usage:
#   bash tools/query/run-sql.sh <query_id>                       # fresh run of a saved query
#   bash tools/query/run-sql.sh --sql "SELECT ..."               # ad-hoc SQL on the default data source
#   bash tools/query/run-sql.sh --sql "SELECT ..." --ds 3        # ad-hoc SQL on data source 3
#   bash tools/query/run-sql.sh --dry-run --sql "SELECT ..."     # validate and show what would run; no network
#   bash tools/query/run-sql.sh --dry-run 42                     # same, for a saved query
#
# Environment — set in your shell profile; never in a URL, never on the command line:
#   SQL_API_URL   base URL of the query API, e.g. https://sql.example.com
#   SQL_API_KEY   API key. Sent only in the Authorization header, passed to curl as a config on stdin.
#   SQL_DS_ID     optional default data source id (default 1)
#
# Output: a markdown table on stdout; progress and errors on stderr.
# Exit codes: 0 ok · 1 runtime or API error · 2 usage · 3 statement rejected by the read-only guard
set -euo pipefail

DEFAULT_DS_ID="${SQL_DS_ID:-1}"
MAX_POLL_ATTEMPTS=30
POLL_INTERVAL=2

usage() {
  cat <<'EOF' >&2
Usage:
  run-sql.sh <query_id>                     # run a saved query (fresh result)
  run-sql.sh --sql "SELECT ..."             # run ad-hoc SQL on the default data source
  run-sql.sh --sql "SELECT ..." --ds <id>   # choose the data source
  run-sql.sh --dry-run ...                  # validate, print what would run, send nothing
Environment: SQL_API_URL, SQL_API_KEY (required for real runs), SQL_DS_ID (optional).
EOF
}

# --- Parse arguments ---------------------------------------------------------------------
MODE=""
QUERY_ID=""
SQL=""
DS_ID="$DEFAULT_DS_ID"
DRY_RUN=0

while [ $# -gt 0 ]; do
  case "$1" in
    --sql)
      if [ $# -lt 2 ]; then echo "ERROR: --sql needs a statement" >&2; exit 2; fi
      MODE="adhoc"; SQL="$2"; shift 2 ;;
    --ds)
      if [ $# -lt 2 ]; then echo "ERROR: --ds needs a data source id" >&2; exit 2; fi
      DS_ID="$2"; shift 2 ;;
    --dry-run) DRY_RUN=1; shift ;;
    -h|--help) usage; exit 0 ;;
    -*) echo "ERROR: unknown option '$1'" >&2; usage; exit 2 ;;
    *)
      if [ -z "$MODE" ]; then
        MODE="saved"; QUERY_ID="$1"
      else
        echo "ERROR: unexpected argument '$1'" >&2; usage; exit 2
      fi
      shift ;;
  esac
done

if [ -z "$MODE" ]; then usage; exit 2; fi
if [ "$MODE" = "saved" ] && ! printf '%s' "$QUERY_ID" | grep -Eq '^[0-9]+$'; then
  echo "ERROR: query id must be a number, got '$QUERY_ID'" >&2; exit 2
fi
if ! printf '%s' "$DS_ID" | grep -Eq '^[0-9]+$'; then
  echo "ERROR: data source id must be a number, got '$DS_ID'" >&2; exit 2
fi

# --- Read-only guard (ad-hoc SQL only; saved queries are reviewed where they are saved) ------
# Order: reject dollar quoting → strip '...' literals per line → reject comments → one statement
# only → first keyword must read → no write/DDL/DCL/session keyword anywhere.
# The guard only ever removes complete single-line string literals, which the server also treats
# as inert. Everything else stays visible to the checks, so the guard can over-reject but never
# sees less than the server executes.
READ_KEYWORDS='SELECT|WITH|EXPLAIN|SHOW|VALUES|TABLE'
WRITE_KEYWORDS='DELETE|DROP|TRUNCATE|UPDATE|INSERT|ALTER|CREATE|MERGE|GRANT|REVOKE|CALL|COPY|EXECUTE|EXEC|DO|INTO|LOCK|VACUUM|REINDEX|REFRESH|SET|RESET|BEGIN|COMMIT|ROLLBACK|PREPARE|DEALLOCATE'

reject() {
  echo "ERROR: write operations are not allowed. Read-only queries only." >&2
  echo "       reason: $1" >&2
  exit 3
}

check_read_only() {
  local sql="$1"
  local stripped upper first body

  if printf '%s' "$sql" | grep -q '\$\$'; then
    reject "dollar quoting (\$\$) is not allowed — it hides statements"
  fi

  # Replace every complete '...' literal (with '' escapes) by '' — per line, before anything else.
  stripped="$(printf '%s\n' "$sql" | sed -E "s/'([^']|'')*'/''/g")"

  # Comments are not allowed: a comment can hide a second statement from a line-based guard.
  if printf '%s' "$stripped" | grep -Eq -- '--|/\*'; then
    reject "comments (-- or /* */) are not allowed in ad-hoc SQL — remove them and keep notes in the document"
  fi

  stripped="$(printf '%s' "$stripped" | tr '\n\r\t' '   ')"
  upper="$(printf '%s' "$stripped" | tr '[:lower:]' '[:upper:]')"

  # One statement: strip trailing spaces and one trailing ';', then no ';' may remain.
  body="$(printf '%s' "$upper" | sed -E 's/[[:space:]]+$//' | sed -E 's/;$//')"
  if printf '%s' "$body" | grep -q ';'; then
    reject "statement chaining with ';' is not allowed — one statement per run"
  fi
  if [ -z "$(printf '%s' "$body" | tr -d '[:space:]')" ]; then
    reject "empty statement"
  fi

  # First keyword (leading parentheses allowed) must be a read keyword.
  first="$(printf '%s' "$body" | sed -E 's/^[[:space:](]*//' | awk '{print $1}')"
  if ! printf '%s' "$first" | grep -Eq "^($READ_KEYWORDS)$"; then
    reject "statement starts with '$first'; it must start with one of: ${READ_KEYWORDS//|/, }"
  fi

  # No write keyword anywhere, as a whole word (so updated_at and created_by pass).
  local hit
  hit="$(printf '%s' "$body" | grep -Eo "(^|[^A-Z0-9_])($WRITE_KEYWORDS)([^A-Z0-9_]|$)" | head -n 1 | tr -d '[:space:](),' || true)"
  if [ -n "$hit" ]; then
    reject "contains the keyword '$hit'"
  fi
}

if [ "$MODE" = "adhoc" ]; then
  check_read_only "$SQL"
fi

# --- Dry run: no network, no credentials needed --------------------------------------------
if [ "$DRY_RUN" -eq 1 ]; then
  echo "DRY RUN — nothing was sent."
  echo "Mode:         $MODE"
  echo "API base:     ${SQL_API_URL:-<unset — required for a real run>}"
  if [ -n "${SQL_API_KEY:-}" ]; then echo "Key:          set (never printed)"; else echo "Key:          unset — required for a real run"; fi
  if command -v jq >/dev/null 2>&1; then echo "jq:           found"; else echo "jq:           MISSING — install it before a real run"; fi
  if [ "$MODE" = "saved" ]; then
    echo "Saved query:  #$QUERY_ID"
    echo "Would call:   POST /api/queries/$QUERY_ID/results {\"max_age\":0} → poll GET /api/jobs/<job> → GET /api/query_results/<result>"
  else
    echo "Data source:  $DS_ID"
    echo "Would call:   POST /api/queries (temporary query) → POST /api/queries/<id>/results → poll GET /api/jobs/<job> → GET /api/query_results/<result> → DELETE /api/queries/<id>"
    echo "Statement passed the read-only guard:"
    printf '%s\n' "$SQL" | sed 's/^/  /'
  fi
  exit 0
fi

# --- Preflight for a real run --------------------------------------------------------------
if [ -z "${SQL_API_URL:-}" ]; then
  echo "ERROR: SQL_API_URL is not set. Add to your shell profile:" >&2
  echo "  export SQL_API_URL=\"https://sql.example.com\"" >&2
  exit 1
fi
if [ -z "${SQL_API_KEY:-}" ]; then
  echo "ERROR: SQL_API_KEY is not set. Add to your shell profile:" >&2
  echo "  export SQL_API_KEY=\"your-key\"" >&2
  exit 1
fi
if ! command -v jq >/dev/null 2>&1; then
  echo "ERROR: jq is required (brew install jq / apt install jq)." >&2
  exit 1
fi
if ! command -v curl >/dev/null 2>&1; then
  echo "ERROR: curl is required." >&2
  exit 1
fi
SQL_API_URL="${SQL_API_URL%/}"

# --- API call: key goes to curl as a config file on stdin, never as an argument -------------
HTTP_CODE=""
api() {  # api <METHOD> <path> [json-body]  → response body on stdout, sets HTTP_CODE
  local method="$1" path="$2" body="${3:-}"
  local tmp code
  tmp="$(mktemp)"
  if [ -n "$body" ]; then
    code="$(printf 'header = "Authorization: Key %s"\nheader = "Content-Type: application/json"\n' "$SQL_API_KEY" \
      | curl -sS -K - -X "$method" --data "$body" -o "$tmp" -w '%{http_code}' "$SQL_API_URL$path")" || code="000"
  else
    code="$(printf 'header = "Authorization: Key %s"\n' "$SQL_API_KEY" \
      | curl -sS -K - -X "$method" -o "$tmp" -w '%{http_code}' "$SQL_API_URL$path")" || code="000"
  fi
  HTTP_CODE="$code"
  cat "$tmp"
  rm -f "$tmp"
}

stop_on_http() {  # stop_on_http <what>
  case "$HTTP_CODE" in
    2*) return 0 ;;
    000) echo "ERROR: could not reach $SQL_API_URL ($1). Check the URL and your network." >&2; exit 1 ;;
    401|403) echo "ERROR: HTTP $HTTP_CODE on $1 — authentication failed. Check SQL_API_KEY and its access to the data source." >&2; exit 1 ;;
    404) echo "ERROR: HTTP 404 on $1 — the endpoint or query does not exist. A 404 is a stop signal: fix the URL or id, do not guess." >&2; exit 1 ;;
    *)   echo "ERROR: HTTP $HTTP_CODE on $1." >&2; exit 1 ;;
  esac
}

CLEANUP_QUERY_ID=""
cleanup() {
  if [ -n "$CLEANUP_QUERY_ID" ]; then
    api DELETE "/api/queries/$CLEANUP_QUERY_ID" >/dev/null 2>&1 || true
  fi
}
trap cleanup EXIT

poll_job() {  # poll_job <job_id> → prints query_result_id
  local job_id="$1" i resp status
  for i in $(seq 1 "$MAX_POLL_ATTEMPTS"); do
    sleep "$POLL_INTERVAL"
    resp="$(api GET "/api/jobs/$job_id")"
    stop_on_http "GET /api/jobs/$job_id"
    status="$(printf '%s' "$resp" | jq -r '.job.status')"
    case "$status" in
      3) printf '%s' "$resp" | jq -r '.job.query_result_id'; return 0 ;;
      4|5)
        echo "ERROR: the query failed." >&2
        printf '%s' "$resp" | jq -r '.job.error // "unknown error"' >&2
        return 1 ;;
    esac
  done
  echo "ERROR: query timed out after $((MAX_POLL_ATTEMPTS * POLL_INTERVAL)) seconds." >&2
  return 1
}

# --- Execute -------------------------------------------------------------------------------
if [ "$MODE" = "saved" ]; then
  echo "Running saved query #$QUERY_ID (fresh result)..." >&2
  EXEC_RESPONSE="$(api POST "/api/queries/$QUERY_ID/results" '{"max_age": 0}')"
  stop_on_http "POST /api/queries/$QUERY_ID/results"
else
  echo "Running ad-hoc SQL on data source #$DS_ID..." >&2
  QUERY_PAYLOAD="$(jq -n --arg sql "$SQL" --argjson ds_id "$DS_ID" \
    '{query: $sql, data_source_id: $ds_id, name: "_adhoc_temp", description: "Created by run-sql.sh; deleted after the run."}')"
  QUERY_RESPONSE="$(api POST "/api/queries" "$QUERY_PAYLOAD")"
  stop_on_http "POST /api/queries"
  CLEANUP_QUERY_ID="$(printf '%s' "$QUERY_RESPONSE" | jq -r '.id // empty')"
  if [ -z "$CLEANUP_QUERY_ID" ]; then
    echo "ERROR: the API did not return a query id. Response:" >&2
    printf '%s' "$QUERY_RESPONSE" | jq . >&2 || printf '%s\n' "$QUERY_RESPONSE" >&2
    exit 1
  fi
  EXEC_RESPONSE="$(api POST "/api/queries/$CLEANUP_QUERY_ID/results" '{"max_age": 0}')"
  stop_on_http "POST /api/queries/$CLEANUP_QUERY_ID/results"
fi

JOB_ID="$(printf '%s' "$EXEC_RESPONSE" | jq -r '.job.id // empty')"
if [ -n "$JOB_ID" ]; then
  RESULT_ID="$(poll_job "$JOB_ID")" || exit 1
else
  RESULT_ID="$(printf '%s' "$EXEC_RESPONSE" | jq -r '.query_result.id // empty')"
fi
if [ -z "$RESULT_ID" ] || [ "$RESULT_ID" = "null" ]; then
  echo "ERROR: no result id in the response:" >&2
  printf '%s' "$EXEC_RESPONSE" | jq . >&2 || printf '%s\n' "$EXEC_RESPONSE" >&2
  exit 1
fi

RESULTS="$(api GET "/api/query_results/$RESULT_ID")"
stop_on_http "GET /api/query_results/$RESULT_ID"

# --- Markdown table ------------------------------------------------------------------------
ROW_COUNT="$(printf '%s' "$RESULTS" | jq -r '.query_result.data.rows | length')"
echo "" >&2
echo "Results: $ROW_COUNT rows" >&2
echo "" >&2

printf '%s' "$RESULTS" | jq -r '
  .query_result.data as $data |
  if ($data.rows | length) == 0 then
    "_No results._"
  else
    ($data.columns | map(.name) | join(" | ")) + "\n" +
    ($data.columns | map("---") | join(" | ")) + "\n" +
    ($data.rows | map(
      . as $row | $data.columns | map((($row[.name] // "") | tostring | gsub("\\|"; "\\|"))) | join(" | ")
    ) | join("\n"))
  end
'
