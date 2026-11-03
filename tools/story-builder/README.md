# Story builder — script → greyscale storyboard → hi-fi loop

Use this when a feature needs buy-in from people who will not read the PRD: the ops lead,
the engineering lead, an insurer-partner manager, a board slide. A story is one case, end
to end, as an auto-playing phone loop with a caption per beat. It is a vision artifact. It is
not the PRD, not the data packet and not the rules; where they differ, the PRD wins.

**Three rules before you start.**

1. **The slide must say "vision".** Every script carries a framing line that names which
   beats are live and which are not. A deck that shows the loop without that word is wrong.
2. **Look baseline = production.** Colour and type come from `context/design/tokens.md` per
   surface, and layouts from the current-behaviour files and production screenshots. Never
   from the design library, another mockup or a vendor's brand.
3. **One case, every hand.** One customer, one policy, from first screen to the end card, and
   every role that touches the case appears or is named: customer, verification officer,
   field verifier, placement specialist, insurer partner, ops lead, compliance officer.

## The method

| Step | You write | Output | Who approves |
|---|---|---|---|
| 1. Script | `story-script.md` from `templates/story-script-template.md`: framing, look baseline, language, demo case, 10–15 beats (time, screen, what happens, caption), open points | the beats table | the owner approves the beats before any pixel |
| 2. Storyboard | `screens/beat-NN.html`, one rough fragment per beat, then `build_story.py --storyboard` | `storyboard-v1.mockup.html`, greyscale, one frame per beat | the owner checks sequence and layout, not colour |
| 3. Hi-fi | refine the same fragments; `build_story.py --palette … --surface …` | `story-v1.html`, then `story-v1.mp4` from `render_story.mjs` | the owner gates the look |

A caption states the outcome, not the feature ("The case is never declined for it", not
"PROVIDER-FAILED flag"). Each beat is one screen and one change. Every number on screen is a
demo number and the script says so.

Worked example: `products/desk/verification-outcome-and-rework/showcase/`.

## Build

```
python3 tools/story-builder/build_story.py <script.md> <out.html> \
    [--palette context/design/tokens.md] [--surface harbor] [--screens DIR] [--storyboard]
```

- Parses the `## Beats` table. `Time (s)` is `start–end`; a bare number is a duration.
- The surface of a beat is the first word of its `Screen` cell (`Desk · case view` → `desk`),
  which selects that surface's palette and type scale. Anything else (`End card`) uses the
  chrome palette.
- Fragments: `screens/beat-NN.html` next to the script. A missing fragment becomes a labelled
  placeholder frame, so the storyboard can be built before the screens exist.
- `--palette` reads every `` `token` | #hex `` row and the type-scale table from the tokens
  file; `--surface` picks whose primary colours the caption panel. `--storyboard` ignores the
  palette: the board is greyscale by construction and by a CSS filter.
- Standard library only. Exit 1 on a missing script, template or beats table.

### Writing a fragment

One root element, written with the template's primitive classes; no CSS needed.

```html
<div class="app" data-clock="9:19 AM">
  <div class="bar">Desk <small>Verification queue</small></div>
  <div class="body">
    <div class="card err"><div class="h2">Identity proof — returned</div><p class="p small">…</p></div>
    <span class="chip pf" data-at="3400">PROVIDER-FAILED</span>
    <div class="btn primary" data-at="4000">Return document</div>
    <div class="toast" data-at="5200">Rework item created</div>
  </div>
</div>
```

| Class | What it draws |
|---|---|
| `.app`, `.bar` (`.light`), `.body`, `.nav` | screen, app bar, scrolling body, bottom tabs |
| `.card` (`.ok` `.warn` `.err` `.acc`), `.row`, `.kv`, `.field`, `.table` + `.tr` (`.head` `.sel`, `--cols`) | containers, key–value lists, data rows |
| `.h1` `.h2` `.p` `.small` `.tiny` `.muted` `.display` | type at the surface's scale |
| `.btn` (`.primary` `.ghost` `.sm`), `.chip` (`.ok` `.warn` `.err` `.acc` `.refer` `.pf` `.t1`–`.t3` `.p` `.outline`) | actions and status words |
| `.ph` (`.dark` `.good` `.sq`), `.msg`, `.toast`, `.tag`, `.steps`, `.box`, `.spin`, `.end` | photo placeholder, WhatsApp bubble, snackbar, language tag, stepper, checkbox, spinner, end card |

Timing inside a beat: `data-at="ms"` reveals an element at that offset; `data-off="ms"` hides
one; add `stay` to keep an element visible and only switch its `.on` state (a checkbox, a
highlighted button via `hl-at`). A still frame (`#beat=N&still`, the storyboard, a pause)
shows the beat's final state. `data-clock` on the root sets the status-bar clock.

Colour in a fragment comes from the variables the build maps per surface: `--p` `--pd`
`--acc` `--ok` `--warn` `--err` `--refer` `--pf` `--t1`…`--t3` and the neutrals `--ink`
`--line` `--bg` `--card`. Never write a hex value in a fragment.

## Play

Open the HTML. Controls: `Space` pause and resume · `←` `→` step · `R` restart · click a
progress segment. URL options: `?layout=vertical` (9:16 for a deck or a phone video) ·
`?layout=board` (the storyboard view of any build) · `#beat=N` · `#beat=N&still` (a static
frame for a screenshot). The file is self-contained: no network, system fonts.

## Record

```
node tools/story-builder/render_story.mjs <story.html> <out.mp4> [--vertical] [--seconds N]
```

Needs `playwright-core`, a Chromium and ffmpeg. Frames come from Chromium's own screencast,
so Playwright's bundled ffmpeg is not required; the system ffmpeg assembles the MP4.

| Need | How the script finds it |
|---|---|
| `playwright-core` | the repo's `node_modules`, `NODE_PATH`, or `PLAYWRIGHT_CORE_DIR`. Install without a global package: `npm i -D playwright-core` in the repo or a scratch folder, then `NODE_PATH=<folder>/node_modules` |
| Chromium | `PLAYWRIGHT_CHROMIUM_PATH=<binary>` → `PLAYWRIGHT_CHANNEL=chrome` → playwright-core's cached build → channel `chrome` |
| ffmpeg | `FFMPEG=<path>` → `/opt/homebrew/bin/ffmpeg` → `/usr/local/bin/ffmpeg` → `PATH` |

Exit 0 wrote the MP4. Exit 2: no recorder or no browser — the script prints the manual
routes (macOS screen recording, or ffmpeg AVFoundation capture) with the exact commands.
Exit 3: no ffmpeg — the frames are kept and the assembly command is printed.

Default length is the whole loop; `--seconds 15` is enough for a proof clip.

## What this folder is not

- Not a prototype. Nothing is clickable; use `/mockup` at fidelity L2 for that.
- Not a source of rules, fields or states. The data packet and the PRD hold those; the story
  may simplify them and must say so in its framing line.
- Not shareable outside the team until the customer-language strings are written in the
  customer's language and the owner has gated the look.
