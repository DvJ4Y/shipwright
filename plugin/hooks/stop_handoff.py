#!/usr/bin/env python3
"""Stop: once per session, ask for a handoff update if artifacts changed and the handoff didn't."""
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _common import project_dir, read_input, state_dir, walk  # noqa: E402

# Session-loop files are the handoff itself, not artifacts.
NOT_ARTIFACTS = ("sessions/", "tasks/", ".claude/")


def main():
    data = read_input()
    if data.get("stop_hook_active"):
        return
    sid = data.get("session_id", "unknown")
    proj = project_dir()
    sd = state_dir(proj)

    asked = os.path.join(sd, f"stop-asked-{sid}")
    marker = os.path.join(sd, f"session-{sid}.start")
    if os.path.exists(asked) or not os.path.exists(marker):
        return
    since = os.path.getmtime(marker)

    changed = []
    for rel, ap in walk(proj):
        if rel.startswith(NOT_ARTIFACTS) or rel == "_profile.md":
            continue
        try:
            if os.path.getmtime(ap) > since:
                changed.append(rel)
        except OSError:
            continue
    if not changed:
        return

    handoff = os.path.join(proj, "sessions", "latest.md")
    if os.path.exists(handoff) and os.path.getmtime(handoff) > since:
        return

    open(asked, "w").close()
    sample = ", ".join(changed[:3]) + (" …" if len(changed) > 3 else "")
    print(json.dumps({
        "decision": "block",
        "reason": (
            f"{len(changed)} artifact(s) changed this session ({sample}), but "
            "sessions/latest.md did not. Run `/session end`: rewrite the handoff "
            "(under 50 lines: focus, decisions, files changed, open threads, next action), "
            "update tasks/todo.md, and add any correction to tasks/lessons.md. "
            "If nothing here needs handing off, say so in one line and stop."
        ),
    }))


if __name__ == "__main__":
    try:
        main()
    except Exception:
        pass  # never trap the user in a session because of a hook failure
    sys.exit(0)
