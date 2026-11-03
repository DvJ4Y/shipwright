#!/usr/bin/env python3
"""SessionStart: inject profile, handoff head, top todo items and open decision points.

Stdout is added to the agent's context. Keep it short: under ~60 lines.
"""
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _common import head, project_dir, read_input, state_dir, walk  # noqa: E402

MAX_DECISIONS = 10
MAX_TODO = 8
MAX_SHIPPED = 10


def profile(proj):
    p = os.path.join(proj, "_profile.md")
    if not os.path.exists(p):
        return ["No `_profile.md` at the workspace root. Suggest `/onboard` to create one."]
    lines = [l for l in head(p, 30) if l.strip().startswith("_")]
    if any("<1 line" in l for l in lines):
        lines.insert(0, "Profile still has template placeholders. Run `/onboard` to fill it in.")
    return lines or ["`_profile.md` exists but has no `_field:` lines."]


def handoff(proj):
    p = os.path.join(proj, "sessions", "latest.md")
    if not os.path.exists(p):
        return ["No `sessions/latest.md`. Copy `_starter-files/` into the workspace root."]
    return [l for l in head(p, 25) if l.strip()][:20]


def todo(proj):
    p = os.path.join(proj, "tasks", "todo.md")
    if not os.path.exists(p):
        return []
    out = []
    for l in head(p, 120):
        s = l.strip()
        if s.startswith(("- [ ]", "- ", "* ")) and not s.startswith("- [x]"):
            out.append(s)
        if len(out) >= MAX_TODO:
            break
    return out


def open_decisions(proj):
    out = []
    for rel, ap in walk(proj):
        if not rel.endswith("decision-log.md"):
            continue
        if rel.split(os.sep)[0] == "_build":  # build-time inputs; never part of a workspace
            continue
        in_pending_section = False
        for l in head(ap, 400):
            if l.startswith("#"):
                in_pending_section = bool(re.search(r"\bPENDING\b", l))
                continue
            if not l.startswith("|") or set(l.replace("|", "").strip()) <= set("-: "):
                continue
            cells = [c.strip() for c in l.strip().strip("|").split("|")]
            status_cell = any(c.strip("*` ") == "PENDING" for c in cells)
            if not (status_cell or in_pending_section) or cells[0].strip("*` ").lower() == "id":
                continue
            ident = cells[0].strip("*` ") or "?"
            text = next((c.strip("*` ") for c in cells[1:]
                         if len(c) > 12 and c.strip("*` ") != "PENDING"), "")
            out.append(f"- {ident} — {text[:90]} ({rel})")
            if len(out) >= MAX_DECISIONS:
                return out
    return out


def shipped_not_landed(proj):
    """PRDs whose frontmatter says `status: shipped` — `land` has not merged them yet."""
    out = []
    root = os.path.join(proj, "products")
    if not os.path.isdir(root):
        return out
    for rel, ap in walk(root, budget_s=1.0):
        if os.path.basename(rel) != "prd.md":
            continue
        lines = head(ap, 30)
        if not lines or lines[0].strip() != "---":
            continue  # no frontmatter: not a PRD by the pack's conventions
        for l in lines[1:]:
            if l.strip() == "---":
                break
            if re.match(r"^status:\s*shipped\b", l.strip()):
                out.append(os.path.join("products", rel))
                break
        if len(out) >= MAX_SHIPPED:
            break
    return out


def main():
    data = read_input()
    source = data.get("source", "startup")
    sid = data.get("session_id", "unknown")
    proj = project_dir()

    marker = os.path.join(state_dir(proj), f"session-{sid}.start")
    if source in ("startup", "clear") or not os.path.exists(marker):
        open(marker, "w").close()

    print("## Workspace context (SessionStart hook)")
    if source == "compact":
        print("Context was just compacted. Re-read the active artifact and its frontmatter before editing it.")
    print("\n**Profile**")
    print("\n".join(profile(proj)))
    print("\n**Handoff — `sessions/latest.md` (head)**")
    print("\n".join(handoff(proj)))
    t = todo(proj)
    if t:
        print("\n**Top of `tasks/todo.md`**")
        print("\n".join(t))
    d = open_decisions(proj)
    if d:
        print("\n**Open decision points (PENDING)**")
        print("\n".join(d))
    s = shipped_not_landed(proj)
    if s:
        print("\n**PRDs shipped, not landed**")
        print("\n".join(f"- {p}" for p in s))
        print("Run `/land <path>` to merge each into current behaviour.")
    print("\n**Routing.** Route new work through `/product-loop` (verdict, tier, workflow). "
          "One topic per session. Use `/session checkpoint` near 60% context.")


if __name__ == "__main__":
    try:
        main()
    except Exception as e:  # never block a session on a hook failure
        print(f"(SessionStart hook error: {e})")
    sys.exit(0)
