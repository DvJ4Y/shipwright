#!/usr/bin/env python3
"""PreToolUse on Edit/Write: deny edits to generated files (marker on the first non-blank line); ask before writing under archive/."""
import json
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _common import project_dir, read_input  # noqa: E402

GENERATED = re.compile(r"GENERATED\s*[—–-]+\s*do not hand-edit", re.IGNORECASE)


def decide(decision, reason):
    print(json.dumps({"hookSpecificOutput": {
        "hookEventName": "PreToolUse",
        "permissionDecision": decision,
        "permissionDecisionReason": reason,
    }}))


def main():
    data = read_input()
    path = (data.get("tool_input") or {}).get("file_path") or ""
    if not path:
        return
    proj = project_dir()
    ap = path if os.path.isabs(path) else os.path.join(proj, path)
    rel = os.path.relpath(ap, proj)

    if os.path.isfile(ap):
        try:
            with open(ap, encoding="utf-8", errors="replace") as fh:
                top = fh.read(800)
        except OSError:
            top = ""
        first = next((l for l in top.splitlines() if l.strip()), "")
        if GENERATED.search(first):
            decide("deny", f"{rel} is headed 'GENERATED — do not hand-edit'. "
                           "Change its source and regenerate it instead.")
            return

    parts = rel.replace("\\", "/").split("/")
    if "archive" in parts[:-1]:
        decide("ask", f"{rel} is under archive/. Archived files are a record. "
                      "Supersede with a new version instead of editing history. "
                      "Approve only for a new archive placement or its 'replaced by' README.")


if __name__ == "__main__":
    try:
        main()
    except Exception:
        pass
    sys.exit(0)
