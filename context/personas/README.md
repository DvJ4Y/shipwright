---
title: Persona cards — index and evidence codes
type: context-index
status: active
version: 1.0
supersedes: —
decision_refs: []
why: Grounds every persona-panel critique in cited evidence rather than opinion
last_updated: 2026-11-02
---

# Persona cards

> Last verified: 2026-11-02

Every claim on a card cites an evidence row (`E1`, `E2`, …) from that card's own table, or
sits under "What we don't know". Panel output built from these cards is labelled SYNTHETIC
and becomes questions for real research, never validation.

All evidence in this pack is fictional and labelled `example`.

## Customer personas

| Card | Shop | Status |
|---|---|---|
| `customer-meera.md` | Small grocery; first policy | evidence-backed |
| `customer-arjun.md` | Electronics retail; three outlets; prior claim | evidence-backed |
| `customer-priya.md` | Pharmacy; strict document needs | evidence-backed |

Segment shares are not measured. Do not quote a split.

## Internal roles and partners

| Card | Role | Kind | Status |
|---|---|---|---|
| `role-support-agent.md` | Support agent — first contact, quote data | internal-role | evidence-backed |
| `role-verification-officer.md` | Verification officer — identity, documents, rules, rework | internal-role | evidence-backed |
| `role-placement-specialist.md` | Placement specialist — insurer choice and queries | internal-role | thin |
| `role-field-verifier.md` | Field verifier — inspection and replacement capture | internal-role | evidence-backed |
| `role-compliance-officer.md` | Compliance officer — regulated actions and complaints | internal-role | thin |
| `role-referral-agent.md` | Referral agent — brings customers, tracks status | partner | evidence-backed |
| `role-insurer-partner.md` | Insurer partner — carries the risk, issues the policy | partner | thin |

Claims handler and ops lead have no card yet. Their jobs are stated in
`../06-teams-and-who-does-what.md`.

## Evidence source codes

| Code | Source | Date | Sample | Label |
|---|---|---|---|---|
| `QA` | Quote-funnel analytics, Harbor | Sep 2026 | September cohort | example |
| `CI` | Customer interviews, in person and by call | Aug–Sep 2026 | 12 customers: grocery (5), electronics retail (4), pharmacy (3) | example |
| `SR` | Support call review | Sep 2026 | 40 recordings | example |
| `OI` | Ops interviews | Sep 2026 | 9 staff: support agents (2), verification officers (3), placement specialist (1), field verifiers (2), compliance officer (1) | example |
| `FV` | Field visit shadowing | Sep 2026 | 6 inspections in 2 regions | example |
| `RA` | Referral agent survey | Sep 2026 | 38 responses | example |
| `PR` | Insurer partner review calls | Sep 2026 | 4 of 6 partners | example |
| `DB` | SQL replica pulls | Sep 2026 | September cases | example |

## Keeping cards honest

- A claim with no `E` row moves to "What we don't know".
- A quote carries its source row and whether it was translated.
- When new research lands, add rows; do not overwrite old ones. Raise `status` from `thin`
  to `evidence-backed` only when two independent sources agree.
- Update `Last verified` only after re-reading the card against the evidence.
