GENERATED — do not hand-edit

# shipwright plugin 0.1.1

This directory is built by `scripts/build-plugin.sh`. Edit the sources, then rerun the script.

| In plugin/ | Source |
| --- | --- |
| `skills/` | `.agents/skills/` |
| `agents/` | `.claude/agents/*.md` |
| `hooks/*.py` | `.agents/hooks/` |
| `hooks/hooks.json` | the hooks block in `scripts/build-plugin.sh` |
| `.mcp.json` | `.mcp.json` at the repo root, when present |
| `.claude-plugin/plugin.json` | Claude Code manifest, written by the script |
| `.codex-plugin/plugin.json` | Codex compatibility manifest, written by the script |
| `.claude-plugin/icon.png` | `assets/icon.png`, rendered from `assets/icon.svg` |

Install for Claude Code from the repo root: `claude plugin marketplace add .` then
`claude plugin install shipwright@shipwright`. For Codex, the marketplace is `.agents/plugins/marketplace.json`.
