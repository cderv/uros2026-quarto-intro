# Quarto talk template

Starter for Christophe Dervieux's Quarto talks: `clean-revealjs` slides with the usual theme,
plugins and Claude Code context.

## Start a new talk

```bash
gh repo create cderv/<talk-repo> --public --template cderv/quarto-talk-template --clone
```

Then fill in **This talk** in `.claude/CLAUDE.md`, replace `REPO-NAME` and the placeholders in
`index.qmd`, and add the conference logo to `images/`.

## What is inside

- `index.qmd`: title slide, EN Quarto opening and closing ("Learning More")
- `reveal-style.scss`, `revealjs-tweak.html`: theme overrides and title-slide logo tweak
- `_extensions/`: `grantmcdermott/clean` and `quarto-ext/attribution`
- `.claude/`: talk context, style and configuration rules, inventory of previous talks
