# Profile — read at every session start

> One per person, at the workspace root. `/onboard` fills it in during the first hour. The
> session-start hook prints every line that starts with `_`; skills read the whole file.
> Edit it whenever something changes.

_role: product-lead             # product-lead | designer | founder
_lane: <customer | ops-platform>
_focus: <1 line — the surfaces or outcomes you own this quarter>
_experience: new                # new = skills explain each step in one line · practised = no explanations
_default_tier: M                # S | M | L — used when intake is ambiguous
_tools_access: tracker=<yes|no>, event_analytics=<yes|no>, sql_replica=<yes|no>, bi_export=<yes|no>
_tracker: <linear | github>     # the issue-tracker adapter to load
_language: en                   # the working language of the workspace documents
_customer_language: <code | none>   # language-pack code for customer copy, or none
_memory_dir: <default | path>  # where the agent keeps memory facts; default = the agent's own project memory
_regulated: <yes | no>          # yes = the regulated-actions register is checked at every gate
_language_review: <yes | no>    # yes = you can review copy in the customer's language · no = copy is flagged for a native reviewer
_workstyle: <1 line — e.g. "options first, short answers, tables over prose">
_struggles: <1 line — areas where skills should slow down and check, e.g. "data, copy in the customer's language">
_gate_owner: <role>             # role that approves your gates

## Role and focus

<What you own, who you work with most (support, verification, field, engineering, design),
and the outcome metrics you answer for — metric IDs from `context/metrics-dictionary.csv`.>

## How I work

<When you think best, how you like options presented, how much detail before a decision,
what you want the agent never to do.>

## Where I struggle

<Areas you want extra checks or explanation in. Skills read this and slow down there.>

## My words → our terms

| I say | The glossary term | Note |
|---|---|---|
| | | |

<Your own vocabulary. The agent uses your words in chat and the glossary term
(`context/07-glossary.md`) in every document.>
