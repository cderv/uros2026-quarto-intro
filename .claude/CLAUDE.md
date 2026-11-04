# Quarto talk

This repository holds one talk by Christophe Dervieux (cderv): Quarto `clean-revealjs` slides in
`index.qmd`. It was created from `cderv/quarto-talk-template`. Fill in **This talk** below during
the first session, then keep it current.

## This talk

- **Title:** Reproducible Statistical Publications with Quarto (official programme title)
- **Event, date, place:** uRos2026, 14th International Conference on the Use of R in Official
  Statistics, hosted by INSEE. Thursday 19 November 2026, session C1 "Automated and Accessible
  Statistical Outputs" (11:30–13:00, 4th of 5 talks), room Bloch-Lainé 2, Centre de conférences
  Pierre Mendès France, 139 rue de Bercy, Paris. Conference site: <https://urosconf.org/>
- **Language:** EN
- **Duration:** 15 min
- **Audience:** international official statisticians (national statistical institutes, Eurostat,
  international organisations, central banks, some academia). They know R; most know the R Markdown
  name, few use Quarto. Details and evidence in `.claude/audience.md`.
- **Talk type:** short intro to Quarto oriented to official-statistics publications. The narrative
  arc is still open: a dedicated brainstorm comes next, once the context is complete.
- **Core message:** TODO (decided in the brainstorm)
- **Closing:** standard EN "Learning More" (Getting started, guide, gallery, Awesome Quarto), slide
  URL first.
- **Slides URL:** <https://cderv.github.io/uros2026-quarto-intro/>
- **Work tracking:** braid, label `uros2026`

## Context files

| File | Contents |
|------|----------|
| `.claude/rules/presentation-style.md` | Narrative arc, slide types, signature phrases, opening and closing formulas, CSS classes, code display |
| `.claude/rules/presentation-config.md` | YAML boilerplate, file structure, extensions, opening and closing templates |
| `.claude/rules/talk-inventory.md` | Christophe's previous talks: event, year, language, published URL, GitHub repo. Reuse material from them instead of starting from scratch |
| `.claude/rules/public-repo.md` | What must never be committed to this public repository |
| `.claude/audience.md` | uRos audience, our session and its neighbours, themes of past editions, material to reuse from previous talks |

## Preparing the talk

1. Fill in **This talk**: ask for any field that is still TODO.
2. Find the closest previous talks in `talk-inventory.md` and clone them read-only for material.
3. Agree on a timed outline before writing slides.
4. `index.qmd` already follows the EN boilerplate. For a FR talk, add `lang: fr` and
   `from: markdown+emoji`, then switch the opening and closing to the FR formulas.
5. Add the conference logo to `images/` and set `logo:` and the title-slide image.
6. When the talk is published, add it to `talk-inventory.md` in this template repository so the
   next talk starts with the full list.

## Conventions

- Author: Christophe Dervieux, affiliation: Posit PBC.
- Use `pagetitle:`, not `title:`; the title slide is the custom HTML block in `index.qmd`.
- One idea per slide. `{.hl}` for key terms. `{footer=false}` on full-bleed image or iframe slides.
- Every meaningful image has alt text (`fig-alt`).
- Do not edit `_extensions/` by hand; update with `quarto add` or `quarto update`.

## Commands

```bash
quarto preview index.qmd
quarto render index.qmd
quarto publish gh-pages
# PDF export (Docker):
docker run --rm -t -v .:/slides astefanutti/decktape -s 1280x720 generic /slides/index.html slides-full.pdf
```
