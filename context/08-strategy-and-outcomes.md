---
title: 08 — Strategy and outcomes
type: context
status: active
version: 1.0
supersedes: —
decision_refs: [D-005]
why: Settles the headline metric, the targets, the outcome metric per journey and the themes
last_updated: 2026-11-02
---

# 08 — Strategy and outcomes

> Last verified: 2026-11-02

Every piece of product work names the outcome metric it moves. If it cannot, it is not ready.

## The headline — POL-M1, policies issued per month

| Month | Policies issued | Label |
|---|---|---|
| Jul | 180 | example |
| Aug | 205 | example |
| Sep | 240 | example |
| Oct | 300 | target |

The target is set by the founders. It is not a baseline. Read the latest measured value from
the saved query on the replica (the BI tool mirrors it), never from this file. A `Renewal`
issues a new policy and counts.

## North Star goals

| ID | Goal | Measured by |
|---|---|---|
| G1 | More shops covered, faster | `POL-M1`; `POL-M2` median days from `Quote` to `Policy issued` |
| G2 | A customer never repeats a document | `DOC-M1`, `VER-M1`, `VER-M2` |
| G3 | Every claim acknowledged inside the service level | `CLM-M1` |
| G4 | Referral agents grow the share of issued policies | `REF-M1` |

## Outcome metrics by journey

Values are September readings — a quote-week cohort or the calendar month, as each
dictionary row states — and are invented. Denominators are quoted from the dictionary; the
full definitions live in `metrics-dictionary.csv`.

| ID | Journey | Numerator ÷ denominator (from the dictionary) | Latest | Label | Target | Label |
|---|---|---|---|---|---|---|
| `QUO-M1` | `Quote` → `Eligibility` | cases at stage `Eligibility` ÷ cases created at `Quote` in the cohort week | 58% | example | 65% | target |
| `ELG-M1` | `Eligibility` → `Documents` | cases with a tier at `Documents` ÷ cases quoted in the cohort week that entered `Eligibility` | 71% | example | 75% | target |
| `DOC-M1` | `Documents` | checklist complete at first submission ÷ cases quoted in the cohort week that made a first submission | 54% | example | 70% | target |
| `VER-M1` | `Verification` | first outcome `pass` ÷ cases quoted in the cohort week that entered `Verification` | 61% | example | 75% | target |
| `VER-M2` | `Verification` | median hours from rework raised to resubmitted, per item | 31 hours | example | 18 hours | target |
| `POL-M2` | `Quote` → `Policy issued` | median days from case creation to `Policy issued`, per issued case | 19 days | example | 12 days | target |
| `PAY-M1` | `Placement` | payment completed ÷ cases quoted in the cohort week that entered `Placement` | 64% | example | 70% | target |
| `PLC-M1` | `Placement` | accepted by the first insurer chosen ÷ cases placed in the week | 83% | example | 88% | target |
| `CLM-M1` | `Claim` | claims acknowledged within the service level ÷ claims opened in the month | 92% | example | 98% | target |
| `REF-M1` | Referral | policies issued with a referral agent ÷ policies issued in the month | 22% | example | 30% | target |

Guardrails (`VER-G1`, `REW-G1`, `CAN-G1`) are in the dictionary. A feature that improves an
outcome while a guardrail falls is not a win.

## Themes — why we build

Themes are connected, not ranked. Every feature names at least one.

| Theme | Code | Current priority | What it means here |
|---|---|---|---|
| Customer trust and transparency | `CTT` | high | Premium, cover, exclusions and process shown plainly; status without calls |
| Verification efficiency | `VEF` | top | Fewer rework loops; faster first pass; field capture where it saves a round trip |
| Placement quality | `PLC` | high | The right insurer first time; fewer insurer queries |
| Referral network growth | `REF` | high | Referral agents see status and commission; more policies issued through them |
| Claims experience | `CLM` | medium | Acknowledgement inside the service level; evidence collected once |
| Compliance by design | `CMP` | raised | Regulated actions built in, with evidence records, not bolted on |
| Data foundation | `DAT` | medium | One metric definition; events that exist; traps documented |

## Where commitments live

| Source | Use it for |
|---|---|
| `09-current-commitments.md` | The dated snapshot: what is committed, in build, in UAT, deployed |
| the tracker (team `HBR`) | Live state of every issue; the only source for "is it deployed" |
| `decisions/decision-log.md` | Why something is or is not on the list |

The commitments file is a snapshot. The tracker is live. When they disagree, the tracker is
right and the snapshot gets refreshed.

## Using this in a review

A reviewer asks three questions of any artifact: which outcome metric does it move, is the
target labelled as a target, and which commitment does it serve. "None — new" is an
acceptable answer to the third only with a PENDING decision naming the owner.
