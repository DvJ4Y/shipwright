---
name: meeting-processor
description: Processes meeting notes, call notes and transcripts into routed outcomes — todo items, intake feedback for the relevant feature or initiative, PENDING decision points, ops tasks and follow-ups. Proposes tracker issues as a draft list for approval and never creates them. Use when someone says "meeting notes", "process this meeting", "process this call", "action items", "summarise this call", "what did we decide", "standup notes", "sprint review notes", "retro notes", "founder sync", "ops review notes", "customer call notes", "insurer call notes", or "field visit notes".
argument-hint: "<notes path or pasted notes>"
---

# Meeting processor — route every outcome, create nothing in the tracker

A meeting produces decisions, direction, tasks and questions. Each goes to one place. This
skill proposes tracker issues as a draft list; it never creates them.

## Read first (if present; else name the missing file and ask)

| File | Gives you |
|---|---|
| The notes (file path or pasted text) | The items to route |
| `sessions/latest.md`, `tasks/todo.md` | Work in flight the meeting may extend or contradict |
| The decision log in scope: `decisions/decision-log.md` (`D-NNN`), the feature's `internal/decision-log.md` or the initiative's `decision-log.md` (`P-nn`) | LOCKED rows an item may contradict; the next free ID |
| The initiative's `INDEX.md` and `intake-feedback.md`, or the feature's `internal/intake-feedback.md` | Where direction from the owner goes |
| `context/06-teams-and-who-does-what.md` | Which role may lock which decision |
| `context/personas/` | Persona cards; customer and field quotes become proposed evidence rows on them |
| `.agents/skills/product-loop/references/conventions.md` | Decision points, folders, source labels |

## Questions first

Ask only what the notes do not show; default the rest.

1. **Meeting type and date.** [inferred from the notes]
2. **Scope.** Which feature or initiative does this touch? [inferred; "workspace" if none]
3. **Decision owner.** Who can lock decisions made here? [the senior role present, checked
   against `context/06-teams-and-who-does-what.md`]
4. **Audience for the summary.** Just you, or shared? [just you]

## Procedure

1. **Read and classify** every item into exactly one bucket:

   | Bucket | Goes to |
   |---|---|
   | Decision made by its owner | Decision log as **LOCKED** (owner role and date recorded) |
   | Decision proposed or leaning | Decision log as **PENDING** |
   | Direction from the owner of a feature or initiative | Its `intake-feedback.md` (newest on top) |
   | Product task with no issue | `tasks/todo.md` |
   | Engineering work | **Proposed issue** (draft list below) |
   | Ops or business task | Listed with owner role; not the tracker |
   | Follow-up | Owner role, channel, due date |
   | Unclear | Parked with a question for the owner |
   | Information only | Skipped |

2. **Contradictions.** If an item contradicts a LOCKED decision, a `current-behaviour.md`
   row or the handoff, flag it. Do not overwrite. Propose a supersede through `/decide`.
3. **Roles, not names.** Record owners as roles.
4. **Type-specific handling:**
   - **Founder sync or leadership review:** direction → intake feedback; priority changes →
     PENDING decisions with the owner named.
   - **Ops or business review:** record a figure said in the room as
     `operational — unverified` with "as stated in the meeting, YYYY-MM-DD", never as a
     measured value. Record a target said in the room as `target`.
   - **Sprint review or retro:** what went well, what did not, actions; process actions →
     `tasks/todo.md` tagged `process`; harness actions → tagged `harness`.
   - **Customer call or field visit:** record quotes with provenance: role or persona,
     date, translated from the customer's language or not. Map pain points to persona cards
     in `context/personas/` as proposed evidence rows. Do not apply them.
   - **Insurer partner call:** appetite or process changes → PENDING decision, owner per
     `context/06-teams-and-who-does-what.md`; nothing reaches `context/policies/` without a
     LOCKED row.
   - **Call transcripts:** patterns across a batch only; one bad call is not a pattern.
5. **Proposed issues.** For each engineering item: title, one-line outcome, the approved
   PRD or issue pack it would come from — or "needs discovery / PRD first". Hand to
   `/issue-tracker` only after the product lead approves the list.

## Gate

Every item is in exactly one bucket. Every LOCKED decision names its owner role. Every
figure carries a label. You created no issue.

## Output

Append to the notes file if it lives in the repo. Otherwise write
`products/<code>/<feature>/internal/evidence/YYYY-MM-DD-<name>.md` (feature scope),
`initiatives/<name>/research/YYYY-MM-DD-<name>.md` (initiative scope) or
`meetings/YYYY-MM-DD-<name>.md` (workspace scope).

```
## Processed — YYYY-MM-DD
### Decisions — LOCKED (D-nnn / P-nn) · PENDING (D-nnn / P-nn)
### Intake feedback routed (file → entry)
### Todo added
### Proposed issues (NOT created)
| Title | Outcome | Source PRD / pack, or "needs PRD" |
### Ops tasks (owner role)
### Follow-ups (owner role, channel, due)
### Parked — needs the owner's input
```

Then update the files named in each section.

Example, from a Harbor Cover ops review: "the ops lead says field verifiers should fix
`unreadable` on site" → PENDING `D-006`, owner ops lead. "First pass is about 60%" →
`operational — unverified`, as stated in the meeting; the dictionary value for `VER-M1`
stays 61% (`example`). "Add a reason-code filter to the Desk queue" → proposed issue,
"needs PRD".

## Do not

- **Never create tracker issues here.** Propose them.
- Do not record a leaning as a LOCKED decision.
- Do not treat figures said in a meeting as verified.
- Do not create issues for vague items ("we should look into X"). Park them with a question.
- Do not edit `context/` from meeting notes. Route the change to `/decide` or the weekly
  interview.

## Hands off to

`/decide` for PENDING items → `/issue-tracker` for approved proposed issues →
`/product-loop` for new work that surfaced → `/session end`.
