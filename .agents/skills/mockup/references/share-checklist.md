# Mockup share checklist

Run this before a mockup, prototype or story leaves the workspace. Every line passes, or the
file header says why not. "Leaves the workspace" means: attached to a tracker issue, sent to
the engineering lead, shown to ops, or published anywhere outside this folder.

## Data and privacy

- [ ] **Fictional data only.** Fixture names (`Customer A`, a persona first name in a story),
      round amounts, references like `CASE-REF-0001` and `DOC-REF-0001`. No real customer,
      shop, mobile number or identity number.
- [ ] **No local paths.** No `/Users/…`, `C:\…` or workspace folder names inside the file.
- [ ] **No secrets.** No API keys, tokens or internal URLs.

## Completeness

- [ ] **Every state present.** EMPTY · PARTIAL · MISSING · RESTRICTED · PROVIDER-FAILED ·
      REWORK, as strips at L0 and as frames at L1 and L2.
- [ ] **Chips resolve.** `python3 tools/wireframe-kit/check_wireframe_data.py <feature-folder>`
      exits 0. Every field carries one chip; every chip has a packet row.
- [ ] **Variation axis** named on each option, with what it trades away.
- [ ] **Options count** matches what was asked for.
- [ ] **Roles** (Desk, Field): actions and read-only fields per role are visible.
- [ ] **Configuration.** Partner- or segment-specific behaviour is shown as configuration.
- [ ] **Click map** (L2): every screen and clickable element listed at the top.

## Look and language

- [ ] **Palette** from `context/design/tokens.md` for this surface; greyscale at L0.
- [ ] **Contrast** meets the token pairs in `tokens.md`; nothing is legible only by colour.
- [ ] **Customer language.** Harbor strings carry `[customer language]` markers or the
      localised strings from `/localisation-copy`; the longest label wraps without clipping.
- [ ] **Kicker says "design preview"** on every mockup and prototype frame. A story slide
      says **"vision"** and its framing lists every beat that is not live.

## File hygiene

- [ ] **Self-contained.** One HTML file, inline styles and script, no build step, no network,
      no external fonts or images.
- [ ] **Versioned** by filename; the previous version is still present.
- [ ] **Header** names the PRD, the persona, the fidelity level, the version and the
      screenshot-check result (done at 360 px / 1280 px, or "not run").
- [ ] **No new rules.** Everything shown is in the PRD, or you added a `[NEEDS CLARIFICATION]`
      marker to the PRD and told the product lead.

## Last question

Would a reader who has never seen this workspace understand the screen from the file alone?
If the answer needs a conversation, write the missing line into the header.
