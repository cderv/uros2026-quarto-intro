# Presentation Configuration & Templates

Technical setup for new Quarto RevealJS talks using Chris's canonical stack.

## Quarto and RevealJS documentation

For Quarto's RevealJS syntax and options, consult the official documentation through
<https://quarto.org/llms.txt>. Follow the relevant `.llms.md` pages for RevealJS
basics, advanced features, and the format reference. For underlying RevealJS behavior
or raw HTML/JavaScript features not covered by Quarto, consult
<https://revealjs.com/llms.txt>. Context7's official Quarto library can help with
targeted searches. Project rules remain authoritative for this deck's conventions.

---

## File Structure

```
talk-name/
├── index.qmd              # Main slide file (single talk)
├── _quarto.yml            # Only for multi-file projects (tutorials)
├── reveal-style.scss      # Project-specific SCSS overrides
├── revealjs-tweak.html    # JS tweaks (hides logo on slide 1, fixes r-vstack images)
├── scripts/
│   └── check-slides.mjs   # Deck check (render, browser, layout) and PDF export
├── .github/workflows/
│   └── check-slides.yml   # Runs the check on every push, uploads screenshots and PDF
├── _extensions/
│   ├── grantmcdermott/
│   │   └── clean/         # clean-revealjs format
│   ├── quarto-ext/
│   │   └── attribution/   # attribution corner plugin
│   └── ...                # optional ones; this deck's list: .claude/extensions.md
└── images/
    ├── conference-logo.png
    └── horst_quarto_schematic.png   # Required for Quarto intro talks
```

---

## YAML Boilerplate

### Standard EN talk:

```yaml
---
pagetitle: "[Talk Title] - [Conference Name]"
date: MM/DD/YYYY
format:
  clean-revealjs:
    width: 1280
    height: 720
    theme: [default, reveal-style.scss]
    footer: Follow along at <https://cderv.github.io/[repo]/> and <https://quarto.org>
    code-line-numbers: false
    slide-number: true
    mermaid-format: png
    preview-links: auto
    multiplex: false
    include-after-body:
      - revealjs-tweak.html
    logo: images/[conference]-logo.png
revealjs-plugins:
  - attribution
---
```

### FR additions (prepend after `date:`):

```yaml
lang: fr
from: markdown+emoji
```

### When slides have executable code:

```yaml
execute:
  cache: true
```

### When using background-iframe live demos:

```yaml
format:
  clean-revealjs:
    preload-iframes: true
```

### When enabling `multiplex` (audience follows presenter):

```yaml
format:
  clean-revealjs:
    multiplex: true
```

### Editable plugin (PyData-style, allows live text edit in presentation):

```yaml
filters:
  - editable
revealjs-plugins:
  - editable
  - attribution
```

---

## Key YAML Choices

| Key | Value | Why |
|-----|-------|-----|
| `pagetitle` (not `title`) | `"Talk - Conf"` | Allows custom title slide HTML; `title:` triggers Quarto auto-title |
| `clean-revealjs` | always | Grant McDermott's clean theme, consistent across all Quarto talks |
| `theme: [default, reveal-style.scss]` | always | Base + project SCSS overrides |
| `code-line-numbers: false` | globally | Opt-in per block only; avoids noise |
| `attribution` plugin | always | Image credits in corner |
| `revealjs-tweak.html` | always | Hides logo on title slide, fixes r-vstack image sizing |
| `mermaid-format: png` | always | Reliable rendering across environments |

---

## Title Slide Template

````markdown
## {#title-slide .quarto-title-block .center}

```{=html}
<h1 class='title'>Talk Title Here</h1>
<p class='subtitle'>Subtitle if any</p>
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

---

## Opening Slides Template (EN Quarto intro)

```markdown
# What is Quarto?

*Quarto is the next generation of R Markdown:\
It unifies and extends it*

## Quarto ...

...is an open-source, scientific, and technical publishing system

- Computations: Python, R, Julia, Observable JS
- Markdown: [Pandoc](https://pandoc.org) w/ many enhancements
- Output: Documents, presentations, websites, books, blogs

![[Artwork from "Hello, Quarto" keynote by Julia Lowndes and Mine Çetinkaya-Rundel. Illustrated by Allison Horst.]{.small-cap}](images/horst_quarto_schematic.png){fig-align="center"}

## With Quarto ...

you can **weave together** narrative text and code to produce elegantly formatted output.

. . .

Just like R Markdown...

. . .

... but not just like it, there's more to it.

## Quarto ... {.center auto-animate="true"}

**unifies** + **extends** the R Markdown ecosystem

## Quarto ... {.center auto-animate="true"}

**unifies** + **extends** the R Markdown ecosystem

**unifies** for people who love R Markdown

## Quarto ... {.center auto-animate="true"}

**unifies** + **extends** the R Markdown ecosystem

**unifies** for people who love R Markdown

**extends** for people who don't know R Markdown
```

---

## Closing Slides Template (EN)

```markdown
## Learning More {.smaller}

#### Slides: <https://cderv.github.io/[repo]/> {.bottom-pad}

- Getting started: <https://quarto.org/docs/get-started/>
- User guide: <https://quarto.org/docs/guide/>
- Gallery: <https://quarto.org/docs/gallery/>
- Awesome Quarto: <https://github.com/mcanouil/awesome-quarto>

#### Questions? {.top-pad}
```

## Closing Slides Template (FR — Rencontres R)

```markdown
# Des questions ?

Merci!

::: {.make-smaller}
{{< fa tv >}} <https://cderv.github.io/[repo]/>

{{< fa brands github >}} <https://github.com/cderv/[repo]>
:::
```

---

## Installing Extensions

```bash
# Add clean-revealjs (always required)
quarto add grantmcdermott/clean

# Add attribution plugin (always required)
quarto add quarto-ext/attribution

# Add fontawesome shortcodes (FR talks, social handles)
quarto add quarto-ext/fontawesome
```

Optional extensions used by the uRos 2026 deck (code morphing, timing bar, carousel, timeline,
icons, QR code, review toolbar): see `.claude/extensions.md` for what each does, how it is used and
its pitfalls. Once installed, `just extensions-update` updates them all; add any new extension to
that recipe.

The editable plugin of the PyData decks is not set up here; check its source before adding it.

---

## Publishing

```bash
# Render
quarto render index.qmd

# Check the deck before publishing (screenshots in _check/slides/)
node scripts/check-slides.mjs --strict

# Publish to GitHub Pages
quarto publish gh-pages

# PDF for the organisers (descriptive filename), without Docker
node scripts/check-slides.mjs --pdf-only slides-uros2026-reproducible-statistical-publications-with-quarto.pdf --pdf-fragments
```

Setup, options and the decktape fallback: `.claude/CLAUDE.md`, section **Checking the deck**.

All published talks use GitHub Pages. Slides URL always follows pattern:
`https://cderv.github.io/[repo-name]/`

Exception: posit::conf 2025 published to `https://cderv.quarto.pub/posit-conf-2025-quarto-lua/`.
