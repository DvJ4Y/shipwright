#!/usr/bin/env python3
"""build_story.py — build a self-contained autoplay story (or its greyscale storyboard)
from a script written with templates/story-script-template.md.

Usage:
  python3 tools/story-builder/build_story.py <script.md> <out.html>
      [--palette context/design/tokens.md] [--surface harbor]
      [--screens <dir>] [--template <file>] [--storyboard]

What it reads
  - the script's frontmatter (title) and `**Framing.**` line (the badge text is its first sentence)
  - the `## Beats` table: columns #, Time (s), Screen, What happens, Caption
  - optional screen fragments `screens/beat-NN.html` next to the script (one HTML fragment per
    beat, written with the template's primitive classes; the root element may carry
    data-clock="7:40 PM")
  - optional palette: every `token | #hex` row in the tokens file, plus the type-scale table

What it writes
  - one HTML file: inline CSS and JS, no network, system fonts. `--storyboard` writes the
    greyscale board instead (no palette is injected, by design).

Standard library only. Exit 1 on a missing script, template or beats table.
"""
import argparse
import json
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
DEFAULT_TEMPLATE = HERE / "story.template.html"
DEFAULT_BEAT_SECONDS = 6.0
HEX = re.compile(r"#[0-9A-Fa-f]{6}\b|#[0-9A-Fa-f]{3}\b")


# ---------- script parsing ----------

def split_frontmatter(text):
    """Return (frontmatter dict, body). Frontmatter is the leading --- block, key: value only."""
    fm = {}
    if not text.startswith("---"):
        return fm, text
    end = text.find("\n---", 3)
    if end < 0:
        return fm, text
    for line in text[3:end].splitlines():
        m = re.match(r"^\s*([A-Za-z_][\w-]*)\s*:\s*(.*?)\s*$", line)
        if m:
            fm[m.group(1)] = m.group(2).strip().strip('"').strip("'")
    return fm, text[end + 4:]


def table_cells(line):
    s = line.strip()
    if s.startswith("|"):
        s = s[1:]
    if s.endswith("|"):
        s = s[:-1]
    return [c.strip() for c in s.split("|")]


def parse_time(cell):
    """'12–19' → (12.0, 19.0); '6 s' → (None, 6.0); else (None, None)."""
    m = re.search(r"(\d+(?:\.\d+)?)\s*[–—\-]\s*(\d+(?:\.\d+)?)", cell)
    if m:
        return float(m.group(1)), float(m.group(2))
    m = re.search(r"(\d+(?:\.\d+)?)", cell)
    if m:
        return None, float(m.group(1))
    return None, None


def surface_of(screen):
    """'Desk · verification queue' → 'desk'; 'End card' → 'end-card'."""
    first = re.split(r"\s*[·—–:|]\s*|\s-\s", screen, maxsplit=1)[0]
    slug = re.sub(r"[^a-z0-9]+", "-", first.strip().lower()).strip("-")
    return slug or "story"


def parse_beats(body):
    """Find the beats table under '## Beats' (or the first table with a Caption column)."""
    lines = body.splitlines()
    start = 0
    for i, line in enumerate(lines):
        if re.match(r"^##\s+Beats\b", line, re.I):
            start = i
            break
    header, rows = None, []
    for line in lines[start:]:
        if not line.strip().startswith("|"):
            if header is not None and rows:
                break
            continue
        cells = table_cells(line)
        if header is None:
            if any("caption" in c.lower() for c in cells):
                header = [c.lower() for c in cells]
            continue
        if all(re.fullmatch(r":?-{2,}:?", c) for c in cells if c):
            continue
        rows.append(cells)
    if header is None:
        return []

    def col(*needles):
        for n in needles:
            for i, h in enumerate(header):
                if n in h:
                    return i
        return None

    ci = {"n": 0, "time": col("time"), "screen": col("screen"),
          "what": col("what", "happens", "on screen"), "caption": col("caption")}
    beats = []
    for cells in rows:
        def get(key):
            i = ci.get(key)
            return cells[i] if i is not None and i < len(cells) else ""
        if not get("caption") and not get("screen"):
            continue
        beats.append({"n_raw": get("n"), "time_raw": get("time"), "screen": get("screen"),
                      "what": get("what"), "caption": get("caption")})
    return beats


def framing_badge(body):
    m = re.search(r"\*\*Framing\.?\*\*\s*(.+)", body)
    if not m:
        return "Product vision"
    first = re.split(r"(?<=[.!?])\s", m.group(1).strip(), maxsplit=1)[0]
    first = re.sub(r"[*_`]", "", first).rstrip(".").strip()
    return first[:60]


# ---------- palette parsing ----------

def parse_palette(path):
    """Return (tokens: list of (name, hex), type_scale: dict surface → css)."""
    text = Path(path).read_text(encoding="utf-8")
    tokens = []
    for line in text.splitlines():
        m = re.match(r"^\|\s*`([a-z][a-z0-9-]*)`\s*\|\s*(.+?)\s*\|", line)
        if not m:
            continue
        name, value = m.group(1), m.group(2)
        hexes = HEX.findall(value)
        if not hexes:
            continue
        tokens.append((name, hexes[0]))
        if len(hexes) > 1:
            tokens.append((name + "-bg", hexes[1]))
    type_scale = {}
    in_table = False
    for line in text.splitlines():
        if line.startswith("|"):
            cells = table_cells(line)
            low = [c.lower() for c in cells]
            if "surface" in low and "body" in low:
                in_table, hdr = True, low
                continue
            if in_table and len(cells) >= 5 and not all(re.fullmatch(r":?-{2,}:?", c) for c in cells if c):
                try:
                    i = {k: hdr.index(k) for k in ("surface", "body", "label", "heading", "display")}
                except ValueError:
                    continue
                name = re.sub(r"[^a-z0-9]+", "-", cells[i["surface"]].lower()).strip("-")
                nums = [cells[i[k]] for k in ("body", "label", "heading", "display")]
                if not all(re.fullmatch(r"\d+(\.\d+)?", n) for n in nums):
                    continue
                note = cells[-1] if len(cells) > i["display"] + 1 else ""
                lh = re.search(r"line height\s*([\d.]+)", note, re.I)
                btn = re.search(r"buttons?\s*(\d+)\s*tall", note, re.I)
                css = "--fs:%spx;--fl:%spx;--fh:%spx;--fd:%spx" % tuple(nums)
                if lh:
                    css += ";--lh:%s" % lh.group(1)
                if btn:
                    css += ";--btn:%spx" % btn.group(1)
                type_scale[name] = css
        else:
            in_table = False
    return tokens, type_scale


def surface_rule(s, known, type_scale):
    """CSS rule mapping one surface's tokens onto the generic --p/--acc/--ok/... roles."""
    if s in known:
        body = ("--p:var(--{s}-primary,#4A4A4A);--pd:var(--{s}-primary-dark,var(--p));"
                "--acc:var(--{s}-accent,var(--p));--ok:var(--{s}-success,var(--status-pass,var(--p)));"
                "--warn:var(--{s}-warning,var(--status-rework,#6A6A6A));"
                "--err:var(--{s}-error,var(--tier-3,#444444))").format(s=s)
    else:
        body = "--p:var(--story-p);--pd:var(--story-pd);--acc:var(--story-acc)"
    if s in type_scale:
        body += ";" + type_scale[s]
    return '.screen[data-surface="%s"]{%s}' % (s, body)


# ---------- fragments ----------

def read_fragment(screens_dir, n):
    path = screens_dir / ("beat-%02d.html" % n)
    if not path.exists():
        return None, None
    html = path.read_text(encoding="utf-8").strip()
    html = re.sub(r"^\s*<!--.*?-->\s*", "", html, count=1, flags=re.S)
    m = re.search(r'data-clock="([^"]*)"', html)
    return html, (m.group(1) if m else None)


def placeholder(beat):
    return ('<div class="placeholder"><div class="h1">%s</div><p>%s</p>'
            '<div class="note">No screens/beat-%02d.html — this frame is a placeholder.</div></div>'
            % (esc(beat["screen"]), esc(beat["what"]), beat["n"]))


def esc(s):
    return (s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace('"', "&quot;"))


# ---------- build ----------

def build(args):
    script = Path(args.script)
    if not script.exists():
        sys.exit("error: script not found: %s" % script)
    template = Path(args.template) if args.template else DEFAULT_TEMPLATE
    if not template.exists():
        sys.exit("error: template not found: %s" % template)
    text = script.read_text(encoding="utf-8")
    fm, body = split_frontmatter(text)
    raw = parse_beats(body)
    if not raw:
        sys.exit("error: no beats table found under '## Beats' in %s" % script)

    screens_dir = Path(args.screens) if args.screens else script.parent / "screens"
    beats, clock_prev, cursor, found, missing = [], "9:41", 0.0, [], []
    for i, b in enumerate(raw, 1):
        start, end = parse_time(b["time_raw"])
        if start is None and end is not None:          # a bare duration
            start, end = cursor, cursor + end
        if start is None or end is None or end <= start:
            start, end = cursor, cursor + DEFAULT_BEAT_SECONDS
            print("warn: beat %d has no usable time (%r); using %.0f s" % (i, b["time_raw"], DEFAULT_BEAT_SECONDS))
        cursor = end
        html, clock = read_fragment(screens_dir, i)
        (found if html else missing).append(i)
        clock = clock or clock_prev
        clock_prev = clock
        beat = {"n": i, "time": "%g–%g" % (start, end), "start": start, "end": end,
                "dur": int(round((end - start) * 1000)), "surface": surface_of(b["screen"]),
                "screen": b["screen"], "what": b["what"], "caption": b["caption"], "clock": clock}
        beat["html"] = html if html else placeholder(beat)
        if len(beat["caption"]) > 90:
            print("warn: beat %d caption is %d characters; aim under 90" % (i, len(beat["caption"])))
        beats.append(beat)
    total = beats[-1]["end"]

    tokens, type_scale, surface = [], {}, (args.surface or "")
    if args.palette and not args.storyboard:
        tokens, type_scale = parse_palette(args.palette)
        if not tokens:
            sys.exit("error: no `token` | #hex rows found in %s" % args.palette)
    known = [n[:-len("-primary")] for n, _ in tokens if n.endswith("-primary")]
    if tokens:
        if not surface:
            surface = known[0] if known else ""
        if surface and surface not in known:
            sys.exit("error: surface %r has no `%s-primary` token in %s (found: %s)"
                     % (surface, surface, args.palette, ", ".join(known) or "none"))
    palette_css = "".join("--%s:%s;" % (n, v) for n, v in tokens)
    if surface and tokens:
        palette_css += ("--story-p:var(--%s-primary);--story-pd:var(--%s-primary-dark,var(--%s-primary));"
                        "--story-acc:var(--%s-accent,var(--%s-primary));" % ((surface,) * 5))
        palette_css += ("--story-bg:var(--neutral-050,#ECEEF1);--story-ink:var(--neutral-900,#1F1F1F);"
                        "--story-ink2:var(--neutral-600,#5C5C5C);--story-line:var(--neutral-200,#D4D7DB);")
    surfaces = []
    for s in known + [b["surface"] for b in beats]:
        if s not in surfaces:
            surfaces.append(s)
    rules = "\n".join(surface_rule(s, known, type_scale) for s in surfaces)

    title = fm.get("title", script.stem).replace(" — script", "").replace(" - script", "")
    brand = fm.get("company", "") or fm.get("brand", "") or title.split(" — ")[0].split(" story")[0]
    badge = framing_badge(body)
    beats_json = json.dumps(beats, ensure_ascii=False).replace("</", "<\\/")
    meta = "Script: %s · beats: %d · loop: %g s · mode: %s · palette: %s · surface: %s" % (
        script.as_posix(), len(beats), total, "storyboard" if args.storyboard else "story",
        args.palette if tokens else "none (greyscale)", surface or "—")

    html = template.read_text(encoding="utf-8")
    html = (html.replace("__TITLE__", esc(title)).replace("__BRAND__", esc(brand))
            .replace("__FRAMING__", esc(badge)).replace("__META__", esc(meta))
            .replace("__BODY_CLASS__", "board" if args.storyboard else "")
            .replace("/*__PALETTE__*/", palette_css).replace("/*__SURFACE_RULES__*/", rules)
            .replace("__TOTAL_SECONDS__", "%g" % total).replace("__BEATS_JSON__", beats_json))
    out = Path(args.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(html, encoding="utf-8")

    print("built %s" % out)
    print("  mode: %s · beats: %d · loop: %g s" % ("storyboard" if args.storyboard else "story", len(beats), total))
    print("  screens: %d found, %d placeholders%s" % (len(found), len(missing),
          (" (missing: %s)" % ", ".join("beat-%02d" % n for n in missing)) if missing else ""))
    print("  palette: %s" % ("%d tokens from %s, chrome surface %s, surface rules: %s"
          % (len(tokens), args.palette, surface, ", ".join(surfaces)) if tokens
          else "none — greyscale (surface rules: %s)" % ", ".join(surfaces)))
    return 0


def main(argv=None):
    ap = argparse.ArgumentParser(description="Build a self-contained story HTML from a beats script.")
    ap.add_argument("script", help="story script written with templates/story-script-template.md")
    ap.add_argument("out", help="output HTML path")
    ap.add_argument("--palette", help="tokens file with `token` | #hex rows, e.g. context/design/tokens.md")
    ap.add_argument("--surface", help="surface whose palette colours the chrome (needs <surface>-primary)")
    ap.add_argument("--screens", help="folder of beat-NN.html fragments (default: screens/ next to the script)")
    ap.add_argument("--template", help="template HTML (default: story.template.html next to this script)")
    ap.add_argument("--storyboard", action="store_true", help="write the greyscale storyboard board instead")
    return build(ap.parse_args(argv))


if __name__ == "__main__":
    sys.exit(main())
