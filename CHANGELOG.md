# Changelog

## 0.1.2 — the worked example, end to end at v1.1

- **PRD and brief v1.1, approved** after a second six-lens gate (`internal/review-2026-11-04-gate.md`): the missing-template fallback, the officer-run retries until the retry queue is live, the missed visit, the regional visit switch, lapse and concurrent capture, consent for the identity re-run. Issue pack v1.1; readiness re-checked.
- **Mockups v2** for Harbor, Desk and Field, and the data packet refreshed to 40 points; the chip check passes.
- **Story v2**, re-recorded: three identity-check attempts, the clock that stays stopped, a plain reason and every route for the customer, the manual verification. The README GIF is cut from it.
- **QA** rows for every state the PRD names, and for the v1.1 additions. **Context**: surface files, the regulated-actions register and the metrics dictionary aligned; D-008 restates the retry rule.

## 0.1.1 — the front page

- **README** — a centred header with the icon, a navigation row, a "Look first" table that walks the worked feature artifact by artifact, the three diagrams as rendered images, and links on every path.
- **Story GIF** — five beats instead of the opening three: the quote, the return, the provider failure, the replacement accepted, the end card.
- **Repository** — marked as a template; Discussions on; `.gitattributes` so the language bar reflects the pack, not its mockups; a social preview card in `assets/`.
- **Worked example** — the PRD and the brief at v1.1, in review; v1.0 archived.

## 0.1.0 — first public release

- **Name** — Shipwright. Repository `DvJ4Y/shipwright`; plugin `shipwright@shipwright`.

- **Skills** — sixteen in `.agents/skills/`: `product-loop`, `product-discovery`, `decide`, `prd-writer`, `mockup`, `product-copy`, `localisation-copy`, `persona-panel`, `review`, `engineering-brief`, `data-analysis`, `issue-tracker` (two tracker adapters), `meeting-processor`, `land`, and the user-invoked `session` and `onboard`.
- **Reviewers** — six read-only agents in `.claude/agents/` with Codex wrappers in `.codex/agents/`: strategy, customer, engineering-readiness, data, writing and compliance; they report and never edit.
- **Rules** — the constitution, the writing standard, and the data, PRD and mockup rules in `.claude/rules/`.
- **Hooks** — session start (profile, handoff head, shipped-not-landed PRDs), a one-time stop reminder for the handoff, and a guard that denies edits to generated files; wired for Claude Code and Codex.
- **Context** — the Harbor Cover example company: company, lifecycle, surfaces, eligibility and verification, numbers and traps, teams, glossary, strategy, commitments, metrics dictionary, persona cards, policies, the regulated-actions register, and one current-behaviour file per surface.
- **Worked example** — `products/desk/verification-outcome-and-rework/`: discovery, decision log, PRD, brief, review, readiness, issue pack, crosswalk, mockups and the story.
- **Templates** — twenty-one artifact templates, from discovery and PRD to crosswalk, current-behaviour row, policy and story script.
- **QA** — the 15-column test-case catalog and the analytics-event catalog per surface, with the four-trigger process.
- **Tools** — the read-only SQL query runner, the wireframe kit with its data-chip check, the story builder, and the UX-audit and competitor-video prompts.
- **Automations** — the weekly session compressor, context miner and knowledge interview, with a runner and cron and launchd schedules.
- **Evals** — the trigger-prompt set across all sixteen skills, the headless runner, the golden shapes and the 90% bar.
- **Docs** — twelve guides from why to policies and compliance, the lessons chapter, and a README that names the decision each document unblocks.
- **Scripts** — the pack check with its pre-commit example, the people denylist, the substitution table, the harness linker, the plugin builder and the review guard.
- **Plugin** — `plugin/` generated from the canonical sources with Claude Code and Codex manifests and a marketplace entry at the repo root.
- **Front door** — README with the loop, the four layers and the visual method as diagrams, a story GIF and stills under `docs/images/` with their sources; `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `PRIVACY.md`, three issue templates, a pull-request template, and the plugin icon under `assets/`.
- **Starter files** — blank profile, decision log, handoff, todo and lessons for a new workspace.
