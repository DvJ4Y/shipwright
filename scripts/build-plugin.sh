#!/usr/bin/env bash
# Generate plugin/ from the canonical sources. Idempotent; rerun after any change to a source.
# Usage (from anywhere): bash scripts/build-plugin.sh [--check]
#   plugin/skills/                 copy of .agents/skills/          (diff -r must be empty)
#   plugin/agents/                 copy of .claude/agents/*.md      (only when agents exist)
#   plugin/hooks/hooks.json        the three hooks, pointing at ${CLAUDE_PLUGIN_ROOT}/hooks/*.py
#   plugin/hooks/*.py              copy of .agents/hooks/*.py
#   plugin/.mcp.json               copy of .mcp.json when it exists
#   plugin/.claude-plugin/plugin.json   Claude Code manifest
#   plugin/.claude-plugin/icon.png      copy of assets/icon.png when it exists (square, 1024 px)
#   plugin/.codex-plugin/plugin.json    Codex compatibility manifest
#   plugin/README.md               headed "GENERATED — do not hand-edit" (the guard hook denies edits)
#   plugin/LICENSE                 copy of LICENSE when it exists
# --check  exit 1 when plugin/ is out of date instead of regenerating it (for CI and pre-commit).
# Plugin install copies files, so plugin/ must hold no symlinks: the script resolves them and verifies.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PLUGIN="$ROOT/plugin"
NAME="shipwright"
VERSION="${PLUGIN_VERSION:-0.1.0}"
DESCRIPTION="Product-management skills, read-only reviewer agents and session hooks: intake, questions, PRDs, mockups, reviews, decisions, handoffs and landing."
CHECK=0
[ "${1:-}" = "--check" ] && CHECK=1

copy_tree() {  # $1 src dir, $2 dst dir — resolves symlinks, drops caches
  mkdir -p "$2"
  if command -v rsync >/dev/null 2>&1; then
    rsync -a --copy-links --exclude '__pycache__' --exclude '.DS_Store' "$1/" "$2/"
  else
    cp -RL "$1/." "$2/"
    find "$2" -name '__pycache__' -type d -prune -exec rm -rf {} + 2>/dev/null || true
  fi
}

build() {  # $1 = target dir
  local out="$1"
  rm -rf "$out/skills" "$out/agents" "$out/hooks"
  mkdir -p "$out/.claude-plugin" "$out/.codex-plugin" "$out/hooks"

  # Skills — the canonical tree.
  [ -d "$ROOT/.agents/skills" ] || { echo "missing .agents/skills" >&2; exit 1; }
  copy_tree "$ROOT/.agents/skills" "$out/skills"

  # Agents — only when .claude/agents/ exists.
  if ls "$ROOT/.claude/agents"/*.md >/dev/null 2>&1; then
    mkdir -p "$out/agents"
    cp -L "$ROOT/.claude/agents"/*.md "$out/agents/"
  fi

  # Hooks — the four Python files plus the plugin-format hooks.json.
  cp -L "$ROOT/.agents/hooks"/*.py "$out/hooks/"
  cat > "$out/hooks/hooks.json" <<'EOF'
{
  "description": "shipwright: workspace context at session start, a one-time handoff reminder at stop, and a guard that denies edits to files headed 'GENERATED — do not hand-edit'.",
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|resume|clear|compact",
        "hooks": [
          {
            "type": "command",
            "command": "python3 \"${CLAUDE_PLUGIN_ROOT}/hooks/session_start.py\"",
            "timeout": 10
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "python3 \"${CLAUDE_PLUGIN_ROOT}/hooks/stop_handoff.py\"",
            "timeout": 10
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Edit|Write|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "python3 \"${CLAUDE_PLUGIN_ROOT}/hooks/guard_edits.py\"",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
EOF

  # MCP servers — shipped only when the root defines them.
  if [ -f "$ROOT/.mcp.json" ]; then cp -L "$ROOT/.mcp.json" "$out/.mcp.json"; else rm -f "$out/.mcp.json"; fi

  # Claude Code manifest. Components use the standard layout, so no component keys are needed.
  cat > "$out/.claude-plugin/plugin.json" <<EOF
{
  "name": "$NAME",
  "displayName": "Shipwright",
  "version": "$VERSION",
  "description": "$DESCRIPTION",
  "author": { "name": "Shipwright contributors" },
  "license": "MIT",
  "homepage": "https://github.com/DvJ4Y/shipwright",
  "repository": "https://github.com/DvJ4Y/shipwright",
  "privacyPolicyUrl": "https://github.com/DvJ4Y/shipwright/blob/main/PRIVACY.md",
  "keywords": ["product-management", "prd", "discovery", "review", "mockup", "handoff", "decision-log"]
}
EOF
  # The listing icon. Source: assets/icon.svg, rendered to assets/icon.png.
  if [ -f "$ROOT/assets/icon.png" ]; then cp -L "$ROOT/assets/icon.png" "$out/.claude-plugin/icon.png"; else rm -f "$out/.claude-plugin/icon.png"; fi

  # Codex compatibility manifest (.codex-plugin/plugin.json). skills/ and hooks/hooks.json are discovered by default;
  # the explicit skills path matches the scaffold Codex generates.
  cat > "$out/.codex-plugin/plugin.json" <<EOF
{
  "name": "$NAME",
  "version": "$VERSION",
  "description": "$DESCRIPTION",
  "author": { "name": "Shipwright contributors" },
  "license": "MIT",
  "keywords": ["product-management", "prd", "discovery", "review", "mockup", "handoff", "decision-log"],
  "skills": "./skills/",
  "interface": {
    "displayName": "Shipwright",
    "shortDescription": "Run agentic product work as a system, not a chatbot.",
    "developerName": "Shipwright contributors",
    "category": "Productivity"
  }
}
EOF

  # README with the generated header; LICENSE when the root has one.
  cat > "$out/README.md" <<EOF
GENERATED — do not hand-edit

# $NAME plugin $VERSION

This directory is built by \`scripts/build-plugin.sh\`. Edit the sources, then rerun the script.

| In plugin/ | Source |
| --- | --- |
| \`skills/\` | \`.agents/skills/\` |
| \`agents/\` | \`.claude/agents/*.md\` |
| \`hooks/*.py\` | \`.agents/hooks/\` |
| \`hooks/hooks.json\` | the hooks block in \`scripts/build-plugin.sh\` |
| \`.mcp.json\` | \`.mcp.json\` at the repo root, when present |
| \`.claude-plugin/plugin.json\` | Claude Code manifest, written by the script |
| \`.codex-plugin/plugin.json\` | Codex compatibility manifest, written by the script |
| \`.claude-plugin/icon.png\` | \`assets/icon.png\`, rendered from \`assets/icon.svg\` |

Install for Claude Code from the repo root: \`claude plugin marketplace add .\` then
\`claude plugin install $NAME@$NAME\`. For Codex, the marketplace is \`.agents/plugins/marketplace.json\`.
EOF
  if [ -f "$ROOT/LICENSE" ]; then cp -L "$ROOT/LICENSE" "$out/LICENSE"; else rm -f "$out/LICENSE"; fi
}

verify() {  # $1 = target dir
  local out="$1" bad=0
  if [ -n "$(find "$out" -type l)" ]; then echo "FAIL: symlinks inside $out:"; find "$out" -type l; bad=1; fi
  if ! diff -r -x __pycache__ -x .DS_Store "$ROOT/.agents/skills" "$out/skills" >/dev/null; then
    echo "FAIL: $out/skills differs from .agents/skills"; bad=1
  fi
  for p in .claude-plugin/plugin.json .codex-plugin/plugin.json hooks/hooks.json; do
    python3 -c "import json,sys; json.load(open(sys.argv[1]))" "$out/$p" || { echo "FAIL: invalid JSON $p"; bad=1; }
  done
  return $bad
}

if [ "$CHECK" = 1 ]; then
  tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
  build "$tmp/plugin"
  if [ -d "$PLUGIN" ] && diff -r -x __pycache__ -x .DS_Store "$tmp/plugin" "$PLUGIN" >/dev/null; then
    echo "plugin/ is up to date"; exit 0
  fi
  echo "plugin/ is out of date — run: bash scripts/build-plugin.sh"; exit 1
fi

build "$PLUGIN"
verify "$PLUGIN"
echo "built $PLUGIN ($VERSION): $(find -L "$PLUGIN/skills" -name SKILL.md | wc -l | tr -d ' ') skill(s), $(ls "$PLUGIN/agents" 2>/dev/null | wc -l | tr -d ' ') agent(s), $(ls "$PLUGIN/hooks"/*.py | wc -l | tr -d ' ') hook script(s)"
echo "next: claude plugin validate $PLUGIN"
