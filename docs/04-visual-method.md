---
title: 04 — The visual method
type: doc
status: active
version: 1.0
supersedes: —
decision_refs: []
why: Settles which visual a feature needs and how to prove it is complete before anyone sees it
last_updated: 2026-11-02
---

# 04 — The visual method

Read this when you need to decide which visual a feature needs, and how to prove the
visual is complete before anyone sees it.

Three steps, in order. Each answers a different question. None is a source of business
rules; the PRD is.

| Step | Level | Answers | Use it when |
|---|---|---|---|
| 1 Story | — | "Is this the right direction?" | Before the PRD is final; for people who will not read the PRD |
| 2 Wireframe | L0 | "Which data does each screen show, and does it exist today?" | Comparing options; the data-complete handoff to engineering |
| 3 Hi-fi or prototype | L1, L2 | "Does the chosen option work in the surface's own look?" / "Can the flow be clicked through?" | After the L0 passes its check and the product lead picks an option; usability tests; flow alignment |

`/mockup` runs all three. The kit is `tools/wireframe-kit/`; the story tooling is
`tools/story-builder/`. The worked example is
`products/desk/verification-outcome-and-rework/mockups/` and its `showcase/` folder.

## Step 1 — the story

The story shows one case end to end as an auto-playing phone loop with a caption per beat.
It is a vision artifact for the ops lead, the engineering lead and the insurer partner, and
it can go on a board slide.

| Rule | Means |
|---|---|
| The slide says "vision" | The script carries a framing line that names which beats are live and which are not |
| Look baseline is production | Colour and type from `context/design/tokens.md`; layouts from the current-behaviour files and production screenshots. Never from another mockup or a vendor's brand |
| One case, every hand | One customer, one policy, first screen to end card. Every role that touches the case appears or is named |

The method, from `tools/story-builder/README.md`:

1. **Script.** `showcase/story-script.md` from `templates/story-script-template.md`:
   framing, look baseline, language, demo case, 10–15 beats (time, screen, what happens,
   caption), open points. The owner approves the beats before any pixel.
2. **Storyboard.** One rough HTML fragment per beat in `showcase/screens/`, then
   `tools/story-builder/build_story.py` with `--storyboard` produces a greyscale board,
   one frame per beat. The owner checks sequence and layout, not colour.
3. **Hi-fi.** Refine the same fragments and build them with `--palette
   context/design/tokens.md --surface <surface>` into the story HTML.
   `tools/story-builder/render_story.mjs` records the MP4. The owner gates the look.

A caption states the outcome, not the feature. Every number on screen is a demo number,
and the script says so. The story may simplify the rules and states. Its framing line must
say so. Where the story differs from the PRD or the data packet, the PRD wins. The look of
the story is the product lead's gate before any external use.

## Step 2 — the L0 wireframe

Grey boxes plus one annotation chip per field. Engineering reads off the screen which data
each field shows, captures or derives, and whether it exists today.

**The chip.** Every field that displays, captures or derives a value carries exactly one:

```
[ POINT-ID · unit/type · provenance · current storage · disposition ]
```

Each segment maps to a column of the feature's `internal/data-packet.csv`
(`point_id, label, type_unit, provenance, current_storage, disposition, surface, notes`).
One row per data point the feature shows, captures or derives.

| Segment | Rule |
|---|---|
| `POINT-ID` | Must be a packet row. A prefix groups points |
| `provenance` | Where the value originates: `customer` · `ops` · `field` · `document` · `provider` · `derived` · `config` · `backfilled`. Shortened to the origin on this screen |
| `current storage` | A reuse location that exists today — a column, a JSONB path, a configuration item — or `none — no current path established`. Product names a location it found; it never designs one |
| `disposition` | What the feature does with the point: `reuse` · `extend` · `proposed new` · `configure` · `derive` · `unresolved` |

**The six state strips.** Every state block opens with one. A screen that cannot reach a
state writes `not applicable on this screen` under the strip, with the reason.

| Strip | Means |
|---|---|
| `EMPTY` | Nothing captured yet. Distinct from zero |
| `PARTIAL` | Some required values present, the rest outstanding |
| `MISSING` | A required value is absent, and the absence is the fact to show. Never rendered as `0` or `—` |
| `RESTRICTED` | The value exists; this role may not see or act on it |
| `PROVIDER-FAILED` | A provider attempt ran and returned no usable result. Never rendered as a successful zero |
| `REWORK` | The value was returned for correction: who asked, why, what reply is expected |

**Other L0 rules**, from `tools/wireframe-kit/kit.md`:

| Rule | Means |
|---|---|
| Greyscale only | No surface palette, no status colour. Colour reads as a design decision |
| One file per feature and surface | Every state on the same page, stacked, each under its strip. No tabs, no hidden states |
| Fictional data only | Never a name, number, amount or document id from a screenshot |
| No invented navigation | A screen with no current equivalent is labelled `NEW SCREEN NEEDED` |
| Customer strings marked | Written in the working language with a `[customer language]` marker until `/localisation-copy` runs |
| Style block inline | Pasted from the kit; never imported |

**The checker.** `python3 tools/wireframe-kit/check_wireframe_data.py products/<code>/<feature>`
reads the packet and every `*.mockup.html` under `mockups/` and runs five checks.

| # | Check | Fails when |
|---|---|---|
| 1 | Chip resolves | The point id is not a packet row, the chip has other than five segments, or its provenance is not one of the row's origins |
| 2 | One chip per field | A field block carries zero or two or more chips |
| 3 | Strip vocabulary | A strip label is not one of the six |
| 4 | Disposition agrees | The chip's last segment differs from the packet's `disposition` |
| 5 | Storage claim agrees | The chip says `none …` for a point whose row has a path, or quotes a path for a point whose row says `none` |

Exit 0 is a pass; exit 1 lists findings as `file:line`; exit 2 is a usage error. The
checker reports a file that lacks one of the six strips in the summary line. It does not
fail the file. The product lead decides whether that becomes a failure. `--prototypes`
checks `*.prototype.html` instead: every `data-pt="ID"` must resolve. A failing check
blocks the share.

## Step 3 — hi-fi and prototype

L1 uses the surface palette from `context/design/tokens.md`, existing components, and
strings of realistic length. One accent per screen on the customer surface. L2 is
clickable and opens with a screen-and-click map: every screen, every clickable element,
where it goes.

## Rules that hold at every step

- Colour comes from `context/design/tokens.md` for the surface. Never from another mockup,
  a screenshot or a vendor's brand.
- Compose from existing components; justify every new one in one line. Extend the queue and
  the case view; do not propose a new dashboard.
- Name the variation axis: UI (same data, new presentation), Data Field (new or changed
  data) or Screen (different flow or order).
- Show the hard cases: the long name, the missing document, several open rework items, the
  provider failure, the restricted view.
- Design customer surfaces in the customer's language first: text expansion, script
  rendering, the longest label. Internal surfaces ship in the working language.
- Version by filename: `-v1`, `-v2`, `-v2.1`. Never overwrite an approved version.
- A mockup that needs a rule the PRD does not state stops. Add a `[NEEDS CLARIFICATION]`
  marker to the PRD first.
- Before sharing: the screenshot check at the surface's width (or "screenshot check: not
  run" in the header), then `.agents/skills/mockup/references/share-checklist.md`.

## Where the decision is recorded

`internal/design-spec.md` from `templates/design-spec-template.md`: the chosen option, the
reasons against the others, the decision point id. Recording the rejected options stops
them being re-proposed next quarter. A recommendation is PENDING until the owner locks it.

## Files

| Artifact | Path |
|---|---|
| Wireframe or hi-fi | `products/<code>/<feature>/mockups/<surface>-<feature>-v<n>.mockup.html` |
| Prototype | `products/<code>/<feature>/mockups/<surface>-<feature>-v<n>.prototype.html` |
| Story | `products/<code>/<feature>/showcase/`: the script, `screens/`, `storyboard-v<n>.mockup.html`, `story-v<n>.html`, `story-v<n>.mp4` |
| Data packet | `products/<code>/<feature>/internal/data-packet.csv` |
| Design spec | `products/<code>/<feature>/internal/design-spec.md` |
