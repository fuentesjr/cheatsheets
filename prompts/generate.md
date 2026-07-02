Generate a single-file interactive HTML cheatsheet for: **{{TOPIC}}**

## Output format — strict

- Output ONLY a complete HTML document, starting with `<!DOCTYPE html>` and ending with `</html>`.
- No markdown code fences. No prose, explanation, or comments before or after the document.
- One file, fully self-contained: all CSS in `<style>`, all JS in `<script>`, inline. Zero external requests — no CDNs, no web fonts, no remote images, no `<link>` or `<script src>` to any URL. It must work offline when opened from `file://`.

## Mandatory interactive features (all four, working)

1. **Live search/filter** — a text input that filters entries as the user types. Non-matching entries (and sections left empty) are hidden; clearing the input restores everything.
2. **Copy-to-clipboard** — every code snippet has a copy button that copies the snippet text and shows brief visual feedback (e.g., "Copied!" for ~1–2s). Use `navigator.clipboard` with a `document.execCommand('copy')` fallback for `file://` contexts.
3. **Collapsible sections** — every section can collapse/expand via its heading (use `<details>/<summary>` or an equivalent with a button, not a bare clickable div).
4. **Dark/light toggle** — a visible toggle that persists the choice in `localStorage` and defaults to `prefers-color-scheme` when nothing is stored. Apply the stored theme before first paint to avoid flash.

## Content

- Dense reference material: commands, code snippets, flags, options, config keys, keyboard shortcuts, and gotchas. Not a tutorial — no long explanations, no "in this section we will".
- Accurate for the current stable version of {{TOPIC}}. Omit anything you are unsure about rather than guessing; do not include deprecated commands or flags without marking them deprecated.
- Choose the sections and visual organization that best fit {{TOPIC}} — group by workflow, subsystem, or task as appropriate. Aim for the coverage an experienced user would want pinned next to their editor.
- Title the page "{{TOPIC}} Cheatsheet" (adjust capitalization to the topic's canonical name).

## Quality bar

- Keyboard accessible: search input, copy buttons, section toggles, and theme toggle all reachable and operable via keyboard; use real `<button>` elements and sensible focus styles.
- Readable in both themes: sufficient contrast for body text, code, and muted text in dark and light modes.
- Semantic HTML, monospace code blocks, comfortable information density on desktop and usable on mobile.
- No JavaScript errors on load; all features work with the page opened directly from disk.
