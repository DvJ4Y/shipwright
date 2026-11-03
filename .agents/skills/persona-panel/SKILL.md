---
name: persona-panel
description: Runs a synthetic critique of a flow, mockup, copy or PRD through the persona cards — customer segments and internal roles (support agent, verification officer, placement specialist, field verifier, compliance officer, referral agent, insurer partner). Each panelist cites an evidence row from its card or abstains. All output is labelled SYNTHETIC and becomes questions and risks to test with real people, never validation. Use when someone says "what would customers think", "how would the pharmacy customer react", "how would a named persona react to this", "how would a verification officer use this", "persona check", "run the personas", "would field verifiers adopt this", "customer reaction", "who would struggle with this" or "how would a customer take a second document request".
argument-hint: "<artifact path> [card segments or role names]"
---

# Persona panel — questions for real research, never answers

Run the panel to find questions for real research, never to validate. A persona panel is
cheap and fast. It cannot tell you what real people will do.

## Read first (if present; else name the missing file and ask)

| File | Gives you |
|---|---|
| `context/personas/README.md` and every card it lists | The panel: each card's `kind`, `status`, evidence rows and "What we don't know" |
| The artifact to critique | The flow, mockup, copy table or PRD |
| `context/01-company.md` | Segments by shop type; positioning; the dignity rule |
| `context/06-teams-and-who-does-what.md` | Roles with no card yet (claims handler, ops lead) |
| `context/02-service-and-lifecycle.md` | Stage and sub-status names the panel must use |
| `templates/persona-card-template.md` | If a card must be drafted first |

**No persona cards?** Stop. Say the panel cannot run without evidence. Offer to draft cards
from named sources with the template.

## Questions first

One batched round; defaults in brackets.

1. **Artifact and moment.** Which screen or step, and what happened just before it? [the whole artifact]
2. **Panel.** Which customer cards and which roles? [every customer card plus every role that touches the step]
3. **Focus.** Comprehension, trust, effort, adoption or operational load? [all]
4. **Next research.** What can follow — calls, a field visit, sitting in on support calls, a usability test? [five calls with the primary shop type]

## Procedure

1. **Seat the panel.** For each panelist: the card named by its segment or role ("the
   pharmacy customer card", "the verification officer card"), `status`, and the evidence
   rows (E#) you will rely on. Include the internal roles that touch the step — a flow the
   customer likes and the verification officer cannot work is a risk. A role with no card
   sits as "no card — questions only", from `context/06-teams-and-who-does-what.md`.
2. **Walk the artifact** step by step as each panelist. For each step record what the
   panelist likely understands, does or worries about — **only when an evidence row supports
   it**, cited by E#. Otherwise write **"abstain — not in evidence"**. A card's "What we don't
   know" list yields questions, never reactions.
   *The pharmacy customer card on a second request for the same document → E1, E3: low
   tolerance for repeat asks; one repeat and she calls support. Her reaction to a field
   verifier capturing the replacement on site → abstain; it sits under "What we don't know".*
3. **Thin cards** (`status: thin`) raise questions only. They produce no risk ratings.
4. **Internal roles** check operational load: extra clicks, time per case, training needed,
   a new field to fill, a second screen. Apply the viability test: who captures it, how long
   per case, can the system derive it. *The verification officer card: one screen, no
   second screen (E1, E3) — a step that needs a second window is a risk.*
5. **Dignity and recovery.** For every `declined` or `rework` step, ask:
   - Is the reason in plain words?
   - Is a recovery path shown?
   - Is the customer framed anywhere as rejected by an insurer or a provider?
   - Is a `refer` ever shown as declined?
   - Is the customer's language used on customer surfaces? Cite the card's language and
     channel rows.
6. **Convert to research.** Every concern becomes a question to test with real people, with
   who to ask, the cheapest method, and what would change if the answer is no.
7. **Optionally dispatch** the `customer-voice` reviewer for a fresh-context run. Merge its
   rows. It reports and never edits.

## Gate

The panel has no gate of its own. Its output feeds `/review` (customer lens) and the next
discovery round. It never closes a decision point.

## Output

| Tier | Path |
|---|---|
| S | In chat |
| M | `products/<code>/<feature>/internal/persona-panel-NN.md`, numbered like the review reports |
| L | `initiatives/<name>/features/<feature>/internal/persona-panel-NN.md` |

```
SYNTHETIC — generated from persona cards; not research findings.

Panel: <card by segment or role (status)>, …
| # | SYNTHETIC | Card (segment or role) | Step | Likely reaction or concern | Evidence (E#) or "abstain" |

Questions for real research
| # | Question | Who to ask | Cheapest method | What would change if the answer is no |

Risks to test (evidence-backed cards only)
| # | Risk | Card (segment or role) | Evidence (E#) | Test |
```

Every table carries the SYNTHETIC label. Remove any row with neither an E# nor "abstain".

## Do not

- Do not present synthetic output as validation, user research or "customers said".
- Do not invent a persona's traits beyond its evidence rows. Abstain instead.
- Do not present a quote from a card as a real customer's words unless its provenance row
  says it is.
- Do not use the panel to settle a disagreement. Use it to choose what to test.
- Do not let a thin card drive a design change.
- Do not quote a segment share that `context/01-company.md` says is not measured.
- Do not name a persona by first name in the panel. Name the card by segment or role.

## Hands off to

`/product-discovery` (research round) → `/decide` if the research would change a choice →
`/review` customer lens.
