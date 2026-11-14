---
title: Design tokens — palette and type per surface
type: context
status: active
version: 1.0
supersedes: —
decision_refs: []
why: One source for colour and type per surface, so no mockup borrows a palette from another mockup
last_updated: 2026-11-02
---

# Design tokens — palette and type per surface

> Last verified: 2026-11-02

Take colour from this file, never from another mockup. Three surfaces, three palettes, one
shared neutral scale. Values are invented for Harbor Cover; replace them with your own.

## Language

| Surface | Language |
|---|---|
| Harbor and every customer message | The customer's language, chosen at entry. Design for text expansion and script rendering first; English is one of the options |
| Desk | English |
| Field | English on screen; voice input in the verifier's language |

## Shared neutral scale

| Token | Hex | Use |
|---|---|---|
| `neutral-900` | `#1F2933` | Primary text |
| `neutral-600` | `#52606D` | Secondary text, labels |
| `neutral-400` | `#9AA5B1` | Placeholders, disabled |
| `neutral-200` | `#E4E7EB` | Borders, dividers |
| `neutral-050` | `#F5F7FA` | Page background |
| `white` | `#FFFFFF` | Cards, inputs |

## Harbor — customer palette

Calm, high contrast, few colours. The customer should never have to decode colour.

| Token | Hex | Use |
|---|---|---|
| `harbor-primary` | `#0E6B6B` | Primary buttons, links, progress |
| `harbor-primary-dark` | `#0A4F4F` | Pressed state, headings on light |
| `harbor-accent` | `#F2A33A` | One highlight per screen: the premium range, the next step |
| `harbor-success` | `#2E8B57` | Received, verified, issued |
| `harbor-warning` | `#C98A00` | On hold, action needed |
| `harbor-error` | `#B3261E` | Rework reason, declined rule; always with a next step beside it |

## Desk — internal palette

Dense, scannable, colour as status only.

| Token | Hex | Use |
|---|---|---|
| `desk-primary` | `#1F3A5F` | Navigation, primary actions |
| `desk-accent` | `#3E7CB1` | Selected row, active filter |
| `tier-3` | `#B3261E` | Tier 3 chip |
| `tier-2` | `#C98A00` | Tier 2 chip |
| `tier-1` | `#52606D` | Tier 1 chip |
| `status-rework` | `#D97706` | Rework chip |
| `status-refer` | `#7C3AED` | Refer chip |
| `status-pass` | `#2E8B57` | Pass chip |
| `status-provider-failed` | `#1F2933` on `#FDE68A` | PROVIDER-FAILED flag |

## Field — field palette

Sunlight-readable, large targets, one hand.

| Token | Hex | Use |
|---|---|---|
| `field-primary` | `#2F6F3E` | Primary buttons, submitted state |
| `field-accent` | `#E07A1F` | Open rework count, pending send |
| `field-error` | `#B3261E` | Empty mandatory slot |
| `field-surface` | `#FFFFFF` on `#F5F7FA` | Cards; minimum contrast ratio 7:1 for body text |

## Type scale

System sans-serif on every surface; the customer's script falls back to the device's font
for that script.

| Surface | Body | Label | Heading | Display | Note |
|---|---|---|---|---|---|
| Harbor | 16 | 14 | 22 | 28 | Line height 1.5; buttons 48 tall |
| Desk | 14 | 12 | 18 | 22 | Line height 1.4; table rows 40 tall |
| Field | 18 | 14 | 24 | 28 | Line height 1.5; buttons 56 tall; one primary action per screen |

Sizes are in device-independent pixels.

## State strips

Every mockup shows six states: EMPTY · PARTIAL · MISSING · RESTRICTED · PROVIDER-FAILED ·
REWORK. The state strip uses `neutral-600` text on `neutral-050`; the state name is in
capitals.

## Rules

- One accent per screen on Harbor. If two things compete, the next step wins.
- Colour never carries meaning alone. A chip has a word; an error has a sentence.
- No colour from another mockup, a screenshot, or a vendor's brand.
