# Presentation Style Rules

Rules for helping Chris (cderv) prepare talks. Apply when drafting slides, suggesting structure, or reviewing content in this folder.

This file covers structure. For **wording** (hooks, bridges, slide text, notes, closings), read
`.claude/references/talk-voice.md` before drafting: it starts with Christophe's own statements
(notes are memory aids he does not read; short spoken intro; he concludes by speaking) and holds
the evidence from his decks. It extends the workshop profile `cderv/raukr-2026-quarto`, `.claude/references/house-voice.md` (not yet copied into this repository).

---

## Talk Format

All talks since 2023 use **Quarto RevealJS** with the `clean-revealjs` extension (Grant McDermott's `grantmcdermott/clean`). Earlier talks (2021–2022) used **xaringan**. The canonical format since 2023 is `clean-revealjs`. Exception: posit::conf 2025 (Lua filters) and its 2026 FR version were made in Google Slides.

**Three talk types:**
- **Intro/overview talk** (40–60 min, 40–60 slides) — full "What / Why / How / Features" arc
- **Short intro talk** (15–20 min) — two models: definition-first (useR! 2024: "What is Quarto?" / "Why Quarto?" / "How to use Quarto?", picked features, about 18 visible slides) and story-driven (PyData Paris 2025, posit::conf 2025: situation first, tool named after the first result). For 15 min, plan about 12 to 15 visible slides (estimate, durations are not on disk)
- **Topic-specific talk** (20 min, 15–50 slides) — 1–2 context slides then straight to topic

---

## Narrative Arc

### Full intro talk arc (EN):
1. Custom title slide (raw HTML, not YAML `title:`). This is the convention since 2024; the Raukr 2023/2025 intro decks still used YAML `title:`
2. `# What is Quarto?` section — italic framing subtitle (the only divider that always has one)
3. Definition slide: "...is an open-source, scientific, and technical publishing system"
4. Allison Horst schematic (`horst_quarto_schematic.png`)
5. Progressive build with `auto-animate`: "unifies + extends" (3 slides)
6. "With Quarto..." — weave narrative + code paragraph
7. `# Why Quarto?` section (sometimes hidden/optional)
8. `# How to use Quarto?` section — CLI + IDE stack + workflow diagram
9. Core feature sections (each = `#` section slide + 3–8 `##` content slides)
10. `## Learning More {.smaller}` — resource list, slide URL first
11. `#### Questions?` inline (no separate slide)

### Full intro talk arc (FR):
Same arc, but section headings in French:
- `# Qu'est-ce que Quarto ?` (French typography keeps the space before `?` and `!` in FR decks) with an italic framing line, e.g. `*Quarto est la nouvelle génération de R Markdown.*` (2024). The topic talk RR 2023 used the plain line `C'est comme R Markdown non ?` instead
- `# Des questions ?` + `Merci!` section slide as final (replaces "Learning More"), or "Learning More" with FR labels and `#### Questions?` (2024 intro)
- Icons: `{{< fa tv >}}` for slides link, `{{< fa brands github >}}` for repo

### Topic-specific talk arc (short, FR or EN):
1. Title slide
2. 1–2 Quarto context slides (very brief, audience already knows Quarto). Variant: situation first, tool named after (posit::conf 2025: a user persona says "I am stuck !"; PyData 2025: a real report and the notebook, then `## Let's use Quarto for this`; RR 2025: `# Produire des HTML` before the turn)
3. Problem statement, stated mildly: a plain connector (`On the other hand,` / `D'un autre côté,`), a question heading (`# What about theming ?`), or the user's own words (a persona bubble or blockquote). `Déjà bien, mais...` was used once (RR 2025). "But what about X?" does not occur in the Quarto-era decks
4. Solution sections (same action before/after, one line of YAML or one command, result shown, mechanism after)
5. Summary/recap (topic talks only; the intro talks end on "Learning More" with no recap), or a call to action that calls back the opening problem (posit::conf 2025)
6. Questions + slide URL

---

## Signature Phrases (EN) — use verbatim

Most of these are shared Quarto-project formulas (quarto.org, the 2022 "Hello, Quarto" material)
that he reuses in intro talks; he does not read them out. Use them verbatim where the arc calls
for them, never as a model for new sentences. His own wording is in `talk-voice.md`.

| Phrase | Where |
|--------|-------|
| `"Quarto is the next generation of R Markdown: It unifies and extends it"` | `#` section subtitle (italic) |
| `"...is an open-source, scientific, and technical publishing system"` | First definition slide (2023 had "a new,"; dropped in 2025) |
| `"Quarto is a [command line interface (CLI)]{.hl} that renders ..."` | "How to use Quarto?" slide (4 decks, 3 talks) |
| `"... you can weave together narrative text and code to produce elegantly formatted output as documents, web pages, blog posts, books and more."` | "With Quarto..." slide (Raukr intro; in notes in useR! 2024) |
| `"*just like R Markdown...*"` then `"but not *just like* it, there's more to it..."` | `. . .` fragment build (Raukr intro only) |
| `"**unifies** + **extends** the R Markdown ecosystem"` | `auto-animate` build, bold (not `{.hl}`) |
| `"Quarto is Posit's attempt to bring 10-years experience of [R Markdown to everyone]{.hl}!"` | Why section |
| `"A lot more can be done with [**Quarto**]{.hl}"` + `"Deep dive at <https://quarto.org>"` | Closing (PyData 2024 and 2025; his own wording) |

## Signature Phrases (FR) — use verbatim

| Phrase | Where |
|--------|-------|
| `"système de publication scientifique et technique"` | Definition; stable core in 3 talks, the rest varies: `"...est un nouveau système de publication scientifique et technique à code source ouvert"` (2024), `"Un système de publication scientifique et technique open-source, intégrant l'exécution de code."` (2025) |
| `"**unifie** + **étend** l'écosystème R Markdown"` | Build slide (2024); `"Quarto unifie + étend R Markdown"` (2023 heading) |
| `"... vous pouvez "tisser" ensemble du texte narratif et du code"` | "Avec Quarto..." slide |

Seen once (one talk each, use only when the situation fits): `"C'est comme R Markdown non ?"`
(RR 2023 opener line), `"Déjà bien, mais..."` (RR 2025 problem turn), `"Prenons un exemple"`
(RR 2025 example intro).

---

## Recurring Slide Types

**Custom title slide** — use raw HTML block, never YAML `title:` key:
````markdown
## {#title-slide .quarto-title-block .center}
```{=html}
<h1 class='title'>Talk Title</h1>
<p class='subtitle'>Subtitle</p>
```
![](images/conf-logo.png){.absolute bottom='35px' right='100px' width='50%'}
::: {.quarto-title-authors}
::: {.quarto-title-author}
::: {.quarto-title-author-name}
Christophe Dervieux
`<p class="quarto-title-affiliation">Posit PBC</p>`{=html}
:::
:::
:::
{{< meta date >}}
````

**Section divider (`#` level)** — the opening divider carries an italic framing line; other dividers carry an agenda list, one plain sentence, or nothing (PyData 2025: most dividers have no body). posit::conf 2025 has no divider slides: a small section label above each heading changes at section boundaries. For the opening divider:
```markdown
# What is Quarto?

*Quarto is the next generation of R Markdown:\
It unifies and extends it*
```

**Progressive build** — use `auto-animate="true"` across 3 consecutive slides for the "unifies + extends" sequence, with `**bold**` on the two verbs (every deck; the opening template in `presentation-config.md` uses `{.hl}` there, which no deck does). Also used for R Markdown → Quarto syntax comparison with `data-id` on divs.

**IDE tools r-stack** — sequential reveal of VSCode → JupyterLab → RStudio/Positron screenshots using `.fragment .fade-in-then-out` with `fragment-index`.

**Workflow diagram r-vstack** — rendering pipeline diagrams stacking vertically, fragment-by-fragment.

**Full-bleed image/iframe** — add `{footer=false}` and `{logo=false}` to hide persistent UI:
```markdown
## {background-image="images/screenshot.png" footer=false}
## {background-iframe="https://..." background-interactive=true footer=false logo=false}
```

**Demo marker** — `{.demo}` on the slide heading for live demo placeholders.

**Two-column** — use Quarto native `.columns` (not tachyons pull-left):
````markdown
::: columns
::: {.column width="50%"}
Explanation
:::
::: {.column width="50%"}
```yaml
code example
```
:::
:::
````

**Allison Horst schematic** — always include in intro/overview talks, always credit:
```markdown
![[Artwork from "Hello, Quarto" keynote by Julia Lowndes and Mine Çetinkaya-Rundel. Illustrated by Allison Horst.]{.small-cap}](images/horst_quarto_schematic.png){fig-align="center"}
```

---

## Opening Formula

EN: Title → `# What is Quarto?` (with signature italic framing) → definition + schematic → "weave together" paragraph with its `. . .` reveals → `auto-animate` build

EN, story-driven (posit::conf 2025, PyData 2025): Title → the situation (a persona's problem in their own words, or a real artefact) → a bridge from what the audience already does → one line or one command → result shown → mechanism → one definition line at most

FR: Title → `# Qu'est-ce que Quarto ?` (italic framing line) → definition → `auto-animate` build

Spoken, he keeps the intro short: "welcome everyone", a quick hook on why he is here, then the topic hook slide. No opening slide has a bio, a personal anecdote, or a question that waits for an answer from the room.

---

## Closing Formula

**EN (standard):**
```markdown
## Learning More {.smaller}

#### Slides: <https://cderv.github.io/[repo]/> {.bottom-pad}

- Getting started: <https://quarto.org/docs/get-started/>
- User guide: <https://quarto.org/docs/guide/>
- Gallery: <https://quarto.org/docs/gallery/>
- Awesome Quarto: <https://github.com/mcanouil/awesome-quarto>

#### Questions? {.top-pad}
```

**FR (Rencontres R):**
```markdown
# Des questions ?

Merci!

::: {.make-smaller}
{{< fa tv >}} <https://cderv.github.io/[repo]/>

{{< fa brands github >}} <https://github.com/cderv/[repo]>
:::
```

**FR (brand.yml / newer):**
```markdown
## Questions? {.center .bigger}

[Merci!]{.fg}
```

**PyData / newer EN:** `A lot more can be done with [**Quarto**]{.hl}` / `Deep dive at <https://quarto.org>`, then a fragment-animated closing with social icons, then `[Thank You !]{.hl}` in large absolute-positioned text (write `Thank You!` without the space in EN).

**posit::conf 2025:** a call to action that calls back the opening word (`Do consider Lua filters next time you are stuck!`), then `Thank you!` + handles + slide URL.

Always put slide URL **first** in the closing. Never omit it. (Kept as the rule although four 2024–2025 decks had it only in the "Follow along at" footer.)

The last slide is for resources; Christophe concludes by speaking. A closing line or slogan goes in the notes as a spoken line, not on a slide; no hand-written deck has a slogan slide.

---

## Text Emphasis

- `[text]{.hl}` — primary highlight (colored background/text). Use for key terms: "multi-language", "multi-engine", "R Markdown", technical terms being introduced. Sparse: about 5 per deck, on a phrase inside a sentence (`[R Markdown to everyone]{.hl}`, `[command line interface (CLI)]{.hl}`)
- `**bold**` — secondary emphasis; also the two verbs of the "unifies + extends" build
- `*italic*` — framing lines on section slides
- `[text]{.small-cap}` — image attribution captions

---

## Layout & Spacing CSS Classes

- `.columns` / `.column` — two-column layout
- `.r-stack` — layered sequential reveals
- `.r-vstack` / `.r-hstack` — vertical/horizontal stacking
- `.center` — center-aligned slide
- `.smaller` — smaller font (dense content, resource slides)
- `.nostretch` — prevent image auto-stretching
- `.bottom-pad` / `.top-pad` — vertical heading spacing
- `.make-smaller` / `.make-bigger` / `.bigger` — font size
- `.top-margin` / `.bottom-margin` — margin control

## Slide-Level Attributes

- `{footer=false}` — hide footer on full-bleed image/iframe slides
- `{logo=false}` — hide logo on demo slides
- `{visibility="hidden"}` — backup/hidden slides (kept in source, not shown)
- `{.demo}` — marks live demo placeholder slide

## Fragments & Animation

- `. . .` — inline pause within slide
- `::: incremental` — bullet-by-bullet list reveal
- `::: {.fragment}` — block fragment
- `{.fragment .fade-in-then-out fragment-index="N"}` — sequential swap in r-stack
- `auto-animate="true"` — morphing between slides (key pattern)

Builds, fragments and `code-line-numbers` steps do the pacing (posit::conf 2025: one bubble or one code callout per build); `. . .` is rare (only on the "With Quarto..." slide in two talks).

## Presenter Notes

`::: notes` are memory aids, not a script: Christophe does not read them. They hold the transition to the next section, the "why" that the slide leaves to an image or code, and stage cues ("Click on the link to show example"). The attested spoken bridges are few and one line long ("Next, let's focus on ..."): never fill notes with paragraphs. The slide never narrates the transition; it shows where we are in the story (a section label that changes, a diagram or image that comes back with the current step marked). Details: `.claude/references/talk-voice.md`.

## Attribution Pattern

```markdown
::: attribution
[Source text or link]{.make-smaller}
:::
```
The `attribution` plugin renders this in the corner. Always include for Allison Horst artwork and any borrowed diagrams.

---

## Code Display

- `code-line-numbers: false` globally — line numbers are opt-in per block only
- Per-block line highlighting: `{.bash code-line-numbers="|1|4|17|18"}` — pipe-separated steps; `|` at start shows all first
- Long code blocks: wrap in `::: {.make-smaller}` or use `::: {.r-fit-text}`
- Filename labels: `` ```{.yaml filename="_quarto.yml"} `` — use for config file demos
- Languages by frequency: bash, yaml, r, markdown, python, scss, lua

---

## Social Handles (current)

`{{< fa brands github >}} {{< fa brands bluesky >}} {{< fa brands mastodon >}} \@cderv  &#183; {{< fa brands linkedin >}} \@chrisderv`

Author name: **Christophe Dervieux**, affiliation: **Posit PBC**

---

## What NOT to Do

- Do NOT use YAML `title:` key — it triggers Quarto's auto-title slide; use `pagetitle:` + custom title slide HTML block
- Do NOT use tachyons utilities (`.fl.w-50`, `.pull-left`) — those are xaringan era
- Do NOT use `???` for speaker notes — use `::: notes` divs
- Do NOT use `---` slide separators — use `##` headings
- Do NOT omit the slide URL in the closing slide
- Do NOT use bio/profile-photo slide (dropped in Quarto era)
- Do NOT write em-dash asides on slides (`---` appears only as a heading separator in three decks), and do NOT ask the room for a show of hands (no talk does): see `.claude/references/talk-voice.md`
- Do NOT use a colon that replaces the verb or stages a reveal (`X: computed`), and keep colons sparse (about one every five slides, none on consecutive titles): talk-voice.md, limits of S4 and F10
