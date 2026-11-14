# Profile adaptation — how `knowledge/PROFILE.md` changes the harness

Every skill reads `knowledge/PROFILE.md` at the start, then the current rows in
`knowledge/facts.md`. Never ask for what either file holds. This table says what each field changes.

| Field | Effect |
|---|---|
| `_role` | Who the reader is: `product-lead`, `designer` or `founder`; sets the default voice of outputs |
| `_lane` | `customer` or `ops-platform`; default lane and default reviewers |
| `_focus` | The surfaces and outcomes in scope this quarter; the first place intake looks for fit |
| `_experience: new` | Add one line of "why this step" at each step |
| `_experience: practised` | No explanations |
| `_default_tier` | Starting tier when intake is ambiguous |
| `_tools_access` | Which sources `/data-analysis` may query; otherwise it writes an export request |
| `_tracker` | Names the tracker adapter `/issue-tracker` loads (`references/adapters/` in that skill) |
| `_language` | The working language of the documents; `/localisation-copy` picks the matching language pack |
| `_customer_language` | Language-pack code for customer copy (`references/language-packs/<code>/` in `/localisation-copy`), or `none` |
| `_memory_dir` | Where the agent keeps memory facts; `default` = the agent's own project memory (Claude Code), else a folder the reader names (Codex) |
| `_regulated: yes` | Intake reads `context/regulated-actions.md`; every gate checks it; `/review` adds the compliance lens |
| `_regulated: no` | The default. No register check and no compliance lens |
| Workstream codes | Your own surface codes, set by `/setup`; they resolve paths through the code table in `references/conventions.md` |
| `_language_review: no` | `/product-copy` flags every customer-language string for a native reviewer |
| `_workstyle` | Match the presentation (options first, short answers, tables) |
| `_struggles` | In those areas: one line of "why", an extra check, an offer to explain, even if `practised` |
| `_gate_owner` | The role that approves gates |
| § My words → our terms | Use the reader's words in chat; glossary terms (`context/07-glossary.md`) in documents |

If `knowledge/PROFILE.md` is missing, use `practised`, tier M, `_regulated: no`, and suggest `/setup` once.
