#!/usr/bin/env bash
# The mechanical pack check. Exit 1 on any finding; warnings alone exit 0.
# Usage (from anywhere): bash scripts/check-pack.sh [--quiet] [--report] [--list] [file ...]
#   no file     check the whole repo (minus the local, gitignored _build/ folder, .git/, plugin/, local state)
#   file ...    check only those files (scripts/pre-commit.example passes the staged list)
#   --quiet     print counts only
#   --report    also write _build/reports/check-pack.md when the local, gitignored _build/ folder exists
#   --list      print the check names and what each does, then stop
# Every finding prints as  file:line: <check>: <text>.  Warnings print the same way under
# a "Warnings" header and do not change the exit code.
# Bash plus the Python 3 standard library; runs on macOS and Linux (no GNU-only flags).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
command -v python3 >/dev/null 2>&1 || { echo "check-pack: python3 is required" >&2; exit 2; }

python3 - "$ROOT" "$@" <<'PY'
import csv
import datetime
import os
import re
import sys
from pathlib import Path

ROOT = Path(sys.argv[1]).resolve()
ARGS = sys.argv[2:]
QUIET = "--quiet" in ARGS
REPORT = "--report" in ARGS
LIST = "--list" in ARGS
FILE_ARGS = [a for a in ARGS if not a.startswith("--")]

CHECKS = [
    ("person-name", "a name from scripts/people.txt (persona names outside their allowed paths)"),
    ("name-heuristic", "warning: two consecutive capitalised words under products/ or docs/ that are not known terms"),
    ("unlabelled-number", "a number with % or a unit word and no source label on the line (products/, context/, docs/)"),
    ("file-length", "a *.md over 200 lines under products/, context/ or .agents/skills/"),
    ("shared-leak", "a local path, decision id, build id or tracker key in a shared/ folder"),
    ("placeholder", "an unfilled {{PLACEHOLDER}} outside the template folders"),
    ("secret", "an API key, token or long hex after KEY="),
    ("landed-prd", "a landed PRD outside archive/, or a landed_into id that is in no current-behaviour file"),
    ("plugin-stale", "plugin/skills differs from .agents/skills, or plugin/ holds a symlink"),
    ("read-first", "a backticked path in a skill's Read-first table that does not exist"),
    ("company-word", "a vendor name from scripts/vendors.txt (and vendors.local.txt if present) outside the adapter and query-tool files, bare CTO, 'the lead', or non-Latin script"),
]
if LIST:
    for name, what in CHECKS:
        print(f"{name:18} {what}")
    sys.exit(0)

# ---------------------------------------------------------------- file walk
TEXT_EXT = {".md", ".csv", ".json", ".sh", ".py", ".html", ".txt", ".toml", ".mjs", ".js",
            ".yaml", ".yml", ".example", ".plist"}
# _build/ is the local, gitignored build folder; plugin/ is generated from the same sources.
SKIP_DIRS = {".git", "_build", "plugin", "node_modules", "__pycache__", ".state", "_retired",
             "_runs", ".venv", "venv"}
SELF = {"scripts/check-pack.sh", "scripts/people.txt", "scripts/substitutions.csv",
        "scripts/vendors.txt", "scripts/vendors.local.txt"}


def rel(p):
    return p.resolve().relative_to(ROOT).as_posix()


def is_text(p):
    return p.suffix.lower() in TEXT_EXT or (p.suffix == "" and p.name.isupper())  # LICENSE


def walk_repo():
    out = []
    for dirpath, dirnames, filenames in os.walk(ROOT):
        dirnames[:] = sorted(d for d in dirnames if d not in SKIP_DIRS)
        for fn in sorted(filenames):
            p = Path(dirpath) / fn
            if fn == ".DS_Store" or p.is_symlink():
                continue
            r = rel(p)
            if r.startswith("evals/results-"):
                continue
            if is_text(p):
                out.append(p)
    return out


if FILE_ARGS:
    FILES = []
    for a in FILE_ARGS:
        p = (ROOT / a) if not os.path.isabs(a) else Path(a)
        if p.is_file() and is_text(p):
            try:
                rel(p)
            except ValueError:
                continue  # outside the repo
            FILES.append(p)
    SCOPE = f"{len(FILES)} file(s) passed on the command line"
else:
    FILES = walk_repo()
    SCOPE = "whole repo"
STAGED = set(rel(p) for p in FILES) if FILE_ARGS else None

_cache = {}


def lines_of(p):
    if p not in _cache:
        try:
            _cache[p] = p.read_text(encoding="utf-8", errors="replace").splitlines()
        except OSError:
            _cache[p] = []
    return _cache[p]


def frontmatter_end(lines):
    """1-based line number of the closing --- when the file opens with frontmatter, else 0."""
    if lines and lines[0].strip() == "---":
        for i in range(1, len(lines)):
            if lines[i].strip() == "---":
                return i + 1
    return 0


def fm_value(lines, key):
    end = frontmatter_end(lines)
    for i in range(1, end - 1):
        m = re.match(r"^" + re.escape(key) + r":\s*(.*)$", lines[i])
        if m:
            val = m.group(1).strip()
            # a YAML block list under the key
            if val == "" and i + 1 < end:
                items = []
                j = i + 1
                while j < end - 1 and lines[j].lstrip().startswith("- "):
                    items.append(lines[j].lstrip()[2:].strip())
                    j += 1
                val = "[" + ", ".join(items) + "]"
            return val.split("#")[0].strip() if not val.startswith("\"") else val
    return None


SEP_RE = re.compile(r"^\s*\|?\s*:?-{3,}")


def table_header_rows(lines):
    return {i for i in range(len(lines) - 1) if lines[i].lstrip().startswith("|") and SEP_RE.match(lines[i + 1])}


def body_lines(lines):
    """Yield (index0, line, in_code) for lines after the frontmatter."""
    start = frontmatter_end(lines)
    in_code = False
    for i in range(start, len(lines)):
        s = lines[i].lstrip()
        if s.startswith("```") or s.startswith("~~~"):
            in_code = not in_code
            yield i, lines[i], True
            continue
        yield i, lines[i], in_code


FINDINGS = []  # (relpath, line, check, text)
WARNINGS = []


def finding(p, line, check, text):
    FINDINGS.append((p if isinstance(p, str) else rel(p), line, check, text.strip()[:160]))


def warning(p, line, check, text):
    WARNINGS.append((p if isinstance(p, str) else rel(p), line, check, text.strip()[:160]))


def under(r, prefixes):
    return any(r == x.rstrip("/") or r.startswith(x) for x in prefixes)


# ---------------------------------------------------------------- 1. person names
def load_people():
    team, personas, allowed, section = [], [], [], None
    f = ROOT / "scripts/people.txt"
    if not f.is_file():
        warning("scripts/people.txt", 0, "person-name", "scripts/people.txt is missing; the check ran with no names")
        return team, personas, allowed
    for raw in f.read_text(encoding="utf-8").splitlines():
        s = raw.split("#", 1)[0].strip()
        if not s:
            continue
        if s.startswith("[") and s.endswith("]"):
            section = s[1:-1].strip().lower()
            continue
        {"team": team, "personas": personas, "persona-paths": allowed}.get(section, []).append(s)
    return team, personas, allowed


def check_person_names():
    team, personas, allowed = load_people()
    team_re = re.compile(r"\b(?:" + "|".join(map(re.escape, team)) + r")\b") if team else None
    persona_re = re.compile(r"\b(?:" + "|".join(map(re.escape, personas)) + r")\b") if personas else None
    for p in FILES:
        r = rel(p)
        if r in SELF:
            continue
        persona_ok = under(r, allowed)
        for i, line in enumerate(lines_of(p), 1):
            if team_re and team_re.search(line):
                finding(r, i, "person-name", f"team name '{team_re.search(line).group(0)}': {line}")
            if persona_re and not persona_ok and persona_re.search(line):
                finding(r, i, "person-name", f"persona name '{persona_re.search(line).group(0)}' outside its allowed paths: {line}")


# ---------------------------------------------------------------- 2. capitalised-name heuristic (warning)
STOP = set("""
the a an in on at if when then each every one two three four five six seven eight nine ten read run use write
never always do not no yes this that these those for from with and or but so to of by as is are was were be it its
we you they he she who what where which why how before after during until once only all any some none more most
less other same new old first last next open closed start end step phase tier lane gate review decision discovery
requirements engineering brief issue issues pack release note land landed compound intake question questions align
produce handoff session memory durable change layer internal external shared product harness shipwright claude code codex
github markdown python bash windows linux mac series done planned current blocked fix pending locked critical major
minor outdated must should could would won draft approved superseded shipped active data screen verdict objective
users rules states metrics dependencies impact crosswalk procedure output source policy policies quote eligibility
documents verification placement issued claim renewal harbor cover desk field hub whatsapp sms email provider failed
rework missing partial empty restricted plan plans monday tuesday wednesday thursday friday saturday sunday january
february march april may june july august september october november december example target analytics
operational unverified verified story builder kit wireframe mockup mockups showcase state strips strip chips chip
level service officer agent lead specialist verifier handler partner customer customers insurer insurers ops
support compliance referral claims regulated action actions register evidence record records audit consent
disclosure cooling off cancellation acknowledgement complaint handling retention identity check document checklist
risk tiers routing sum insured band premium range reason codes recovery path paths hold lapsed declined refer
cancelled google docs sheets notes tracker replica tool bi event events sql query queue cases case row rows table
version status type title owner why last updated frontmatter template templates archive readme licence license
reviewer reviewers lens lenses strategy writing readiness red team post ship gated gating option options profile
language pack packs customer-language working shop grocery pharmacy electronics retail outlets region regions
must-fix kill assumptions pre-mortem intended built match gap deferred not applicable refined merged carried
dropped split tier-s tier-m tier-l quiet report list sessions tasks lessons todo weekly daily miner compressor
interview automation automations hook hooks guard stop edit edits plugin skills skill agents adapter adapters
inspection replacement provider-failed policyholder cooling-off sum-insured reason-code recovery-path
""".split())


def known_words():
    words = set(STOP)
    gl = ROOT / "context/07-glossary.md"
    if gl.is_file():
        for line in lines_of(gl):
            m = re.match(r"^\|\s*\*\*([^*]+)\*\*", line)
            if m:
                words.update(w.lower() for w in re.findall(r"[A-Za-z][A-Za-z-]*", m.group(1)))
            m = re.match(r"^\|\s*([A-Za-z][A-Za-z ]+?)\s*\|", line)  # Systems table names
            if m:
                words.update(w.lower() for w in m.group(1).split())
    sub = ROOT / "scripts/substitutions.csv"
    if sub.is_file():
        with sub.open(encoding="utf-8") as fh:
            for row in csv.DictReader(fh):
                words.update(w.lower() for w in re.findall(r"[A-Za-z][A-Za-z-]*", row.get("find", "")))
    return words


PAIR_RE = re.compile(r"(?<![\w'’\-/.])([A-Z][a-z]{2,})\s+([A-Z][a-z]{2,})\b")


def check_name_heuristic():
    known = known_words()
    for p in FILES:
        r = rel(p)
        if p.suffix != ".md" or not (r.startswith("products/") or r.startswith("docs/")):
            continue
        lines = lines_of(p)
        headers = table_header_rows(lines)
        for i, line, in_code in body_lines(lines):
            if in_code or line.lstrip().startswith("#") or i in headers or SEP_RE.match(line):
                continue
            clean = re.sub(r"`[^`]*`", " ", line)
            clean = re.sub(r"\]\([^)]*\)", "]", clean)
            for m in PAIR_RE.finditer(clean):
                a, b = m.group(1), m.group(2)
                if a.lower() in known or b.lower() in known:
                    continue
                warning(r, i + 1, "name-heuristic", f"'{a} {b}' looks like a person's name: {line}")


# ---------------------------------------------------------------- 3. numbers without a label
LABEL_RE = re.compile(r"DB-verified|analytics|operational\s+[—-]\s+unverified|\btarget\b|\bexample\b")
UNIT = r"(?:%|percent|hours?|hrs?|days?|weeks?|months?|years?|minutes?|mins?|seconds?|policies|cases|items)"
NUM_RE = re.compile(r"(?<![\w./\-#§])(?:\d{1,3}(?:,\d{3})+|\d+)(?:\.\d+)?[\s\-]*" + UNIT + r"\b|₹\s?\d")
# Rule constants carry no label (rule values, not measurements): the staleness ladder, line
# limits, the question count, the hook's size cap, the context threshold, the story beat count.
RULE_CONST_RE = re.compile(
    r"\b(?:21|30|45)\s*days?\b|\b(?:200|50)\s*lines?\b|\b3\s*[–\-]\s*5\s*questions?\b|\b32\s*KiB\b|\b60\s*%|\b10\s*[–\-]\s*15\s*beats?\b")


def check_numbers():
    for p in FILES:
        r = rel(p)
        if p.suffix != ".md" or not (r.startswith("products/") or r.startswith("context/") or r.startswith("docs/")):
            continue
        if "/showcase/" in "/" + r:
            continue
        lines = lines_of(p)
        headers = table_header_rows(lines)
        for i, line, in_code in body_lines(lines):
            if in_code or i in headers or SEP_RE.match(line):
                continue
            if "Last verified" in line or "last_updated" in line:
                continue
            probe = re.sub(r"`[^`]*`", " ", line)  # code spans are paths and ids, not figures
            probe = RULE_CONST_RE.sub(" ", probe)
            m = NUM_RE.search(probe)
            if m and not LABEL_RE.search(line):
                finding(r, i + 1, "unlabelled-number", f"'{m.group(0).strip()}' has no source label: {line}")


# ---------------------------------------------------------------- 4. files over 200 lines
def check_length():
    for p in FILES:
        r = rel(p)
        if p.suffix == ".md" and (r.startswith("products/") or r.startswith("context/") or r.startswith(".agents/skills/")):
            n = len(lines_of(p))
            if n > 200:
                finding(r, n, "file-length", f"{n} lines; the limit is 200 — split the file")


# ---------------------------------------------------------------- 5. shared/ leaks
def tracker_keys():
    keys = {"HBR"}
    sub = ROOT / "scripts/substitutions.csv"
    if sub.is_file():
        with sub.open(encoding="utf-8") as fh:
            for row in csv.DictReader(fh):
                v = (row.get("find") or "").strip()
                if re.fullmatch(r"[A-Z][A-Z0-9]{1,6}", v):
                    keys.add(v)
    return sorted(keys)


def check_shared():
    keys = tracker_keys()
    pats = [
        (re.compile(r"/Users/"), "local path"),
        (re.compile(r"[A-Za-z]:\\"), "local path"),
        (re.compile(r"(?<![\w])\.\./"), "relative path"),
        (re.compile(r"\bP-\d\d\b"), "decision point id"),
        (re.compile(r"\bD-\d{3}\b"), "decision id"),
        (re.compile(r"\bB-\d+\b"), "build-log id"),
        (re.compile(r"\b(?:" + "|".join(map(re.escape, keys)) + r")-\d+\b"), "tracker key"),
    ]
    for p in FILES:
        r = rel(p)
        if "shared" not in Path(r).parts[:-1]:
            continue
        lines = lines_of(p)
        for i, line, _ in body_lines(lines):
            for pat, what in pats:
                m = pat.search(line)
                if m:
                    finding(r, i + 1, "shared-leak", f"{what} '{m.group(0)}' in a shared/ file: {line}")
                    break


# ---------------------------------------------------------------- 6. placeholders
PLACEHOLDER_OK = ("templates/", "tools/prompts/", "scripts/substitutions.csv",
                  ".agents/skills/localisation-copy/references/language-packs/_template/", "_starter-files/")
PH_RE = re.compile(r"\{\{[A-Z_]+\}\}")


def check_placeholders():
    for p in FILES:
        r = rel(p)
        if under(r, PLACEHOLDER_OK) or r in SELF:
            continue
        for i, line in enumerate(lines_of(p), 1):
            m = PH_RE.search(line)
            if m:
                finding(r, i, "placeholder", f"unfilled {m.group(0)}: {line}")


# ---------------------------------------------------------------- 7. secrets
SECRET_RES = [
    re.compile(r"api_key=(?![\"'<$\{])[A-Za-z0-9_\-]{16,}"),
    re.compile(r"github_pat_[A-Za-z0-9_]{10,}"),
    re.compile(r"\bgh[pousr]_[A-Za-z0-9]{20,}"),
    re.compile(r"Bearer (?![\"'<$\{`…])[A-Za-z0-9_\-.=]{20,}"),
    re.compile(r"KEY=[A-Fa-f0-9]{24,}"),
    re.compile(r"\bsk-[A-Za-z0-9\-]{20,}"),
    re.compile(r"\bxox[baprs]-[A-Za-z0-9\-]{10,}"),
    re.compile(r"\bAKIA[0-9A-Z]{16}\b"),
]


def check_secrets():
    for p in FILES:
        r = rel(p)
        if r in SELF:
            continue
        for i, line in enumerate(lines_of(p), 1):
            for pat in SECRET_RES:
                m = pat.search(line)
                if m:
                    finding(r, i, "secret", f"looks like a credential: {m.group(0)[:12]}…")
                    break


# ---------------------------------------------------------------- 8. landed PRDs
ROW_ID_RE = re.compile(r"^[A-Z]{2,6}-\d{3,}$")


def surface_row_ids():
    ids = set()
    for f in sorted((ROOT / "context/surfaces").glob("*/current-behaviour.md")):
        for line in lines_of(f):
            m = re.match(r"^\|\s*([A-Z]{2,6}-\d{3,})\s*\|", line)
            if m:
                ids.add(m.group(1))
    return ids


def check_landed():
    ids = None
    for p in FILES:
        r = rel(p)
        if p.suffix != ".md" or not r.startswith("products/"):
            continue
        lines = lines_of(p)
        if not frontmatter_end(lines):
            continue
        status = fm_value(lines, "status")
        if status == "landed" and "archive" not in Path(r).parts:
            finding(r, 1, "landed-prd", "status: landed outside an archive/ folder — /land moves the folder")
        landed_into = fm_value(lines, "landed_into")
        if not landed_into or landed_into in ("[]", "—", "-", "~"):
            continue
        if ids is None:
            ids = surface_row_ids()
        entries = [e.strip().strip("\"'") for e in landed_into.strip("[]").split(",") if e.strip()]
        for e in entries:
            if ROW_ID_RE.match(e):
                if e not in ids:
                    finding(r, 1, "landed-prd", f"landed_into row {e} is in no context/surfaces/*/current-behaviour.md")
            elif e.startswith("context/"):
                if not (ROOT / e.split("#")[0]).exists():
                    finding(r, 1, "landed-prd", f"landed_into destination {e} does not exist")
            else:
                warning(r, 1, "landed-prd", f"landed_into entry '{e}' is neither a row id nor a context/ path")


# ---------------------------------------------------------------- 9. plugin freshness
IGNORE_NAMES = {"__pycache__", ".DS_Store"}


def tree_files(base):
    out = {}
    for dirpath, dirnames, filenames in os.walk(base):
        dirnames[:] = [d for d in dirnames if d not in IGNORE_NAMES]
        for fn in filenames:
            if fn in IGNORE_NAMES:
                continue
            p = Path(dirpath) / fn
            out[p.relative_to(base).as_posix()] = p
    return out


def check_plugin():
    if STAGED is not None and not any(
            s.startswith((".agents/skills/", ".agents/hooks/", ".claude/agents/", "plugin/", ".mcp.json",
                          "scripts/build-plugin.sh", "LICENSE")) for s in STAGED):
        return
    src, dst = ROOT / ".agents/skills", ROOT / "plugin/skills"
    if not dst.is_dir():
        finding("plugin/skills", 0, "plugin-stale", "missing — run: bash scripts/build-plugin.sh")
        return
    a, b = tree_files(src), tree_files(dst)
    diff = sorted(set(a) ^ set(b))
    for k in sorted(set(a) & set(b)):
        try:
            if a[k].read_bytes() != b[k].read_bytes():
                diff.append(k)
        except OSError:
            diff.append(k)
    if diff:
        finding("plugin/skills", 0, "plugin-stale",
                f"differs from .agents/skills in {len(diff)} file(s) ({', '.join(diff[:3])}{'…' if len(diff) > 3 else ''}) — run: bash scripts/build-plugin.sh")
    for dirpath, dirnames, filenames in os.walk(ROOT / "plugin"):
        for n in dirnames + filenames:
            q = Path(dirpath) / n
            if q.is_symlink():
                finding(rel(q), 0, "plugin-stale", "symlink inside plugin/ — plugin install copies files")


# ---------------------------------------------------------------- 10. Read-first paths
PATH_TOKEN_RE = re.compile(r"`([A-Za-z0-9_.][A-Za-z0-9_./\-]*)`")
FEATURE_RELATIVE = ("internal/", "shared/", "mockups/", "showcase/", "releases/")


def check_read_first():
    for skill in sorted((ROOT / ".agents/skills").glob("*/SKILL.md")):
        r = rel(skill)
        if STAGED is not None and r not in STAGED:
            continue
        lines = lines_of(skill)
        start = next((i for i, l in enumerate(lines) if re.match(r"^##\s+Read first", l)), None)
        if start is None:
            warning(r, 0, "read-first", "no '## Read first' section")
            continue
        for i in range(start + 1, len(lines)):
            line = lines[i]
            if line.startswith("## "):
                break
            if not line.lstrip().startswith("|") or SEP_RE.match(line):
                continue
            if re.search(r"optional|if present", line, re.I):
                continue
            for m in PATH_TOKEN_RE.finditer(line):
                tok = m.group(1)
                if re.fullmatch(r"\.[a-z]+", tok) or ("/" not in tok and "." not in tok):
                    continue
                if tok.startswith(FEATURE_RELATIVE) or tok == "MEMORY.md":
                    continue
                # "the feature's `x.md`" / "the initiative's `x.md`" name a file inside a folder
                # the row does not fix; nothing to resolve.
                if re.search(r"(?:feature|initiative)['’]s", line[max(0, m.start() - 40):m.start()]):
                    continue
                cands = [skill.parent / tok, ROOT / tok]
                ok = any((c.is_dir() if tok.endswith("/") else c.exists()) for c in cands)
                if not ok:
                    finding(r, i + 1, "read-first", f"path `{tok}` does not exist")


# ---------------------------------------------------------------- 11. company words
# Vendor names the pack carries only as capability names. The list ships in scripts/vendors.txt
# (generic: common tracker, analytics, BI, messaging, telephony, payments, identity and auth
# vendors; edit it for your stack). scripts/vendors.local.txt, gitignored and optional, holds
# the names you must never publish. Both files: one name per line, "#" comments, and two
# sections — [case-insensitive] (the default) and [capitalised-only] for ordinary English words
# that are also vendor names, matched only when capitalised.
def load_vendors():
    ci, cs, found = [], [], False
    for name in ("scripts/vendors.txt", "scripts/vendors.local.txt"):
        f = ROOT / name
        if not f.is_file():
            continue
        found, section = True, "case-insensitive"
        for raw in f.read_text(encoding="utf-8").splitlines():
            v = raw.split("#", 1)[0].strip()
            if not v:
                continue
            if v.startswith("[") and v.endswith("]"):
                section = v[1:-1].strip().lower()
                continue
            (cs if section == "capitalised-only" else ci).append(v)
    if not found:
        warning("scripts/vendors.txt", 0, "company-word", "scripts/vendors.txt is missing; the vendor-name check ran with no names")
    return ci, cs


VENDORS_CI, VENDORS_CS = load_vendors()
VENDOR_OK = (".agents/skills/issue-tracker/references/adapters/", "tools/query/", ".mcp.json",
             ".mcp.README.md", ".agents/skills/data-analysis/references/query-api.md")
VENDOR_CI_RE = re.compile(r"(?<![\w.])(?:" + "|".join(re.escape(v) for v in VENDORS_CI) + r")(?!\w)(?!\.\w)", re.I) if VENDORS_CI else None
VENDOR_CS_RE = re.compile(r"(?<![\w.])(?:" + "|".join(re.escape(v) for v in VENDORS_CS) + r")(?!\w)(?!\.\w)") if VENDORS_CS else None
CTO_RE = re.compile(r"\bCTO\b")
THE_LEAD_RE = re.compile(r"\bthe lead\b")
NON_LATIN_RE = re.compile("[ऀ-෿]")


def check_company_words():
    for p in FILES:
        r = rel(p)
        if r in SELF:
            continue
        vendor_ok = under(r, VENDOR_OK)
        for i, line in enumerate(lines_of(p), 1):
            if not vendor_ok:
                m = (VENDOR_CI_RE and VENDOR_CI_RE.search(line)) or (VENDOR_CS_RE and VENDOR_CS_RE.search(line))
                if m:
                    finding(r, i, "company-word", f"vendor name '{m.group(0)}' — use the capability name: {line}")
            if CTO_RE.search(line):
                finding(r, i, "company-word", f"'CTO' — write 'the engineering lead': {line}")
            if THE_LEAD_RE.search(line):
                finding(r, i, "company-word", f"'the lead' — write 'the product lead': {line}")
            m = NON_LATIN_RE.search(line)
            if m:
                finding(r, i, "company-word", f"non-Latin script (U+{ord(m.group(0)):04X}): {line}")


# ---------------------------------------------------------------- run
for fn in (check_person_names, check_name_heuristic, check_numbers, check_length, check_shared,
           check_placeholders, check_secrets, check_landed, check_plugin, check_read_first,
           check_company_words):
    fn()

ORDER = [c for c, _ in CHECKS]
FINDINGS.sort(key=lambda f: (ORDER.index(f[2]), f[0], f[1]))
WARNINGS.sort(key=lambda f: (ORDER.index(f[2]), f[0], f[1]))


def fmt(f):
    return f"{f[0]}:{f[1]}: {f[2]}: {f[3]}"


def counts(items):
    out = {}
    for f in items:
        out[f[2]] = out.get(f[2], 0) + 1
    return out


if QUIET:
    for c, n in counts(FINDINGS).items():
        print(f"  {c}: {n}")
    for c, n in counts(WARNINGS).items():
        print(f"  {c} (warning): {n}")
else:
    for f in FINDINGS:
        print(fmt(f))
    if WARNINGS:
        print("\nWarnings")
        for f in WARNINGS:
            print(fmt(f))
    if FINDINGS or WARNINGS:
        print()
print(f"check-pack: {len(FINDINGS)} finding(s), {len(WARNINGS)} warning(s) — {len(FILES)} file(s), {SCOPE}")

# The report goes to the local, gitignored _build/ folder; without it, --report prints only.
if REPORT and (ROOT / "_build").is_dir():
    out = ROOT / "_build/reports/check-pack.md"
    out.parent.mkdir(parents=True, exist_ok=True)
    now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
    doc = [f"# check-pack report — {now}", "", f"Scope: {SCOPE} · {len(FILES)} file(s).",
           f"Result: **{len(FINDINGS)} finding(s)**, {len(WARNINGS)} warning(s). Exit {1 if FINDINGS else 0}.", "",
           "| Check | Findings | Warnings |", "|---|---|---|"]
    cf, cw = counts(FINDINGS), counts(WARNINGS)
    for c, _ in CHECKS:
        doc.append(f"| `{c}` | {cf.get(c, 0)} | {cw.get(c, 0)} |")
    if FINDINGS:
        doc += ["", "## Findings", ""]
        doc += [f"- `{f[0]}:{f[1]}` — `{f[2]}` — {f[3]}" for f in FINDINGS]
    if WARNINGS:
        doc += ["", "## Warnings", ""]
        doc += [f"- `{f[0]}:{f[1]}` — `{f[2]}` — {f[3]}" for f in WARNINGS]
    out.write_text("\n".join(doc) + "\n", encoding="utf-8")
    if not QUIET:
        print(f"report: {rel(out)}")

sys.exit(1 if FINDINGS else 0)
PY
