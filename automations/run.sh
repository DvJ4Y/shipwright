#!/usr/bin/env bash
# automations/run.sh — run one weekly prompt (compressor, miner or interview) through the
# Claude Code CLI from the repo root. Plain bash and standard Unix tools only.
#
# Usage:
#   bash automations/run.sh <compressor|miner|interview> [--dry-run] [--model <m>] [--memory-dir <path>] [--as-of YYYY-MM-DD]
#
# What it does:
#   1. Strips the frontmatter from automations/<name>.md.
#   2. Prepends a run-context block: repo root, today, ISO week, 7-day window, memory dir, mode.
#   3. compressor and miner: `claude -p` with --tools and --allowedTools "Read,Grep,Glob,Write,Edit",
#      --permission-mode acceptEdits and a per-prompt --max-turns cap.
#      interview: the same flags but an interactive `claude` session, because it asks questions.
#   4. Writes sessions/weekly/_runs/<name>-<date>.log (and the composed prompt for print-mode runs).
#   --dry-run prints the composed command and the first 20 lines of the prompt; it calls nothing
#   and writes nothing.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: bash automations/run.sh <compressor|miner|interview> [--dry-run] [--model <m>] [--memory-dir <path>] [--as-of YYYY-MM-DD]

  compressor   sessions/daily (last 7 days)            -> sessions/weekly/YYYY-WNN-summary.md
  miner        weekly summary + lessons vs context/**  -> sessions/weekly/YYYY-WNN-context-digest.md
  interview    interactive: digest -> up to 7 questions -> approved edits (run by hand)

  --dry-run           print the composed command and the first 20 lines of the prompt; do not call claude
  --model <m>         pass --model to claude (default: the CLI's configured model)
  --memory-dir <path> directory of memory files; read by the miner, edited (with approval) by the interview
  --as-of <date>      run as if today were this date (re-run a missed Sunday; sets the week and the window)
EOF
}

# --- Arguments ---------------------------------------------------------------------------
if [ $# -lt 1 ]; then usage; exit 2; fi
NAME="$1"; shift
case "$NAME" in
  compressor|miner|interview) ;;
  -h|--help) usage; exit 0 ;;
  *) echo "ERROR: unknown automation '$NAME' (expected compressor, miner or interview)" >&2; usage; exit 2 ;;
esac

DRY_RUN=0
MODEL=""
MEMORY_DIR=""
AS_OF=""
while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --model)
      if [ $# -lt 2 ]; then echo "ERROR: --model needs a value" >&2; exit 2; fi
      MODEL="$2"; shift 2 ;;
    --memory-dir)
      if [ $# -lt 2 ]; then echo "ERROR: --memory-dir needs a path" >&2; exit 2; fi
      MEMORY_DIR="$2"; shift 2 ;;
    --as-of)
      if [ $# -lt 2 ]; then echo "ERROR: --as-of needs a date (YYYY-MM-DD)" >&2; exit 2; fi
      AS_OF="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "ERROR: unknown option '$1'" >&2; usage; exit 2 ;;
  esac
done
if [ -n "$AS_OF" ] && ! printf '%s' "$AS_OF" | grep -Eq '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'; then
  echo "ERROR: --as-of must be YYYY-MM-DD, got '$AS_OF'" >&2; exit 2
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROMPT_FILE="$ROOT/automations/$NAME.md"
if [ ! -f "$PROMPT_FILE" ]; then
  echo "ERROR: prompt file not found: $PROMPT_FILE" >&2
  exit 1
fi

if [ -n "$MEMORY_DIR" ]; then
  if [ ! -d "$MEMORY_DIR" ]; then
    echo "ERROR: --memory-dir is not a directory: $MEMORY_DIR" >&2
    exit 1
  fi
  MEMORY_DIR="$(cd "$MEMORY_DIR" && pwd)"
fi

# --- Dates (works with both GNU and BSD date) ---------------------------------------------
# date_fmt <YYYY-MM-DD> <format> [days-offset]  → formats the given date, optionally shifted.
# GNU date takes "-d '<date> +N days'"; BSD date takes "-j -f <fmt> -v+Nd <date>". On BSD the
# sign is required: "-v0d" would SET the day of month to 0 instead of adding nothing.
if date --version >/dev/null 2>&1; then DATE_FLAVOUR="gnu"; else DATE_FLAVOUR="bsd"; fi
date_fmt() {
  local d="$1" fmt="$2" off="${3:-0}"
  case "$off" in -*) ;; *) off="+$off" ;; esac
  if [ "$DATE_FLAVOUR" = "gnu" ]; then
    date -d "$d $off days" "+$fmt"
  else
    date -j -f %Y-%m-%d -v"${off}d" "$d" "+$fmt"
  fi
}
if [ -n "$AS_OF" ]; then TODAY="$AS_OF"; else TODAY="$(date +%Y-%m-%d)"; fi
if ! date_fmt "$TODAY" %Y-%m-%d >/dev/null 2>&1; then
  echo "ERROR: cannot parse the date '$TODAY'" >&2; exit 2
fi
ISO_WEEK="$(date_fmt "$TODAY" %G-W%V)"
SINCE="$(date_fmt "$TODAY" %Y-%m-%d -6)"   # today plus the six days before it = 7 days

# --- Per-prompt settings -----------------------------------------------------------------
TOOLS="Read,Grep,Glob,Write,Edit"
PERMISSION_MODE="acceptEdits"
INTERACTIVE=0
MAX_TURNS=40
case "$NAME" in
  compressor) MAX_TURNS=40 ;;
  miner)      MAX_TURNS=120 ;;   # one Read per context file, plus the sessions and the write
  interview)  INTERACTIVE=1 ;;
esac

# --- Compose the prompt: run context + prompt body without frontmatter -------------------
strip_frontmatter() {
  awk 'NR==1 && $0=="---" {fm=1; next} fm==1 {if ($0=="---") fm=2; next} {print}' "$1"
}

run_context() {
  echo "## Run context"
  echo "- Automation: $NAME"
  echo "- Repo root: $ROOT (every path in these instructions is relative to it)"
  echo "- Today: $TODAY"
  echo "- ISO week: $ISO_WEEK"
  echo "- Window: $SINCE to $TODAY inclusive (7 days, by filename date)"
  if [ -n "$MEMORY_DIR" ]; then
    echo "- Memory directory: $MEMORY_DIR"
  else
    echo "- Memory directory: none given"
  fi
  if [ "$INTERACTIVE" -eq 1 ]; then
    echo "- Mode: interactive. The product lead is present. Ask, then wait for answers."
  else
    echo "- Mode: non-interactive. Nobody will answer a question. Write the output file and stop."
  fi
  echo
}

PROMPT_TEXT="$(run_context; strip_frontmatter "$PROMPT_FILE")"

# --- Compose the command -----------------------------------------------------------------
CMD=(claude)
if [ "$INTERACTIVE" -eq 0 ]; then CMD+=(-p); fi
CMD+=(--tools "$TOOLS" --allowedTools "$TOOLS" --permission-mode "$PERMISSION_MODE")
if [ "$INTERACTIVE" -eq 0 ]; then CMD+=(--max-turns "$MAX_TURNS"); fi
if [ -n "$MODEL" ]; then CMD+=(--model "$MODEL"); fi
if [ -n "$MEMORY_DIR" ]; then CMD+=(--add-dir "$MEMORY_DIR"); fi

RUNS_DIR="$ROOT/sessions/weekly/_runs"
LOG="$RUNS_DIR/$NAME-$TODAY.log"
PROMPT_OUT="$RUNS_DIR/$NAME-$TODAY.prompt.md"

show_command() {
  # The prompt is the last argument. Show the command with a placeholder instead of the text.
  local shown=""
  local part
  for part in "${CMD[@]}"; do
    shown="$shown $(printf '%q' "$part")"
  done
  if [ "$INTERACTIVE" -eq 0 ]; then
    echo "cd $(printf '%q' "$ROOT") &&${shown} \"\$(cat $(printf '%q' "$PROMPT_OUT"))\""
  else
    echo "cd $(printf '%q' "$ROOT") &&${shown} \"<prompt: run context + automations/$NAME.md body>\""
  fi
}

# --- Dry run -----------------------------------------------------------------------------
if [ "$DRY_RUN" -eq 1 ]; then
  echo "DRY RUN — claude was not called and nothing was written."
  echo
  echo "Composed command:"
  echo "  $(show_command)"
  echo
  echo "Log would be:    $LOG"
  if [ "$INTERACTIVE" -eq 0 ]; then
    echo "Prompt would be: $PROMPT_OUT"
  fi
  echo
  echo "First 20 lines of the composed prompt:"
  echo "----------------------------------------"
  printf '%s\n' "$PROMPT_TEXT" | head -n 20
  echo "----------------------------------------"
  echo "($(printf '%s\n' "$PROMPT_TEXT" | wc -l | tr -d ' ') lines in total)"
  exit 0
fi

# --- Real run ----------------------------------------------------------------------------
if ! command -v claude >/dev/null 2>&1; then
  echo "ERROR: 'claude' is not on PATH. Install the Claude Code CLI or add it to PATH for the scheduler." >&2
  exit 1
fi

mkdir -p "$RUNS_DIR"
{
  echo "=== $NAME run started $(date '+%Y-%m-%d %H:%M:%S %Z')"
  echo "command: $(show_command)"
  echo "prompt file: $PROMPT_FILE"
  echo "window: $SINCE to $TODAY · iso week: $ISO_WEEK · memory dir: ${MEMORY_DIR:-none}"
} >> "$LOG"

cd "$ROOT"
RC=0
if [ "$INTERACTIVE" -eq 0 ]; then
  printf '%s\n' "$PROMPT_TEXT" > "$PROMPT_OUT"
  set +e
  # stdin from /dev/null: a scheduler has no terminal, and the CLI otherwise waits for piped input.
  "${CMD[@]}" "$PROMPT_TEXT" < /dev/null 2>&1 | tee -a "$LOG"
  RC="${PIPESTATUS[0]}"
  set -e
else
  echo "Starting the interview interactively. Its transcript is not logged; the interview writes sessions/weekly/<week>-interview.md." | tee -a "$LOG"
  set +e
  "${CMD[@]}" "$PROMPT_TEXT"
  RC=$?
  set -e
fi

echo "=== $NAME run finished $(date '+%Y-%m-%d %H:%M:%S %Z') exit $RC" >> "$LOG"
if [ "$RC" -ne 0 ]; then
  echo "run.sh: $NAME exited with $RC — see $LOG" >&2
fi
exit "$RC"
