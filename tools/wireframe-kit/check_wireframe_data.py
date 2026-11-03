#!/usr/bin/env python3
"""Check that every wireframe field in a feature folder resolves to the feature's data packet.

Usage:
    python3 tools/wireframe-kit/check_wireframe_data.py <feature-folder>
    python3 tools/wireframe-kit/check_wireframe_data.py <feature-folder> --prototypes

<feature-folder> is products/<code>/<feature>/. The script reads
<feature-folder>/internal/data-packet.csv (columns point_id, label, type_unit, provenance,
current_storage, disposition, surface, notes) and every *.mockup.html under
<feature-folder>/mockups/.

Checks on every mockup:
  1. every chip resolves: five segments, a point id that is a packet row, and a provenance
     that is one of the row's origins;
  2. every `class="f"` field block carries exactly one chip;
  3. no state-strip label outside the six (EMPTY, PARTIAL, MISSING, RESTRICTED,
     PROVIDER-FAILED, REWORK);
  4. each chip's disposition matches the packet;
  5. a chip may not claim "none — no current path" for a point that has storage, nor quote
     a path for a point that has none.

The chip's storage segment is not string-compared: chips abbreviate long paths. Only the
claim class (path / no path) must agree with the packet.

--prototypes mode reads *.prototype.html instead and asserts that every data-pt="ID"
attribute resolves to the packet. Prototypes carry no chips, so checks 2, 4 and 5 do not
apply to them. Strip labels are still checked.

Exit 0 on pass, 1 on any finding (each printed as file:line: message on stderr), 2 on a
usage error. Standard library only.
"""

from __future__ import annotations

import csv
import re
import sys
from pathlib import Path

STRIPS = ("EMPTY", "PARTIAL", "MISSING", "RESTRICTED", "PROVIDER-FAILED", "REWORK")
DISPOSITIONS = ("reuse", "extend", "proposed new", "configure", "derive", "unresolved")
PROVENANCE = ("customer", "ops", "field", "document", "provider", "derived", "config", "backfilled")
COLUMNS = ("point_id", "label", "type_unit", "provenance", "current_storage", "disposition", "surface", "notes")

POINT_ID = re.compile(r"^[A-Z][A-Z0-9]{1,7}-[0-9]{1,4}$")
CHIP = re.compile(r'<span class="chip">(.*?)</span>', re.S)
CHIP_OPEN = '<span class="chip">'
DIV_OPEN = re.compile(r"<div\b([^>]*)>", re.S)
CLASS_ATTR = re.compile(r'\bclass="([^"]*)"')
DIV_TOKEN = re.compile(r"<div\b|</div>")
STRIP = re.compile(r'<div class="strip">(.*?)</div>', re.S)
DATA_PT = re.compile(r'data-pt="([^"]*)"')
TAG = re.compile(r"<[^>]+>")
LABEL = re.compile(r'class="lbl">([^<]*)')


def rel(path: Path) -> str:
    """Path as the reader would type it: relative to the working directory when possible."""
    try:
        return str(path.resolve().relative_to(Path.cwd().resolve()))
    except ValueError:
        return str(path)


def line_of(text: str, pos: int) -> int:
    return text.count("\n", 0, pos) + 1


def tokens(value: str) -> list[str]:
    """Split a provenance cell such as `ops/field` or `derived; backfilled` into origins."""
    return [t.strip().casefold() for t in re.split(r"[/;,]", value or "") if t.strip()]


def claims_no_path(storage: str) -> bool:
    return storage.strip().casefold().startswith("none")


def load_packet(path: Path, problems: list[str]) -> dict[str, dict]:
    rows: dict[str, dict] = {}
    with path.open(newline="", encoding="utf-8") as handle:
        reader = csv.DictReader(handle)
        missing = [c for c in COLUMNS if c not in (reader.fieldnames or [])]
        if missing:
            problems.append(f"{rel(path)}:1: packet is missing column(s): {', '.join(missing)}")
            return rows
        for row in reader:
            line = reader.line_num
            point_id = (row["point_id"] or "").strip()
            if not POINT_ID.match(point_id):
                problems.append(f"{rel(path)}:{line}: point_id {point_id!r} is not of the form ABC-01")
                continue
            if point_id in rows:
                problems.append(f"{rel(path)}:{line}: duplicate point_id {point_id}")
                continue
            disposition = (row["disposition"] or "").strip().casefold()
            if disposition not in DISPOSITIONS:
                problems.append(
                    f"{rel(path)}:{line}: {point_id} disposition {disposition!r} is not one of "
                    + ", ".join(DISPOSITIONS)
                )
            origins = tokens(row["provenance"])
            if not origins:
                problems.append(f"{rel(path)}:{line}: {point_id} has no provenance")
            for origin in origins:
                if origin not in PROVENANCE:
                    problems.append(
                        f"{rel(path)}:{line}: {point_id} provenance {origin!r} is not one of "
                        + ", ".join(PROVENANCE)
                    )
            storage = (row["current_storage"] or "").strip()
            if not storage:
                problems.append(
                    f"{rel(path)}:{line}: {point_id} current_storage is empty; "
                    "write 'none — no current path established' when none exists"
                )
            rows[point_id] = {
                "disposition": disposition,
                "origins": set(origins),
                "no_path": claims_no_path(storage),
                "line": line,
            }
    return rows


def parse_chip(raw: str) -> list[str]:
    text = TAG.sub("", raw).replace("&middot;", "·")
    text = " ".join(text.split()).strip().strip("[]").strip()
    return [segment.strip() for segment in text.split("·")]


def balanced_inner(html: str, start: int) -> str:
    """Inner HTML of a div that opened just before `start`, balanced on nested divs."""
    depth = 1
    for token in DIV_TOKEN.finditer(html, start):
        depth += 1 if token.group() == "<div" else -1
        if depth == 0:
            return html[start : token.start()]
    return html[start:]


def check_strips(path_label: str, html: str, problems: list[str]) -> set[str]:
    found: set[str] = set()
    for match in STRIP.finditer(html):
        label = " ".join(TAG.sub("", match.group(1)).split()).upper()
        if label not in STRIPS:
            problems.append(
                f"{path_label}:{line_of(html, match.start())}: state strip {label!r} is not one of "
                + " · ".join(STRIPS)
            )
        found.add(label)
    return found & set(STRIPS)


def strip_summary(found: set[str]) -> str:
    absent = [s for s in STRIPS if s not in found]
    summary = f"strips {len(found)}/6"
    return summary + (f" (absent: {', '.join(absent)})" if absent else "")


def check_mockup(path: Path, packet: dict[str, dict], problems: list[str]) -> None:
    html = path.read_text(encoding="utf-8")
    label = rel(path)
    points: set[str] = set()

    for match in CHIP.finditer(html):
        line = line_of(html, match.start())
        segments = parse_chip(match.group(1))
        if len(segments) != 5:
            problems.append(
                f"{label}:{line}: chip has {len(segments)} segment(s); expected 5: "
                "[ POINT-ID · unit/type · provenance · current storage · disposition ]"
            )
            continue
        point_id, _unit, provenance, storage, disposition = segments
        fact = packet.get(point_id)
        if fact is None:
            problems.append(f"{label}:{line}: chip {point_id} is not in the data packet")
            continue
        points.add(point_id)
        for origin in tokens(provenance):
            if origin not in fact["origins"]:
                problems.append(
                    f"{label}:{line}: chip {point_id} says provenance {origin!r}; "
                    f"packet says {'/'.join(sorted(fact['origins']))}"
                )
        if disposition.casefold() != fact["disposition"]:
            problems.append(
                f"{label}:{line}: chip {point_id} says disposition {disposition!r}; "
                f"packet says {fact['disposition']!r}"
            )
        if claims_no_path(storage) and not fact["no_path"]:
            problems.append(
                f"{label}:{line}: chip {point_id} claims no current path, but the packet records one"
            )
        if not claims_no_path(storage) and fact["no_path"]:
            problems.append(
                f"{label}:{line}: chip {point_id} quotes a storage path, but the packet records none"
            )

    fields = 0
    for match in DIV_OPEN.finditer(html):
        classes = CLASS_ATTR.search(match.group(1))
        if not classes or "f" not in classes.group(1).split():
            continue
        fields += 1
        inner = balanced_inner(html, match.end())
        count = inner.count(CHIP_OPEN)
        if count != 1:
            name = LABEL.search(inner)
            problems.append(
                f"{label}:{line_of(html, match.start())}: field "
                f"{(name.group(1).strip() if name else '?')!r} has {count} chip(s); expected exactly 1"
            )

    found = check_strips(label, html, problems)
    print(f"{label}: {fields} fields, {len(points)} distinct points, {strip_summary(found)}")


def check_prototype(path: Path, packet: dict[str, dict], problems: list[str]) -> None:
    html = path.read_text(encoding="utf-8")
    label = rel(path)
    matches = list(DATA_PT.finditer(html))
    if not matches:
        problems.append(f"{label}:1: no data-pt attributes; a prototype must trace every field")
    points: set[str] = set()
    for match in matches:
        point_id = match.group(1).strip()
        if point_id not in packet:
            problems.append(
                f"{label}:{line_of(html, match.start())}: data-pt {point_id} is not in the data packet"
            )
        else:
            points.add(point_id)
    found = check_strips(label, html, problems)
    print(f"{label}: {len(matches)} data-pt attribute(s), {len(points)} distinct points, {strip_summary(found)}")


def usage(message: str) -> int:
    print(f"error: {message}", file=sys.stderr)
    print(
        "usage: python3 tools/wireframe-kit/check_wireframe_data.py <feature-folder> [--prototypes]",
        file=sys.stderr,
    )
    return 2


def main(argv: list[str]) -> int:
    flags = {a for a in argv if a.startswith("--")}
    positional = [a for a in argv if not a.startswith("--")]
    unknown = flags - {"--prototypes"}
    if unknown:
        return usage(f"unknown option(s): {', '.join(sorted(unknown))}")
    if len(positional) != 1:
        return usage("give exactly one feature folder")

    folder = Path(positional[0])
    packet_path = folder / "internal" / "data-packet.csv"
    mockups_dir = folder / "mockups"
    if not folder.is_dir():
        return usage(f"{folder} is not a folder")
    if not packet_path.is_file():
        return usage(f"{rel(packet_path)} not found")
    if not mockups_dir.is_dir():
        return usage(f"{rel(mockups_dir)} not found")

    problems: list[str] = []
    packet = load_packet(packet_path, problems)

    if "--prototypes" in flags:
        files = sorted(mockups_dir.rglob("*.prototype.html"))
        if not files:
            print(f"{rel(mockups_dir)}: no *.prototype.html found; nothing to check")
        for path in files:
            check_prototype(path, packet, problems)
    else:
        files = sorted(mockups_dir.rglob("*.mockup.html"))
        if not files:
            return usage(f"no *.mockup.html under {rel(mockups_dir)}")
        for path in files:
            check_mockup(path, packet, problems)

    if problems:
        sys.stdout.flush()
        print(f"\nFAIL — {len(problems)} finding(s)", file=sys.stderr)
        for problem in problems:
            print("  " + problem, file=sys.stderr)
        return 1
    print(f"\nPASS — {len(files)} file(s) checked against {len(packet)} packet point(s)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
