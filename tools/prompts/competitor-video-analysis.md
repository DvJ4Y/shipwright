---
status: active
version: 1.0
supersedes: none
decision_refs: none
why: Turn a messy screen recording of another product into findings a product team can act on
last_updated: 2026-11-02
---

# Competitor recording analysis — two prompts

Record a competitor's flow, fill the context block, paste it with one of the two prompts into
a model that accepts video or screenshots, and save the output. Prompt 1 is the default and
handles messy, non-linear recordings. Prompt 2 is for a clean start-to-finish walkthrough.

## Placeholders — fill these once per team, then reuse

| Placeholder | Meaning | Example |
|---|---|---|
| `{{category}}` | the product category you compete in | small-business insurance; payroll software; home-services booking |
| `{{your_product}}` | your own product's name, for the comparison line | Harbor |
| `{{decision_moment}}` | the point where the product tells the user yes, no or a price | eligibility result; quote; approval; match |
| `{{key_inputs}}` | the data points your own flow collects before the decision moment | shop type, sum insured, address, licence number |
| `{{identity_step}}` | what identity or ownership proof the category asks for | identity document; business registration; phone verification |
| `{{hidden_terms}}` | terms users care about that products tend to hide | exclusions, waiting periods, fees, renewal price |
| `{{user_types}}` | the user segmentations your category branches on | first-time buyer, multi-outlet owner, regulated trade |
| `{{product_variants}}` | the product variations a flow may branch into | shop, stock, liability, staff health |
| `{{customer_language}}` | the language your customers read first | the customer's language |
| `{{research_root}}` | where analyses are saved | `research/competitors/` |

## Recording context (fill per file, paste before the prompt)

```
## Recording context
- Product recorded: [name]
- Platform: [mobile web / desktop web / Android / iOS]
- Recording type: [end-to-end journey / scenario test / edge case / feature deep-dive / error handling / comparison run]
- What I was trying to do: [one or two sentences]
- What I was testing specifically: [optional — e.g. "entered an invalid {{identity_step}} to see validation"]
- Data I used: [optional — the persona or inputs]
- Known context: [optional — "third recording of this product; earlier ones covered the happy path"]
```

## Prompt 1 — exploratory analysis (default)

```
You are a UX researcher analysing screen recordings and screenshots of {{category}} products.
These recordings are exploratory research, not clean demos. They may be non-linear, repeat
steps, test edge cases or cover one sub-flow.

## Approach
1. Read the Recording context first. It says what the researcher was investigating. Prioritise
   findings about that.
2. Reconstruct what happened, even when non-linear. Note where the user went back, retried or
   explored an alternative.
3. Separate the product's behaviour from the researcher's exploration. Deliberate invalid input
   is a test of the product's response, not a product fault.
4. Extract the signal that is there. A thirty-second clip of one error state is enough for a
   finding. Do not pad.

## Output — skip any section the recording does not support
### 1. Summary
- Product and flow explored · what was tested · the finding in one or two sentences

### 2. Flow reconstruction
| # | Position | Screen or state | What the user did | What the product did | Notable |
Mark deliberate test inputs as [TEST: …]. Show both paths when the researcher branched.

### 3. Scenario-specific findings
- Branching: what input triggered it; how the UI adapted; what was carried forward vs re-asked.
- Error or edge case: the input; the response (inline, modal, redirect, silent); the recovery
  path; whether state survived.
- Feature deep-dive: mechanics step by step; layout and interactions; exact copy.
- Comparison run: what changed between runs; where the product personalises vs stays generic.

### 4. Screens that matter
| Screen | Fields and components | Behaviour | Copy (exact text) |
Include field types, defaults, validation observed, conditional fields, loading and empty
states, help text and trust signals.

### 5. Patterns and anti-patterns
| Pattern | Category (trust / flow / error handling / education / personalisation / accessibility) | Good or bad | Detail |

### 6. {{category}} deep dive — fill regardless of recording type
- Data collection map: every data point collected, type, mandatory or optional, and whether
  it is asked before or after the user gets any value. Compare with {{key_inputs}}: what do
  they ask that {{your_product}} does not, and the reverse?
- Decision moment: where does {{decision_moment}} happen? Does everyone pass (lead capture)
  or does the product filter? Any real-time check visible (spinner after an input, instant
  result, conditional UI)?
- Outcome transparency: what does the user learn about price, terms and next steps? Generic
  or personalised? Which of {{hidden_terms}} are shown, and which are hidden?
- Identity and consent: when does {{identity_step}} happen and why there? What consent is
  asked, in what words, and can the user proceed without it? Is an account created? How is a
  returning user recognised?
- Saying no: when the product declines or defers, what words does it use, and is there a path
  forward (alternative product, a person to contact, a retry)?
- Branching: how many of {{user_types}} and {{product_variants}} are visible, and what
  changes per branch?

### 7. Raw observations and questions
Things that seemed intentional but unexplained; inconsistencies; what to test next;
accessibility and {{customer_language}} observations.

## Rules
- Quote exact UI copy. Reference positions in the recording.
- Write [UNCLEAR] rather than guess.
- A focused 200 words on the interaction tested beats 1,000 generic words.
- Deliver findings about what the Recording context says was being tested.
- When several recordings cover one product, say how this one connects to the others.
```

## Prompt 2 — end-to-end walkthrough (clean recordings only)

```
You are a UX researcher analysing a complete screen recording of a {{category}} journey.
Capture every distinct screen or state, including modals, tooltips, loading and error states.

### 1. Journey metadata
Product · journey type · platform · languages available · steps to complete · time to complete

### 2. Screen by screen
| # | Screen | Purpose | Inputs and actions | Validation and errors | Trust and transparency | Friction | Smart patterns |
Inputs: every field, button, toggle and upload with type, placeholder and default. Trust:
progress, security cues, "why we ask" text, price or term transparency. Friction: anything that
could cause drop-off. Smart patterns: prefill, smart defaults, conditional fields, skip, save
and resume, contextual help.

### 3. Information architecture
What is collected at each stage; the sequencing logic; branches by {{user_types}} or
{{product_variants}}; what can be skipped or deferred.

### 4. Copy and messaging
Headlines and calls to action (exact text); how the value is explained; tone; which languages
appear and whether {{customer_language}} is first or a translation; how complex terms are
explained.

### 5. Data collection inventory
| # | Data point | Type | Mandatory | Screen | Early, mid or late | Likely purpose |
Then: what is captured before the likely drop-off points; what is deferred to a later stage or
a person; the minimum data to finish; how this compares with {{key_inputs}}.

### 6. {{decision_moment}} and outcome
Does everyone pass, or does the product filter? Where does the user get a decision or price?
Is it personalised? Which of {{hidden_terms}} are shown? When the answer is no or not yet,
what words are used and what path forward is offered?

### 7. Identity, consent and account
When {{identity_step}} happens and why there; consent asked, in what words, and whether it is
optional; whether an account is created; how a returning user is recognised.

### 8. Drop-off and resume
Likely drop-off screens; save and resume; what the product knows about the user before each
drop-off; re-engagement signals; behaviour on back navigation and timeout.

### 9. Five things done well · 10. Five gaps
Each with a screen reference.

Quote exact copy. Reference screen numbers. Write [UNCLEAR] rather than guess.
```

## Workflow

1. Record what you are exploring. Neatness does not matter.
2. Fill the Recording context (about thirty seconds).
3. Paste context plus Prompt 1 or 2 into the model; attach the recording or screenshots.
4. Save the output to `{{research_root}}/<product>/<topic>/analysis-NN.md` and key frames to
   `screenshots/` beside it.
5. Bring the file into a product session for the comparison with `{{your_product}}`.

```
{{research_root}}/<product>/
  context.md                 ← what you know about this product overall
  journey-main/              ← Prompt 2 output and screenshots
  scenario-<topic>/          ← Prompt 1 outputs, one file per recording
  edge-cases/
```
