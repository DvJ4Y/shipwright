---
name: mockup
description: Makes the visuals for a feature in three steps — a story walkthrough for direction and agreement (script, greyscale storyboard, hi-fi autoplay), an L0 greyscale wireframe with data chips and the six state strips for engineering, then L1 hi-fi in the surface palette or an L2 clickable prototype when needed. Asks first for surface, persona, variation axis (UI, Data Field or Screen), fidelity and number of options. Designs customer surfaces in the customer's language first and internal surfaces in the working language, versions by filename, runs the share checklist and a screenshot check, and records the choice in a design spec. Use when someone says "mock this up", "mock up the screen", "create a mockup", "how should this look", "wireframe", "design options", "show me options", "prototype", "make it clickable", "storyboard", "walkthrough", "demo video", "UI for this", or "redesign this screen".
argument-hint: "[story | L0 | L1 | L2] [surface] [options]"
---

# Mockup — a design prototype, not a data mirror

Show the PRD's flow and states as screens. Take every rule from the PRD, never from the mockup.

## Read first (if present; else name the missing file and ask)

| File | Gives you |
|---|---|
| `context/design/tokens.md` | Palette, type scale and language per surface; the six state strips |
| `context/surfaces/<surface>/current-behaviour.md` | What the surface does today; the rows this screen extends |
| `context/03-surfaces-and-systems.md` | "Already done — do not re-propose" |
| The PRD at `products/<code>/<feature>/shared/prd.md`, or the discovery for an early sketch | The flow, rules and states to show |
| `context/personas/<card>.md` | Who is on the screen, in what conditions |
| `tools/wireframe-kit/kit.md` | The L0 block: style, chips, strips, naming, the verification hook |
| `tools/story-builder/README.md` | The story method: script → greyscale storyboard → hi-fi |
| `templates/story-script-template.md`, `templates/design-spec-template.md` | Where the beats and the decision are recorded |
| `templates/screen-contract-template.md` | Tier L only — a screen several features share |
| `_profile.md` | `_language`, `_customer_language`, `_language_review`, `_experience`, `_struggles` |

**No PRD and no discovery?** A story or an L0 sketch to support discovery is allowed. Say so
in the file header. L1 and L2 need a PRD at `in-review` or `approved`.

## Questions first

One batched round; defaults in brackets.

1. **Surface.** Harbor, Desk or Field? For Field, which role: field verifier or referral agent? [from the PRD]
2. **Persona and moment.** Who is on this screen, and what just happened? [the primary persona in the PRD]
3. **Variation axis.** UI (same data, new presentation), Data Field (new or changed data) or Screen (different flow or order)? [UI]
4. **Step and fidelity.** Story for direction and agreement; L0 for options and the engineering handoff; L1 for the chosen option; L2 when a flow must be clicked through? [L0]
5. **Options.** How many? [4 when options are asked for; otherwise 1]

## The three steps, in order (step 3 is L1 or L2)

| Step | Level | What it is | Use for |
|---|---|---|---|
| **1 Story** | — | One case end to end, through every stakeholder who touches it. Script from the template → greyscale storyboard, one frame per beat → hi-fi autoplay from the story builder. The look comes from production screenshots and the surface's tokens. The slide says **"vision"** | Direction and agreement before the PRD is final |
| **2 Wireframe** | L0 | Greyscale. Real labels, fictional data. Every field carries one data chip `[ POINT-ID · unit/type · provenance · current storage · disposition ]`; the chip resolves to a row in `internal/data-packet.csv`. The six states, each under its labelled strip | Comparing options; the data-complete handoff to engineering |
| **3 Hi-fi** | L1 | The surface palette from `tokens.md`; existing components; strings of realistic length | The chosen option; review with ops or customers |
| **3 Prototype** | L2 | Clickable. A screen-and-click map at the top of the file: every screen, every clickable element, where it goes. Every `data-pt="ID"` resolves to the packet | Usability tests; flow alignment with engineering |

The six states are **EMPTY · PARTIAL · MISSING · RESTRICTED · PROVIDER-FAILED · REWORK**.
`tools/wireframe-kit/kit.md` defines them. The mockup shows them.

## Procedure

1. **Phase check.** State it.
2. **Read current behaviour** for the surface. List the rows and components you extend
   (Harbor Cover example: the rework list is `HUB-008`, the officer's reason code is
   `DESK-004`, on-site capture is `FLD-005`). Justify any new component in one line.
3. **Pick the step** from question 4. If `tools/wireframe-kit/` or `tools/story-builder/`
   is missing, name it and ask.
4. **Story.** Write the script from `templates/story-script-template.md` in chat first:
   framing, look baseline, language, demo case, beats. Each beat is one screen and one
   change. The caption states the outcome, not the feature. On approval, build the
   greyscale storyboard: `python3 tools/story-builder/build_story.py <script.md>
   <board.html> --storyboard`. Then build the hi-fi with the same command without
   `--storyboard`, adding `--palette context/design/tokens.md --surface <surface>`. List
   every beat that is not live under framing.
5. **Wireframe.** One `.mockup.html` per feature and surface, from the kit's style block.
   Every `class="f"` field carries exactly one chip. Every chip's point id exists in
   `internal/data-packet.csv` and its disposition matches the packet. All six strips are
   present. Run `python3 tools/wireframe-kit/check_wireframe_data.py <feature-folder>`; it
   must exit 0 before anyone sees the file. If a data point has no row, add the row with
   disposition `unresolved`. Do not invent a storage path.
6. **Palette.** Greyscale at L0. At L1 and L2, the surface palette from `tokens.md`. One
   accent per screen on Harbor.
7. **Language.** Harbor and every customer message: the customer's language first. Write
   each string in the working language (`_language`) with a `[customer language]` marker
   until `/localisation-copy` runs. Design for text expansion and script rendering; show the
   longest-label case. Desk and Field: the working language. `/product-copy` supplies the
   final strings.
8. **Show the hard cases.** The long shop name, the missing document, a case with three
   rework items, the provider-failed identity check, the restricted audit view.
9. **Roles.** On Desk and Field, show what each role can do and what is read-only. Show
   partner- or segment-specific behaviour as configuration.
10. **Screenshot check.** Open each file at 360 px wide (1280 px for Desk) when a browser is
    available: the editor's browser, a screenshot tool or the product lead's browser. Fix
    overlaps, clipped labels and illegible contrast. With no browser, write "screenshot
    check: not run" in the file header.
11. **Share checklist.** `references/share-checklist.md`. Every line passes, or the header
    says why not.
12. **Rules check.** If the mockup needed a rule the PRD does not state, stop. Add
    `[NEEDS CLARIFICATION: <question> → P-nn]` to the PRD and tell the product lead.
13. **Record** the choice in the design spec once the product lead picks an option: what was
    chosen, why the others were not, the decision point id. A recommendation is PENDING
    until the owner locks it.

## Gate

| Tier | Gate |
|---|---|
| S | Share checklist passes · screenshot check done or stated as not run |
| M | S gate · the chip check exits 0 · PRD and mockup describe the same flow (readiness check 6) · design spec written · `/review` customer lens run |
| L | M gate · a screen contract for any screen shared by several features · the product lead approves the story before the hi-fi build |

## Output

| Artifact | Path |
|---|---|
| Wireframe or hi-fi | `products/<code>/<feature>/mockups/<surface>-<feature>-v<n>.mockup.html` |
| Clickable prototype | `products/<code>/<feature>/mockups/<surface>-<feature>-v<n>.prototype.html` |
| Story | `products/<code>/<feature>/showcase/story-script.md`, `storyboard-v<n>.mockup.html`, `story-v<n>.html` |
| Design spec | `products/<code>/<feature>/internal/design-spec.md` |
| Tier S | The same mockup path. A Tier S change has a feature folder too |

A long feature name may be shortened in the filename (`harbor-verification-outcome-v1` for
`verification-outcome-and-rework`). The design spec records the short form. Versions live in
the filename: `-v1`, `-v2`. Never overwrite an approved version; copy to the next number and
keep the previous file. In chat: the paths, one line per option on what it trades away, the
chip-check result and the screenshot result.

## Do not

- Do not invent business rules in the mockup. Stop and mark the PRD.
- Do not build a parallel component set or a new dashboard. Extend the queue and the case view.
- Do not take colour from another mockup, a screenshot or a vendor's brand.
- Do not present one option when options were asked for.
- Do not ship a customer surface without the `[customer language]` markers or the localised strings.
- Do not let a story stand in for the wireframe. The story is vision; the wireframe is data.
- Do not specify component structure, state management or storage for engineering. A chip
  names where a value lives today; it does not say how to build anything.

## Hands off to

`/product-copy` for the strings → `/localisation-copy` for the customer's language →
`/persona-panel` for questions to test → `/review` → `/prd-writer` if the mockup exposed a gap.
