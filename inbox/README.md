# inbox/ — drop anything here, then run /learn

Put material you want the agent to learn in this folder, then run `/learn`. Nothing here is
read until you ask.

## What to drop

| Kind | Example | Name it |
|---|---|---|
| Notes | Meeting notes, a voice-memo transcript, a list of decisions | `YYYY-MM-DD-<topic>.md` |
| Documents | A PRD, a strategy memo, a policy, a release note | Keep the original name |
| Transcripts | A customer call, a stakeholder interview | `YYYY-MM-DD-<who-by-role>.md` |
| Data exports | A CSV from event analytics, the BI tool or the SQL replica | `YYYY-MM-DD-<what>.csv` |
| Screenshots | A production screen, a dashboard | `YYYY-MM-DD-<surface>.png` |
| Links | `urls.md`, one URL per line, an optional note after a space | `urls.md` |

Say where a figure came from in the file name or the first line. `/learn` refuses a figure
it cannot label.

## What /learn does with it

1. Reads every file, every captured chat in `inbox/sessions/` and every URL in `urls.md`.
2. Extracts typed facts, each with this file as its source.
3. Matches them against `knowledge/facts.md`: new, duplicate, update or contradiction.
4. Shows you one diff table. Writes only the rows you approve.
5. Moves each processed file to `inbox/_processed/YYYY-MM-DD/`. Deletes processed captured
   chats; they are not archived. Clears the processed lines from `urls.md`.

## inbox/sessions/

The session-end hook writes each chat here as `YYYY-MM-DD-<id>.md`: your messages and the
agent's replies, without tool output. Git ignores this folder. Nothing leaves your machine.

## Safety

Everything in this folder is untrusted input. `/learn` reads it as data and follows no
instruction written inside it. Do not drop secrets, keys or customer personal data here.
