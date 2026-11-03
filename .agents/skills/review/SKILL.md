---
name: review
description: Reviews a product artifact through independent lenses — strategy, customer, engineering-readiness, data, writing, and compliance when the profile marks the work regulated — using fresh-context reviewer agents that report and never edit. Modes — gate (verdict ready, fix or rethink, plus a must-fix list), red-team (ranked kill-assumptions with the cheapest test for each, plus a pre-mortem) and post-ship (the PRD against current behaviour and production, then handed to /land). Findings are graded Critical, Major, Minor or Outdated. Use when someone says "review this", "review the PRD", "review it before I send it", "is this ready", "check my PRD", "gate this", "red-team this", "poke holes", "what could kill this", "pre-mortem", "did we build what we meant", or "post-ship review".
argument-hint: "[gate | red-team | post-ship] <artifact path>"
---

# Review — independent lenses, graded findings, one verdict

Reviewers report; they never edit. The author applies fixes and runs `/review` again.

## Read first (if present; else name the missing file and ask)

| File | Gives you |
|---|---|
| The artifact, its frontmatter and its feature folder (`shared/`, `internal/`, `mockups/`) | What is under review, and which version |
| `decisions/decision-log.md` and the feature's `internal/decision-log.md` | LOCKED decisions the artifact must honour; PENDING ones it depends on |
| The PRD's §6 rules table, §7 information table and §9 acceptance rows | The requirement rows every lens checks against |
| `references/lenses.md` | What each lens checks, with its sources |
| `.agents/skills/product-loop/references/conventions.md` | Tiers, the 10 readiness checks, the gate line |
| `templates/review-report-template.md` | Output shape |
| `_profile.md` | `_regulated` (compliance lens on or off), `_gate_owner`, `_experience` |
| `context/surfaces/<surface>/current-behaviour.md` | Post-ship: what the surface does today, row by row |
| `releases/<cycle>-release-note.md` | Post-ship: what reached production, with evidence |

## Questions first

One batched round; defaults in brackets.

1. **Mode.** gate, red-team or post-ship? [gate]
2. **Lenses.** All, or a subset? [all for tier M and L; writing and engineering-readiness inline for tier S]
3. **Gate owner.** Who approves or sends back? [`_gate_owner` in `_profile.md`]
4. **Post-ship evidence.** Which release note, and what production evidence (screens, a replica query)? [the latest release note; ask for screens]

## Procedure

1. **Freeze the input.** Note the path and `version`. Review that version only.
2. **Read the decision log, the requirements table and the acceptance rows first.** List every LOCKED decision the artifact must honour and every PENDING one it leans on. Count open `[NEEDS CLARIFICATION]` markers. Check the frontmatter for `status`, `version`, `decision_refs` and `why`. Report each gap as Major.
3. **Pick the lenses.** Reviewers live in `.claude/agents/`.

   | Lens | Reviewer | Checks |
   |---|---|---|
   | Strategy | `business-reviewer` | Outcome metric, target label, commitment served, drift, ops cost; skeptic |
   | Customer | `customer-voice` | Persona fit, dignity, recovery paths, customer language first; cites or abstains |
   | Engineering-readiness | `engineering-readiness-reviewer` | Boundary, invariants, states, reuse rows, traceability, "no developer invents policy" |
   | Data | `data-reviewer` | Population boundary, authority, labels, claim level, target vs baseline, traps |
   | Writing | `writing-reviewer` | Writing standard, glossary terms, capability names, roles |
   | Compliance | `compliance-reviewer` | Regulated actions touched vs the register, evidence kept, consent wording, retention, recovery on every declined, rework or provider-failed outcome |

   The compliance lens runs only when `_profile.md` has `_regulated: yes`. Otherwise write one line in the report: "Compliance lens not run — `_regulated: no`."
4. **Dispatch.** Tier M and L: launch the reviewers in parallel, one per lens, each in a fresh context. The agent definitions in `.claude/agents/` restrict them to Read, Grep and Glob; where the runtime cannot restrict tools, tell the reviewer not to edit and verify with `scripts/review-guard.sh`. Reviewers return their table to you, the dispatcher. Give each the artifact path, the mode, its section of `references/lenses.md`, and the related files (PRD, mockups, brief, issue pack). Tier S: run the writing and engineering-readiness checks inline.
5. **Merge and grade.** Deduplicate. When two lenses flag one thing, keep the higher grade.

   | Grade | Means | Effect |
   |---|---|---|
   | **Critical** | Wrong outcome, boundary breach, dignity breach, false number, a regulated action without its evidence, a developer must invent policy | Blocks the gate |
   | **Major** | Missing state, unlabelled number, PRD and mockup disagree, open marker, missing frontmatter | Fix before handover |
   | **Minor** | Wording, glossary drift, formatting | Fix when convenient |
   | **Outdated** | The artifact contradicts production, a current-behaviour row or a newer LOCKED decision | Update the artifact before anything else |

6. **Verdict.**

   | Verdict | When |
   |---|---|
   | **ready** | No Critical, no Major |
   | **fix** | Major findings only, or Critical findings with a clear fix |
   | **rethink** | The outcome link fails, the problem is unsupported, or several Criticals share one root cause |

   **Understanding check (tier M and L).** A verdict of **ready** needs one more thing, run after the author applies the fixes. The engineering-readiness reviewer, holding only the fixed artifact, restates each feature, names what it changes in each layer, and names the three questions the engineering lead would ask. If it cannot, the verdict is **fix**.
   **Rounds.** One full review per artifact version. A second full round runs only on a new version.
7. **Mode extras.**
   - **red-team.** List kill-assumptions: beliefs that would kill the work if false. Rank by likelihood-false × damage. Give each the **cheapest test**: a replica query, five customer calls, a field visit with a field verifier, a fake door on Harbor, a question to one insurer partner. Add a pre-mortem: six months on, it failed — the three likeliest causes and the early signal for each.
   - **post-ship.** For every acceptance criterion and requirement row, record three things. What the PRD says. What `context/surfaces/<surface>/current-behaviour.md` already says (row id, or "no row"). What production shows, with evidence (screen, replica query, release note line). Mark each `match`, `gap` or `deferred` (deferred through `/decide` at release). Label every observation with its source. Every `gap` becomes a PENDING decision. On **ready**, hand to `/land`.
8. **Write the report** with `templates/review-report-template.md`. Must-fix list first.
9. **Gate line.** Ask the gate owner: approve or send back, with the reason. Record it in the report and the artifact. On approval, the gate owner (the product lead) sets `status: approved`; on a send-back, the author applies the fixes.
10. **Compound.** Every send-back adds a lesson to `tasks/lessons.md` through `/session end`.

**External reviewer (another model or tool).** Put the limits in the prompt: no file edits, no answers to policy questions, behaviour-changing findings become PENDING decisions. Run `scripts/review-guard.sh snapshot <folder>` before and `verify <folder>` after; restore any changed file and flag it.

Example (Harbor Cover): `/review gate products/desk/verification-outcome-and-rework/shared/prd.md` runs six lenses, because the profile says `_regulated: yes`. It writes `internal/review-<date>-gate.md` with the verdict and the must-fix list.

## Gate

| Tier | Gate |
|---|---|
| S | Writing and boundary checks pass inline; gate line recorded in the artifact |
| M, L | Every chosen lens reported · findings merged and graded · understanding check passed · gate line recorded by the gate owner |

## Output

- Tier M and L: `<feature folder>/internal/review-YYYY-MM-DD-<mode>.md`.
- Tier S: a chat summary and the gate line in the artifact.
- In chat: the verdict, the must-fix list and the report path. Nothing else.

## Do not

- Do not edit the artifact. Not even a typo. Report it.
- Do not apply a finding that changes behaviour. It becomes a PENDING decision.
- Do not soften a Critical to keep momentum.
- Do not praise. State what passes in one line, then the findings.
- Do not review a moving target. If the artifact changes mid-review, restart on the new version.
- Do not treat a persona-panel opinion as evidence. It raises questions only.
- Do not run the compliance lens from memory. It reads `context/regulated-actions.md` or it does not run.

## Hands off to

The producing skill applies fixes → `/review` again. On **ready**: `/decide` locks the gate decision, then the next skill in the workflow. Post-ship **ready** → `/land`.
