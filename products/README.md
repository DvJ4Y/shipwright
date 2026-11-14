---
title: products — one folder per feature
type: readme
status: active
version: 1.0
supersedes: —
decision_refs: []
why: Says where a feature's documents go before the first one exists
last_updated: 2026-11-04
---

# `products/` — the change layer

One folder per feature: `products/<code>/<feature>/`. `<code>` is the workstream code of the
surface the feature mainly changes; set your codes in `knowledge/PROFILE.md`. `/product-loop`
creates the folder on the first tier M piece of work.

| Folder | Holds | Written by |
|---|---|---|
| `shared/` | The PRD, the brief, the copy table. Self-contained; handed to engineering. No local paths, no decision ids, no phase check | `/prd-writer`, `/engineering-brief`, `/product-copy` |
| `internal/` | Discovery, the `P-nn` decision log, the data packet, the design spec, reviews, readiness, the issue pack, the crosswalk | the producing skills |
| `mockups/` | Wireframes and prototypes, versioned by filename | `/mockup` |
| `showcase/` | The story script and the story build | `/mockup`, `tools/story-builder/` |
| `<code>/archive/landed-YYYY-MM-DD/<feature>/` | A landed feature folder | `/land` only |

A filled feature folder: `examples/harbor-cover/products/desk/verification-outcome-and-rework/`.
