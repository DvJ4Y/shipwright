---
title: Lessons from running the loop
type: doc
status: active
version: 1.1
supersedes: lessons-from-ten-months.md (v1.0)
decision_refs: []
why: Settles which habits to adopt on day one, before any of them costs a week
last_updated: 2026-11-03
---

# Lessons from running the loop

Read this when you need to decide which habits to adopt on day one, before any of these
costs you a week.

I learned each of these the expensive way: a number I presented as a baseline that was a
target, a status I reported as shipped that was not, a framework I pushed into a system of
record before anyone had tried it on a real case. Eleven rules, each with the reason it
exists. Add your own to `tasks/lessons.md` from the first session; that file is where this
chapter came from.

## Numbers and evidence

**1. Establish the population boundary before computing anything.**
Why: I once computed a rate from a source that held only successful outcomes. Only the
numerator existed. A source like that yields counts, never rates.

**2. A ratio across two sources needs proven containment.**
Why: the result came out near the value I expected, and I took that as confirmation. It was
corroboration, not proof. That is what makes the error hard to catch.

**3. Never present a target as a measured baseline.**
Why: a target and a run-rate are different kinds of number. The label is the only thing
that tells a downstream reader which one they are looking at. I have seen a target quoted
back to me as last month's actual.

**4. Assert the strongest claim level the evidence supports, and no more.**
Why: adding an event makes a behaviour measurable. It does not show that a rate moved. I
wrote "improved" when I had earned "now visible".

**5. If a source cannot be read, say so and stop.**
Why: a number inferred from other files cannot be traced, and it looks identical to one
that can. A 404 is a stop signal, not a reason to improvise.

## Status and vocabulary

**6. Never promote a conversational label into taxonomy.**
Why: a phrase I used once in a chat became a project name, then a milestone, then a
requirement. Nobody decided that. It acquired authority by being written down.

**7. "Done" is not shipped. Give every item one status from production evidence.**
Why: release words mean different things to different people. A status stamp records the
author's state at writing time, not the state now. I reconcile against production, not
against the tracker.

**8. Reconcile against the surfaces that exist, not only the sources in the inputs.**
Why: a surface missing from the inputs reads as an oversight unless the author says why it
is absent. The question "what about the field app?" should never come from the reader.

## Scope and altitude

**9. Match the altitude to the audience.**
Why: a data owner who decides the implementation needs the objective, the cohorts, the cuts
and the cadence. I once sent a specification with joins. It wasted their time and mine.

**10. Depth per feature beats volume per phase. Delegate by feature, not by document.**
Why: frames, acceptance rows and coverage tables can each pass their own check while no
feature has a stated requirement, its connections or an owner. I had a folder of passing
artifacts and not one feature I could restate.

## Product judgement

**11. Validate operational viability before building a framework.** Push nothing
unvalidated into a system of record.
Why: ask who captures this, how long it takes per case, and whether the system can derive
it instead. If it needs a training manual, it is too complex. A framework acquires
authority by existing in the tracker, and reversing it there is expensive.

## The four that matter most on day one

Start with rule 1 (the boundary), rule 3 (a target is not a baseline), rule 7 ("Done" is
not shipped) and rule 11 (viability first). The rest arrive with the first send-back at a
gate, sooner than you expect.
