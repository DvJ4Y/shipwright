---
paths:
  - "**/prd/**"
  - "**/prd.md"
  - "**/*-prd.md"
---

# PRD files

- A PRD answers WHAT and WHY. It never answers HOW.
- It lives at `products/<code>/<feature>/shared/prd.md`. `shared/` is self-contained: no
  dates, no decision history, no internal IDs. Discovery, decisions, reviews, readiness and
  evidence live in `internal/`.
- Frontmatter carries `status` (draft | in-review | approved | shipped | landed | superseded),
  `version`, `supersedes`, `decision_refs`, `landed_into` and `why`.
- Discovery must exist before a PRD. If it does not, say so and offer `/product-discovery`.
- Read `context/surfaces/<surface>/current-behaviour.md` before writing. Cite row ids in
  "Current behaviour and reuse"; never re-specify a landed behaviour.
- One line **"Regulated actions touched:"** lists the register rows from
  `context/regulated-actions.md`, or "none". Required when `_profile.md` says
  `_regulated: yes`.
- Acceptance criteria are observable: "When … then …".
- Every metric names its source and its claim level. A target is labelled as a target.
- Open points are inline markers: `[NEEDS CLARIFICATION: <question> → P-nn]`. Any open
  marker blocks `in-review`.
- Use `templates/prd-template.md`. Keep the main use case visible on the first page.
- Under 200 lines. Split by feature if longer.
