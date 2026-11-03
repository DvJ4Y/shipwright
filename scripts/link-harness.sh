#!/usr/bin/env bash
# Make .claude/skills mirror .agents/skills, the canonical skills tree shared by Claude Code and Codex.
# Usage (from anywhere): bash scripts/link-harness.sh [--copy] [--dry-run]
#   default   .claude/skills becomes a relative symlink to ../.agents/skills
#   --copy    .claude/skills becomes a real directory copied from .agents/skills
#             (Windows, or any machine where symlinks misbehave; rerun after editing a skill)
#   --dry-run print the commands without running them
# Hooks stay in .agents/hooks; .claude/settings.json and .codex/hooks.json point there, so only skills need linking.
# An existing .claude/skills that is a real directory is moved to .claude/_retired/<date>/ unless it already
# matches .agents/skills, in which case it is replaced.
set -euo pipefail

MODE=link; DRY=0
for a in "$@"; do
  case "$a" in
    --copy) MODE=copy ;;
    --dry-run) DRY=1 ;;
    -h|--help) sed -n '2,10p' "$0"; exit 0 ;;
    *) echo "unknown arg $a" >&2; exit 2 ;;
  esac
done

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/.agents/skills"
DST="$ROOT/.claude/skills"
STAMP="$(date +%Y-%m-%d)"
run() { if [ "$DRY" = 1 ]; then echo "+ $*"; else "$@"; fi; }

[ -d "$SRC" ] || { echo "missing $SRC — the canonical skills tree is not here" >&2; exit 1; }
run mkdir -p "$ROOT/.claude"

if [ -L "$DST" ]; then
  run rm "$DST"
elif [ -d "$DST" ]; then
  if diff -rq "$SRC" "$DST" >/dev/null 2>&1; then
    run rm -rf "$DST"
  else
    run mkdir -p "$ROOT/.claude/_retired/$STAMP"
    run mv "$DST" "$ROOT/.claude/_retired/$STAMP/skills-$(date +%H%M%S)"
    echo "retired a differing .claude/skills to .claude/_retired/$STAMP/"
  fi
elif [ -e "$DST" ]; then
  echo "$DST exists and is neither a directory nor a symlink; remove it by hand" >&2; exit 1
fi

if [ "$MODE" = link ]; then
  run ln -s "../.agents/skills" "$DST"
else
  run cp -RL "$SRC" "$DST"
fi
echo "$MODE .claude/skills -> .agents/skills"

if [ "$DRY" = 0 ]; then
  n="$(find -L "$DST" -name SKILL.md 2>/dev/null | wc -l | tr -d ' ')"
  echo "Done. $n skill(s) visible at .claude/skills. Check with /skills in Claude Code."
fi
