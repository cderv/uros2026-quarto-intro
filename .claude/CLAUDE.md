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
- **Talk type:** short intro to Quarto oriented to official-statistics publications, aimed at
  bringing in new users: why Quarto matters to people who already use R and communicate statistics.
  Storytelling first (hook, unfold, open up), little technical detail, no live rebuild. The talk
  stands on its own: no structural reliance on the talks before it in the session.
- **Core message (governing idea, may be adjusted with the outline):** By publishing with Quarto
  (reproducible: every number computed from your R code; one source for HTML, PDF, Word and your
  website; publication-ready tooling: figures, tables, cross-references, your institute's look),
  you get publications that stay correct and consistent everywhere and update in one run, for
  statistics you communicate faster, to every audience, with confidence.
- **Candidate closing line:** "You already do R. You already publish. Quarto makes it
  reproducible, from one source, ready to publish."
- **Closing:** standard EN "Learning More" (Getting started, guide, gallery, Awesome Quarto), slide
  URL first.
- **Slides URL:** <https://cderv.github.io/uros2026-quarto-intro/>
- **Work tracking:** braid, label `uros2026`

## Context files

| File | Contents |
|------|----------|
| `.claude/rules/presentation-style.md` | Narrative arc, slide types, signature phrases, opening and closing formulas, CSS classes, code display |
| `.claude/rules/presentation-config.md` | YAML boilerplate, file structure, extensions, opening and closing templates |
| `.claude/talk-inventory.md` | Not auto-loaded, read it for the Material step. Christophe's previous talks: event, year, language, published URL, GitHub repo. Reuse material from them instead of starting from scratch |
| `.claude/connect-cloud-preview.md` | Not auto-loaded, read it when publishing a preview or when the CI publish step fails. How every push publishes the deck to Posit Connect Cloud, one-time setup, token secrets, renewal |
| `.claude/rules/public-repo.md` | What must never be committed to this public repository |
| `.claude/audience.md` | uRos audience, our session and its neighbours, themes of past editions, material to reuse from previous talks |
| `.claude/skills/braid/` | braid skill (managed by `braid agents-info --install`; do not edit) |
| `.claude/skills/brand-yml/`, `quarto-authoring/`, `alt-text/` | Posit skills from `posit-dev/skills` (`_brand.yml`, Quarto authoring, figure alt text), pinned in `skills-lock.json`; update with `just skills-update`, do not edit |
| `justfile` | Build, check and publish recipes (`just` lists them) |
| `.claude/settings.json` | No Claude attribution trailers or session URLs in commits and PRs |

## Preparing the talk

Each step is a braid task under the talk's epic (see **Work tracking**).

1. Framing: fill in **This talk**; ask for any field that is still TODO.
2. Audience: analyse the conference programme and past editions (who attends, recurring themes,
   our session and its neighbours). Record the public, de-personalised result in
   `.claude/audience.md`.
3. Material: find the closest previous talks in `.claude/talk-inventory.md`, clone them read-only and note
   what to reuse.
4. Story: brainstorm the narrative and the core message.
5. Agree on a timed outline before writing slides.
6. Build the slides. `index.qmd` already follows the EN boilerplate. For a FR talk, add
   `lang: fr` and `from: markdown+emoji`, then switch the opening and closing to the FR formulas.
   Add the conference logo to `images/` and set `logo:` and the title-slide image.
7. Rehearse and time it; review the deck. Run `node scripts/check-slides.mjs --strict` and look
   at the screenshots in `_check/slides/` (see **Checking the deck**).
8. Publish (gh-pages, PDF for the organisers with `--pdf-only`), then add the talk to
   `talk-inventory.md` in the template repository so the next talk starts with the full list.

## Work tracking

braid holds the plan and the history of the talk; the repository holds only the result.

- Start every session with `braid ready --label <talk-label>`, then `braid show` the
  highest-priority ready task and read its latest comment starting with `HANDOFF`: it says where
  the previous session stopped and what to do next. Run `braid agents-info` when the workflow is
  unclear. Never run `braid secret` unless asked.
- End every session with a `HANDOFF` comment on the next task to pick up: state, key facts,
  what to do first, what was lost with the container (scratchpad files). Handoffs live in braid,
  never in a file in this repository.
- One epic per talk, one task per step of **Preparing the talk**, linked to the epic
  (`--deps parent-child:<epic>`) and to each other with `blocks` dependencies. File work found on
  the way with `--deps discovered-from:<current>`.
- Claim a task when starting it (`braid update <id> --status in_progress`). Record each decision
  as it is made with `braid comment <id> "..."`. Close with `braid close <id> --reason "..."` only
  once Christophe agrees.
- Where things go:
  - decisions, working notes, anything about named people or private exchanges → braid comments;
  - durable, public, de-personalised context → `.claude/` (for example `.claude/audience.md`);
  - talk content → `index.qmd`, `images/`.
- Never write braid IDs (`br-...`) in files or commit messages.

## Conventions

- Author: Christophe Dervieux, affiliation: Posit PBC.
- Use `pagetitle:`, not `title:`; the title slide is the custom HTML block in `index.qmd`.
- One idea per slide. `{.hl}` for key terms. `{footer=false}` on full-bleed image or iframe slides.
- Every meaningful image has alt text (`fig-alt`).
- Do not edit `_extensions/` by hand; update with `quarto add` or `quarto update`.

## Commands

`just` (<https://just.systems>) runs every task; `just` alone lists the recipes.

```bash
just preview          # live preview of the slides
just check            # render + browser + layout checks, screenshots in _check/slides/
just pdf              # slides-full.pdf for the organisers
just gallery          # screenshots of the public Quarto publications shown on the gallery slide
just example-deps     # install the example's R packages (rig proj sync, example/rproj.lock)
just example          # render the example bulletin in example/
just publish          # check, then publish the slides to gh-pages (asks for confirmation)
just publish connect  # same, to the preview on Posit Connect Cloud (after the one-time setup)
```

The recipes call these commands, which also work without `just`:

```bash
quarto preview index.qmd
quarto render index.qmd
node scripts/check-slides.mjs --strict --pdf
node scripts/check-slides.mjs --pdf-only [--pdf-fragments]
quarto publish gh-pages index.qmd
```

## Checking the deck

`scripts/check-slides.mjs` renders `index.qmd`, opens it in Chromium through Playwright, shows
every slide with all its fragments, and reports:

- render: `quarto render` failures; its WARNINGs (unresolved cross-reference...) are errors with
  `--strict`;
- browser: JavaScript and console errors, failed requests (images, fonts, iframes), broken images;
  what a site shown in an iframe fails to load is only a warning;
- layout: content outside the slide box (1280x720) is an error, a code block that scrolls is a
  warning. `.r-fit-text`, `.absolute` and `.scrollable` are skipped; add `.no-overflow-check` to a
  slide or an element to skip it on purpose.

Outputs go to `_check/` (gitignored): `slides/NN-<id>.png`, `report.json`, `report.md`. Exit code
0 means no error, 1 errors in the deck, 2 a tool problem. `--no-render` reuses `index.html`;
`--help` lists every option.

The PDF uses revealjs `?print-pdf` in the same browser: fragments in their final state, notes
hidden, Google fonts loaded, background iframes replaced by the screenshot taken during the walk.
The deck's YAML options `pdf-separate-fragments`, `pdf-max-pages-per-slide` and `show-notes` apply.

Setup:

- Claude cloud sessions: nothing to install; Playwright and Chromium are preinstalled. Do not
  install another Playwright version and do not use Docker.
- Locally (Windows, macOS, Linux), once per clone: `npm install --no-save playwright`, then
  `npx playwright install chromium`. Needs Node.js 18 or later.
- GitHub: `.github/workflows/check-slides.yml` runs the check with `--strict --pdf` on every push
  and uploads screenshots, reports and PDF as the `check-slides` artifact.

Bulletin screenshots (`just captures`, script `example/captures.R`): webshot2 drives Chrome for the
HTML, pdftools reads the PDF; both are dev dependencies in `example/rproj.toml`, installed by
`just example-deps`. Locally, an installed Chrome is enough (chromote looks in the standard
install locations); on Linux, pdftools also needs the Poppler library (`libpoppler-cpp`).
In Claude cloud sessions, the SessionStart hook `.claude/hooks/session-start.sh` (cloud only)
installs Poppler and veraPDF, runs `rig proj sync` in `example/` when `rproj.lock` changed, and
sets `CHROMOTE_CHROME` to the preinstalled Chromium.

Fallback if the PDF looks wrong: decktape through npx, still without Docker (slower, renders live
iframes). In cloud sessions, point it to the preinstalled Chromium and skip Puppeteer's download:

```bash
PUPPETEER_SKIP_DOWNLOAD=1 npx -y decktape reveal --chrome-path /opt/pw-browsers/chromium --chrome-arg=--no-sandbox -s 1280x720 index.html slides-full.pdf
```

Locally, `npx -y decktape reveal -s 1280x720 index.html slides-full.pdf` downloads its own Chrome.

