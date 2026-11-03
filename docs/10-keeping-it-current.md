---
title: 10 — Keeping it current
type: doc
status: active
version: 1.0
supersedes: —
decision_refs: []
why: Settles whether a file is still true, how to correct it without bloat, and when a feature's requirements become durable
last_updated: 2026-11-02
---

# 10 — Keeping it current

Read this when you need to decide whether a file is still true, how to correct it without
bloating the pack, and when a feature's requirements become durable.

## Write what is true

A fresh reader has made none of the earlier mistakes. A "never write X" rule about a term
they have never used costs context and adds nothing.

| Write this | Not this |
|---|---|
| "The verification queue is ordered by risk tier, then age." | "Do not propose re-ordering the queue; that was rejected." |
| "Extend the queue and the case view." | "Do not propose a new dashboard." |
| "`Done` is not shipped; only `deployed to prod` counts." | "People keep reporting `Done` as shipped." |

Keep the rule, drop the history. The backstory lives in `tasks/lessons.md`.

## The land step

A feature's requirements become durable through `/land`, and only through it. The surface
table in `.agents/skills/product-loop/references/conventions.md` names the file each
requirement lands in.

| `/land` does | `/land` never does |
|---|---|
| Reads a PRD at `shipped` with `shipped_on` set, the release note that confirms it, and the post-ship review | Lands a PRD at any other status, or one the tracker alone says is done |
| Builds the landing table in chat first. One line per requirement row and acceptance group, each with a verdict: `land`, `gap — PENDING via /decide` or `deferred — <decision point>`. The product lead confirms before `/land` writes anything | Appends a row for a `gap`. Production that contradicts the PRD is a PENDING decision, not a fact |
| Appends one `When … then …` row per landed requirement to the surface file. Each row carries the next id, the PRD's archive path and the production date. Prefixes a replaced row `SUPERSEDED by <id>` | Deletes, reorders or renumbers a row. Guesses a surface |
| Writes `internal/crosswalk.md`. PRD rows equal crosswalk rows; unmapped is zero | Edits anything already under `archive/` |
| Flips QA rows from `Planned` to `Current` where the release note confirms them | Sets `Blocked` or `Fix-pending`; those belong to whoever shipped |
| Sets the PRD to `landed` with `landed_into:`. Moves the parent product issue to `Landed`. Moves the folder to `products/<code>/archive/landed-YYYY-MM-DD/` with a "replaced by" README. Proposes one commit | Lands twice, or lands a deferred criterion; that criterion returns in a later PRD |

The session-start hook and `/session end` list PRDs at `shipped` not yet landed.
`/issue-tracker pulse` flags them too.

## The review pass

Run it after substantial edits, or about quarterly. One dimension per pass; mixing them
produces a shallow review. If a reviewer agent runs a pass, it reports and the author
edits.

### 1. Framing

```bash
grep -rniE "never write|has been (corrected|rejected|broken)|people get wrong|will bite you|widely misreported|catch(es)? people out" --include='*.md' context docs products
```

Keep a counterintuitive fact stated positively. Cut anything that only makes sense as a
record of a past error.

### 2. Accuracy

```bash
grep -rn "DB-verified\|operational — unverified\|Last verified" --include='*.md' context
```

Re-run every `DB-verified` figure; the query is in the file that uses it. Re-check every
`operational — unverified` figure against the BI tool. Ask of each `Last verified` date: is
this still true, and who would know? A number with no decision or query behind it is the
one most likely to be wrong.

### 3. Self-sufficiency

Every backticked path resolves inside the repo.

```bash
python3 - <<'PY'
import pathlib, re
pat = re.compile(r'`([A-Za-z0-9_][A-Za-z0-9_./-]*\.(?:md|csv|json|html|sh|py|mjs))`')
for p in sorted(pathlib.Path(".").rglob("*.md")):
    if p.parts[0] in {"plugin", "node_modules"}: continue
    for m in pat.finditer(p.read_text()):
        f = m.group(1)
        if not (pathlib.Path(f).exists() or (p.parent / f).exists()):
            print(f"BROKEN {f} <- {p}")
PY
```

A path with a placeholder (`<surface>`, `YYYY-MM-DD`) is not matched and is not checked.

### 4. Density

For each file, ask of every paragraph: does a fresh reader act differently because of
this? If not, cut it. A fact restated in a file that does not own it is a pointer waiting
to be written.

### 5. Prose integrity

After any scripted edit:

```bash
python3 - <<'PY'
import pathlib, re
dup = re.compile(r'\b([a-zA-Z]{2,8})\s+\1\b')
for p in sorted(pathlib.Path(".").rglob("*.md")):
    if p.parts[0] in {"plugin", "node_modules"}: continue
    for i, l in enumerate(p.read_text().splitlines(), 1):
        if any(m.group(1).lower() not in {"had", "that", "very", "first"} for m in dup.finditer(l)):
            print(f"dup  {p}:{i}")
        if "****" in l:
            print(f"bold {p}:{i}")
PY
```

Then read the changed files. A grep cannot see a sentence that parses but no longer means
what it did.

### The mechanical pack check

`bash scripts/check-pack.sh` runs the deterministic checks in one go. Zero findings before
any commit; `scripts/pre-commit.example` wires it to git. It checks:

- person names in plans;
- numbers without a label;
- files over the line limit;
- local paths or ids in `shared/`;
- unfilled placeholders;
- secrets;
- a `landed` PRD outside `archive/`;
- the plugin out of date;
- a missing "Read first" path in a skill;
- company-word residue: vendor names outside the adapters, the old title for the
  engineering lead, the old nickname for the product lead, non-Latin script;
- a capitalised two-word name under `products/` or `docs/` (a warning, not a failure).

## The lessons ratchet

Every correction goes to `tasks/lessons.md` as a rule, at `/session end`. When the same
rule appears three times, ask first: **can this be a check?** A grep, a hook, a column
validation, a line in the pack check. Only when no check can catch it does it become skill
text. The agent follows skill text sporadically; a check runs every time. The weekly miner
reads `tasks/lessons.md` and flags the context files a lesson contradicts.

## What goes where

| Kind of thing | Home |
|---|---|
| A fact about the business, the product or the data | `context/`, one owner file per fact |
| A rule about how we work | `docs/`, or the skill that applies it |
| The backstory behind a rule | `tasks/lessons.md` |
| Current commitments | `context/09-current-commitments.md`, refreshed after each release reconciliation |
| What the agent must know every session | `AGENTS.md`; keep it short |

When something changes, update one file. If the same fact lives in three, two go stale and
you will not know which.

## Refreshing a context file

Re-check the facts against production, the BI tool or the owner. Then move `Last verified`.
The weekly interview does this one approved diff at a time (`docs/06-weekly-sync.md`). The
`Last verified` ladder in `context/README.md` cannot detect a date moved without a
re-check; that is the one thing only discipline covers.
