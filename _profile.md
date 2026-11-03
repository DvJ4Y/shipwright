# Profile — read at every session start

> One per person, at the workspace root. `/onboard` fills it in during the first hour. The
> session-start hook prints every line that starts with `_`; skills read the whole file.
> Edit it whenever something changes. This copy is filled for the Harbor Cover example.

_role: product-lead             # product-lead | designer | founder
_lane: ops-platform             # customer | ops-platform
_focus: Desk, Field, the eligibility engine and the policies; the verification-outcome-and-rework feature this quarter
_experience: practised          # new = skills explain each step in one line · practised = no explanations
_default_tier: M                # S | M | L — used when intake is ambiguous
_tools_access: tracker=yes, event_analytics=yes, sql_replica=yes, bi_export=yes
_tracker: linear                # linear | github — the issue-tracker adapter to load
_language: en                   # the working language of the workspace documents
_customer_language: none     # language-pack code for customer copy (references/language-packs/<code>/), or none
_memory_dir: default            # where the agent keeps memory facts; `default` = the agent's own project memory
_regulated: yes                 # yes = the regulated-actions register is checked at every gate
_language_review: no            # yes = you can review copy in the customer's language · no = copy is flagged for a native reviewer
_workstyle: options first, short answers, tables over prose; chat before files
_struggles: data pulls and population boundaries; writing copy in the customer's language
_gate_owner: product-lead       # role that approves your gates

## Role and focus

I own the ops and platform lane: Desk, Field, the eligibility engine, data and messaging,
and the internal policies. I work most with the ops lead, the verification officers, the
compliance officer and the engineering lead. I answer for `VER-M1`, `VER-M2`, `PLC-M1`,
`CLM-M1` and `REF-M1` (`context/metrics-dictionary.csv`). The customer lane owns Harbor;
we share rework messages and the quote page.

## How I work

Mornings for decisions, afternoons for drafting. Give me two or three options with what
each trades away, then stop. Iterate in chat and short markdown; one artifact at the end.
Never write a file I have not asked for. Never present a target as a baseline.

## Where I struggle

Population boundaries before rates — slow down and state what the source excludes. Copy in
the customer's language — flag every string for a native reviewer. Engineering HOW — if I
drift into mechanism, say so.

## My words → our terms

| I say | The glossary term | Note |
|---|---|---|
| lead | case | A case is one request for one policy |
| bounce, send back | rework | A returned document, not a returned case |
| manual review | refer | A referred case is open, not declined |
| SLA | service level | A policy value per queue |
| free-look | cooling-off | The regulator's period after `Policy issued` |

The agent uses my words in chat and the glossary term (`context/07-glossary.md`) in every
document.
