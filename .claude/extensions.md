# Extensions used by the deck

Read this before using or changing an extension's markup in `index.qmd`. The extensions live in
`_extensions/`: never edit them by hand, update them all with `just extensions-update` (the
recipe lists the GitHub sources). After an update, run `just check` and look at the slides that
use the extension.

| Extension (version) | Kind | Used for | In the deck |
|---|---|---|---|
| `grantmcdermott/clean` (1.0.0) | format | `clean-revealjs`, the theme of every talk since 2023 | `format: clean-revealjs` |
| `emilhvitfeldt/quarto-revealjs-magic-move` (0.4.0) | revealjs plugin | code that morphs between steps | X1 code slides, X2 YAML build, `#again` / `#again-fix` |
| `emilhvitfeldt/quarto-revealjs-timing-bar` (0.1.0) | filter + plugin | a progress bar against the spoken time | every slide (`timing-duration`) |
| `emilhvitfeldt/quarto-timeline` (1.0.0) | filter | a horizontal timeline built one event at a time | `#quarto-today` |
| `emilhvitfeldt/quarto-easycarousel` (0.1.0) | filter | an autoplaying carousel of screenshots | `#products` (gallery) |
| `mcanouil/quarto-iconify` (4.2.2) | shortcode | icons by name | Thursday cards (`mdi` set) |
| `jmbuhr/quarto-qrcode` (0.0.1) | shortcode | a QR code to the slides | Learning More |
| `quarto-ext/attribution` (0.1.1) | revealjs plugin | a credit in the slide corner (`::: attribution`) | loaded, not used: the schematic credit is a `.small-cap` caption |
| `blairj09/annotate` (0.3.0) | filter | a review toolbar: comments pinned on slides, sent to the editor | off by default, `just preview annotate` |

## How each one is used here

### clean (format)

`format: clean-revealjs` with `theme: [default, reveal-style.scss]`. Use `pagetitle:`, never
`title:` (the title slide is the custom HTML block). Base styles come from the extension; deck
styles go in `reveal-style.scss`.

### magic-move (code morphing)

Two forms, which behave differently:

- **On the slide** (`## Title {.magic-move}`, one code block per slide): the code morphs from one
  slide to the next. Quarto's `code-line-numbers` highlight works; this is the form to use when a
  line must be highlighted. The X1 slides (`#r-code` to `#inline`), the X2 build and
  `#again` / `#again-fix` use it.
- **In a div** (`::: {.magic-move}` with several code blocks): the steps happen on one slide, but
  the plugin draws its own copy of the code, so `code-line-numbers` highlights are lost and a line
  number gutter appears. Avoid it when a highlight matters.

Deck CSS that goes with it (`reveal-style.scss`): the line-number gutter and its anchor are
hidden on `section.magic-move` code (the anchor took line height and made tall blocks scroll),
and the X1 code is set at 0.85em with a 1.15 line height so 24 lines fit without scrolling.
`code-line-numbers` counts the lines as written in `index.qmd`: after the editor reformats a code
block (one argument per line), recount the highlighted lines.

`just check` captures a magic-move slide before its animation ends, so the next slide's screenshot
can show ghost code from the previous one. Check those slides live or with a settled screenshot.

### timing-bar (time budget)

`timing-bar: duration: 12m30s` in the format options sets the bar to the ceiling. Each slide has
`timing-duration="..."`; the first slide of a part has `.timing-section` and
`timing-title="X1 · ..."`. The per-part budgets are in `.claude/rules/deck-structure.md`; keep
the durations aligned with it.

### timeline

`::: timeline` with one `::: {.event .fragment data-label="2022"}` per event (bold name, then one
line). Used once, on `#quarto-today`.

### easycarousel (gallery)

A fenced block ```` ```{.carousel #gallery autoplay="2500" effect="scale" ...} ```` with one image
per line (the caption is the image text; keep it short, it shows for 2.5 s). Deck additions:

- `revealjs-tweak.html` restarts the carousel from the first image when its slide is shown, stops
  it on the last image and pauses it when the slide is left (the extension autoplays from page
  load and loops).
- On the next click the carousel fades out and a static grid of the same thumbnails (with links
  and a line of names) takes its place. The PDF export shows only the grid.

### iconify (icons)

`{{< iconify mdi file-word-box >}}`: the set (`mdi`), then the icon name. The `iconify-icon` web
component fetches each icon from the Iconify servers when the deck is viewed, so the icons need
network. The extension can preload icons from a JSON file for offline use (its filter reads them
into `window.IconifyPreload`); this deck does not do it yet.

### qrcode

`{{< qrcode https://cderv.github.io/uros2026-quarto-intro/ width=200 height=200 >}}` on the
Learning More slide.

### attribution

Installed with the template (`::: attribution` puts a credit in the corner, see
`presentation-style.md`). Not used in this deck: the Horst schematic is credited in its caption.

### annotate (review toolbar)

Adds a toolbar to the rendered deck to pin comments on slides and send them to the editor
(Positron), through a notes server that the editor extension runs on `127.0.0.1:4850`.

- Off by default: `annotate: false` in the YAML of `index.qmd`. Render, check, PDF, CI and every
  publish path get the deck without it.
- On for a review: `just preview annotate` (`quarto preview index.qmd -M annotate:true`).
- Without the editor's notes server, every slide with notes logs a failed request to
  `127.0.0.1:4850`; `just check --strict` counts those as errors. This is why it is off by
  default.
- Review notes are saved next to the deck as `*.annotations.json` (gitignored, never commit them).

## Deck additions that are not extensions

- **Section label** (`kicker`): `## Title {kicker="Ready to publish"}` shows a small label above
  the heading (`reveal-style.scss`, `section[data-kicker]::before`). It marks where we are in the
  story (talk-voice F7). Leave it off a slide that does not belong to the claim (the schematic).
- **Frames on screenshots**: `.hl-shot` + `[]{.hl-box style="left: ..%; top: ..%; ..."}` places a
  frame in % of the image (`#one-render`, `#render-cli`). `#crossref` uses `.xr-box .absolute` in
  px, measured on the rendered slide: re-measure after any change to the code text above.
- **`revealjs-tweak.html`**: hides the logo on the title slide, sizes images in `r-vstack`,
  lifts the screenshots out of their `<p>` in `.shots-v` (otherwise auto-animate moves the `<p>`
  as well as the image and the screenshots jump), and drives the gallery carousel.
- **Print**: `.print-hide` / `.print-only` swap content in the PDF export (the scrolling PDF pages
  on `#pdf`, the gallery carousel).
