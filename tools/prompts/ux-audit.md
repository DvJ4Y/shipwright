---
status: active
version: 1.0
supersedes: none
decision_refs: none
why: Audit your own surface against your own standards and personas, not generic heuristics
last_updated: 2026-11-02
---

# Internal UX audit — prompt template

Audit a flow on one of your own surfaces against the pack's standards and your personas. Fill
the surface context once per surface, fill the recording context per recording, paste both
with the audit prompt into a model that accepts video or screenshots, and save the output.

## Placeholders

| Placeholder | Meaning | Example (Harbor Cover) |
|---|---|---|
| `{{surface}}` | the surface under audit | Harbor; Desk; Field |
| `{{surface_type}}` | `customer-facing`, `internal` or `field-and-partner` | customer-facing |
| `{{primary_users}}` | roles or personas who use it | the three customer persona cards; verification officer |
| `{{persona_cards}}` | paste the persona cards, or the path to them | `context/personas/` |
| `{{current_behaviour}}` | the surface's current-behaviour doc | `context/surfaces/harbor/current-behaviour.md` |
| `{{known_issues}}` | issues already logged for this surface | from the surface's open threads |
| `{{success_metrics}}` | the metrics this surface moves, with their labels | `DOC-M1`, `VER-M2` |
| `{{customer_language}}` | the language customers read first | the customer's language |
| `{{regulated_actions}}` | regulated actions this flow touches | identity verification; consent and disclosure |
| `{{sensitive_fields}}` | data that must never show in plain text | identity numbers, phone, payment details, document images |
| `{{flow}}` | the flow being reviewed | document returned for rework |
| `{{research_root}}` | where audits are saved | `research/internal/` |

## Step 1 — surface context (fill once per surface)

```
## Surface context
- Surface: {{surface}} ({{surface_type}})
- Primary users: {{primary_users}}
- Persona cards: {{persona_cards}}
- Current behaviour: {{current_behaviour}}
- Known issues: {{known_issues}}
- Success metrics: {{success_metrics}}
- Language rule: customer-facing copy in {{customer_language}} first; internal screens in English
- Regulated actions in scope: {{regulated_actions}}
- Sensitive fields: {{sensitive_fields}}
```

## Step 2 — recording context (fill per recording)

```
## Recording context
- Flow reviewed: {{flow}}
- What I was checking: [e.g. "what the customer sees when a document is returned"]
- Scenario and persona: [e.g. "the pharmacy persona, drug licence unreadable"]
- Conditions: [optional — slow network, provider timeout, second attempt]
- Known context: [optional — "recording starts after login"]
```

## Step 3 — audit prompt

```
You are a UX researcher auditing one of our own surfaces. This is not a competitor review.
Judge the flow against the standards below and the personas in the Surface context, not
against generic heuristics.

## Approach
1. Read the Surface context and the Recording context first. They are your frame.
2. Separate known issues from new findings. Confirm or deny each known issue with evidence;
   mark anything not on the list NEW.
3. Be specific about impact: which persona, at which step, and what they do instead (call,
   abandon, enter wrong data, ask a colleague).

## Audit standards — reference the number in every finding
1. Dignity. The flow never frames the user as rejected, failed or at fault. Reasons are plain
   and about the document or the rule, not the person.
2. Recovery path. Every declined, rework, error or provider-failed state says what the user
   can do next, through which channel, and what happens then. A dead end is Critical.
3. Customer language first. On a customer-facing surface, every piece of copy exists in
   {{customer_language}} and reads as written, not translated. English-only critical text is
   High.
4. Internal surfaces in English. Internal and field screens ship in English; free-text and
   voice input may be in the operator's language. Mixed-language internal labels are Medium.
5. Every state shown. The six states — EMPTY, PARTIAL, MISSING, RESTRICTED, PROVIDER-FAILED,
   REWORK — are each visible and distinguishable where they can occur. A silent failure or an
   unexplained spinner is Critical.
6. Transparency. Price, terms, status and the next step are stated plainly. Nothing the user
   needs to decide is hidden behind a call.
7. Sensitive data masked. None of {{sensitive_fields}} appears in plain text where it need
   not. Any exposure is Critical.
8. Regulated actions evidenced. Where the flow performs one of {{regulated_actions}}, the
   required consent, disclosure or acknowledgement is present and the user can see it was
   recorded.
9. Ask once. The flow never re-asks what the product already knows about this user or case.

## Output
### 1. Summary
Surface and flow · what was tested · verdict (working / needs improvement / broken / missing) ·
the top finding in one or two sentences

### 2. Walkthrough
| # | Screen or state | What the user does | What the surface does | Standard met or broken (#) | Severity |
Severity: Critical (blocks or exposes) · High (forces a workaround) · Medium (friction) ·
Low (polish).

### 3. Persona impact
For each persona in the Surface context: does the flow work for them; where exactly would
they stop; what would they do instead.

### 4. Known issues — status
| Known issue | Confirmed? | Severity now | Evidence |

### 5. New findings
| Finding | Persona affected | Standard (#) | Severity | What happens | Direction of fix |
"Direction of fix" names the kind of change (copy, state, flow, rule), never the build.

### 6. State coverage
| State | Can occur here? | Shown? | Distinguishable from the others? | Recovery path present? |
One row each for EMPTY, PARTIAL, MISSING, RESTRICTED, PROVIDER-FAILED, REWORK.

### 7. Metric impact
| Metric (with label) | Observed state | Which findings move it | What would improve it |

### 8. Handoff check
Where this flow hands to another surface or to a person: does context carry over; does the
user repeat anything; where is the boundary visible to them.

### 9. What to do first
| Finding | Category (copy fix / missing state / flow change / rule change / needs discovery) | Severity |
No effort estimates. Order by severity, then by how many personas it touches.

## Rules
- Reference personas by their card name and standards by number.
- Quote exact copy, in {{customer_language}} where it appears.
- New findings are worth more than confirmed known issues; spend the words there.
- Every finding carries a persona, a standard number and a severity. No generic remarks.
```

## Cross-surface journey prompt (when the recording crosses a boundary)

```
You are auditing a journey that crosses surfaces: [list, e.g. messaging → {{surface}} →
internal console → field app]. Focus on the boundaries.

### 1. Journey observed
| Step | Surface | What happens | Data captured | Carried forward | Lost or re-asked |
### 2. Each handoff
| From → To | Trigger | What the user experiences | Data continuity | Standard broken (#) | Severity |
### 3. Customer effort
How often the customer repeats information; how many contacts before a clear answer; where
trust or momentum drops.
### 4. Internal effort
Where a person bridges a gap between surfaces by hand. Each is a candidate for the product.
### 5. Opportunities
| Opportunity | Surfaces | Current state | Target state | Standard served (#) |

Rules: judge the journey, not one surface; name every place manual work bridges a gap.
```

## Workflow

1. Fill the Surface context (once) and the Recording context (per recording).
2. Paste both with the audit prompt; attach the recording or screenshots.
3. Save to `{{research_root}}/<surface>/<flow>/audit-NN.md`, screenshots beside it.
4. Bring the file into a product session. New findings become intake; confirmed known issues
   update the surface's open threads.

```
{{research_root}}/
  <surface>/<flow>/audit-01.md
  cross-surface/<from>-to-<to>/audit-01.md
```
