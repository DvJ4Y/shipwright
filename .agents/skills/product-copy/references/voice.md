# Voice, applied to each element type

Use this file to shape each element type; the voice rules are in `context/design/voice.md`.
That file owns the four rules, the words we use and do not, the message shape, the Never list
and the tone per audience. This file points to them and does not restate them. Every example
is Harbor Cover, in the working language, labelled `example`. `/localisation-copy` writes the
customer's language from the same intent.

## Element types

| Element | Job | Shape | Default limit | Example (`example`) | Common fault |
|---|---|---|---|---|---|
| Label | Names the thing in the customer's words | Noun phrase | 24 | "Shop licence photo" | An internal field name: "Doc type" |
| Helper text | Says why we ask and what good looks like | One or two sentences | 90 | "Shows your shop trades at this address. A photo in daylight works best." | Policy wording copied in |
| Button | The action the reader takes | Verb first | 18 | "Send new photo" | "Submit", "OK", "Proceed" |
| Input error | What is wrong with the input and how to fix it | Fact, then fix | 90 | "This number has 9 digits. A mobile number has 10." | "Invalid input" |
| Empty state | What belongs here and the first step | What + first step | 90 | "No documents yet. Start with the identity proof; the insurer checks it first." | "Nothing to show" |
| Status line | The sub-status in plain words | State — what is waited for | 40 | "On hold — waiting for your address proof" | The sub-status code alone |
| Notification | What happened and one action | The message shape from `context/design/voice.md` | 160 | "Your shop licence photo was returned: we could not read it. Take it again in daylight and upload it in Harbor. Nothing else is needed." | Two actions in one message |
| Refusal | A `declined`, `rework`, `on hold` or `provider-failed` outcome | See below | per element | — | No next step on the same screen |

## Refusal with recovery

Every refusal follows the message shape in `context/design/voice.md` and ends with a route
that exists today: replace the document in Harbor · a field verifier captures it at the shop
· upload a different identity proof · talk to a verification officer. The words to use and to
avoid for each outcome are in `context/design/voice.md` § Words we use and § Never.

| Outcome | Next step shape | Example (`example`) |
|---|---|---|
| `rework` | The reason in plain words, then the fix, then the fallback route | "Your shop licence photo was returned: the text was too blurred to read. Take it again in daylight, flat on a table, and upload it here. If that is hard, a field verifier can take it at your shop." |
| `declined` | The rule in plain words, then what would change it, then who can review | "Stock cover is not available for an open yard above ₹1 crore right now. You can lower the stock amount, or ask our team to review the case." |
| `on hold` | What is waited for, then what to send, then where | "Your case is on hold until we have the address proof. Upload a utility bill or the rent agreement in Harbor." |
| `provider-failed` | What we could not do, then what we do next, then what the customer need not do | "We could not complete the identity check just now. We will retry; nothing is needed from you. If it does not go through, our verification team confirms it from the proof you sent." |

The outcome describes the cover, the document or the check. It never describes the person.

## Channel shapes

Tone per audience is in `context/design/voice.md` § Per audience. The shape per channel:

| Channel | Shape |
|---|---|
| Screen | One idea per element. The next step is a button, not a sentence |
| WhatsApp | One message, four parts, one action. Say where a link goes before the link |
| Voice script | Spoken sentences. Repeat the number once. Mark pauses. No abbreviations |

## The customer's language

- Write the intent, then the source string, then hand the key, string, context and limit to
  `/localisation-copy`. Never translate the source yourself.
- In mockups, each customer-facing string carries a `[customer language]` marker until the
  localised string arrives.
- Leave room. The language pack states the expansion limit per element. A layout designed
  to the source length will clip.
- Read the back-translation against the intent, not against the source sentence.

## Worked strings for the worked feature

Keys for `products/desk/verification-outcome-and-rework/`, source only, all `example`.

| key | element | source | chars | limit |
|---|---|---|---|---|
| `hub.rework.item.unreadable` | helper text | "Returned: we could not read the photo. Take it again in daylight, flat on a table." | 82 | 90 |
| `hub.rework.item.mismatched` | helper text | "Returned: the name here differs from your identity proof. Upload the matching one." | 82 | 90 |
| `hub.rework.item.missing` | helper text | "Not received yet. The insurer needs it to confirm your shop address." | 68 | 90 |
| `hub.rework.action.replace` | button | "Send new photo" | 14 | 18 |
| `hub.rework.action.visit` | button | "Book a shop visit" | 17 | 18 |
| `hub.identity.provider_failed` | status line | "Identity check — we will retry" | 30 | 40 |
| `field.rework.capture.sent` | status line (staff) | "Replacement sent to the officer" | 31 | 40 |
