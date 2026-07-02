You are reviewing a generated HTML cheatsheet for: **{{TOPIC}}**. The full HTML document appears after these instructions.

## Response format — strict, machine-parsed

The FIRST line of your response MUST be exactly one of:

```
VERDICT: PASS
VERDICT: FAIL
```

Nothing before it — no greeting, no preamble, no blank line, no markdown fence. After the verdict line, output a bulleted issue list (`- ` items), one issue per bullet, each naming the problem concretely (the wrong command/flag, the missing feature, the offending URL). If the verdict is PASS and there are no issues, output nothing after the verdict line. You may append PASS-compatible bullets prefixed `- note:` for minor observations.

## What to check

### 1. Factual accuracy (FAIL on errors)

- Verify every command, flag, option, API call, config key, and code snippet against the current stable version of {{TOPIC}}.
- Flag anything wrong, invented, or misspelled (a flag that doesn't exist, wrong argument order, incorrect syntax, wrong default value).
- Flag anything deprecated or removed that is presented as current.

### 2. Contract compliance (FAIL if violated)

- **Live search/filter**: a search input exists and the JS actually hides non-matching entries as the user types.
- **Copy-to-clipboard**: every code snippet has a copy button wired to working copy logic with visual feedback.
- **Collapsible sections**: sections can collapse/expand via their headings.
- **Dark/light toggle**: a theme toggle exists, persists to localStorage, and defaults to `prefers-color-scheme`.
- **Self-contained**: no external requests of any kind — no `http(s)://` URLs in `<link>`, `<script src>`, `<img src>`, `@import`, `url(...)`, or fetch calls. Documentation links in visible text are the only acceptable external URLs.
- **Valid single document**: exactly one complete HTML document from `<!DOCTYPE html>` through `</html>`, with no stray markdown fences or prose, and no obvious JS syntax errors or references to undefined functions.

Judge features by reading the code: the handlers must exist, be attached, and plausibly work — a button with no listener is a FAIL.

## Severity rules

- FAIL: any factual error, any of the four interactive features missing or evidently broken, any external resource request, or a malformed/multiple/incomplete HTML document.
- Do NOT fail for stylistic preferences: section ordering, color choices, naming, density, or content you would merely have organized differently. Report those as `- note:` bullets under a PASS.

REMINDER: your first line must be exactly `VERDICT: PASS` or `VERDICT: FAIL` — nothing else on that line, nothing before it — followed by the bulleted issues (empty only for a clean PASS).

The HTML document to review follows below.

---
