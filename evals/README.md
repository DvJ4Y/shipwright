# Evals — does the harness route and shape work correctly?

Two files test the pack: `trigger-prompts.csv` tests routing, `golden.md` tests shape.

## Run the trigger evals

```bash
bash evals/run-triggers.sh                 # all rows; writes evals/results-<date>.csv (gitignored)
bash evals/run-triggers.sh --limit 10      # the first ten rows
bash evals/run-triggers.sh --ids T50,T53   # only these rows — re-run misses after an edit
bash evals/run-triggers.sh --model <name>  # a specific model
```

Each row runs as a fresh headless session with one turn and no write tools, from the repo
root, so the session sees the project's own skills. The runner records the first `Skill` tool
call and compares it with `expected_skill`. A row that expects `none` passes when no skill
fires: `session` and `onboard` are user-invoked (`disable-model-invocation: true`), so a
prompt in their words must not make the model invoke them.

The set covers all sixteen skills with at least two prompts each, five for `land`, three that
name a regulated action and expect `review` or `prd-writer`, and two `issue-tracker` release
prompts. Every prompt is in Harbor Cover terms and carries no vendor name and no person name.

**The bar is 90%.** The runner prints the per-skill tally and the overall rate. A run with
errors or timeouts counts those rows as failures; re-run them with `--ids` before judging.

## How to read a miss

A miss means the skill description did not win the routing, or another description won it.

1. Read the `fired` column. If another pack skill fired, the two descriptions overlap on the
   prompt's words; tighten the one that should have won and, where the overlap is real, move
   the phrase out of the other. If nothing fired, the description lacks the words people use.
2. **Tighten the description, never the prompt.** The prompts are the test; they say what a
   product lead says. A prompt rewritten to match a description proves nothing.
3. Edit the skill's `description:` in `.agents/skills/<name>/SKILL.md`, rebuild the plugin
   (`bash scripts/build-plugin.sh`), and re-run the missed rows with `--ids`.
4. Two misses on the same skill in one run point at the description; one miss on a prompt
   that passed before is noise — re-run it once before editing anything.

Add a prompt when a real request routed wrongly in daily use: copy the wording, set the
skill that should have fired, and keep the id sequence.

## Golden shapes

`golden.md` shows the intake verdict block, a PRD acceptance row, a brief scenario row, the
review findings table and the landing table for the worked feature. Judge an output by those
shapes: the must-have and must-not-have lines under each.

## Cost

A full run is about sixty headless sessions. Run it after editing any skill description,
`AGENTS.md` routing table or `CLAUDE.md`, and before a release; not on every commit.
