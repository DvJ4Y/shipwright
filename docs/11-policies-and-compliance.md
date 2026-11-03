---
title: 11 — Policies and compliance
type: doc
status: active
version: 1.0
supersedes: —
decision_refs: []
why: Settles how an internal rule or an external obligation enters a feature, and who decides it
last_updated: 2026-11-02
---

# 11 — Policies and compliance

Read this when you need to decide how an internal rule or an external obligation enters a
feature, and who decides it.

## Internal policies are durable context

An internal policy is a rule the company sets for itself. A regulated action is a rule set
from outside. Keep them apart.

Policies live in `context/policies/`, one file per policy. `templates/policy-template.md`
is the shape. Every policy file has:

- a condition → outcome table;
- an owner role;
- a `Last verified` line;
- a rule source;
- one line that says what the product must do.

The fictional set:

| File | Settles | Proposes | Locks |
|---|---|---|---|
| `context/policies/eligibility-rules.md` | Shop type × sum-insured band → risk tier; the hard rules; recovery paths | The ops lead | The product lead |
| `context/policies/document-checklist.md` | The documents per product and shop type; what makes a submission complete | The ops lead | The ops lead |
| `context/policies/risk-tiers-and-routing.md` | What each tier means for routing | The ops lead | The ops lead |
| `context/policies/service-levels.md` | Time commitments per queue; hold and lapse rules | The ops lead | The ops lead |
| `context/policies/data-handling-and-retention.md` | Who may see what; how long records are kept; what is masked | The compliance officer | The compliance officer |

Production configuration is authoritative. A policy file describes it, and its owner
refreshes it from production. A file edited before production changed is a plan: mark the
row `proposed` until production matches.

**How a policy changes.**

| Step | Who | Does |
|---|---|---|
| 1 | The role in the Proposes column | Proposes the change, with the reason and the metric it should move |
| 2 | The product lead | Logs it PENDING in `decisions/decision-log.md`, with its blast radius: which surfaces, which messages, which QA rows |
| 3 | The role in the Locks column | Locks it |
| 4 | The ops lead, or engineering where the value is code | Changes the configuration in production |
| 5 | The owner | Refreshes the policy file from production and moves `Last verified` |

A PRD cites a policy value by file and row; it never restates the number. The brief's
configuration table names who changes it and where it is configured today. `/land` sends a
rule requirement to the policy file it names, not to a surface table.

## The regulated-actions register

`context/regulated-actions.md` names every action an outside rule governs. The compliance
officer owns it, holds the exact references, and names each rule source generically.

| Column | Holds |
|---|---|
| Action | One row per action. The fictional set: identity verification, consent and disclosure, cooling-off and cancellation, claim acknowledgement, complaint handling, record retention |
| Rule source | The regulator's rules, named generically |
| What the product must do | The obligation, as behaviour |
| Evidence kept | The evidence record: reference, result, time, role; consent text version, channel, language |
| Surfaces | Where the action is visible |

The register covers the regulated distributor's obligations only. The insurer's
obligations are the insurer's. Tax and invoicing belong to finance.

## How a feature uses the register

| Step | What happens |
|---|---|
| Intake | A touched row escalates the tier. `/decide` treats a regulated action as a one-way door |
| Discovery | Names the rows the idea touches. One line each |
| PRD | A labelled line closing the "Information, permissions and audit" section: **Regulated actions touched:** the register rows, or "none". The section's table names the evidence per row |
| Brief | Section 6 lists the evidence record per row as a required outcome, not a mechanism |
| QA | One `P0` row per evidence record the feature creates |
| Land | The current-behaviour row carries the suffix "— regulated action: <register row>" |

**The line is a list, not a gate.** Naming a regulated action does not block the feature
and does not summon the compliance officer. It records that a regulated action exists, so
the author plans the evidence with the feature, not after it. The product lead decides
whether to involve the compliance officer. The agent does not block on compliance, and does
not draft questions for the compliance officer, unless asked.

## The compliance lens is opt-in

`_profile.md` carries `_regulated: yes | no`. With `no`, the review report carries one line:
"Compliance lens not run." With `yes`:

| Where | What changes |
|---|---|
| Intake | Reads the register; a touched row escalates the tier |
| Every gate | Checks the register |
| Readiness check 4 | Names each action touched and its evidence |
| `/review` | Adds a sixth lens, `compliance-reviewer` |

The dispatch decision lives in `/review`; the agent does not gate itself. The lens reads
the register, or it does not run. Its seven checks, from
`.agents/skills/review/references/lenses.md`:

1. Every touched action is named against the register.
2. The evidence is stated as an outcome, with a `P0` QA row planned.
3. Consent and disclosure wording is plain and in the customer's language.
4. Retention and the deletion record are stated.
5. Cancellation, complaint and cooling-off paths exist where the flow reaches them.
6. Every declined, rework or provider-failed outcome carries a recovery path. A provider
   failure never declines.
7. Nothing regulated is left to a developer to decide. This one is Critical.

## Evidence is a WHAT

The brief states what evidence the product must keep and where it is visible. It never
states the table, the log format or the mechanism. "Keep the provider response reference,
the result, the time and the officer role, visible in the audit view" is an outcome. A
column list is engineering's.

## Dignity is a rule, not a tone

Customer-facing surfaces never frame the customer as rejected by an insurer or a provider.
Every `declined`, `rework` or provider-failed outcome carries a recovery path. A decline
with no recovery path is a defect. The writing and compliance reviewers grade a breach
Critical.

## What the register is not

Not legal advice. Not a substitute for the compliance officer's references. Not a list of
everything regulated in the business; only the actions a product surface performs.
