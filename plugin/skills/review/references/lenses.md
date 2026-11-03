# Review lenses — what each one checks

Each lens returns its findings in one table. No prose essay.

```
Lens: <name> · Artifact: <path> (version x.y) · Missing inputs: <files it could not read, or none>
| # | Grade | Location (file#section) | Finding | Suggested fix |
```

Grades: Critical · Major · Minor · Outdated (defined in the review skill). A lens with nothing to report returns one line: "No findings." A lens that could not read a file it needs names the file under "Missing inputs" and does not guess its contents.

---

## Strategy — `business-reviewer`

Sources: `context/08-strategy-and-outcomes.md`, `context/09-current-commitments.md`, `context/metrics-dictionary.csv`, `decisions/decision-log.md`.

1. **Outcome.** Does the artifact name a metric id from the dictionary? Is the path from this change to that metric stated, or only implied?
2. **Target.** Is every target labelled `target`? Is any baseline a measured reading with its own label?
3. **Commitment.** Which row in `context/09-current-commitments.md` does this serve? If none, is it declared new work with a PENDING decision naming the owner?
4. **Drift.** Has scope moved away from the outcome since discovery? Compare with the approved discovery and the decision log.
5. **Skeptic.** What is the strongest reason not to do this now? Were "do nothing" and "extend what exists" (a current-behaviour row) considered?
6. **Ops cost.** Does the plan add support agent, verification officer or field verifier time without saying so?
7. **Guardrail.** Is the guardrail from the dictionary named beside the outcome?
8. **Red-team mode.** Ranked kill-assumptions with the cheapest test each; pre-mortem.

## Customer — `customer-voice`

Sources: `context/personas/`, `context/01-company.md`, `context/02-service-and-lifecycle.md`, `context/design/voice.md`.

1. **Persona fit.** Which persona card is served? Does the flow work for the hardest case — low document readiness, the longest checklist for the shop type, a customer who uses WhatsApp only?
2. **Dignity.** The customer is never framed as rejected by an insurer or a provider. No blame. Plain reasons.
3. **Recovery.** Every declined, rework or provider-failed outcome carries a recovery path: update a document, upload a different identity proof, book a field visit, talk to a verification officer.
4. **Customer language first.** The author designs customer-facing text in the customer's language, allows for text expansion, and names a native reviewer when `_language_review: no`.
5. **Channel and literacy.** The flow fits the persona's channel, language and digital fluency from the card.
6. **Evidence.** Every claim cites a persona-card evidence row (`E<n>`) or the lens abstains. The lens labels persona-based findings **SYNTHETIC** and phrases them as questions to test.

## Engineering-readiness — `engineering-readiness-reviewer`

Sources: `.claude/rules/constitution.md`, `templates/readiness-record-template.md`, `context/03-surfaces-and-systems.md`, `context/surfaces/<surface>/current-behaviour.md`.

1. **Boundary.** Any API, schema, architecture, component, test, rollout, technology or estimate content? Each instance is Critical.
2. **Invariants.** Stated, and true in every state?
3. **States.** EMPTY, PARTIAL, MISSING, RESTRICTED, PROVIDER-FAILED and REWORK all covered where they can occur?
4. **Policy gaps.** Would a developer have to invent a business rule, a threshold or a message? Critical.
5. **Reuse.** Existing behaviour cited by current-behaviour row id; data points marked existing or new with a real location. Guessed names are Major.
6. **Traceability.** Every issue maps to an acceptance criterion; every acceptance criterion maps to a use case.
7. **Agreement.** PRD, mockups, brief and issue pack describe the same flow and the same states.
8. **Understanding.** Holding only the artifact, restate each feature, what it changes in each layer, and the three questions the engineering lead would ask. Unanswerable questions are findings.

## Data — `data-reviewer`

Sources: `context/05-numbers-data-and-traps.md`, `context/metrics-dictionary.csv` and `.md`, `tools/query/sources.md`.

1. **Population boundary** stated before every rate? Any rate from a survivors-only source (`h_policy`, closed rework items)?
2. **Authority and label.** Funnel and impact figures from the BI tool? No replica rate headlined? Each figure carries the label `tools/query/sources.md` assigns its source; the five labels are defined in `.claude/rules/writing-standard.md` rule 8.
3. **Labels.** Every number carries one of the five source labels.
4. **Target vs baseline.** Any target presented as a measurement? Critical.
5. **Claim level.** Is the claim stronger than the evidence? Timing alone never supports causal impact.
6. **Containment.** Cross-source ratios only with proven containment on shared case ids.
7. **Metric contract.** Metric ids exist in the dictionary; numerator, denominator, cohort anchor and maturity match the row.
8. **Traps.** The three traps in `context/05-numbers-data-and-traps.md` avoided? Zero-row results questioned before being reported?
9. **Events.** Every event named exists in `context/05-numbers-data-and-traps.md`, or is marked **new** with a `Planned` QA row.

## Writing — `writing-reviewer`

Sources: `.claude/rules/writing-standard.md`, `context/07-glossary.md`, `context/design/voice.md`.

1. **Opening.** Does the first sentence state the decision or the ask?
2. **One idea per sentence.** Flag sentences carrying two ideas or over about 25 words.
3. **Terms.** Glossary terms only; no synonym for the same concept; exact production stage names.
4. **Voice.** Active voice; no filler, hedging or buzzwords.
5. **Rules vs limitations** in separate sentences.
6. **Names.** Capability names, not vendor names. Roles, not person names. "The product lead", never a bare "lead".
7. **Facts, not history.** No "we got this wrong before" framing.
8. **Labels.** Every number carries a source label; a missing label is a finding, not a fix.

## Compliance — `compliance-reviewer`

Runs only when `_profile.md` has `_regulated: yes`. Sources: `context/regulated-actions.md`, `context/policies/`, `context/policies/data-handling-and-retention.md`, the PRD's "Regulated actions touched" list and its §7 information table.

1. **Register match.** The artifact names every regulated action it touches against the register. No register row the flow passes through is missing from the list.
2. **Evidence kept.** For each action touched, the artifact states the evidence the register requires as an outcome and plans a `P0` QA row for it.
3. **Consent and disclosure.** Consent and disclosure wording is present, plain, and in the customer's language. The flow asks the customer for nothing without consent.
4. **Retention.** The artifact states the retention period and the deletion record for every record the feature creates.
5. **Cancellation, complaint and cooling-off.** The paths exist where the flow reaches `Policy issued`, a complaint or a cancellation request, and they are reachable on the customer's channel.
6. **Recovery on every declined, rework or provider-failed outcome.** Each of these outcomes carries a recovery path. A provider failure never declines.
7. **No regulated behaviour left to a developer.** Nothing in the artifact asks engineering to decide a regulated behaviour — a wording, a period, a masking rule, an evidence field. Critical.
