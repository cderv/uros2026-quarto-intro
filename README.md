# Quarto talk template

Starter for Christophe Dervieux's Quarto talks: `clean-revealjs` slides with the usual theme,
plugins and Claude Code context.

## Start a new talk

```bash
gh repo create cderv/<talk-repo> --public --template cderv/quarto-talk-template --clone
```

Then fill in **This talk** in `.claude/CLAUDE.md`, replace `REPO-NAME` and the placeholders in
`index.qmd`, and add the conference logo to `images/`.

## Check the deck and export the PDF

`scripts/check-slides.mjs` renders the deck, walks every slide in Chromium and reports render
warnings, console errors, failed requests, broken images and content outside the 1280x720 slide,
with one screenshot per slide in `_check/slides/`. The same walk exports the PDF, without Docker.

```bash
# once per clone (not needed in Claude cloud sessions, where Playwright is preinstalled)
npm install --no-save playwright
npx playwright install chromium
```

```bash
node scripts/check-slides.mjs --strict --pdf
```

Exit code 0 means no error, 1 errors in the deck, 2 a tool problem. `--pdf-only` exports the PDF
without the checks; `--help` lists every option. On GitHub, `.github/workflows/check-slides.yml`
runs the same command on every push and uploads screenshots, reports and `slides-full.pdf` as the
`check-slides` artifact. Details in `.claude/CLAUDE.md`, section **Checking the deck**.

## What is inside

- `index.qmd`: title slide, EN Quarto opening and closing ("Learning More")
- `reveal-style.scss`, `revealjs-tweak.html`: theme overrides and title-slide logo tweak
- `_extensions/`: `grantmcdermott/clean` and `quarto-ext/attribution`
- `scripts/check-slides.mjs`, `.github/workflows/check-slides.yml`: deck check and PDF export,
  locally and on every push
- `.claude/`: talk context, style and configuration rules, inventory of previous talks
