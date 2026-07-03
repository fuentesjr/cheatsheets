# cheatsheets

A small Ruby CLI that generates interactive, single-file HTML cheatsheets for a
given topic (minitest, rails, postgresql, …) and publishes them via GitHub Pages.

**Live:** https://fuentesjr.github.io/cheatsheets/

Each sheet is a self-contained HTML file — inline CSS/JS, zero external requests —
with live search/filter, copy-to-clipboard on every snippet, collapsible sections,
and a dark/light toggle persisted in `localStorage`.

## Requirements

- Ruby (stdlib only — no gems)
- The [`claude`](https://docs.claude.com/en/docs/claude-code) CLI on your `PATH`

## Usage

```bash
bin/cheatsheet generate <topic>   # generate <topic>/index.html + rebuild root index
bin/cheatsheet list               # list existing sheets
```

Generating an existing topic prompts before overwriting. The tool never touches
git — you commit and push the results yourself.

## How it works

1. **Generate** — renders `prompts/generate.md` with the topic and calls
   `claude -p --tools ""` to get a self-contained HTML document back as text.
2. **Self-review** — a second `claude -p` call (`prompts/review.md`) checks factual
   accuracy and contract compliance, returning `VERDICT: PASS|FAIL` plus issues.
   On failure it regenerates once with the issues appended, then gives up loudly.
3. **Write** — saves `<topic>/index.html`, rebuilds the root `index.html` topic
   listing, and opens the sheet for a human eyeball pass before you commit.

See [DESIGN.md](DESIGN.md) for the full design, decisions, and tradeoffs.

## Tests

```bash
ruby test/cheatsheet_test.rb
```

## Publishing

GitHub Pages serves from the root of `main`, so `postgresql/index.html` →
`/cheatsheets/postgresql/`. Pushing to `main` rebuilds the site automatically.
