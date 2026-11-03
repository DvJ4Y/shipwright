---
title: "Engineering brief: <feature>"
type: eng-brief
status: draft            # draft | in-review | approved | superseded
version: 0.1
tier: M
owner: <role>
audience: engineering lead
prd: <path> (approved)
aligned_on: —           # set after engineering alignment (YYYY-MM-DD); the issue pack reads this
supersedes: —
decision_refs: []
why: <one line — what engineering can decide once it has read this>
last_updated: YYYY-MM-DD
---

# Engineering brief: <feature>

> WHAT product needs and WHERE it touches the system. Never HOW. No API contracts, schema
> definitions, architecture, component structure, test scenarios, rollout plan, technology
> choice or estimates.

## 1. Capability

<3–5 lines. What is added or changed, for whom, and the outcome it serves.>

## 2. Reuse — what exists

| Existing capability | Where (table / column / event / screen, as a reuse location) | Extended how (product terms) |
|---|---|---|

<Cite the names in `context/05-numbers-data-and-traps.md` and the current-behaviour rows.
Mark each data point existing or new.>

**Configuration** (readiness check 3 — partner- or segment-specific behaviour is configuration):

| Item | Who changes it | Where it is configured today | Existing or new |
|---|---|---|---|

## 3. Invariants — must not break

- <A rule that holds in every state, e.g. "a declined outcome always carries a recovery
  path" or "a provider failure never sets declined".>

## 4. Scenarios

| # | Type (state / failure / integration) | Scenario | Required outcome | Acceptance id |
|---|---|---|---|---|

<Cover EMPTY · PARTIAL · MISSING · RESTRICTED · PROVIDER-FAILED · REWORK where they apply.
Every outcome comes from a PRD rule or a policy row. A scenario with no stated outcome is
written as `open input — owner: <role>` and blocks handover; "engineering to decide" answers
HOW questions only.>

## 5. Dependencies and constraints

| Dependency | Owner | Status | Constraint it adds |
|---|---|---|---|

## 6. Regulated actions and evidence

| Register row | Evidence the product must keep | Where it is visible |
|---|---|---|

## 7. Observability and reconciliation

<What product must be able to see after release: the events, counts or reconciliations that
prove it works. Name the metric IDs.>

## 8. Decisions engineering owns

Schema · APIs · component design · migration · rollout mechanics · test plan · estimates ·
technical task breakdown. <Add any feature-specific decision engineering should make.>

## 9. Open inputs

| Input | Owner (role) | Does a developer need to invent policy without it? |
|---|---|---|

## 10. Anticipated questions

| Question the engineering lead will ask | Product answer, or "engineering to decide" |
|---|---|

<!-- No phase check in the body: a shared file is self-contained. The phase check lives in
chat and in internal/readiness.md. -->
