#!/usr/bin/env python3
"""SessionStart: inject the profile, handoff head, top todo items, open decision points,
PRDs shipped but not landed, and how many inbox items wait for /learn.

Stdout is added to the agent's context. Keep it short: under ~100 lines.
"""
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _common import head, project_dir, read_input, state_dir, walk  # noqa: E402

MAX_DECISIONS = 8
MAX_TODO = 6
MAX_SHIPPED = 5
MAX_HANDOFF = 14
MAX_PROFILE = 80
MAX_TOTAL = 100

PLACEHOLDER = re.compile(r"<(?!!--)[^<>\n]{1,80}>")
SETUP_HINT = "No filled-in `knowledge/PROFILE.md`. Suggest `/setup` to create it."


def profile(proj, budget):
    p = os.path.join(proj, "knowledge", "PROFILE.md")
    if not os.path.exists(p):
        return [SETUP_HINT]
    lines = head(p, 400)
    body = "\n".join(l for l in lines if not l.lstrip().startswith("<!--"))
    if PLACEHOLDER.search(body):
        return ["`knowledge/PROFILE.md` still has `<…>` placeholders. Suggest `/setup` to fill it in."]

    settings = [l.rstrip() for l in lines if l.strip().startswith("_")]
    sections = []
    keep, last_blank = False, True
    for l in lines:
        if l.startswith("## "):
            keep = l[3:].strip().lower().startswith(("static", "dynamic"))
        elif l.startswith("# "):
            keep = False
        if not keep or l.lstrip().startswith("<!--"):
            continue
        blank = not l.strip()
        if blank and last_blank:
            continue
        sections.append(l.rstrip())
        last_blank = blank
    out = settings + ([""] if settings and sections else []) + sections
    if not out:
        return ["`knowledge/PROFILE.md` has no `_` settings and no Static or Dynamic section. Suggest `/setup`."]
    cap = max(10, min(MAX_PROFILE, budget))
    if len(out) > cap:
        out = out[:cap - 1] + ["… (profile truncated; read `knowledge/PROFILE.md`)"]
    return out


def handoff(proj):
    p = os.path.join(proj, "sessions", "latest.md")
    if not os.path.exists(p):
        return []
    return [l for l in head(p, 25) if l.strip()][:MAX_HANDOFF]


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
        top = rel.split(os.sep)[0]
        if top in ("_build", "examples"):  # build inputs and the worked example are not this workspace
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


def count_files(root, skip_dirs=()):
    n = 0
    if not os.path.isdir(root):
        return 0
    for cur, dirs, files in os.walk(root):
        rel = os.path.relpath(cur, root)
        if rel == ".":
            dirs[:] = [d for d in dirs if d not in skip_dirs and not d.startswith(".")]
        else:
            dirs[:] = [d for d in dirs if not d.startswith(".")]
        for f in files:
            if f.startswith(".") or (rel == "." and f == "README.md"):
                continue
            n += 1
    return n


def inbox_waiting(proj):
    root = os.path.join(proj, "inbox")
    drops = count_files(root, skip_dirs=("_processed", "sessions"))
    chats = count_files(os.path.join(root, "sessions"), skip_dirs=("_processed",))
    total = drops + chats
    if not total:
        return []
    return [f"{total} items wait in inbox/ — run /learn "
            f"({drops} dropped, {chats} captured chat(s))."]


def main():
    data = read_input()
    source = data.get("source", "startup")
    sid = data.get("session_id", "unknown")
    proj = project_dir()

    marker = os.path.join(state_dir(proj), f"session-{sid}.start")
    if source in ("startup", "clear") or not os.path.exists(marker):
        open(marker, "w").close()

    blocks = []  # (title, lines) in print order; the profile is sized from what remains
    h = handoff(proj)
    if h:
        blocks.append(("**Handoff — `sessions/latest.md` (head)**", h))
    t = todo(proj)
    if t:
        blocks.append(("**Top of `tasks/todo.md`**", t))
    d = open_decisions(proj)
    if d:
        blocks.append(("**Open decision points (PENDING)**", d))
    s = shipped_not_landed(proj)
    if s:
        blocks.append(("**PRDs shipped, not landed**",
                       [f"- {p}" for p in s] + ["Run `/land <path>` to merge each into current behaviour."]))
    i = inbox_waiting(proj)
    if i:
        blocks.append(("**Inbox**", i))

    fixed = 6 + sum(len(b[1]) + 2 for b in blocks)
    prof = profile(proj, MAX_TOTAL - fixed - 2)

    print("## Workspace context (SessionStart hook)")
    if source == "compact":
        print("Context was just compacted. Re-read the active artifact and its frontmatter before editing it.")
    print("\n**Profile — `knowledge/PROFILE.md`**")
    print("\n".join(prof))
    for title, lines in blocks:
        print("\n" + title)
        print("\n".join(lines))
    print("\n**Routing.** Route new work through `/product-loop` (verdict, tier, workflow). "
          "One topic per session. Use `/session checkpoint` near 60% context.")


if __name__ == "__main__":
    try:
        main()
    except Exception:  # never block a session on a hook failure
        pass
    sys.exit(0)
