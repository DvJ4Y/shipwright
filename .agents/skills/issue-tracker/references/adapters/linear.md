# Adapter — Linear

Loaded when `_profile.md` has `_tracker: linear`. This file may name Linear; every other skill file says "the tracker".

## Connect

The repo's `.mcp.json` defines the server under the key `tracker` and runs it through `mcp-remote` against `https://mcp.linear.app/mcp`. Run `/mcp` once per machine to sign in. Without the repo file:

| Client | Command |
|---|---|
| Claude Code | `claude mcp add --transport http tracker https://mcp.linear.app/mcp`, then `/mcp` to sign in |
| Codex | `codex mcp add tracker --url https://mcp.linear.app/mcp` (needs `experimental_use_rmcp_client = true` under `[features]` in `~/.codex/config.toml`) |
| Read-only | `https://mcp.linear.app/mcp/readonly`, or request only the `read` scope |

Keep the server key `tracker`. The tool names below carry it as their prefix. `.claude/settings.json` allows reads under that prefix and asks before writes.

## Keys

| Key | Where it is recorded |
|---|---|
| Product team key | `context/07-glossary.md` § Systems — `HBR` in the Harbor Cover example |
| Engineering team key | Ask once; record it in the same glossary row. It stays the engineering team's own |

## Tools

Tool names are `mcp__tracker__<tool>`. The prefix follows the server key in `.mcp.json`. The `<tool>` part is as the server exposed it when this file was written. The client's tool list after `/mcp` is authoritative. If a name differs, use the client's and note it in the session handoff.

| Need | Tool | Notes |
|---|---|---|
| Verify access | `mcp__tracker__list_teams` | The cheapest read; failure means stop |
| Team states | `mcp__tracker__list_issue_statuses` with `team` | Read the state names before setting any |
| Labels | `mcp__tracker__list_issue_labels` | Confirm the three groups exist |
| Find issues | `mcp__tracker__list_issues` with `team`, `project`, `cycle`, `state`, `label`, `query`, `updatedAt`, `parentId`, `limit` | Pulse filters on `updatedAt`; release filters on `cycle` and `state` on the engineering team |
| Read one issue | `mcp__tracker__get_issue` | Read-back after publish |
| Create or update | `mcp__tracker__save_issue` — `team`, `title`, `description`, `project`, `cycle`, `state`, `parentId`, `addLabels`, `blockedBy`, `links` | Omit `id` to create; pass `id` to update. `description` is Markdown with real newlines. Asks for permission |
| Comment | `mcp__tracker__save_comment` (asks), `mcp__tracker__list_comments` | Publication log entries and read-back notes |
| Projects and cycles | `mcp__tracker__list_projects`, `mcp__tracker__get_project`, `mcp__tracker__list_cycles` | Resolve names before saving |

Never pass `estimate`. Never set `assignee` from a plan. The product lead assigns people in Linear by hand.

## Workflow states — product team

| State | PRD status it mirrors | Enter when |
|---|---|---|
| `Backlog` | — | Intake verdict `park`, with an unpark condition in the description |
| `Discovery` | — | Intake verdict `go` |
| `Drafting` | `draft` | A producing skill is working |
| `In Review` | `in-review` | `/review gate` running |
| `Approved` | `approved` | Gate line recorded |
| `Handed to Eng` | `approved` + brief | Engineering issue linked (below) |
| `Shipped` | `shipped` | Release reconciliation shows a shipped status |
| `Landed` (state type `completed`) | `landed` | `/land` has appended the current-behaviour rows |
| `Cancelled` (state type `cancelled`) | `superseded` or dropped | A decision point names why |

Engineering states belong to the engineering team. The one that matters here is its **deployed-to-production** state (`Deployed to Prod` in the Harbor Cover example). `Done` is not that state.

## The link

Set the engineering issue as a blocker of the parent product issue: `mcp__tracker__save_issue` with `id: <parent>` and `blockedBy: ["<ENG-key>-<n>"]`. Sub-issues move with the parent; if engineering splits its work, repeat this per split sub-issue. Add the engineering issue URL to the parent's `Links` line with `links`. The skill moves the product issue to `Shipped` only when the blocker is at the deployed-to-production state; the tracker does not enforce this. A parent in `Handed to Eng` with no `blockedBy` relation is a broken link in pulse.

## Label groups

| Group | Labels | Rule |
|---|---|---|
| Scope | `lane:customer`, `lane:ops-platform` | One per issue |
| Work type | `discovery`, `prd`, `design`, `copy`, `research`, `feature`, `chore` | One per issue |
| Surface | `hub` (Harbor), `desk`, `field`, `rules`, `data`, `comms` | One or more |

Create missing labels with `mcp__tracker__save_issue_label` (asks for permission) only after the product lead agrees. Do not import engineering's labels.

## Pack publication, in tool calls

1. `mcp__tracker__save_issue` the parent: `team`, `title`, `description`, `project`, `cycle`, `state: Approved`, `addLabels`. Omit `id` when the duplicate check found none; pass the found issue's `id` otherwise.
2. `mcp__tracker__save_issue` each sub-issue with `parentId` set to the parent's identifier, same project, cycle and state.
3. `mcp__tracker__get_issue` each created issue; diff title, description, labels, parent against the pack.
4. `mcp__tracker__save_comment` on the parent: "Published from `<pack path>` version x.y; read-back matches: yes".

## Release reconciliation, in tool calls

`mcp__tracker__list_issues` with `team: <engineering key>`, `cycle: <cycle>`, `state: <deployed-to-production state>`; then `mcp__tracker__list_issues` with `team: <product key>`, `state: Handed to Eng`. Join on the parent's `blockedBy` relation, and on a split sub-issue's own. Anything in `Handed to Eng` whose blocker is not at the deployed-to-production state is not shipped, whatever its tracker state says.
