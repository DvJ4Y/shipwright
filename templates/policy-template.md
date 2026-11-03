---
title: Policy — <name>
type: policy
status: active           # active | proposed | retired
version: 0.1
supersedes: —
decision_refs: []
why: <one line — what this policy settles, so every surface enforces the same rule>
last_updated: YYYY-MM-DD
---

# Policy — <name>

> Last verified: YYYY-MM-DD

**Owner:** <role who proposes and the role who locks>.
**Rule source:** <internal, or the outside rule named generically, e.g. "the insurance
regulator's conduct rules">.
**What the product must do:** <one sentence. The observable behaviour every surface shows
because this policy exists.>

<Every value carries a label. Production configuration is authoritative; this file describes
it. A file edited before production changed is `proposed`, not `active`.>

## Rules

| Condition | Outcome | Label |
|---|---|---|
| <If …> | <then …> | <example / DB-verified <date> / operational — unverified> |

<Rules run in the order listed, unless the table says otherwise.>

## What the user sees

| Outcome | Customer sees | Staff sees |
|---|---|---|

## Evidence kept

<For a policy that touches a regulated action: the evidence record per outcome, and the
register row in `context/regulated-actions.md`.>

## Configuration or code

<Which items are configuration (product and the owner change them) and which are
engineering's. Product documents name the item and the value, never the mechanism.>

## Where to check

| Question | Where |
|---|---|
| Current configured values | <production configuration, via the owner> |
| Outcome counts | <table or view> |
