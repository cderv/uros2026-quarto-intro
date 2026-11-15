# Reproducible Statistical Publications with Quarto

Slides and supporting material for a talk at [uRos2026](https://urosconf.org/), the 14th International Conference on the Use of R in Official Statistics, in Paris on 19 November 2026.

**Slides:** <https://cderv.github.io/uros2026-quarto-intro/>

This 15-minute introduction shows how Quarto turns text and R code into reproducible statistical publications.
A Eurostat tourism bulletin illustrates one source producing HTML, PDF and Word, with computed figures and tables, cross-references and an institute's branding.

## What is inside

- `index.qmd`: the RevealJS slides, using the `clean-revealjs` theme.
- `_extensions/`: the Quarto extensions the slides use (theme, code animation, timing bar, carousel, timeline, icons, QR code, review toolbar); `.claude/extensions.md` explains each one. Update them with `just extensions-update`.
- `example/`: the example bulletin and its HTML, Typst PDF and Word configuration, a git submodule of [cderv/uros2026-quarto-example](https://github.com/cderv/uros2026-quarto-example). Clone with `git clone --recurse-submodules`, or run `just example-init` afterwards.
- `analysis/`: data, code and methodology for the analysis of uRos programmes from 2014 to 2026 used in the opening slides; see `analysis/README.md` for sources and limitations.
- `images/`: the conference logo and screenshots used in the slides.
- `scripts/check-slides.mjs`: browser-based slide checks, screenshots and PDF export.
- `justfile`: build, check, example, analysis and publishing commands.
- `.github/workflows/check-slides.yml`: the deck check and PDF export run on every push.

## Work on the slides

Install [Quarto](https://quarto.org/docs/get-started/) and [just](https://just.systems/man/en/packages.html).
Run `just` to list all available commands.

```bash
just preview           # live preview with auto-reload
just preview annotate  # same, with the annotate review toolbar (comments sent to the editor)
just render            # render index.qmd to index.html
just check             # render, check in Chromium and screenshot every slide
just pdf               # export slides-full.pdf for the organisers
```

The slide check uses Node.js 24 (see `.nvmrc`; with nvm, run `nvm use`).
Install its browser dependencies once per clone:

```bash
just setup
```

`just check` writes screenshots and reports to `_check/`.
The GitHub Actions workflow runs the same strict check, exports the PDF and uploads both as the `check-slides` artifact.

## Build the supporting material

The example bulletin uses R packages pinned in `example/rproj.lock`:

```bash
just example-deps  # check out the example submodule, install its R packages with rig
just example       # render HTML, PDF and Word to example/_output/
just captures      # screenshot the rendered bulletin for the slides
```

Other supporting commands are `just gallery` for the publication screenshots on the gallery slide, `just reference-doc` to rebuild the Word reference document from the example's branding, and `just analysis` to rebuild the scripted programme-analysis outputs after `just analysis-deps`.

## Publish

```bash
just publish          # check, then publish to GitHub Pages
just publish connect  # check, then update the Posit Connect Cloud preview
```

Both publishing commands ask for confirmation.
`just publish-only` skips the check when it has already run; it still re-renders `index.html` first.
