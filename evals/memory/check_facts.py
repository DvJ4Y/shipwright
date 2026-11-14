#!/usr/bin/env python3
"""Check a facts ledger (knowledge/facts.md) against the learning-layer rules.

Usage: python3 evals/memory/check_facts.py [--today YYYY-MM-DD] [--quiet] FILE [FILE ...]

Deterministic, standard library only, no model. Exit 0 when every file passes, 1 on any
finding, 2 on a usage error. Warnings print but do not change the exit code.
Rules: docs/12-the-learning-layer.md and the column rules in knowledge/facts.md.
"""
import datetime
import re
import sys

TYPES = {"fact", "decision", "metric", "target", "behaviour", "outcome",
         "preference", "constraint", "open-question"}
ID_RE = re.compile(r"^F-\d{4}$")
DATE_RE = re.compile(r"^\d{4}-\d{2}-\d{2}$")
HEADER = ["id", "type", "claim", "source", "recorded", "status", "tags"]
EMPTY = {"", "-", "—", "–", "n/a", "none", "tbd", "?"}
# The five source labels. A metric row carries one of the first four; `target` is for targets.
MEASURED_LABELS = [
    ("DB-verified", re.compile(r"\bDB-verified \d{4}-\d{2}-\d{2}\b")),
    ("analytics", re.compile(r"\banalytics\b", re.I)),
    ("operational — unverified", re.compile(r"\boperational\s*[—–-]+\s*unverified\b", re.I)),
    ("example", re.compile(r"\bexample\b", re.I)),
]
TARGET_LABEL = re.compile(r"\btarget\b", re.I)
SUPERSEDES_RE = re.compile(r"\bsupersedes (F-\d{4})\b")
STATUS_RES = [
    ("current", re.compile(r"^current$")),
    ("superseded", re.compile(r"^superseded by (F-\d{4})$")),
    ("expires", re.compile(r"^expires (\d{4}-\d{2}-\d{2})$")),
    ("expired", re.compile(r"^expired(?: (\d{4}-\d{2}-\d{2}))?$")),
    ("open", re.compile(r"^open$")),
]


def parse_date(s):
    try:
        return datetime.date.fromisoformat(s) if DATE_RE.match(s) else None
    except ValueError:
        return None


def cells(line):
    s = line.strip()
    if s.startswith("|"):
        s = s[1:]
    if s.endswith("|"):
        s = s[:-1]
    return [c.strip().strip("`").strip() for c in s.split("|")]


def read_ledger(path):
    """Return (rows, problems). A row is (line_no, [7 cells]). The ledger is the table whose
    header is ID | Type | Claim | Source | Recorded | Status | Tags."""
    with open(path, encoding="utf-8") as f:
        lines = f.read().splitlines()
    rows, problems, in_table, found = [], [], False, False
    for i, line in enumerate(lines, 1):
        if not line.strip().startswith("|"):
            in_table = False
            continue
        c = cells(line)
        if [x.lower() for x in c] == HEADER:
            in_table, found = True, True
            continue
        if not in_table or re.fullmatch(r"[\s|:\-]+", line):
            continue
        if len(c) != 7:
            problems.append((i, "columns", f"{len(c)} cells, expected 7"))
            continue
        rows.append((i, c))
    if not found:
        problems.append((0, "header", "no ledger table (ID | Type | Claim | Source | Recorded | Status | Tags)"))
    return rows, problems


def check(path, today):
    rows, errors = read_ledger(path)
    warnings = []
    by_id, status_of = {}, {}

    for ln, (fid, typ, claim, source, recorded, status, tags) in rows:
        def err(check, text):
            errors.append((ln, check, f"{fid}: {text}"))

        if not ID_RE.match(fid):
            err("id", "ID must be F- and four digits")
        elif fid in by_id:
            err("id", f"duplicate ID (first on line {by_id[fid][0]})")
        else:
            by_id[fid] = (ln, typ, claim, status, recorded)

        if typ not in TYPES:
            err("type", f"type '{typ}' not in {sorted(TYPES)}")
        if not claim or claim.lower() in EMPTY:
            err("claim", "claim is empty")
        if source.lower() in EMPTY:
            err("source", "no source — a row with no source is refused")
        rec = parse_date(recorded)
        if rec is None:
            err("recorded", f"recorded date '{recorded}' is not YYYY-MM-DD")
        elif rec > today:
            err("recorded", f"recorded date {recorded} is in the future")
        if not re.search(r"#[\w-]+", tags):
            warnings.append((ln, "tags", f"{fid}: no #tag — recall cannot match this row"))

        measured = [name for name, rx in MEASURED_LABELS if rx.search(claim)]
        if typ == "metric":
            if TARGET_LABEL.search(claim):
                err("target-as-metric", "a target is typed as a metric — make it a target row")
            elif not measured:
                err("metric-label", "metric has no source label (DB-verified YYYY-MM-DD, analytics, operational — unverified, example)")
            elif len(measured) > 1 and "example" not in measured:
                err("metric-label", f"metric carries more than one label: {measured}")
        if typ == "target" and any(m in measured for m in ("DB-verified", "operational — unverified")):
            err("target-as-metric", "a target row carries a measured label — a target is never a baseline")

        kind, val = None, None
        for name, rx in STATUS_RES:
            m = rx.match(status)
            if m:
                kind, val = name, (m.group(1) if m.groups() else None)
                break
        if kind is None:
            err("status", f"status '{status}' is not current · superseded by F-nnnn · expires YYYY-MM-DD · expired [YYYY-MM-DD] · open")
        elif kind == "open" and typ != "open-question":
            err("status", "status 'open' is only for open-question rows")
        elif kind == "expires":
            d = parse_date(val)
            if d is None:
                err("status", f"expiry date '{val}' is not a date")
            elif d < today:
                err("expiry", f"expires {val} has passed — mark it 'expired {val}'")
        elif kind == "expired":
            if val is None:
                warnings.append((ln, "expiry", f"{fid}: 'expired' without its date — write 'expired YYYY-MM-DD'"))
            else:
                d = parse_date(val)
                if d is None:
                    err("status", f"expired date '{val}' is not a date")
                elif d > today:
                    err("expiry", f"marked expired but its date {val} is in the future")
        status_of[fid] = (kind, val)

    # Supersede links: both directions, existing targets, no cycles.
    named_by = {}  # old id -> list of rows whose claim says "supersedes old"
    for ln, c in rows:
        for old in SUPERSEDES_RE.findall(c[2] + " " + c[5].replace("superseded by", "")):
            named_by.setdefault(old, []).append(c[0])
            if old == c[0]:
                errors.append((ln, "supersede", f"{c[0]}: supersedes itself"))
            elif old not in by_id:
                errors.append((ln, "supersede", f"{c[0]}: supersedes {old}, which does not exist"))
            elif status_of.get(old, (None,))[0] != "superseded" or status_of[old][1] != c[0]:
                errors.append((ln, "supersede", f"{c[0]}: supersedes {old}, but {old} is not 'superseded by {c[0]}'"))

    for fid, (kind, succ) in status_of.items():
        if kind != "superseded":
            continue
        ln = by_id[fid][0] if fid in by_id else 0
        if succ == fid:
            errors.append((ln, "supersede", f"{fid}: superseded by itself"))
            continue
        if succ not in by_id:
            errors.append((ln, "supersede", f"{fid}: superseded by {succ}, which does not exist"))
            continue
        if succ not in named_by.get(fid, []):
            errors.append((ln, "supersede", f"{fid}: superseded by {succ}, but {succ} does not say '(supersedes {fid})'"))
        s_rec, f_rec = parse_date(by_id[succ][4]), parse_date(by_id[fid][4])
        if s_rec and f_rec and s_rec < f_rec:
            errors.append((ln, "supersede", f"{fid}: successor {succ} was recorded before it"))
        # Follow the chain to its end; flag cycles and bad ends.
        seen, cur = [fid], succ
        while True:
            if cur in seen:
                errors.append((ln, "supersede", f"{fid}: cycle {' -> '.join(seen + [cur])}"))
                break
            seen.append(cur)
            k, nxt = status_of.get(cur, (None, None))
            if k == "superseded" and nxt in by_id:
                cur = nxt
                continue
            if k == "expired":
                warnings.append((ln, "supersede", f"{fid}: chain ends in expired row {cur}"))
            elif k not in ("current", "expires", "open", "superseded"):
                errors.append((ln, "supersede", f"{fid}: chain ends in {cur} with an invalid status"))
            break

    return rows, errors, warnings


def main(argv):
    today, quiet, files = datetime.date.today(), False, []
    it = iter(argv)
    for a in it:
        if a == "--today":
            today = parse_date(next(it, ""))
            if today is None:
                print("check_facts: --today needs YYYY-MM-DD", file=sys.stderr)
                return 2
        elif a == "--quiet":
            quiet = True
        elif a in ("-h", "--help"):
            print(__doc__.strip())
            return 0
        else:
            files.append(a)
    if not files:
        print(__doc__.strip(), file=sys.stderr)
        return 2
    failed = False
    for path in files:
        try:
            rows, errors, warnings = check(path, today)
        except OSError as e:
            print(f"{path}: cannot read: {e.strerror}")
            failed = True
            continue
        if not quiet:
            for ln, name, text in sorted(errors):
                print(f"{path}:{ln}: {name}: {text}")
            for ln, name, text in sorted(warnings):
                print(f"{path}:{ln}: warning {name}: {text}")
        verdict = "FAIL" if errors else "PASS"
        print(f"{path}: {verdict} — {len(rows)} rows, {len(errors)} findings, {len(warnings)} warnings (today {today})")
        failed = failed or bool(errors)
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
