# Privacy

Shipwright collects nothing. There is no telemetry, no analytics call and no server run by
the maintainers.

| Part | What it does with data |
|---|---|
| Skills, rules, reviewer agents | Text instructions your agent reads. They send nothing anywhere on their own |
| Hooks (`.agents/hooks/*.py`) | Run on your machine with the Python standard library. They read files in your workspace and print to your agent session. They make no network call |
| Scripts and tools (`scripts/`, `tools/`, `automations/`) | Run on your machine. The SQL runner connects only to the query endpoint you configure in your environment |
| MCP servers (`.mcp.json`: `tracker`, `analytics`) | Connect only to the services you configure and authorise. What they receive is governed by those services' own terms |
| Your agent runtime | Your prompts and the files your agent reads go to the model provider you use, under that provider's terms |

Do not put secrets in the repository or in permission rules. Keep keys in your environment;
`.gitignore` excludes `.env` files and personal settings.

Questions: open an issue at <https://github.com/DvJ4Y/shipwright/issues>.
