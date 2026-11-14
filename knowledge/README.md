# knowledge/ — what the agent knows about you and the product

Run `/setup` once to fill these files. Run `/learn` whenever you have something new.
Every skill reads this folder first and does not ask for what it already holds.

| File | Holds | Who writes it |
|---|---|---|
| `PROFILE.md` | The `_` settings, Static (you, the product, users, model, constraints) and Dynamic (in flight, decisions, open questions) | `/setup` creates it and you edit Static. `/learn` regenerates Dynamic |
| `facts.md` | The ledger: one typed row per fact, each with a source, a date and a status | `/learn`, `/setup`, `/land`, `/review post-ship`, `/decide` — always as a diff you approve |
| `lessons.md` | Every correction, as a rule and its reason | `/session end` and `/learn` |

Rules that keep it true:

- No row without a source. No metric without a source label.
- A contradiction is shown to you, never overwritten. The old row is kept as superseded.
- A fact with a horizon carries an expiry date, and `/learn` marks it expired.
- Long reference material belongs in `context/`; a row points to its chapter.

The design: `docs/12-the-learning-layer.md`. The check: `evals/memory/check_facts.py`.
