# Cheatsheet Generator — Design

A small Ruby CLI that generates interactive, single-file HTML cheatsheets for a
given topic (minitest, rails, mysql, postgresql, …) and publishes them via
GitHub Pages at `https://fuentesjr.github.io/cheatsheets/<topic>/`.

## Goals

- One command turns a topic name into a polished, self-contained HTML cheatsheet.
- Sheets are interactive: search/filter, copy-to-clipboard on snippets,
  collapsible sections, dark mode toggle (persisted in localStorage).
- Content layout is free-form per topic — the model decides which sections fit
  minitest vs. postgresql. Interactive behaviors are mandatory; structure is not.
- Every sheet passes an automated self-review before it is written to disk.
- Zero runtime dependencies beyond Ruby stdlib and the `claude` CLI.

## Non-goals (v1)

- No update/merge lifecycle. Regenerating a topic overwrites it (with confirmation).
- No search across sheets, versioning, or CMS features.
- No API billing — generation reuses the local `claude` CLI subscription.
- No build step for the site; what's committed is what's served.

## Decisions (from design review)

| Question | Decision |
|---|---|
| Consumption | Interactive HTML served by GitHub Pages from this repo |
| Content source | Shell out to `claude` CLI in print mode (`claude -p`) |
| Language | Ruby (stdlib only) |
| Scope | One-shot generation; overwrite on regenerate |
| Structure | Free-form per topic, mandatory interactivity contract |
| Quality gate | Second `claude` self-review pass, then human eyeball before commit |

## CLI

```
bin/cheatsheet generate <topic>   # generate <topic>/index.html + refresh index
bin/cheatsheet list               # list existing sheets
```

`generate` on an existing topic asks before overwriting. Exit non-zero if the
`claude` CLI is missing, generation fails, or review fails twice.

## Repo layout

```
bin/cheatsheet          # executable Ruby CLI (single file to start)
lib/                    # extracted only when bin/cheatsheet demonstrably outgrows one file
prompts/generate.md     # generation prompt template ({{TOPIC}} placeholder)
prompts/review.md       # self-review prompt template
<topic>/index.html      # one directory per sheet, served by Pages
index.html              # auto-generated topic directory (rebuilt on every generate)
DESIGN.md
```

GitHub Pages serves from the root of the default branch, so
`postgresql/index.html` → `/cheatsheets/postgresql/`.

## Generation pipeline

1. **Prompt build** — render `prompts/generate.md` with the topic. The prompt
   specifies the *contract*, not the layout:
   - single self-contained HTML file: inline CSS/JS, no external requests, no CDNs
   - must implement: live search/filter over entries, copy button on every code
     snippet, collapsible sections, dark/light toggle persisted in localStorage
   - dense reference content (commands, snippets, gotchas) — not a tutorial
   - section choice and visual organization are the model's call per topic
2. **Generate** — `claude -p <prompt>` (headless); capture stdout, extract the
   HTML document.
3. **Self-review** — second `claude -p` call with `prompts/review.md` + the
   generated HTML. It checks (a) factual accuracy of commands/flags/APIs and
   (b) contract compliance (the four interactive features, self-containment).
   Returns verdict + issue list. On failure: one regeneration attempt with the
   issues appended to the prompt, then give up loudly with the issues printed.
4. **Write** — save `<topic>/index.html`, rebuild root `index.html` from the
   directory listing, `open <topic>/index.html` for the human eyeball pass.
5. **Publish** — human commits and pushes. The tool never touches git.

## Risks / accepted tradeoffs

- **Free-form output varies in quality.** Accepted for v1; the review pass and
  eyeball gate catch the worst. If quality is too uneven in practice, tighten
  the contract before reaching for a rigid template.
- **Two `claude` calls per sheet is slow** (likely 1–3 min total). Fine for a
  tool run occasionally per topic.
- **Model may emit prose around the HTML.** The extractor takes everything from
  `<!DOCTYPE html` (or `<html`) through `</html>`; anything else is discarded.
- **Review pass can't truly verify facts** — it's a second opinion, not a test
  suite. The human eyeball remains the real gate before commit.

## Setup prerequisites (one-time, manual)

- `git init`, create `fuentesjr/cheatsheets` on GitHub, push.
- Enable GitHub Pages: deploy from branch, root of default branch.
