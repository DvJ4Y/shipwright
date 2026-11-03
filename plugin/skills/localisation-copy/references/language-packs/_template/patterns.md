---
title: "Language pack {{code}} — patterns"
type: language-pack
language: "{{code}}"
status: draft
version: 0.1
owner: "{{native reviewer role}} with the designer"
supersedes: —
decision_refs: []
why: The rules that make a string sound spoken, fit the layout and read the same to every reviewer
last_updated: YYYY-MM-DD
---

# {{Language name}} — patterns

> Last verified: YYYY-MM-DD

Fill every `{{...}}`. Each table's first row is a worked line in the working language. It
shows the kind of difference the row records. Replace it with the pack's own line.

## 1. Bookish against spoken

Grammatically correct is not enough. A string a customer would never say aloud is a fault.

| Pattern | Bookish form | Spoken form | Rule |
|---|---|---|---|
| Formal request | "Kindly furnish the requisite documentation." (`example`) | "Send us the shop licence photo." (`example`) | Name the document; use the verb a person would use |
| Honorific stacking | {{bookish}} | {{spoken}} | {{rule}} |
| Passive voice | {{bookish}} | {{spoken}} | {{rule: name who does the action}} |
| Nominalised verb | {{bookish}} | {{spoken}} | {{rule}} |
| Formal conjunction | {{bookish}} | {{spoken}} | {{rule}} |
| Machine-translated idiom | {{bookish}} | {{spoken}} | {{rule}} |

## 2. Code-mixing

The test: if a customer says the source-language word in conversation, keep it.

| Rule | Value |
|---|---|
| Source-language words kept as loanwords | {{list: e.g. policy, premium, product names, the one-time code's abbreviation}} |
| Script for loanwords | {{the pack's script, or Latin when the screen shows the word in Latin elsewhere}} |
| Words that must be in the pack language | {{list: everything that explains, instructs or reassures}} |
| Product and surface names | Harbor and every product name stay as the customer sees them (`example`) |

## 3. Text expansion limits

Over the limit, shorten the string. Never shrink the font.

| Element | Source limit (chars) | Expansion allowed | Pack limit (chars) | Note |
|---|---|---|---|---|
| Label | 24 | +30% (`example`) | 31 | Worked line; measure your language and replace |
| Button | 18 | {{%}} | {{n}} | {{...}} |
| Helper text | 90 | {{%}} | {{n}} | {{...}} |
| Input error | 90 | {{%}} | {{n}} | {{...}} |
| Status line | 40 | {{%}} | {{n}} | {{...}} |
| Notification | 160 | {{%}} | {{n}} | {{one message, not two}} |

## 4. Numbers, currency, dates and phone numbers

| Item | How the pack writes it | Example |
|---|---|---|
| Currency | {{symbol position; grouping; the word for the unit when spoken}} | {{...}} |
| Large amounts | {{lakh and crore, or thousands and millions, as customers say them}} | {{...}} |
| Dates | {{order; month as word or number; how a deadline is phrased}} | {{...}} |
| Phone numbers | {{grouping; how a one-time code is read aloud}} | {{...}} |
| Percentages and ranges | {{"between X and Y" phrasing}} | {{...}} |

## 5. Romanisation scheme

| Rule | Value |
|---|---|
| Scheme | {{name or a one-line description of the scheme every reviewer uses}} |
| Long vowels | {{marking}} |
| Retroflex and aspirated sounds | {{marking, if the language has them}} |
| Loanwords | {{romanised as the source word, or by the scheme}} |

`/localisation-copy` romanises every option by this scheme, so two reviewers read the same
romanisation.
