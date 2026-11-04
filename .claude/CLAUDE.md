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
| `.claude/rules/talk-inventory.md` | Christophe's previous talks: event, year, language, published URL, GitHub repo. Reuse material from them instead of starting from scratch |
| `.claude/rules/public-repo.md` | What must never be committed to this public repository |
| `.claude/audience.md` | uRos audience, our session and its neighbours, themes of past editions, material to reuse from previous talks |
| `.claude/skills/braid/` | braid skill (managed by `braid agents-info --install`; do not edit) |
| `.claude/settings.json` | No Claude attribution trailers or session URLs in commits and PRs |

## Preparing the talk

Each step is a braid task under the talk's epic (see **Work tracking**).

1. Framing: fill in **This talk**; ask for any field that is still TODO.
2. Audience: analyse the conference programme and past editions (who attends, recurring themes,
   our session and its neighbours). Record the public, de-personalised result in
   `.claude/audience.md`.
3. Material: find the closest previous talks in `talk-inventory.md`, clone them read-only and note
   what to reuse.
4. Story: brainstorm the narrative and the core message.
5. Agree on a timed outline before writing slides.
6. Build the slides. `index.qmd` already follows the EN boilerplate. For a FR talk, add
   `lang: fr` and `from: markdown+emoji`, then switch the opening and closing to the FR formulas.
   Add the conference logo to `images/` and set `logo:` and the title-slide image.
7. Rehearse and time it; review the deck.
8. Publish (gh-pages, PDF for the organisers), then add the talk to `talk-inventory.md` in the
   template repository so the next talk starts with the full list.

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

```bash
quarto preview index.qmd
quarto render index.qmd
quarto publish gh-pages
# PDF export (Docker):
docker run --rm -t -v .:/slides astefanutti/decktape -s 1280x720 generic /slides/index.html slides-full.pdf
```
