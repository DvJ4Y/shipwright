#!/usr/bin/env python3
"""UserPromptSubmit: recall matching rows from knowledge/facts.md and rules from knowledge/lessons.md.

Plain word overlap, no embeddings. Prints nothing when nothing matches.
Within a session, a row or rule is injected once; the IDs are kept in .claude/.state/.
"""
import datetime
import hashlib
import json
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _common import project_dir, read_input, state_dir  # noqa: E402

MAX_FACTS = 8
MAX_LESSONS = 3
MIN_SCORE = 2
MAX_CHARS = 2000
HEADER = "## Recalled from knowledge/ (facts.md, lessons.md)"

STOPWORDS = set("""
about above after again against also among another anything around because been before
being below between both cannot could does doing done down during each either else even
every from further have having here hers herself himself into itself just know less like
made make many maybe more most much must myself need needs never next once only other ought
ours ourselves over please rather really same shall should since some something still such
than that thats their theirs them themselves then there these they thing things think this
those though through thus today together tomorrow under until upon very want wants were what
whatever when where whether which while whom whose will with within without would yesterday
your yours yourself yourselves okay sure thanks thank help tell show give take look looks
going come went work works used using use also just
""".split())

WORD = re.compile(r"[^\W\d_]{4,}", re.UNICODE)
TAG = re.compile(r"#([\w][\w-]*)", re.UNICODE)


def norm(w):
    w = w.lower()
    if len(w) > 4 and w.endswith("s") and not w.endswith("ss"):
        w = w[:-1]
    return w


def words(text):
    return {norm(w) for w in WORD.findall(text or "") if w.lower() not in STOPWORDS}


def tags(text):
    out = set()
    for t in TAG.findall(text or ""):
        t = t.lower()
        out.add(norm(t))
        out.update(norm(p) for p in t.split("-") if len(p) >= 4)
    return out


def live(status):
    s = status.strip("*` ").lower()
    if s.startswith(("current", "open")):
        return True
    m = re.match(r"expires\s+(\d{4}-\d{2}-\d{2})", s)
    if m:
        try:
            return datetime.date.fromisoformat(m.group(1)) >= datetime.date.today()
        except ValueError:
            return False
    return False


def fact_rows(path):
    try:
        with open(path, encoding="utf-8", errors="replace") as fh:
            lines = fh.readlines()
    except OSError:
        return []
    rows = []
    for l in lines:
        if not l.startswith("| F-"):
            continue
        cells = [c.strip() for c in l.strip().strip("|").split("|")]
        if len(cells) < 7:
            continue
        rid, typ, claim, source, _rec, status, tagcell = cells[:7]
        if not live(status):
            continue
        rows.append({"id": rid, "type": typ, "claim": claim, "source": source,
                     "status": status, "tags": tagcell})
    return rows


def score(pw, ptags, text, tagtext):
    row_tags = tags(tagtext)
    s = len(pw & words(text))
    s += 2 * len((pw | ptags) & row_tags)
    return s


def lesson_lines(path):
    try:
        with open(path, encoding="utf-8", errors="replace") as fh:
            lines = fh.readlines()
    except OSError:
        return []
    out = []
    for l in lines:
        s = l.strip()
        if not s or s.startswith(("#", ">", "<!--", "---")) or set(s) <= set("|-: "):
            continue
        if s.startswith("|") and s.strip("| ").lower().startswith(("rule", "id", "date")):
            continue  # a table header
        out.append(s)
    return out


def load_seen(path):
    try:
        with open(path, encoding="utf-8") as fh:
            return set(json.load(fh))
    except Exception:
        return set()


def main():
    data = read_input()
    prompt = (data.get("prompt") or data.get("user_prompt") or "").strip()
    if not prompt or prompt.startswith("/") or len(prompt.split()) < 4:
        return
    pw = words(prompt)
    ptags = tags(prompt)
    if not pw and not ptags:
        return

    proj = project_dir()
    kdir = os.path.join(proj, "knowledge")
    if not os.path.isdir(kdir):
        return
    sid = re.sub(r"[^A-Za-z0-9_-]", "", str(data.get("session_id", "unknown")))[:64] or "unknown"
    seen_path = os.path.join(state_dir(proj), f"recall-{sid}.json")
    seen = load_seen(seen_path)

    facts = []
    for r in fact_rows(os.path.join(kdir, "facts.md")):
        if r["id"] in seen:
            continue
        sc = score(pw, ptags, r["claim"] + " " + r["type"], r["tags"])
        if sc >= MIN_SCORE:
            facts.append((sc, r))
    facts.sort(key=lambda x: (-x[0], x[1]["id"]))
    facts = facts[:MAX_FACTS]

    lessons = []
    for l in lesson_lines(os.path.join(kdir, "lessons.md")):
        key = "L-" + hashlib.sha1(l.encode("utf-8")).hexdigest()[:10]
        if key in seen:
            continue
        sc = score(pw, ptags, l, " ".join("#" + t for t in TAG.findall(l)))
        if sc >= MIN_SCORE:
            lessons.append((sc, key, l))
    lessons.sort(key=lambda x: -x[0])
    lessons = lessons[:MAX_LESSONS]

    if not facts and not lessons:
        return

    out = [HEADER]
    used = len(HEADER) + 1
    injected = []

    def add(line, key):
        nonlocal used
        if used + len(line) + 1 > MAX_CHARS:
            return False
        out.append(line)
        used += len(line) + 1
        injected.append(key)
        return True

    for _, r in facts:
        line = f"- {r['id']} ({r['type']}, {r['status']}) {r['claim']} — {r['source']} {r['tags']}".rstrip()
        if not add(line[:400], r["id"]):
            break
    if lessons and used + 12 < MAX_CHARS:
        out.append("Lessons:")
        used += 9
        for _, key, l in lessons:
            if not add("- " + l.lstrip("-* ")[:400], key):
                break
    if not injected:
        return

    print("\n".join(out))
    try:
        with open(seen_path, "w", encoding="utf-8") as fh:
            json.dump(sorted(seen | set(injected)), fh)
    except OSError:
        pass


if __name__ == "__main__":
    try:
        main()
    except Exception:
        pass  # a broken hook never blocks a prompt
    sys.exit(0)
