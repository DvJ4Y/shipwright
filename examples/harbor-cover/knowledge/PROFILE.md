# Profile — Harbor Cover example

> Read at every session start. `/setup` creates this file; `/learn` regenerates **Dynamic**
> from current rows in `facts.md`. This copy is filled for the fictional Harbor Cover
> example; every figure in it is `example` or `target`.

_role: product-lead             # product-lead | designer | founder
_lane: ops-platform             # customer | ops-platform
_focus: Desk, Field, the eligibility engine and the policies; the verification-outcome-and-rework feature this quarter
_experience: practised          # new = skills explain each step in one line · practised = no explanations
_default_tier: M                # S | M | L — used when intake is ambiguous
_tools_access: tracker=yes, event_analytics=yes, sql_replica=yes, bi_export=yes
_tracker: linear                # linear | github — the issue-tracker adapter to load
_language: en                   # the working language of the workspace documents
_customer_language: none        # language-pack code for customer copy, or none
_memory_dir: default            # where the agent keeps memory facts
_regulated: yes                 # yes = the regulated-actions register is checked at every gate
_language_review: no            # no = customer-language copy is flagged for a native reviewer
_workstyle: options first, short answers, tables over prose; chat before files
_struggles: data pulls and population boundaries; writing copy in the customer's language
_gate_owner: product-lead       # role that approves your gates

## Static

**Me.** Product lead for the ops and platform lane: Desk, Field, the eligibility engine,
data and messaging, and the internal policies. I answer for `VER-M1`, `VER-M2`, `PLC-M1`,
`CLM-M1` and `REF-M1`. The customer lane owns Harbor; we share rework messages and the
quote page.

**The product.** Harbor Cover distributes small-business insurance (shop, stock, liability,
staff health) through 6 insurer partners (`example`). Revenue is commission on issued
policies. The insurer carries the risk; Harbor Cover owns the customer, verification and
the claims desk. Regulated, ops-heavy, document-heavy.

**Users.** Shop owners by shop type: grocery, electronics, pharmacy, apparel, hardware,
food service. Personas: Meera (grocery, first policy), Arjun (electronics, three outlets),
Priya (pharmacy). Internal: support agents, verification officers, placement specialists,
claims handlers, field verifiers, the ops lead, the compliance officer. External: about 120
referral agents (`example`).

**Surfaces.** Harbor (`hub`, customer web app) · Desk (`desk`, ops console) · Field
(`field`, field and partner app) · the eligibility engine (`rules`) · data and messaging
(`data`, `comms`).

**Stages (production).** `Quote` · `Eligibility` · `Documents` · `Verification` ·
`Placement` · `Policy issued` · `Active`, then `Claim` and `Renewal`. Sub-statuses: `open` ·
`on hold` · `rework` · `declined` · `cancelled` · `lapsed`. Every `declined` carries a
recovery path.

**Constraints.** Six regulated actions (`context/regulated-actions.md`). Cooling-off is 15
days (`example`). The BI tool is authoritative for funnel rates; the SQL replica for counts.
Three replica traps in `context/05-numbers-data-and-traps.md`.

**How I work.** Two or three options with what each trades away, then stop. Iterate in chat
and short markdown; one artifact at the end. Never write a file I have not asked for. Never
present a target as a baseline. My words → glossary terms: lead → case · bounce → rework ·
manual review → refer · SLA → service level · free-look → cooling-off.

## Dynamic

> Generated from current rows in `facts.md`. Do not edit by hand.

**In flight.** C1 verification outcome and rework: PRD v1.1 approved, brief and issue pack
approved, pack not published, engineering alignment not yet (F-0024). C4 automatic retry
queue in UAT (F-0025). C5 replacement capture from the inspection checklist in build
(F-0026). C8 renewal reminders committed, no PRD (F-0027).

**Headline.** Policies issued: Sep 240 (`example`, F-0011); Oct target 300 (`target`,
F-0012).

**Open decisions.** D-004 rework hold window · D-006 which rework reasons a field verifier
resolves on site · D-008 identity-check retries after a provider timeout. Owner: the ops
lead for all three.

**Open questions.** Who reads the WhatsApp messages when staff handle the paperwork
(F-0034). Why customers leave after the premium range (F-0035).
