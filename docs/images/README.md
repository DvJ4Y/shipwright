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
| `loop.png` | `src/loop.mmd`. The README shows this image | Mermaid, neutral theme, in a headless browser; text colour and borders from the shared neutral scale in `context/design/tokens.md` |
| `layers.png` | `src/layers.mmd`. The README shows this image | the same |
| `visual-method.png` | `src/visual-method.mmd`. The README shows this image | the same |
| `story.gif` | `products/desk/verification-outcome-and-rework/showcase/story-v1.mp4` (all twelve beats). The GIF is five beats cut from it: 1 (the quote), 3 (the officer returns a document), 4 (the provider failure), 8 (the replacement accepted) and 12 (the end card) | ffmpeg: each beat cut at eight frames a second, 640 px wide, joined, one palette for the whole clip |
| `../../assets/social-preview.png` | `assets/social-preview.svg` — the card GitHub shows when the repo link is shared; upload it under Settings → Social preview | headless browser, 1280 × 640 |
| `story-frame-quote.png` | the same video, one frame from beat 1 (Harbor, the quote) | ffmpeg, one frame |
| `story-frame-documents.png` | the same video, one frame from beat 2 (Harbor, the documents) | ffmpeg, one frame |
| `story-frame-desk.png` | the same video, one frame from beat 3 (Desk, the case view) | ffmpeg, one frame |

Every name, amount and identifier on the story frames is a demo value from the story
script, labelled `example` there. The story is product vision, not shipped behaviour; any
slide that uses a frame must say so (`docs/04-visual-method.md`).

## Re-rendering a diagram

The `.mmd` under `src/` is the source; the README shows the rendered PNG, because GitHub's own Mermaid theme shrinks wide diagrams.

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
i=0; for r in "0.5 5" "12.5 6" "19.5 6" "45.5 6" "69 5"; do set -- $r
  ffmpeg -ss $1 -t $2 -i $V -vf "fps=8,scale=640:-1:flags=lanczos" -an /tmp/c$i.mp4
  echo "file '/tmp/c$i.mp4'" >> /tmp/list.txt; i=$((i+1)); done
ffmpeg -f concat -safe 0 -i /tmp/list.txt -c copy /tmp/hero.mp4
ffmpeg -i /tmp/hero.mp4 -vf "palettegen=stats_mode=diff" /tmp/palette.png
ffmpeg -i /tmp/hero.mp4 -i /tmp/palette.png -lavfi "paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle" docs/images/story.gif
ffmpeg -ss 4.5 -i $V -frames:v 1 docs/images/story-frame-quote.png
```

Re-record the video first when the story changes: `tools/story-builder/README.md`. The look
of the story is the product lead's gate before any external use.
