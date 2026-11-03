---
title: Images — where each one comes from
type: readme
status: active
version: 1.0
supersedes: —
decision_refs: []
why: Names the source of every image so a reader regenerates it instead of trusting it
last_updated: 2026-11-03
---

# Images — where each one comes from

Read this when you need to change an image, or check what it was rendered from. Every
image in this folder is rendered from a file in this repository. Edit the source,
re-render, replace the image. Nothing here is a screenshot of a real product.

| Image | Source | Rendered how |
|---|---|---|
| `loop.png` | `src/loop.mmd`. The loop block in `README.md` carries the same text | Mermaid, neutral theme, in a headless browser; text colour and borders from the shared neutral scale in `context/design/tokens.md` |
| `layers.png` | `src/layers.mmd`. The four-layers block in `README.md` carries the same text | the same |
| `visual-method.png` | `src/visual-method.mmd`. The visual-method block in `README.md` carries the same text | the same |
| `story.gif` | `products/desk/verification-outcome-and-rework/showcase/story-v1.mp4`, which the story builder recorded from `story-v1.html`. The clip covers the first three beats of the twelve in `showcase/story-script.md` | ffmpeg: ten frames a second, 720 px wide, one palette built from the whole clip |
| `story-frame-quote.png` | the same video, one frame from beat 1 (Harbor, the quote) | ffmpeg, one frame |
| `story-frame-documents.png` | the same video, one frame from beat 2 (Harbor, the documents) | ffmpeg, one frame |
| `story-frame-desk.png` | the same video, one frame from beat 3 (Desk, the case view) | ffmpeg, one frame |

Every name, amount and identifier on the story frames is a demo value from the story
script, labelled `example` there. The story is product vision, not shipped behaviour; any
slide that uses a frame must say so (`docs/04-visual-method.md`).

## Re-rendering a diagram

The `.mmd` under `src/` is the source. The README block is a copy of it, so GitHub renders
the diagram without an image. Change both when you change one.

Any Mermaid renderer works. With mermaid-cli:

```bash
mmdc -i docs/images/src/loop.mmd -o docs/images/loop.png -b white -s 2
```

The shipped PNGs were rendered at twice the CSS size with the neutral theme, the system
sans-serif font, and a wrapping width of 520 px so the layer boxes stay wide. A renderer
with other settings produces a different-looking but equally correct image.

## Re-cutting the GIF and the stills

```bash
V=products/desk/verification-outcome-and-rework/showcase/story-v1.mp4
ffmpeg -i $V -vf "fps=10,scale=720:-1:flags=lanczos,palettegen=stats_mode=diff" /tmp/palette.png
ffmpeg -i $V -i /tmp/palette.png -lavfi "fps=10,scale=720:-1:flags=lanczos[x];[x][1:v]paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle" docs/images/story.gif
ffmpeg -ss 4.5 -i $V -frames:v 1 docs/images/story-frame-quote.png
```

Re-record the video first when the story changes: `tools/story-builder/README.md`. The look
of the story is the product lead's gate before any external use.
