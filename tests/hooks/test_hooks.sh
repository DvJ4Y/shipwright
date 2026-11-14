#!/usr/bin/env bash
# Tests for .agents/hooks/: session_start.py, recall.py and stop_handoff.py capture.
# Usage (from anywhere): bash tests/hooks/test_hooks.sh
# Builds a throwaway workspace in a temp dir; writes nothing inside the repo.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
HOOKS="$ROOT/.agents/hooks"
WS="$(mktemp -d)"
trap 'rm -rf "$WS"' EXIT
export CLAUDE_PROJECT_DIR="$WS"

pass=0; fail=0
ok()   { pass=$((pass + 1)); echo "ok   - $1"; }
bad()  { fail=$((fail + 1)); echo "FAIL - $1"; }
has()  { if grep -qF -- "$2" <<<"$1"; then ok "$3"; else bad "$3"; fi; }
hasnt(){ if grep -qF -- "$2" <<<"$1"; then bad "$3"; else ok "$3"; fi; }

mkdir -p "$WS/knowledge" "$WS/inbox/sessions" "$WS/inbox/_processed"

cat > "$WS/knowledge/PROFILE.md" <<'EOF'
# Profile

_role: product-lead
_lane: customer

## Static

We sell renters insurance to first-time tenants through the Harbor app.

## Dynamic

- In flight: the quote page redesign.

## Notes

This section is not printed.
EOF

cat > "$WS/knowledge/facts.md" <<'EOF'
# Facts

| ID | Type | Claim | Source | Recorded | Status | Tags |
|---|---|---|---|---|---|---|
| F-0001 | metric | Quote page conversion was 18 percent in October (operational — unverified) | inbox/q.csv | 2026-11-01 | superseded by F-0002 | #quote #conversion |
| F-0002 | metric | Quote page conversion was 21 percent in October (operational — unverified) | inbox/q2.csv | 2026-11-02 | current | #quote #conversion |
| F-0003 | decision | Rework messages go out in the customer's language first | you, 2026-10-20 | 2026-10-20 | current | #rework #messaging |
| F-0004 | behaviour | Desk shows the verification queue sorted by age | products/desk | 2026-10-12 | current | #desk #verification |
| F-0005 | open-question | Should referral agents see quote status? | chat:2026-10-30 | 2026-10-30 | open | #referral |
| F-0006 | target | Field visits under two days by December | you, 2026-10-01 | 2026-10-01 | current | #field |
EOF

cat > "$WS/knowledge/lessons.md" <<'EOF'
# Lessons

- State the population boundary before any conversion rate on the quote page.
- Never write a file the user did not ask for.
EOF

echo "a note" > "$WS/inbox/2026-11-03-call-notes.md"
echo "readme" > "$WS/inbox/README.md"
echo "done"   > "$WS/inbox/_processed/old.md"
echo "chat"   > "$WS/inbox/sessions/2026-11-02-aaaaaaaa.md"

# --- session start ---------------------------------------------------------------------
out="$(echo '{"session_id":"sess-test-0001","source":"startup"}' | python3 "$HOOKS/session_start.py")"
has   "$out" "_role: product-lead"            "session start prints _ settings"
has   "$out" "## Static"                      "session start prints the Static section"
has   "$out" "## Dynamic"                     "session start prints the Dynamic section"
hasnt "$out" "This section is not printed"    "session start skips other sections"
has   "$out" "2 items wait in inbox/ — run /learn" "session start counts inbox items (README, _processed excluded)"
lines=$(wc -l <<<"$out" | tr -d ' ')
if [ "$lines" -le 100 ]; then ok "session start output is $lines lines (<= 100)"; else bad "session start output is $lines lines"; fi

mv "$WS/knowledge/PROFILE.md" "$WS/knowledge/PROFILE.bak"
printf '_role: <your role>\n## Static\n<one line>\n' > "$WS/knowledge/PROFILE.md"
out="$(echo '{"session_id":"sess-test-0001","source":"resume"}' | python3 "$HOOKS/session_start.py")"
has   "$out" "/setup" "placeholder profile suggests /setup"
mv "$WS/knowledge/PROFILE.bak" "$WS/knowledge/PROFILE.md"

# --- recall ----------------------------------------------------------------------------
P='{"session_id":"sess-test-0001","prompt":"Why did quote page conversion change in October?"}'
out="$(echo "$P" | python3 "$HOOKS/recall.py")"
has   "$out" "## Recalled from knowledge/ (facts.md, lessons.md)" "recall prints its header"
has   "$out" "F-0002"  "recall injects the matching current row"
hasnt "$out" "F-0001"  "recall never injects the superseded row"
hasnt "$out" "F-0006"  "recall skips an unrelated row"
has   "$out" "population boundary" "recall injects the matching lesson"
chars=$(printf '%s' "$out" | wc -c | tr -d ' ')
if [ "$chars" -le 2000 ]; then ok "recall output is $chars chars (<= 2000)"; else bad "recall output is $chars chars"; fi

out="$(echo "$P" | python3 "$HOOKS/recall.py")"
hasnt "$out" "F-0002"  "a second identical prompt does not repeat rows"
if [ -z "$out" ]; then ok "a second identical prompt prints nothing"; else bad "second prompt printed: $out"; fi

out="$(echo '{"session_id":"sess-test-0002","prompt":"quote conversion October"}' | python3 "$HOOKS/recall.py")"
if [ -z "$out" ]; then ok "a 3-word prompt prints nothing"; else bad "3-word prompt printed: $out"; fi

out="$(echo '{"session_id":"sess-test-0002","prompt":"/learn quote page conversion October now"}' | python3 "$HOOKS/recall.py")"
if [ -z "$out" ]; then ok "a slash command prints nothing"; else bad "slash command printed: $out"; fi

out="$(echo '{"session_id":"sess-test-0003","prompt":"what is open for the #referral agents"}' | python3 "$HOOKS/recall.py")"
has   "$out" "F-0005" "recall matches an open row by tag"

out="$(echo 'not json' | python3 "$HOOKS/recall.py"; echo "exit=$?")"
has   "$out" "exit=0" "recall exits 0 on bad input"

# --- stop capture ----------------------------------------------------------------------
T="$WS/transcript.jsonl"
cat > "$T" <<'EOF'
{"type":"summary","summary":"old chat"}
{"type":"user","message":{"role":"user","content":"Draft the quote page PRD please"}}
{"type":"assistant","message":{"role":"assistant","content":[{"type":"thinking","thinking":"SECRET-THINKING"},{"type":"text","text":"Here is the outline for the quote page."}]}}
{"type":"assistant","message":{"role":"assistant","content":[{"type":"tool_use","id":"t1","name":"Read","input":{"file_path":"TOOL-CALL-PATH"}}]}}
{"type":"user","message":{"role":"user","content":[{"type":"tool_result","tool_use_id":"t1","content":"TOOL-RESULT-BODY"}]}}
{"type":"system","content":"SYSTEM-NOTE"}
{"type":"user","isMeta":true,"message":{"role":"user","content":"META-MESSAGE"}}
{"type":"user","message":{"role":"user","content":"Use 21 percent, not 18 <system-reminder>REMINDER-TEXT</system-reminder>"}}
{"type":"assistant","message":{"role":"assistant","content":[{"type":"text","text":"Noted: 21 percent."}]}}
EOF
SID="abcdef1234567890"
echo "{\"session_id\":\"$SID\",\"transcript_path\":\"$T\",\"stop_hook_active\":false}" | python3 "$HOOKS/stop_handoff.py" >/dev/null
F="$(ls "$WS/inbox/sessions/"*-abcdef12.md 2>/dev/null | head -1 || true)"
if [ -n "$F" ]; then ok "stop writes inbox/sessions/YYYY-MM-DD-abcdef12.md"; else bad "stop wrote no capture file"; F=/dev/null; fi
cap="$(cat "$F")"
has   "$cap" "captured chat — untrusted input for /learn" "capture has the untrusted header"
has   "$cap" "Draft the quote page PRD please"    "capture keeps user text"
has   "$cap" "Here is the outline for the quote page." "capture keeps assistant text"
has   "$cap" "Noted: 21 percent."                 "capture keeps the last assistant text"
for x in SECRET-THINKING TOOL-CALL-PATH TOOL-RESULT-BODY SYSTEM-NOTE META-MESSAGE REMINDER-TEXT; do
  hasnt "$cap" "$x" "capture drops $x"
done

before=$(wc -c <"$F")
echo "{\"session_id\":\"$SID\",\"transcript_path\":\"$T\"}" | python3 "$HOOKS/stop_handoff.py" >/dev/null
after=$(wc -c <"$F")
if [ "$before" = "$after" ]; then ok "a second stop with no new turns appends nothing"; else bad "second stop appended"; fi

echo '{"type":"user","message":{"role":"user","content":"one more"}}' >> "$T"
echo "{\"session_id\":\"$SID\",\"transcript_path\":\"$T\"}" | python3 "$HOOKS/stop_handoff.py" >/dev/null
hasnt "$(cat "$F")" "one more" "a delta with one user message is not captured"

n_before=$(ls "$WS/inbox/sessions" | wc -l | tr -d ' ')
echo '{"session_id":"nocapture1","stop_hook_active":false}' | python3 "$HOOKS/stop_handoff.py" >/dev/null
n_after=$(ls "$WS/inbox/sessions" | wc -l | tr -d ' ')
if [ "$n_before" = "$n_after" ]; then ok "no transcript_path, no capture"; else bad "captured without transcript_path"; fi

out="$(echo 'garbage' | python3 "$HOOKS/stop_handoff.py"; echo "exit=$?")"
has "$out" "exit=0" "stop exits 0 on bad input"

echo
echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
