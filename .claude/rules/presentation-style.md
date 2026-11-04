# Presentation Style Rules

Rules for helping Chris (cderv) prepare talks. Apply when drafting slides, suggesting structure, or reviewing content in this folder.

---

## Talk Format

All talks since 2023 use **Quarto RevealJS** with the `clean-revealjs` extension (Grant McDermott's `grantmcdermott/clean`). Earlier talks (2021–2022) used **xaringan**. The canonical format since 2023 is `clean-revealjs`.

**Two talk types:**
- **Intro/overview talk** (40–60 min, 40–60 slides) — full "What / Why / How / Features" arc
- **Topic-specific talk** (20 min, 15–50 slides) — 1–2 context slides then straight to topic

---

## Narrative Arc

### Full intro talk arc (EN):
1. Custom title slide (raw HTML, not YAML `title:`)
2. `# What is Quarto?` section — italic framing subtitle
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
- `# Qu'est-ce que Quarto?` with subtitle `*C'est comme R Markdown non ?*`
- `# Des questions ?` + `Merci!` section slide as final (replaces "Learning More")
- Icons: `{{< fa tv >}}` for slides link, `{{< fa brands github >}}` for repo

### Topic-specific talk arc (short, FR or EN):
1. Title slide
2. 1–2 Quarto context slides (very brief, audience already knows Quarto)
3. Problem statement ("Déjà bien, mais..." / "But what about X?")
4. Solution sections
5. Summary/recap
6. Questions + slide URL

---

## Signature Phrases (EN) — use verbatim

| Phrase | Where |
|--------|-------|
| `"Quarto is the next generation of R Markdown: It unifies and extends it"` | `#` section subtitle (italic) |
| `"...is an open-source, scientific, and technical publishing system"` | First definition slide |
| `"you can weave together narrative text and code to produce elegantly formatted output"` | Second content slide |
| `"just like R Markdown... but not just like it, there's more to it"` | `. . .` fragment build |
| `"Posit's attempt to bring 10-years experience of R Markdown to everyone"` | Why section |
| `"A lot more can be done with [**Quarto**]{.hl}"` | Closing (recent EN) |

## Signature Phrases (FR) — use verbatim

| Phrase | Where |
|--------|-------|
| `"C'est comme R Markdown non ?"` | Section subtitle opener |
| `"...est un nouveau système de publication scientifique et technique à code source ouvert"` | Definition |
| `"unifie et étend l'écosystème R Markdown"` | Build slide |
| `"Déjà bien, mais..."` | Problem statement transition |
| `"Prenons un exemple"` | Demo slide intro |

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

**Section divider (`#` level)** — always include italic framing line:
```markdown
# What is Quarto?

*Quarto is the next generation of R Markdown:\
It unifies and extends it*
```

**Progressive build** — use `auto-animate="true"` across 3 consecutive slides for the "unifies + extends" sequence. Also used for R Markdown → Quarto syntax comparison with `data-id` on divs.

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

EN: Title → `# What is Quarto?` (with signature italic framing) → definition + schematic → `. . .` reveals → "weave together" paragraph

FR: Title → `# Qu'est-ce que Quarto?` (with `*C'est comme R Markdown non ?*`) → definition → `auto-animate` build

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

**PyData / newer EN:** fragment-animated closing with social icons, then `[Thank You !]{.hl}` in large absolute-positioned text.

Always put slide URL **first** in the closing. Never omit it.

---

## Text Emphasis

- `[text]{.hl}` — primary highlight (colored background/text). Use for key terms: "multi-language", "multi-engine", "R Markdown", technical terms being introduced
- `**bold**` — secondary emphasis
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
