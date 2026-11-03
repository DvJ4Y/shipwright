## What this changes

<!-- One change. Which skill, rule, template, document or context file, and what it does differently. -->

## Why

<!-- The decision it unblocks, or the run where the current behaviour cost something. Link the issue if there is one. -->

## Checks

- [ ] `bash scripts/check-pack.sh` reports nothing
- [ ] Skills, agents, hooks or `.mcp.json` changed → `bash scripts/build-plugin.sh` run, `claude plugin validate plugin/` passed, `plugin/` committed
- [ ] A skill's description or trigger words changed → `bash evals/run-triggers.sh` run for that skill
- [ ] A template changed → the filled example beside it updated
- [ ] A rule or convention changed → the decision it changes is named above
- [ ] No company data, person names, vendor names outside the adapters, or engineering design
- [ ] Every number carries a source label
