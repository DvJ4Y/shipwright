#!/usr/bin/env bash
# Run each prompt in trigger-prompts.csv in a fresh headless session and record which skill fired first.
# Usage (from anywhere): bash evals/run-triggers.sh [--model <model>] [--limit N] [--ids T01,T07,...]
#   --model   pass a model to `claude -p` (default: the CLI's default)
#   --limit   run only the first N rows
#   --ids     run only these row ids (comma-separated) — for re-running misses after a description edit
# Runs from the repo root so the project's .claude/skills tree is what the session sees.
# Writes evals/results-<date>.csv (gitignored) and prints the pass rate. A row expecting `none`
# passes when no Skill tool fired. Needs the `claude` CLI on PATH.
set -euo pipefail

MODEL=""; LIMIT=0; IDS=""
while [ $# -gt 0 ]; do
  case "$1" in
    --model) MODEL="$2"; shift 2 ;;
    --limit) LIMIT="$2"; shift 2 ;;
    --ids) IDS="$2"; shift 2 ;;
    -h|--help) sed -n '2,9p' "$0"; exit 0 ;;
    *) echo "unknown arg $1" >&2; exit 2 ;;
  esac
done

HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
OUT="$HERE/results-$(date +%Y-%m-%d).csv"
command -v claude >/dev/null 2>&1 || { echo "run-triggers: the claude CLI is not on PATH" >&2; exit 2; }
cd "$ROOT"

python3 - "$HERE/trigger-prompts.csv" "$OUT" "$MODEL" "$LIMIT" "$IDS" <<'PY'
import csv, json, subprocess, sys, time
src, out, model, limit, ids = sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4]), sys.argv[5]
rows = list(csv.DictReader(open(src, encoding="utf-8")))
if ids:
    want = {i.strip() for i in ids.split(",") if i.strip()}
    rows = [r for r in rows if r["id"] in want]
if limit:
    rows = rows[:limit]
if not rows:
    print("no rows selected"); sys.exit(2)
res, passed = [], 0
for r in rows:
    cmd = ["claude", "-p", r["prompt"], "--output-format", "stream-json", "--verbose",
           "--max-turns", "1", "--disallowedTools", "Write,Edit,Bash,NotebookEdit"]
    if model:
        cmd += ["--model", model]
    fired = "error"
    for attempt in range(2):  # retry once: a session that errors before any turn is not a routing result
        try:
            p = subprocess.run(cmd, capture_output=True, text=True, timeout=240,
                               stdin=subprocess.DEVNULL)  # never let the child read this script
        except subprocess.TimeoutExpired:
            fired = "timeout"; continue
        saw_turn, fired = False, "none"
        for line in p.stdout.splitlines():
            try:
                ev = json.loads(line)
            except ValueError:
                continue
            if ev.get("type") != "assistant":
                continue
            saw_turn = True
            for c in ev.get("message", {}).get("content", []):
                if c.get("type") == "tool_use" and c.get("name") == "Skill":
                    fired = str(c.get("input", {}).get("skill", "?")).split(":")[-1].lstrip("/")
                    break
            if fired != "none":
                break
        if saw_turn:
            break
        fired = "error"; time.sleep(20)
    ok = fired == r["expected_skill"]
    passed += ok
    res.append({**r, "fired": fired, "pass": "yes" if ok else "no"})
    print(f'{r["id"]} {"PASS" if ok else "FAIL"} expected={r["expected_skill"]} fired={fired}', flush=True)
with open(out, "w", newline="", encoding="utf-8") as f:
    w = csv.DictWriter(f, fieldnames=list(res[0].keys())); w.writeheader(); w.writerows(res)
errs = sum(x["fired"] in ("error", "timeout") for x in res)
by = {}
for x in res:
    k = x["expected_skill"]; by.setdefault(k, [0, 0]); by[k][1] += 1; by[k][0] += x["pass"] == "yes"
print("\nper skill: " + " · ".join(f"{k} {v[0]}/{v[1]}" for k, v in sorted(by.items())))
print(f"{passed}/{len(res)} = {100*passed/len(res):.0f}%  (errors: {errs})  → {out}")
PY
