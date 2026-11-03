# Adapter — GitHub Issues

Loaded when `_profile.md` has `_tracker: github`. This file may name GitHub; every other skill file says "the tracker". Commands use the GitHub CLI, `gh`.

## Connect

`gh auth status` must succeed. If the product and engineering issues live in different repositories, every command carries `-R <owner>/<repo>`. Editing projects needs `gh auth refresh -s project`.

## Keys

| Key | Where it is recorded |
|---|---|
| Product repository | Ask once; record it in the glossary's tracker row (`context/07-glossary.md` § Systems). `<owner>/harbor-product` in the Harbor Cover example |
| Engineering repository | Ask once; record it in the same row |

## Commands

Subcommands as the CLI manual lists them: `list`, `view`, `create`, `edit`, `comment`, `close`, `reopen`, `status`. Confirm flags with `gh issue <subcommand> --help` if the installed version differs.

| Need | Command |
|---|---|
| Verify access | `gh issue list -R <repo> --limit 1` |
| Find issues | `gh issue list -R <repo> --label <label> --milestone <cycle> --state all --json number,title,labels,milestone,updatedAt,body` |
| Read one issue | `gh issue view <n> -R <repo> --comments --json number,title,body,labels,milestone` |
| Create | `gh issue create -R <repo> --title "<title>" --body-file <file> --label <label> --milestone <cycle> [--project <title>]` |
| Update | `gh issue edit <n> -R <repo> --add-label <label> --remove-label <label> --milestone <cycle> --body-file <file>` |
| Comment | `gh issue comment <n> -R <repo> --body "<text>"` |

Write bodies to a temporary file and pass `--body-file`. A long `--body` string on the command line is fragile.

## States as labels

GitHub has `open` and `closed`. The product workflow is a label group; exactly one `state:` label per issue.

| Label | PRD status it mirrors |
|---|---|
| `state:backlog` | — (with an unpark condition in the body) |
| `state:discovery` | — |
| `state:drafting` | `draft` |
| `state:in-review` | `in-review` |
| `state:approved` | `approved` |
| `state:handed-to-eng` | `approved` + brief |
| `state:shipped` | `shipped` |
| `state:landed` | `landed` — close the issue at this point |
| `state:cancelled` | `superseded` or dropped — close with a comment naming the decision point |

Moving state = `--add-label state:<new> --remove-label state:<old>` in one `edit`. Engineering's own labels are theirs; the one that matters is its deployed-to-production label (`state:deployed-to-prod` in the Harbor Cover example).

## Cycles and projects

- A cycle is a **milestone** named after the cycle (`2026-11` in the example). Every issue in the pack gets the milestone.
- Projects are optional. Use `--project` only if the team already runs a project board.

## Parent and sub-issues

The parent body ends with a task list, one line per sub-issue: `- [ ] #<n> — <slice title>`. Each sub-issue body carries `Parent: #<parent>` on its `Depends on` line. Create the parent first, then the sub-issues, then edit the parent body to add the numbers.

## The link

The parent product issue body carries one line: `Implements: <owner>/<eng-repo>#<n>`. Sub-issues move with the parent; if engineering splits its work, each split sub-issue carries its own line. State transitions mirror. `state:handed-to-eng` needs the line. `state:shipped` needs two things: the engineering issue carries its deployed-to-production label, and every acceptance criterion has production evidence or a `/decide` deferral. A `state:handed-to-eng` parent without an `Implements:` line is a broken link in pulse.

## Label groups

| Group | Labels |
|---|---|
| Scope | `lane:customer`, `lane:ops-platform` |
| Work type | `discovery`, `prd`, `design`, `copy`, `research`, `feature`, `chore` |
| Surface | `hub` (Harbor), `desk`, `field`, `rules`, `data`, `comms` |

Create missing labels with `gh label create <name>` only after the product lead agrees.

## Pack publication, in commands

1. `gh issue create` the parent with `state:approved`, the Scope, Work type and Surface labels and the milestone — or `gh issue edit <n>` the issue the duplicate check found; never create a second one.
2. `gh issue create` each sub-issue with the same labels and milestone; body from the pack.
3. `gh issue edit <parent> --body-file` to add the task list of sub-issue numbers.
4. `gh issue view <n> --json ...` for each; diff title, body, labels, milestone against the pack.
5. `gh issue comment <parent> --body "Published from <pack path> version x.y; read-back matches: yes"`.

## Release reconciliation, in commands

`gh issue list -R <eng-repo> --milestone <cycle> --state all --label state:deployed-to-prod --json number,title,closedAt`, then `gh issue list -R <product-repo> --label state:handed-to-eng --json number,title,body`. Join on the `Implements:` line only. Anything in `state:handed-to-eng` whose engineering issue lacks the deployed-to-production label is not shipped, whatever its state says.
