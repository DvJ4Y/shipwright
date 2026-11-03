---
name: decide
description: Decision partner and decision log. Frames the decision (owner, deadline, one-way or two-way door), asks the product lead's leaning first, agrees "good enough" criteria, runs at most three Socratic rounds and a contrarian pass, pulls evidence only when it would change the answer, applies a stop rule, then logs the decision PENDING or LOCKED with a propagation list. Supersede mode writes the crosswalk and archives the old version. Use when someone says "help me decide", "should we", "I'm torn", "which option", "challenge my thinking", "push back on this", "is this the right call", "log this decision", "record that we decided", or "supersede that decision".
---

# Decide — a decision partner, not a cheerleader

Frame the decision, challenge the leaning, then log it PENDING or LOCKED. Be succinct and
Socratic. Give no praise. Argue the other side when the evidence allows. The goal is a good
decision made on time, not a perfect one made late.

## Read first (if present; else name the missing file and ask)

| File | Gives you |
|---|---|
| The decision log in scope: `decisions/decision-log.md` (`D-NNN`), the feature's `internal/decision-log.md` or the initiative's `decision-log.md` (`P-nn`). If the feature log does not exist yet, create it from `templates/decision-log-template.md` | An existing row on the same question; the next free ID |
| The artifact the decision affects, if one is named | What changes when the row locks |
| `.agents/skills/product-loop/references/conventions.md` | Decision points, statuses, supersession, folders |
| `context/06-teams-and-who-does-what.md` | Who owns which kind of decision |
| `context/regulated-actions.md` | Whether the decision touches a regulated action; that makes it a one-way door |

## Questions first

One batched round. Skip what the request already answers.

1. **Decision.** What is being chosen between, in one line? [as stated]
2. **Owner and deadline.** Who locks it, and by when? [the owner from `context/06-teams-and-who-does-what.md`; no deadline]
3. **Door.** One-way or two-way? [two-way, unless the list below applies]
4. **Leaning.** "Which way are you leaning, and why?" [no default — the product lead answers before you offer a view]

One-way doors: a customer-facing commitment, data deleted or exposed, a regulated action, an
insurer partner contract, a public statement. Anything reversible within a cycle at low cost
is a two-way door.

## Procedure

Pick the mode from the request.

| Mode | Trigger | Does |
|---|---|---|
| **partner** (default) | "help me decide", "should we", "I'm torn", "challenge this" | Partner steps 1–7 |
| **log** | "log this decision", "record that we decided" | Partner step 7 only, after confirming frame and owner |
| **supersede** | "supersede D-nnn", "we changed our mind on" | Supersede steps 1–4 |

**Partner**

1. **Frame in one line.** Decision · owner · deadline · door.
2. **"Good enough" criteria.** Agree 2–4 criteria before looking at options. A decision that
   meets them is acceptable; do not keep searching for a better one.
3. **Socratic round.** At most 3 questions per round, at most 3 rounds. Each question must be
   able to change the answer. "What would have to be true for the other option to win?" ·
   "Who bears the cost if this is wrong?" · "What do we lose by waiting a cycle?"
4. **Contrarian pass.** Steelman the opposite of the leaning in 2–3 sentences. Evaluate the
   proposal in the third person: "The proposal claims X. The evidence for X is Y." Name each
   unsupported claim with its claim level, each vague word ("better", "faster", "most"), each
   sunk cost and each missing data point. If you hold a recommendation, argue against it too.
5. **Evidence.** Pull data or research only when it would change the answer. Cite it with
   one of the five source labels: `DB-verified <date>` · `analytics` ·
   `operational — unverified` · `target` · `example`. Route queries to `/data-analysis`.
6. **Stop rule.**

   | Situation | Action |
   |---|---|
   | Two-way door, criteria met, about 70% of the information | Say: **"Enough. Decide X. Revisit if Y."** |
   | One-way door | Run a pre-mortem first: six months on, it failed — the three likeliest reasons and their early signals. Then decide |
   | Reversible micro-choice | Default-and-inform: pick, state it in one line, move on |
   | Three rounds done, still split | Name the crux in one sentence and hand it to the owner |

7. **Record.** Append a row (`templates/decision-log-template.md`). Columns: why, rejected
   alternatives, door, owner, revisit trigger, propagation list. The **propagation list**
   names every file the decision changes: a PRD, `context/policies/<file>.md`,
   `context/surfaces/<surface>/current-behaviour.md`, QA rows, message templates. For a
   one-way door or long reasoning, also write a decision record
   (`templates/decision-record-template.md`) and link it.
   - Log your recommendation PENDING. It becomes LOCKED only when the owner confirms in
     this conversation or in writing.
   - Once LOCKED, replace each matching `[NEEDS CLARIFICATION: … → P-nn]` marker and work
     through the propagation list. List any file not yet updated.
   - A bundle is several rows. List each decision that reaches another team, a metric or a
     locked row on its own, with a one-line consequence and its blast radius (own team,
     other team, metric, locked row). Ask the owner to rank them. If the owner replies
     "proceed with all", ask once more for that item's consequence.

Example: `D-006` — which rework reasons a field verifier may resolve on site. Recommendation:
`unreadable` and `missing` on site; `mismatched` back to the customer. Owner: ops lead. Door:
two-way. PENDING until the ops lead confirms. Propagates to the worked feature PRD and
`context/surfaces/field/current-behaviour.md`.

**Supersede**

1. Read the old row and every file in its propagation list.
2. If the old decision carried requirements, write a crosswalk
   (`templates/crosswalk-template.md`) showing where each one goes.
3. Add a new row whose `Supersedes` names the old ID. Set the old row's status to
   SUPERSEDED. Never rewrite the old row's text.
4. Move superseded artifacts to `archive/superseded-YYYY-MM-DD/` with a "replaced by"
   README. Update the files on the propagation list.

Method sources: devil's advocate against the agent's own pick · third-person framing
against sycophancy · pre-mortem · one-way and two-way doors with the 70% rule ·
satisficing · Socratic questioning.

## Gate

The row has every column filled. The status matches who confirmed it. The propagation list
names every file the decision changes. A decision that reaches another team, a metric or a
locked row carries a one-line consequence in `Why`.

## Output

- A row in the decision log, PENDING or LOCKED.
- Optionally a decision record: `decisions/YYYY-MM-DD-<topic>.md` for the workspace,
  `products/<code>/<feature>/internal/` for a feature, `initiatives/<name>/research/` for
  tier L.
- In chat, at most 6 lines: frame, decision, door, revisit trigger, status, files to update.

## Do not

- Do not praise the idea or the question.
- Do not give your view before the product lead states a leaning.
- Do not run more than three rounds. Decision fatigue is a cost.
- Do not log a recommendation as LOCKED.
- Do not log a bundle as one decision (step 7).
- Do not ask about reversible micro-choices. Default and inform.
- Do not invent evidence. If the data does not exist, say what would settle it.
- Do not present a target as a baseline in `Why`.

## Hands off to

The artifact's producing skill, to apply the propagation list. `/data-analysis` if evidence
is needed. `/land` when a LOCKED row changes a landed behaviour. `/session end` to record
the decision in the handoff.
