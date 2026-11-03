# Contributing

Thank you for reading this far. The pack improves fastest from reports of what broke on a
real feature, so an issue is as welcome as a pull request.

## Before anything else

Run the loop on one real piece of work. `/onboard`, then `/product-loop` on something you
would have done by hand this week. Note what the agent invented, which gate let something
through, and which file you had to read twice. That is the raw material for an issue.

## Issues

Three templates. Pick the one that fits.

| Template | Use it when |
|---|---|
| Something broke | A skill, reviewer, hook, script or document did not do what the docs say |
| Propose a change | You want a skill, rule, template, doc or context file to behave differently |
| We ran the loop | You ran a feature end to end and want to report what happened |

An issue about a skill names the skill and quotes the prompt you gave. An issue about a
document names the file and the sentence. Never paste your company's data, names or
vendor contracts into an issue; describe the shape of the problem instead.

## Pull requests

One change per pull request: one skill, one rule, one template, one document, or one
coherent fix across the files that one change touches. A pull request that improves three
unrelated things is three pull requests.

Before you open it:

1. `bash scripts/check-pack.sh` reports nothing. The check runs on every commit if you
   install `scripts/pre-commit.example`.
2. If you changed a skill, a reviewer agent, a hook or `.mcp.json`: `bash scripts/build-plugin.sh`,
   then `claude plugin validate plugin/`, and commit `plugin/` with the change.
3. If you changed a skill's description or its trigger words: `bash evals/run-triggers.sh`
   for that skill. The bar is in `evals/README.md`.
4. If you changed a template: update the filled example beside it in the worked feature
   or in `context/`, so the two still agree.
5. If you changed a rule or a convention: say in the pull request which decision it
   changes and why. Maintainers log it in the decision record.

Write the way the pack writes: lead with the decision or the ask, one idea per sentence,
active voice, tables over prose, a rule and a limitation as two sentences. The standard is
`.claude/rules/writing-standard.md`. Every number carries one of the five source labels.
Roles, not person names. Capability names, not vendor names, outside the two tracker
adapters and the query tool.

Commit messages follow the existing log: `feat:`, `fix:`, `docs:`, `chore:`, then what
changed, in one line.

## What a contribution must not add

- A real company's data, figures, names, screenshots or vendor list. Harbor Cover is
  fiction, and the pack stays that way.
- Engineering design: API contracts, schemas, architecture, estimates. Product writes WHAT
  and WHY; engineering writes HOW.
- A second way to do something the pack already does one way. One template per artifact,
  one source per fact, one skill per job. Replace, do not add beside.
- Anything a reader cannot run without an account on a specific vendor. Adapters are the
  one place a vendor is named.

## Contributions that would help most

- A tracker adapter beyond the two shipped, in `.agents/skills/issue-tracker/references/adapters/`.
- A language pack for `/localisation-copy`, from the template in its `references/` folder.
- A second worked example in a different domain, run through the whole loop, including the
  land rehearsal.
- Eval prompts that catch a mis-route you hit.
- A verified run on Codex, Linux or Windows, with what differed.

## Where things live

`docs/01-folder-structure.md` says who writes each folder and which folders are generated.
Never hand-edit `plugin/`; the guard hook denies it. Decisions about the pack are recorded
in `decisions/decision-log.md` by the maintainers; propose, do not edit.

## Licence

MIT. By contributing you agree that your contribution is licensed under the same terms.
