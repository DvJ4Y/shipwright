"""Shared helpers for the harness hooks. Standard library only."""
import json
import os
import sys
import time

# Directories never walked: version control, dependencies, history, and bulky raw data.
PRUNE = {".git", "node_modules", "archive", "_retired", "_build", ".state", "__pycache__",
         ".venv", "venv"}


def read_input():
    try:
        return json.load(sys.stdin)
    except Exception:
        return {}


def project_dir():
    return os.environ.get("CLAUDE_PROJECT_DIR") or os.getcwd()


def state_dir(proj):
    d = os.path.join(proj, ".claude", ".state")
    os.makedirs(d, exist_ok=True)
    return d


def walk(proj, budget_s=1.5, max_depth=6):
    """Yield (relpath, abspath) for files under proj, pruned and time-boxed."""
    start = time.time()
    base_depth = proj.rstrip(os.sep).count(os.sep)
    for root, dirs, files in os.walk(proj):
        if time.time() - start > budget_s:
            return
        depth = root.count(os.sep) - base_depth
        dirs[:] = [d for d in dirs
                   if d not in PRUNE and not d.startswith(".") and depth < max_depth]
        for f in files:
            if f.startswith("."):
                continue
            ap = os.path.join(root, f)
            yield os.path.relpath(ap, proj), ap


def head(path, n):
    try:
        with open(path, encoding="utf-8", errors="replace") as fh:
            return [next(fh).rstrip("\n") for _ in range(n)]
    except StopIteration:
        with open(path, encoding="utf-8", errors="replace") as fh:
            return [l.rstrip("\n") for l in fh]
    except OSError:
        return []
