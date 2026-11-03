---
paths:
  - "**/*.mockup.html"
  - "**/*.prototype.html"
---

# Mockup and prototype files

- One self-contained HTML file. Inline styles. No build step and no external assets.
- **Version by filename** (`-v2`, `-v2.1`). Never overwrite an approved version.
- **Colour comes from `context/design/tokens.md`** for the surface, never from another
  mockup, a screenshot or a vendor's brand.
- Compose from the components in `tools/wireframe-kit/kit.md`. Justify every new component.
- **Show the six state strips** on every screen: EMPTY · PARTIAL · MISSING · RESTRICTED ·
  PROVIDER-FAILED · REWORK.
- **Every data chip carries a source**: an existing location (a current-behaviour row, a
  replica column, an event) or `new`. Run `tools/wireframe-kit/check_wireframe_data.py`
  before sharing; a failing chip check blocks the share.
- Name the variation axis: UI, Data Field or Screen.
- Customer-facing surfaces (Harbor, WhatsApp) are designed in the customer's language first:
  text expansion, script rendering, long labels. Internal surfaces (Desk, Field) are English
  unless `_profile.md` says otherwise.
- A mockup explains the PRD. It is not a source of business rules. If it reveals a new rule,
  update the PRD first.
- Before sharing, run the share checklist in
  `.agents/skills/mockup/references/share-checklist.md`.
