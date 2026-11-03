@AGENTS.md

## Claude Code specifics

**Always-on rules** load from `.claude/rules/`: the constitution and the writing standard.
Path-scoped rules load for mockups (`**/*.mockup.html`), PRDs (`**/prd.md`) and query files
(`**/*.sql`, `tools/query/**`, the metrics dictionary).

**Hooks** (`.claude/settings.json` → `.agents/hooks/`): the SessionStart hook injects your
profile, the handoff head, the top todo items, open PENDING decision points and PRDs at
`shipped` not yet landed. The Stop hook asks once for a handoff if artifacts changed and
`sessions/latest.md` did not. The PreToolUse guard denies edits to generated files, the
ones whose head carries the marker `scripts/build-plugin.sh` writes into `plugin/`. It asks
before any write under an `archive/` folder.

**Permissions** apply after you accept the trust dialog on the first interactive run.
Personal rules go in `.claude/settings.local.json`; never put a secret in a rule.

**Skills** resolve through `.claude/skills` → `.agents/skills`. If `/skills` shows nothing, run
`bash scripts/link-harness.sh` (or `--copy` on Windows). Reviewers load from `.claude/agents/`.

**Plugin.** If the `shipwright` plugin is installed in this project, do not also keep
the hooks in `.claude/settings.json`; they would run twice. One route per repo.

**MCP.** `.mcp.json` declares `tracker` and `analytics`. Run `/mcp` once per machine.

**Memory.** The project memory directory holds one fact per file with `MEMORY.md` as the
index (`.agents/skills/session/references/memory.md`). Never store there what the repo
records.

## When compacting, preserve

- The active artifact path, its tier and its phase.
- Open decision points (`P-nn`) and open `[NEEDS CLARIFICATION]` markers.
- The list of files modified this session.
- The last gate result and the next action.
