# Reference: talk voice (how Christophe words a talk)

## How to use this file

- **Who reads it:** any agent that writes or reviews slide text, section bridges, hooks, presenter
  notes or closings for one of Christophe's **talks** (conference talk or lecture, 15 to 60 min).
- **When:** before drafting slide wording (Story and Build steps), and again when reviewing a deck.
- **What it adds:** `cderv/raukr-2026-quarto`, `.claude/references/house-voice.md` (not yet copied into this repository) is the validated profile for all prose
  (short declarative spine, parentheses for asides, colon before examples, no em-dash, no idioms,
  the machine-tell list). It was built from workshops and is not repeated here. This file records
  what is specific to talks and names where talks differ from workshops (section 15).
- **Structure rules** (title slide, arc, CSS classes) stay in `.claude/rules/presentation-style.md`.
- **Order of authority:** Christophe's own statements (section 0) > patterns from his hand-written
  decks (sections 1 to 10) > shared Quarto wording (section 11) > 2026 material that may be assisted.

## 0. First-hand statements (Christophe, 2026-11-08)

These outrank every inferred pattern below.

- **F1. Notes are memory aids, not a script.** He does not read his notes. *Superseded for the uRos
  2026 deck by F11.*
- **F2. The intro is short.** "Welcome everyone", then directly a quick hook that says why he is
  here, then quickly the slide that hooks the topic.
- **F3. He does not read the formula lines** (the recurring Quarto definitions); they support what
  he says.
- **F4. The last slide is for resources; he concludes by speaking.** A closing line such as the
  one in CLAUDE.md belongs in the notes as a spoken line, not on a slide.
- **F5. His most prepared talk is posit::conf 2025 (Lua filters)**: the closest model for a
  story-driven conference talk (section 12).
- **F6. Recordings exist on YouTube.** They are not in this corpus (section 15).
- **F7. Transitions use visual cues of where we are in the story.** The audience keeps track of
  the talk through what is on screen: a section label that changes, a diagram or image that comes
  back with the current step marked (as in posit::conf 2025, section 12). The bridge itself is
  spoken. Slides never narrate it ("Now let's see...").
- **F8. Validated for the uRos opening:** "Welcome everyone", a one-line hook on why he is here,
  then a real publication with the doubt voiced as a persona line; Quarto defined in one line only
  after the first result.
- **F9. Banned in his talks:** dramatic hooks, "X isn't just Y" flips, three-beat slogans,
  show-of-hands questions (section 14). Closing as F4, a callback to the opening is allowed.
- **F10. Colons (2026-11-13).** Label + colon stays his form, but never as a reveal that replaces
  the verb, and sparingly: about one colon device every five slides, a few in the notes (limits of
  S4, §14 items 13 to 17).
- **F11. The notes are the learned script (2026-11-17, uRos 2026).** After a timed rehearsal ran
  13:58 for 11:00, he chose to write out what he says, learn it, and keep it as the speaker-view
  notes. He learns it, he does not read it from the screen. Rules for writing it: section 18.

## Evidence base and how to read the counts

Each pattern gives the number of talks it appears in and at least two verbatim quotes with their
location `repo/path:line`, relative to the root of each talk repository listed in
`.claude/talk-inventory.md`. Quotes are verbatim, typos and the French space before `?`/`!` in EN
included. **Do not copy the typos or the French spacing** (house-voice.md, What NOT to codify).

| Key | Repo / file | Event, language | Type |
|---|---|---|---|
| T1 | `raukr-2021-rmd-boost/slides/slides.Rmd`, `raukr-2022-rmd-skills/slides/slides.Rmd` | Raukr lecture 2021, revised 2022 (2022 co-presented: only slides carried over from 2021 are used) | topic, EN, xaringan |
| T2 | `user2021-extend-Rmd/slides/slides.Rmd` | useR! 2021 | short topic, EN, xaringan |
| T3 | `meetup-2021-rmd-business-report/slides/slides.Rmd` | community meetup 2021 | topic, EN, xaringan |
| T4 | `user2022-knitr-engines/slides/slides.Rmd` | useR! 2022 | short topic, EN, xaringan |
| T5 | `raukr-2023-quarto/index.qmd`, `raukr-2025-quarto/index.qmd` | Raukr intro 2023, revised 2025 | full intro, EN |
| T6 | `user2024-quarto-talk/index.qmd` | useR! 2024 | short intro, EN |
| T7 | `pydata-paris-2024-quarto-dashboard/index.qmd` | PyData Paris 2024 | topic, EN |
| T8 | `pydata-paris-2025-quarto-publish/index.qmd` | PyData Paris 2025 | topic, story-driven, EN |
| T9 | `rr-2023-quarto-html-theming/index.qmd` | Rencontres R 2023 | topic, FR |
| T10 | `2024-quarto-evolution-rmd/index.qmd` | talk for official statisticians, 2024 | full intro, FR |
| T11 | `rr2025-quarto-brand-yml/index.qmd` | Rencontres R 2025 | topic, FR |
| T12 | `positconf/slides.txt` (cited `:line (p. N)`) | posit::conf 2025, Lua filters | topic, story-driven, EN, Google Slides, no notes |

T12 locations refer to the text extraction (`pdftotext -layout`) of the PDF published at the URL
on its last slide (`positconf/slides.txt:597 (p. 55)`, also in `presentation-config.md`); the
posit::conf entry of `.claude/talk-inventory.md` has the recording. Words inside images are cited
"(p. N, image)".

Counting rules:

- **Denominator: 12 talks** (14 hand-written decks; each revision pair, T1 and T5, counts once).
  9 EN (T1 to T8, T12), 3 FR (T9 to T11). Quarto era (2023 and later): 8 talks (T5 to T12).
  **Quarto-era EN wording rests on 5 talks** (T5 to T8, T12): keep that small base in mind.
- **Tutorials** (`tuto-quarto-rr-2023`, FR; `user2024-tutorial-quarto`, EN) are supporting evidence
  ("+ tutorials n/2") and never decide whether a pattern is kept.
- **2026 material** (`rr2026-lua-filters`, FR translation of T12; `tuto-quarto-typst-rr-2026`) may
  have been written with an assistant: counted as "[2026: ...]", never the only support. For the FR
  Lua talk, lines that translate a T12 line count as T12 evidence; lines added in 2026 stay weak
  (section 12).
- A pattern seen in one talk only, or with a single quote, is in section 13 (Seen once).

---

## 1. Openings and hooks

**O1. First content slide is a question heading, answered at once.** 8/12 (T1, T2, T3 after a bio
slide; T5, T6, T7, T9, T10; T4 on its second slide). T8 and T12 do not. + tutorials 2/2.

- `# What is Quarto?` (`raukr-2023-quarto/index.qmd:22`); `## What is Quarto?` (`user2024-quarto-talk/index.qmd:44`)
- `# Qu'est-ce que Quarto ?` (`rr-2023-quarto-html-theming/index.qmd:25`, `2024-quarto-evolution-rmd/index.qmd:23`)
- `# What is a {knitr} engine ? ` (`user2022-knitr-engines/slides/slides.Rmd:61`)

In T5 to T7 the answer is the shared definition (section 11), which he does not read out (F3).

**O2. The audience comes in through what it already does.** 10/12 (T1, T2, T5 to T12). For R rooms
the handle is R Markdown or R scripts; for a Python room (T7) standard Markdown.

- `**extends** for people who don't know R Markdown` (`raukr-2023-quarto/index.qmd:73`)
- `Problem to solve` ... `R Scripts` ... `Package`, mirrored by `Quarto` `Document` ... `Lua Filters`
  ... `Quarto Extension` (`positconf/slides.txt:39-68 (pp. 5-6)`); the same task as an R function,
  then as a Lua filter (pp. 9-10, image)
- `*Building on standard Markdown with features essential for scientific communication*`
  (`pydata-paris-2024-quarto-dashboard/index.qmd:48`)
- notes: `Everyone should know rmarkdown among R users.` (`raukr-2021-rmd-boost/slides/slides.Rmd:83`)

**O3. Show the situation before naming the tool.** 5/12 (T2, T3, T8, T11, T12). In T12 Quarto is
never defined; in T8 it is defined only after the first result.

- `The "I'm Stuck" Problem` / `Solving the problems a built-in feature can't.`
  (`positconf/slides.txt:5, :9 (p. 2)`), then the bubble `I am stuck !` (`:16 (p. 3)`)
- `# Let's discuss publishing` (`pydata-paris-2025-quarto-publish/index.qmd:47`), a real public
  report (`:53`), then `## Let's use Quarto for this` (`:79`) and one command (`:88`)
- `# Produire des HTML` (`rr2025-quarto-brand-yml/index.qmd:63`) with one YAML line and a silent GIF
- `> I work in an organization with some styling guidelines and I would like to use them on my R
  Markdown document.` (`meetup-2021-rmd-business-report/slides/slides.Rmd:82`)

## 2. Section bridges and transitions

**B1. Question headings carry the bridge.** 9/12 (T1 to T8, T10). Forms: "How to ...?", "Why
...?", "What about ...?", short, often subjectless. T12 has none (section labels instead).

- `# How to use Quarto ?` (`raukr-2023-quarto/index.qmd:126`); `## Why Quarto?` (`user2024-quarto-talk/index.qmd:68`)
- `## Why multi-format matters ?`, `# What about theming ?` (`pydata-paris-2025-quarto-publish/index.qmd:181`, `:330`)
- `# What about PDF output ? ` (`meetup-2021-rmd-business-report/slides/slides.Rmd:669`)

**B2. One sentence split across two slides (or builds) with an ellipsis.** 8/12 (T3, T5 to T10,
T12). + tutorials 2/2. The ellipsis is the bridge; nothing narrates it.

- `# From Notebook...` / `# ... to Publish‑Ready Report` (`pydata-paris-2025-quarto-publish/index.qmd:69`, `:77`)
- `From R Markdown...` / `... to Quarto` (`user2024-quarto-talk/index.qmd:193`, `:225`)
- `The document node…` / `…split in` `Blocks` (`positconf/slides.txt:213, :224-225 (pp. 22-24)`)
- `## Un choix de thèmes disponibles...` / `## ...facilement personnalisable !` (`rr-2023-quarto-html-theming/index.qmd:106`, `:145`)

**B3. Section markers are light.** Italic framing lines: 4/12 (on `#` dividers in T5, T10; on `##`
slides in T6, T7). Agenda list on a divider: 3/12 (T5, T8, T10). Many dividers carry nothing (T7,
T8, T11). T12 has **no divider slides**: a small section label (kicker) sits above each heading and
changes at section boundaries. xaringan: a `.subtitle[...]` under every heading (4/4).

- `*Quarto is the next generation of R Markdown:\` / `It unifies and extends it*` (`raukr-2023-quarto/index.qmd:24-25`)
- `*Ce n'est pas un package R comme R Markdown...*` (`2024-quarto-evolution-rmd/index.qmd:129`)
- kicker `HOW QUARTO SEES YOUR DOCUMENT` over `Quarto does not work on text directly` (`positconf/slides.txt:121, :125 (p. 11)`)
- `.subtitle[Powered by the new **sass** R ` (`raukr-2021-rmd-boost/slides/slides.Rmd:652`)

**B4. The spoken transition is said, not written; the slide shows where we are (F7).** The
slide carries a position cue (B3 section label, B6 callback), never a narrated sentence. Notes, when
they hold a bridge, 4/12 (T1, T3, T5 in 2025,
T6) keep it to one line. Few forms are on disk (six, four from 2021); with F1 they are memory aids.

- `Next, let's focus on some of the features that make Quarto unique.` (`raukr-2025-quarto/index.qmd:341`, `user2024-quarto-talk/index.qmd:325`)
- `Next in presentation -> broad overview of Quarto and its feature. ` (`user2024-quarto-talk/index.qmd:65`)
- `Let's talk about styling content now. ` (`raukr-2021-rmd-boost/slides/slides.Rmd:525`, `meetup-2021-rmd-business-report/slides/slides.Rmd:134`)

**B5. "Let's" + a concrete verb + an object.** On slides: 5/12 (T1, T3, T4, T8; FR T11 "Prenons");
on Quarto-era EN slides only T8 (two headings). In notes: T5, T6. Never a generic "dive in"
(section 15, contradiction 1).

- `## Let's use Quarto for this`, `# Let's discuss publishing` (`pydata-paris-2025-quarto-publish/index.qmd:79`, `:47`)
- `Let's take a tour!` (`user2022-knitr-engines/slides/slides.Rmd:108`); `.subtitle[Let's sum up!]` (`raukr-2021-rmd-boost/slides/slides.Rmd:930`)
- `# Prenons un exemple` (`rr2025-quarto-brand-yml/index.qmd:99`)

**B6. Callbacks are shown, not announced.** 4/12 (T5, T7, T10, T12): a heading that repeats an
earlier one, or an earlier visual that comes back. T12 reopens three sections with the persona
bubbles and reuses its pipeline diagram (p. 43, image) and result screenshot (p. 29, image).

- `## Revisit: What is Quarto?` (`raukr-2023-quarto/index.qmd:130`); `## Une nouvelle fois : Qu'est-ce que Quarto ?` (`2024-quarto-evolution-rmd/index.qmd:131`)
- `Can I reuse a` / `Can I share my` ... `organization ?` (`positconf/slides.txt:452-454 (p. 44)`)
- T7 shows gallery screenshots again after the layout slides (`pydata-paris-2024-quarto-dashboard/index.qmd:470`, `:504`)

## 3. Problem to solution

**P1. The problem is stated mildly, next to the solution, with a plain connector.** 5/12 (T1, T3,
T5, T10, T11). Words: "can be hard", "tricky", "not easy", "limits". Connectors: "but", "On the
other hand,", "D'un autre côté,", "Déjà bien, mais...". T12 names a section `THE MANUAL PAIN
POINT` (`positconf/slides.txt:88 (p. 8)`), but the problem itself is in the persona's mouth (P2).

- notes: `quite easy to start (write text, add code chunk, compile) but it can be harder to learn new skill` (`raukr-2021-rmd-boost/slides/slides.Rmd:84`)
- notes: `But with CSS files it can be hard to create theme file you can reuse.` / `Enter SASS` (`meetup-2021-rmd-business-report/slides/slides.Rmd:197`, `:199`)
- `# Déjà bien, mais...` (`rr2025-quarto-brand-yml/index.qmd:87`)
- notes: `Simplifier l'utilisation de markdown pour le scientifique. Aujourd'hui une bonne alternative mais trop complexe trop vite` (`2024-quarto-evolution-rmd/index.qmd:111`)

**P2. The need belongs to an organisation or a user, in their words.** 4/12 (T2, T3, T11, T12).
The exact move for institutes with a house style.

- `My organization` / `“AcmeInc” requires` / `to use ™ symbol` / `each time it is` / `named.` / `Can I automate ?` (`positconf/slides.txt:93-98 (p. 8)`)
- `Les organisations ont besoin de **personnaliser** leurs documents selon leur **charte graphique**.` (`rr2025-quarto-brand-yml/index.qmd:90`)
- `> I want to .color1[**add a border**] to create a box and .color1[**apply my blue color**].` (`user2021-extend-Rmd/slides/slides.Rmd:265`)

**P3. Same action, before and after.** 7/12 (T2, T5 in 2025, T6, T7, T8, T11, T12). One line
changes; the rest stays.

- `# Produire des HTML` / `# Produire des HTML avec `_brand.yml`` (`rr2025-quarto-brand-yml/index.qmd:63`, `:123`)
- `## Notebook ➝ HTML` / `## Notebook ➝ Dashboard` (`pydata-paris-2024-quarto-dashboard/index.qmd:245`, `:260`)
- the same ™ task as an R function, then as a Lua filter (`positconf/slides.txt` pp. 9-10, image)

**P4. Show, then explain: one line or command, the result on screen, the mechanism after.** 5/12
(T7, T8, T9, T11, T12).

- `quarto publish quarto-pub whr-data-analysis.ipynb` (`pydata-paris-2025-quarto-publish/index.qmd:88`), then a live iframe (`:92`); `Same command` (`:227`)
- T12: the Lua code (p. 10, image), then `Quarto does not work on text directly` (`positconf/slides.txt:125 (p. 11)`); a second example opens on its result (pp. 19-20, image)
- T9: a live iframe demo after each YAML slide (`rr-2023-quarto-html-theming/index.qmd:104`, `:143`)

**P5. Continuity is reassured in one sentence.** 3/12 (T5, T6, T10). + tutorials 2/2.

- `Quarto utilise toujours Knitr sous le capot` (`2024-quarto-evolution-rmd/index.qmd:187`)
- `(old syntax still works)` (`raukr-2023-quarto/index.qmd:183`)
- `Consequently, ***the vast majority of existing Rmd files*** can be rendered unmodified.` (`user2024-quarto-talk/index.qmd:254`, notes; possibly docs wording)
- tutorial: `No need, Quarto is compatible!` (`user2024-tutorial-quarto/2-rmd-quarto/2-rmd-quarto.qmd:99`)

## 4. Slide text shape and density

**S1. Labels and verbless fragments; whole sentences are rare.** 12/12. In T12 full sentences occur
almost only in the persona bubbles.

- `- Faster sharing` / `- stakeholder-ready output` (`pydata-paris-2025-quarto-publish/index.qmd:98-99`)
- `String element as input`, `Modiﬁed element as output` (`positconf/slides.txt:171, :187 (pp. 15-16)`)
- `- Format HTML basé sur Bootstrap 5` (`rr-2023-quarto-html-theming/index.qmd:264`)

**S2. Few words per slide, fewer over time.** All 12. From the reports: xaringan median about 27
words, Raukr intro about 40, PyData 2025 mostly 0 to 5 plus one code block, RR 2025 10 to 25, T12
median about 20. Many slides have no words (image, code, iframe).

- `Same command`, the whole body (`pydata-paris-2025-quarto-publish/index.qmd:227`)
- `No need to` / `go further` with a stop icon (`positconf/slides.txt:84-85 (p. 7)`)
- `# Déjà bien, mais...` + one 12-word sentence (`rr2025-quarto-brand-yml/index.qmd:87-90`)

**S3. Builds do the pacing: one bubble, one callout, one item at a time.** 6/12 (T5, T6, T7, T8,
T11, T12). T12: 32 of 55 pages are builds; the heading stays fixed while the body grows. Code is
revealed by step highlighting or by callouts added one per page. `. . .` is rare (2 talks).

- `code-line-numbers="|1|4|17|18|21-26"` (`user2024-quarto-talk/index.qmd:101`); `code-line-numbers="|3"` (`pydata-paris-2024-quarto-dashboard/index.qmd:247`)
- callouts `Applies on all strings in the` / `document` -> `String element as input` -> `Modiﬁed element as output` (`positconf/slides.txt:165-187 (pp. 14-16)`)

**S4. Label + colon.** 6/12 (T1, T5, T6, T10, T11, T12). His most common sentence-shape habit on
slides, consistent with house-voice's colon.

- `Under the hood: the Abstract Syntax Tree` (`positconf/slides.txt:139 (p. 12)`)
- `## Focus: HTML Theming` (`user2024-quarto-talk/index.qmd:331`); `Examples: [HTML]` (`raukr-2023-quarto/index.qmd:386`)
- `Going further: See the [`js` engine]` (`raukr-2021-rmd-boost/slides/slides.Rmd:551`)
- FR `## Objectif: Publication avec données calculées` (`2024-quarto-evolution-rmd/index.qmd:88`); `Exemple: Rectangle avec la couleur primaire` (`rr2025-quarto-brand-yml/index.qmd:549`)

**Limits of S4 (measured 2026-11-13; Christophe agreed).** The colon is his habit, not a machine
tell; its *form* and its *density* can be. Counted on the `index.qmd` of four past decks (useR!
2024, PyData Paris 2024 and 2025, Raukr 2025), against the uRos 2026 draft that over-used it:

- **Form.** In his decks the colon is followed by a name: a topic, a term, a list, a link
  (`Focus: HTML Theming`, `Examples: HTML`). The label on the left is generic and could head
  several slides (`Focus:`, `Goal:`, `Layout:`). Never a colon that replaces the verb or stages a
  reveal, a claim then its payoff: `The number in the sentence: computed`, `Cross-references:
  numbered for you`, `All six: 514.7`, `Quarto is the step between: next Thursday...`. 0 of the
  59 on-screen colon lines in the four decks have this form. Write the verb (`R computes the number
  in the sentence`, `All six show 514.7`) or a full stop.
- **Density on screen.** 0.16 to 0.22 colons used as a sentence device per slide (link labels,
  list intros, quote attributions and image credits not counted); 0 in PyData 2025. The draft had
  0.75. Never colon titles on consecutive slides; 4 colon titles per deck at most.
- **Density in notes.** 8 to 12% of note lines carry a colon in his decks. The draft had 56%;
  after review, 29%, all cue labels (`Bridge:`, `(click)`) or list intros, which is acceptable.
  The kind matters more than the count: no colon that replaces a verb.
- **Not a rewrite recipe.** When removing an em-dash or a verbless fragment, prefer a verb or a
  full stop; a label + colon only while the deck stays inside the densities above. Applied as the
  default fix, S4 made the colon take over the em-dash's job.

**S5. Headings: noun phrases first; gerunds and imperatives under a label.** 12/12. In the .qmd
decks 33 of 42 `##` headings are noun phrases (Raukr 2023), 13 of 17 (useR 2024), 17 of 18 (RR
2025). EN gerunds: 4/12 (T3, T4, T8, T12; T12 has six, each under a section label). FR section
titles are infinitives (3/3).

- `## Quarto Workflow` (`user2024-quarto-talk/index.qmd:167`); `# Takeaways` (`pydata-paris-2025-quarto-publish/index.qmd:437`)
- `Using functions` (`positconf/slides.txt:39 (p. 5)`); `# Improving the rendered output` (`pydata-paris-2025-quarto-publish/index.qmd:258`)
- `# Personnaliser sa sortie HTML avec Quarto` (`rr-2023-quarto-html-theming/index.qmd:63`); `# Produire des HTML` (`rr2025-quarto-brand-yml/index.qmd:63`)

**S6. One short takeaway line under code or an example.** 6/12 (T1, T2, T3, T6, T7, T8).

- `Support is now built-in **rmarkdown**` (`raukr-2021-rmd-boost/slides/slides.Rmd:663`, `user2021-extend-Rmd/slides/slides.Rmd:290`)
- `Quarto integrates with other tools.` (`user2024-quarto-talk/index.qmd:144`, `pydata-paris-2024-quarto-dashboard/index.qmd:155`)
- `Automatically picked up by Quarto` (`pydata-paris-2025-quarto-publish/index.qmd:408`)

**S7. Slide-only shorthand: `+`, `=`, `->`, `➝`, `w/`.** 8/12 (T1 to T5, T7, T9, T10). Slides only.

- `## Quarto unifie + étend R Markdown` (`rr-2023-quarto-html-theming/index.qmd:42`)
- `## Notebook ➝ Dashboard` (`pydata-paris-2024-quarto-dashboard/index.qmd:260`)
- `Current release of RStudio IDE has Quarto tooling on-par w/ R Markdown tooling` (`raukr-2023-quarto/index.qmd:711`)

**S8. List length varies: 3 and 4 items both common.** 6/12 (T5, T6, T7, T8, T10, T12). No
reflexive triad.

- 4 items: `- Different audiences` and three more "Different ..." (`pydata-paris-2025-quarto-publish/index.qmd:183-186`)
- 4 verbs: `To modify, replace, remove or just` / `for side eﬀects` (`positconf/slides.txt:583-584 (p. 54)`)
- 3 items: `1. Create` / `2. Distribute for easy reuse` / `3. Use it` (`positconf/slides.txt:555-557 (p. 52)`)

## 5. Recurring words

**W1. Quarto as an agent that does things, without adjectives.** 5/12 (T5 in 2025, T6, T7, T8,
T12). His own descriptions; the shared definition is in section 11.

- `Quarto does not work on text directly`; kicker `HOW QUARTO SEES YOUR DOCUMENT` (`positconf/slides.txt:125, :121 (p. 11)`)
- `A Command Line Interface to render and publish documents and projects` (`pydata-paris-2025-quarto-publish/index.qmd:112`)
- `Extensions are the way to add some features to Quarto, like R packages with R Markdown` (`raukr-2025-quarto/index.qmd:671`)
- `Quarto integrates with other tools.` (`user2024-quarto-talk/index.qmd:144`)

**W2. Homely positives, not hype.** 10/12. "useful", "quite", "nice/nicely", "fresh", "polished",
"built-in", "easy/easily", "facilement". "powerful" is in his 2021 notes nine times (`It is quite
powerful ! `, `raukr-2021-rmd-boost/slides/slides.Rmd:251`); in Quarto-era decks only in copied
docs sentences. Keep the house-voice ban anyway.

- `Multiple fresh polished formats, built-in, with consistent syntax and features.` (`raukr-2025-quarto/index.qmd:275`, added in 2025)
- `This is the quickest way to do PDF with already nice features ! ` (`user2024-quarto-talk/index.qmd:384`)
- `2. Distribute for easy reuse` (`positconf/slides.txt:498 (pp. 46-52)`)
- `Useful for prototyping, for quick iteration, for single file example` (`raukr-2021-rmd-boost/slides/slides.Rmd:555`)

**W3. "multi-" and "same source".** 5/12 (T5, T6, T7, T8, T10). The uRos core message.

- `- Fast sharing of an existing analysis, with multiple formats from same source` (`pydata-paris-2025-quarto-publish/index.qmd:442`)
- `- Multi formats outputs` (`pydata-paris-2025-quarto-publish/index.qmd:176`)
- `Multi-engine support for configurable computations` (`pydata-paris-2024-quarto-dashboard/index.qmd:52`)
- `## Objectif : Une source unique pour la publication` (`2024-quarto-evolution-rmd/index.qmd:114`)

**W4. "Going further" / "Deep dive at" / "A lot more can be done with".** 6/12 (T1, T2, T3, T7, T8, T9).

- `# How to go further ?` (`raukr-2021-rmd-boost/slides/slides.Rmd:945`, `user2021-extend-Rmd/slides/slides.Rmd:411`)
- `A lot more can be done with [**Quarto**]{.hl}` / `Deep dive at <https://quarto.org>` (`pydata-paris-2025-quarto-publish/index.qmd:452`, `:456`)

**W5. A comparison with what the room already uses; the plain word before the term.** 5/12 (T1,
T5, T9, T10, T12).

- `Like `git`, this is a system level component ...` (`raukr-2023-quarto/index.qmd:705`)
- `Whole doc is split in` ... `called   Blocks` ... `called   Inlines` (`positconf/slides.txt:140-154 (p. 12)`); `Blocks (The "Containers")` (`:323 (p. 36)`)
- `Comme R Markdown, on peut produire différents formats de documents.` (`2024-quarto-evolution-rmd/index.qmd:261`)
- `Quite like child document but a bit different.` (`raukr-2021-rmd-boost/slides/slides.Rmd:414`)

**W6. The tool does it "for you" / "automatically".** 3/12 (T1, T3, T8).

- `rmarkdown will run Pandoc & knitr for you.` (`raukr-2021-rmd-boost/slides/slides.Rmd:115`)
- `rmarkdown will run Pandoc & knitr for you so one input for multiple output possible.` (`meetup-2021-rmd-business-report/slides/slides.Rmd:121`, notes)
- `Automatically picked up by Quarto` (`pydata-paris-2025-quarto-publish/index.qmd:408`)

## 6. Punctuation on slides

**U1. The ellipsis is a main slide device** (split sentences, open sets, turns). 9/12 (T3, T5 to
T12). House-voice says "sparingly" for prose; on slides it is normal (11 to 14 per Raukr deck).

- `Others possible...` (`raukr-2023-quarto/index.qmd:175`)
- `[Which includes...]{.fragment fragment-index=1} [**Dashboards**]{.fragment fragment-index=2}` (`pydata-paris-2024-quarto-dashboard/index.qmd:66`)
- `The document node…` (`positconf/slides.txt:213 (p. 22)`)

**U2. Few exclamation marks, never decorative.** 1 to 5 per deck in the Quarto-era EN decks
(xaringan decks had many). They sit on an enthusiasm line, a persona bubble, the call to action or
the thanks. Talks with an enthusiasm or call-to-action "!": 4/12 (T5, T6, T10, T12).

- `[R Markdown to everyone]{.hl}!` (`raukr-2023-quarto/index.qmd:124`; shared wording, section 11)
- `This is the quickest way to do PDF with already nice features ! ` (`user2024-quarto-talk/index.qmd:384`)
- `Do consider Lua ﬁlters next time you are stuck!` (`positconf/slides.txt:576 (p. 54)`)

**U3. No em-dash aside on slides.** None in the slide prose of the 14 hand-written decks. `---`
(rendered as an em-dash) appears only as a heading separator in 3 decks (T5, T7, T10); T12 has en
dashes only inside copied web page titles. Otherwise a spaced hyphen. The one em-dash aside on
disk is a notes sentence (section 14, item 10).

- `## Jupyter Engine --- ipynb` (`raukr-2023-quarto/index.qmd:195`); `## Jupyter --- ipynb` (`2024-quarto-evolution-rmd/index.qmd:201`)
- `First chunk will be used twice - different options are allowed.` (`raukr-2021-rmd-boost/slides/slides.Rmd:438`)
- `We're limitated by their features - not everything can be customized.` (`meetup-2021-rmd-business-report/slides/slides.Rmd:644`)

**U4. Parentheses hold lists or a plain gloss.** 6/12 (T1, T5, T6, T7, T8, T12).

- `Designed for reproducible input (.ipynb, .qmd) towards professional outputs.` (`pydata-paris-2025-quarto-publish/index.qmd:123`)
- `* Can be used with any engine (R, Python, C++, ...)` (`raukr-2022-rmd-skills/slides/slides.Rmd:300`, a 2022 revision)
- `Inlines (The "Contents")` (`positconf/slides.txt:323 (p. 36)`)

## 7. Questions to the audience

**Q1. Every question is rhetorical or a persona's, answered by the next slides.** 12/12. No talk
asks the room for an answer (no show of hands, no "who here"). Tutorials do (ice-breakers).

- `## Why does this matters ? ` (`pydata-paris-2025-quarto-publish/index.qmd:95`)
- `# Pourquoi Quarto ?` (`2024-quarto-evolution-rmd/index.qmd:77`)

**Q2. Persona questions: the audience's question in the user's voice.** 5/12 (T2, T3, T8, T9,
T12). In T12 they are speech bubbles and open three sections.

- `Can Quarto do X` / `that I need for my` / `organization` / `report ?` (`positconf/slides.txt:17-21 (p. 3)`)
- `> How does that work ?` (`meetup-2021-rmd-business-report/slides/slides.Rmd:84`)
- `Can I use variable for color and limit duplication ? ` (`user2021-extend-Rmd/slides/slides.Rmd:267`)
- `C'est comme R Markdown non ? ` (`rr-2023-quarto-html-theming/index.qmd:27`)

**Q3. The Q&A invitation is a heading or label, not a sentence.** 6/12 (T5, T6, T9, T10, T11, T12).

- `#### Questions? {.top-pad}` (`raukr-2023-quarto/index.qmd:802`, `user2024-quarto-talk/index.qmd:575`)
- kicker `Any question ? Contact me !` (`positconf/slides.txt:585 (p. 55)`)
- `## Questions? {.center .bigger}` (`rr2025-quarto-brand-yml/index.qmd:692`)

## 8. Humour, person, notes

**H1. Humour is mild and visual.** Images or visual gags: 5/12 (T1, T3, T4, T7, T12: a stop sign
on `No need to go further`, playing-card suits as the second example, the fictional `AcmeInc™`).
Text quips: 2/12 (T1, T3), both 2021.

- `(.small[but you probably won't!])` (`raukr-2021-rmd-boost/slides/slides.Rmd:135`)
- `.color2[**Paginated HTML is a thing**]` (`meetup-2021-rmd-business-report/slides/slides.Rmd:759`)
- `My organization` / `“AcmeInc” requires` (`positconf/slides.txt:93-94 (p. 8)`)

**H2. Person: "you" for the audience, "we" for the team or the room, no speaker "I" on slides.**
12/12. "I" is a persona (Q2, P2), the 2021 bio heading `# Who am I ?`
(`raukr-2021-rmd-boost/slides/slides.Rmd:38`), or `Contact me !` (T12). FR: "vous" only (3/3).
Spoken, he says why he is here (F2). Tutorials differ (`I'm going to **assume** that you`,
`user2024-tutorial-quarto/1-what-is-quarto/1-what-is-quarto.qmd:106`).

- `HOW QUARTO SEES YOUR DOCUMENT`, `Solve your own problems` (`positconf/slides.txt:121, :578`)
- `This presentation aimed to give you a taste of what Quarto can do ...` (`user2024-quarto-talk/index.qmd:560`)
- `But we worked this summer with Pandoc team to improve Powerpoint templating mechanism.` (`meetup-2021-rmd-business-report/slides/slides.Rmd:645`)

**N1. Notes are short, unlabelled memory aids.** 9/12 talks have notes (none in T7, T9, T12).
Length: 10 to 35 words (xaringan), 1 to 5 short bullets (Raukr 2025), one line (PyData 2025), 4 to
17 words (T10). No Say/Do/Ask labels. He does not read them (F1). For uRos 2026 the notes are the learned script instead (F11, §18). A one-line `Bridge:` or `Next:`
cue to the next slide is fine (kept in the uRos 2026 deck after the coach review of 2026-11-12).

- `Click on the link to show example` (`raukr-2023-quarto/index.qmd:389`); `Cliquez sur le lien pour voir l'exemple` (`2024-quarto-evolution-rmd/index.qmd:485`)
- `Pandoc feature. R Markdown knows and extend it. ` (`raukr-2021-rmd-boost/slides/slides.Rmd:780`)
- `` `quarto publish` calls `quarto render` unless `quarto publish --no-render` `` (`pydata-paris-2025-quarto-publish/index.qmd:171`)

**N2. Notes carry the "why" that the slide leaves to an image or code.** 4/12 (T1, T5, T6, T10).
His 2025 revision moved explanation from slide to notes (section 10).

- `-   Same workflow logic than R Markdown: Engine + Convertion` (`user2024-quarto-talk/index.qmd:184`, image-only slide)
- `-   For R, Quarto still uses Knitr under the hood.` (`raukr-2025-quarto/index.qmd:269`, slide text in 2023)
- `Everyone should know rmarkdown among R users.` (`raukr-2021-rmd-boost/slides/slides.Rmd:83`, image-only slide)

## 9. Closings and EN/FR

**C1. The last slide is for resources: slides URL, a few links, "Questions?"** (F4). "Learning
More": 4/12 (T5, T6, T7, T10). Slides URL on the last slide: 6/12 (T2, T4, T5, T9, T10, T12),
first in the .qmd decks, at the bottom of the thanks slide in T12. The "Follow along at" footer
carries it in all Quarto-era EN .qmd decks (4/4). T12 spreads resources through the talk as link +
QR pairs.

- `#### Slides: <https://cderv.github.io/raukr-2023-quarto> {.bottom-pad}` ... `#### Questions? {.top-pad}` (`raukr-2023-quarto/index.qmd:786-802`)
- `Thank you!` / `@cderv` ... / slide URL (`positconf/slides.txt:590-597 (p. 55)`)
- FR `{{< fa tv >}} <https://cderv.github.io/rr-2023-quarto-html-theming/> ` first (`rr-2023-quarto-html-theming/index.qmd:281-289`)

**C2. A recap only in topic talks; intro talks end on resources.** 5/12 (T1, T3, T8, T9, T11). No
slogan in recaps. T12 has no recap: its call to action restates the core idea (section 12).

- `# Takeaways` / `- Fast sharing of an existing analysis, with multiple formats from same source` (`pydata-paris-2025-quarto-publish/index.qmd:437-442`)
- `# What we've learn so far ? ` / `.subtitle[Let's sum up!]` (`raukr-2021-rmd-boost/slides/slides.Rmd:928-930`)
- `## A retenir` (`rr-2023-quarto-html-theming/index.qmd:262`); `# Pour résumer` (`rr2025-quarto-brand-yml/index.qmd:578`)

**C3. Thanks in two words, or none.** 9/12 (T1 to T4, T7, T8, T9, T11, T12); none in the intro talks.

- `# Thank you !` (`raukr-2021-rmd-boost/slides/slides.Rmd:984`); `Thank you!` (`positconf/slides.txt:590 (p. 55)`)
- `[Merci!]{.fg}` (`rr2025-quarto-brand-yml/index.qmd:694`)

**C4. "A lot more can be done with ..." opens the last slide of a topic talk.** 2/12 (T7, T8).

- `A lot more can be done with **Quarto Dashboard**:` (`pydata-paris-2024-quarto-dashboard/index.qmd:749`)
- `A lot more can be done with [**Quarto**]{.hl}` (`pydata-paris-2025-quarto-publish/index.qmd:452`)

**X1. FR register.** 3/3 FR talks: "vous" only; infinitive titles; definitions start with "C'est
..." or a noun phrase; first-person-plural imperatives ("Prenons"); English terms kept, sometimes
glossed (`(_Terminologie anglaise de la doc_)`, `2024-quarto-evolution-rmd/index.qmd:331`). The
space before `?`/`!` is correct in FR, wrong in EN.

- `C'est un nouveau [système de publication scientifique et technique Open-Source]{.hl}` (`rr-2023-quarto-html-theming/index.qmd:31`)
- `1. Créez un fichier `_brand.yml` dans votre projet` (`rr2025-quarto-brand-yml/index.qmd:149`)
- `## Learning More {.smaller}` in a FR deck (`2024-quarto-evolution-rmd/index.qmd:934`)

**X2. The same lines, translated rather than rewritten.** 2/12 (T5 into T10; T12 into its 2026 FR
version). + tutorials 2/2.

- `you can weave together` / `vous pouvez "tisser" ensemble` (`raukr-2023-quarto/index.qmd:39`, `2024-quarto-evolution-rmd/index.qmd:40`)
- `No need to` / `go further` (`positconf/slides.txt:84-85 (p. 7)`) / `Pas besoin` / `d’aller plus` / `loin` (`rr2026-lua-filters/slides-source.txt:72-75 (p. 7)`)

## 10. Examples to imitate (his own hand, verbatim)

His revisions show the direction (old -> new):

- `...is a new, open-source, ...` -> `...is an open-source, ...` (`raukr-2023-quarto/index.qmd:29` -> `raukr-2025-quarto/index.qmd:29`): no novelty claim.
- `For R, Quarto still uses Knitr under the hood. ...` moved from slide to notes (`raukr-2023-quarto/index.qmd:181` -> `raukr-2025-quarto/index.qmd:269-270`).
- `# New Features` -> `# Focus on some features` (`raukr-2023-quarto/index.qmd:354` -> `raukr-2025-quarto/index.qmd:465`).
- The publishing-services table was replaced by the `quarto publish --help` output (`raukr-2025-quarto/index.qmd:720-744`): show the tool.
- `Load same content in several Rmd document` -> `Reuse the same content across several Rmd documents:` (`raukr-2021-rmd-boost/slides/slides.Rmd:316` -> `raukr-2022-rmd-skills/slides/slides.Rmd:399`).

| Job | Real line | Location |
|---|---|---|
| hook (persona) | `I am stuck !` / `Can Quarto do X` / `that I need for my` / `organization` / `report ?` | `positconf/slides.txt:16-21 (p. 3)` |
| hook (artefact) | `# Let's discuss publishing` + notes `when you have a notebook analysis and you are ready to share.` | `pydata-paris-2025-quarto-publish/index.qmd:47`, `:50` |
| bridge from what they do | `From Custom Scripts to Custom Filters` / `Using functions` | `positconf/slides.txt:34, :39 (p. 5)` |
| scope cut | `No need to` / `go further` | `positconf/slides.txt:84-85 (p. 7)` |
| need of an organisation | `Les organisations ont besoin de **personnaliser** leurs documents selon leur **charte graphique**.` | `rr2025-quarto-brand-yml/index.qmd:90` |
| solution in one line | `## Let's use Quarto for this` | `pydata-paris-2025-quarto-publish/index.qmd:79` |
| mechanism, plainly | `Quarto does not work on text directly` | `positconf/slides.txt:125 (p. 11)` |
| gloss | `Under the hood: the Abstract Syntax Tree` + `called   Blocks` | `positconf/slides.txt:139, :154 (p. 12)` |
| takeaway under code | `Automatically picked up by Quarto` | `pydata-paris-2025-quarto-publish/index.qmd:408` |
| why it matters | `## Why multi-format matters ?` + `- Different audiences` ... | `pydata-paris-2025-quarto-publish/index.qmd:181-186` |
| own enthusiasm | `Multiple fresh polished formats, built-in, with consistent syntax and features.` | `raukr-2025-quarto/index.qmd:275` |
| recap bullet | `- Fast sharing of an existing analysis, with multiple formats from same source` | `pydata-paris-2025-quarto-publish/index.qmd:442` |
| closing callback | `Do consider Lua ﬁlters next time you are stuck!` | `positconf/slides.txt:576 (p. 54)` |
| note (cue / bridge) | `Click on the link to show example`; `Next, let's focus on some of the features that make Quarto unique.` | `raukr-2023-quarto/index.qmd:389`; `raukr-2025-quarto/index.qmd:341` |

## 11. Shared Quarto wording: fine on a slide, not his voice

These EN formulas are Quarto-project wording (quarto.org, the 2022 "Hello, Quarto" material) that he
reuses verbatim in intro talks (T5 to T8) and translates in FR (T10, T11). Use them verbatim where
an arc calls for a definition; he does not read them out (F3). **Never use them as a model for new
sentences, and never as a rewrite target.**

- definition: `...is an open-source, scientific, and technical publishing system` (`raukr-2025-quarto/index.qmd:29`, `pydata-paris-2025-quarto-publish/index.qmd:81`)
- `... you can weave together narrative text and code to produce elegantly formatted output ...` (`raukr-2023-quarto/index.qmd:39`)
- `**unifies** + **extends** the R Markdown ecosystem` (`raukr-2023-quarto/index.qmd:55`) and the "for people who love / don't know R Markdown" build
- the `## So, Why a New System?` bullets: `Quarto is at its core [multi-language and multi-engine]{.hl}`, `Quarto is Posit's attempt to bring 10-years experience of [R Markdown to everyone]{.hl}!` (`raukr-2023-quarto/index.qmd:119-124`)
- `The R Markdown ecosystem was built over nearly a decade (resulting in lots of inconsistency & duplication)` (`raukr-2023-quarto/index.qmd:248`)
- likely shared: `Quarto is a command line interface (CLI) that renders plain text formats ...` (`raukr-2023-quarto/index.qmd:132`, `user2024-quarto-talk/index.qmd:98`; his 2025 compression is in W1); `[Computational Documents]{.hl} and [Scientific Markdown]{.hl}` (`user2024-quarto-talk/index.qmd:70`)

## 12. The story-driven model: posit::conf 2025 (T12)

His most prepared talk (F5): EN, about 23 distinct slides over 55 pages, no notes in the export.

1. **Persona problem opener.** Section label `The "I'm Stuck" Problem`, heading `Solving the
   problems a built-in feature can't.`, then two speech bubbles in the user's first person: `I am
   stuck !`, `Documentation` / `says I can do Z but` / `I really need Y.` (`positconf/slides.txt:5-33 (pp. 2-4)`).
   No definition of Quarto, no bio, no question to the room.
2. **Bridge from what R users already do.** `From Custom Scripts to Custom Filters` / `Using
   functions`: `Problem to solve` -> `Code Analysis` -> `R Scripts` -> `Package`, mirrored by Quarto
   Document -> Lua Filters -> Quarto Extension; then the scope cut `No need to` / `go further` (pp. 5-7).
3. **Concrete case.** `THE MANUAL PAIN POINT` + the AcmeInc ™ bubble, then the same task as an R
   function and as a Lua filter (pp. 8-10).
4. **Show, then explain.** Code first, then `Quarto does not work on text directly`, `Under the
   hood: the Abstract Syntax Tree`, callouts added one per page, then the result screenshot (pp.
   11-18). A second example opens on its result (pp. 19-20).
5. **Section labels and visual callbacks instead of divider slides.** A kicker names each section;
   persona bubbles reopen sections (pp. 3, 8, 44); the pipeline diagram and the result come back
   (pp. 29, 43); the running example threads to the end (p. 52).
6. **Progressive builds.** 32 of 55 pages are builds; the heading stays, the body grows.
7. **Depth deferred** to link + QR pairs, not explained (pp. 37-53).
8. **Close that calls back the opening word.** `You’re not alone` (p. 53), then `WHAT IS NEXT FOR
   YOU` / `Do consider Lua ﬁlters next time you are stuck!` / `Go try it !` / `Solve your own
   problems` / `Lua Filters` / `are functions` (`positconf/slides.txt:568-584 (pp. 53-54)`), then
   `Thank you!` + handles + slide URL (p. 55).

**FR 2026 version (`rr2026-lua-filters/slides-source.txt`).** It translates T12, so these FR lines
are T12 evidence: `"Je suis bloqué"`, `Des scripts aux filtres`, `Pas besoin` / `d’aller plus` / `loin`, the
AcmeInc bubble, `Puis-je réutiliser` / `Puis-je partager`, `Vous n'êtes pas seul·e·s`, `Pensez aux
filtres Lua la prochaine fois que vous êtes bloqué·e !` (`:522 (p. 53)`), `Lancez-vous !`, `Les
filtres Lua sont des fonctions`, `Contactez moi !`. **Added in 2026 (weak evidence):** statements
turned into questions (`Comment Quarto voit votre document ?`, `ET MAINTENANT ?`, `Peut-on
automatiser ça ?`), `Résoudre VOTRE problème avec les filtres Lua est la première étape` (`:411`),
`avec votre propre logique`, `Commencez dès aujourd'hui à expérimenter des modifications simples.`,
`dans votre workflow Quarto`, inclusive `·e·s`, captions glossing Pandoc and the engine on the
pipeline diagram, `(AST)` added to the heading, the API prose turned into bullets.

## 13. Seen once (one talk, or a single quote)

Real, but not a pattern. Use only when the situation matches.

- **Imperative call to action + callback to the opening word**: T12 only (`positconf/slides.txt:576-578 (p. 54)`).
- **Speech-bubble persona and kicker labels**: T12 only (section 12).
- **Code shown in R first, then in the new language**: T12 only (pp. 9-10, image).
- **Notes that complete the heading**: T8 only (`# Let's discuss publishing` + `when you have a notebook analysis and you are ready to share.`, `pydata-paris-2025-quarto-publish/index.qmd:47-50`).
- **"Déjà bien, mais..."**, **"Prenons un exemple"**: T11 only (`rr2025-quarto-brand-yml/index.qmd:87`, `:99`).
- **"C'est comme R Markdown non ?"** as the FR opener line: T9 only (`rr-2023-quarto-html-theming/index.qmd:27`).
- **"Enter X"** for a tool reveal: T3 only (`meetup-2021-rmd-business-report/slides/slides.Rmd:199`, `:728`).
- **"Focus:" heading prefix**: T6 only (`user2024-quarto-talk/index.qmd:331`, `:369`).
- **"-ready" vocabulary**: T8 only (`From Notebook to Publish‑Ready Report with Quarto`, `pydata-paris-2025-quarto-publish/index.qmd:29`; `- Publications-ready features`, `:178`). The uRos core message uses "publication-ready": attested in one talk.
- **A real public report as the running example**: T8 only (`## World Happiness Report 2025`, `pydata-paris-2025-quarto-publish/index.qmd:53`).
- **External evidence for reproducibility** (a survey image): T10 only (`2024-quarto-evolution-rmd/index.qmd:103`).
- **Scope framed as "a taste", pointing to other talks**: T6 only (`user2024-quarto-talk/index.qmd:560-562`); not for uRos (the talk stands alone).
- **Teaser in two fragments** (`[Which includes...]` / `[**Dashboards**]`): T7 only (`pydata-paris-2024-quarto-dashboard/index.qmd:66`).
- **De-mystifying `This is not so magic.`**: 2021 decks only (`raukr-2021-rmd-boost/slides/slides.Rmd:102`).
- **Deflection joke** `LaTeX customization is a topic for another time !`: T1 only (`raukr-2021-rmd-boost/slides/slides.Rmd:921`).

## 14. Anti-examples: machine tells specific to talks

Each is **invented** unless marked real. Rewrites use his own forms, not the shared wording.

1. **Dramatic hook** (invented): `Every number you publish is a promise. What if one of them is wrong?`
   Rewrite (O3, Q2): a persona bubble, `I updated the table in the HTML report. Is it the same in the PDF?`, or an artefact image with the doubt in the notes.
2. **Narrated transition on the slide** (invented): `Now that we've seen why it matters, let's dive into how Quarto works.`
   Rewrite: a section label or `# How to use Quarto?` (B1, B3); notes: `Next: the command line.` (B4).
3. **Antithesis flip** (invented): `Quarto isn't just a tool, it's a new way to publish.`
   Rewrite (W1): `A Command Line Interface to render and publish documents and projects` (real, `pydata-paris-2025-quarto-publish/index.qmd:112`).
4. **Slogan in three beats** (invented): `One source. Every format. Zero copy-paste.`
   Rewrite: `Same command` under `## Publishing multiple formats` (P4), or say it (F4).
5. **Inflated stakes** (invented): `Stop losing hours to copy-paste errors that undermine trust in official statistics.`
   Rewrite (P1): `Numbers copied by hand can get out of sync with the code.`
6. **Hype adjectives** (invented): `A powerful, seamless way to produce stunning reports.`
   Rewrite (W2): `This is the quickest way to do PDF with already nice features!` (real, `user2024-quarto-talk/index.qmd:384`, space removed).
7. **Question to the room** (invented): `Who here has ever fixed the same number in three files?`
   Rewrite (Q2): the persona asks it, in a bubble or a blockquote.
8. **Announcing a callback** (invented): `Remember our bulletin? Here's the payoff.`
   Rewrite (B6): the bulletin comes back on screen, changed; the label or heading names it.
9. **Exhortation without a callback** (invented): `Go forth and publish reproducibly!`
   Rewrite: T12's shape, a call back to the opening problem (`Do consider Lua ﬁlters next time you are stuck!`), or the resource slide (C1) with the conclusion spoken (F4).
10. **Dashed voice-over in notes** (real outlier): `Instead of handing over a raw .ipynb, Quarto lets you ship production‑quality HTML and paginated PDFs — polished, brandable, and ready for stakeholders — all from the same source document.` (`pydata-paris-2025-quarto-publish/index.qmd:105`).
    Rewrite: `Quarto renders the notebook to HTML and PDF from the same source. Both can use the organisation's brand.`
11. **Bold-lead + em-dash bullets** (real, 2026 tutorial only, e.g. `**Rien à installer** —`, `tuto-quarto-typst-rr-2026/1-quarto-typst/1-quarto-typst.qmd:179`).
    Rewrite: a verb first (`- Typst comes with Quarto, nothing to install`); a label + colon (S4) only within its limits.
12. **Script-length notes** (2026 tutorial notes average about 85 words). Rewrite: one memory aid per line (N1, F1), or, when the notes are the learned script (F11), the spoken text of §18 within the slide's seconds.

The bans of F9 and of this section apply to spoken lines too, not only to slide text: a spoken
triad is still a slogan (`one command, one button, one extension`, cut from the uRos 2026 script).

Found in the assisted uRos 2026 draft by the wording reviews of 2026-11-13 (real, assisted; all
removed with Christophe's agreement):

13. **Reveal colon** (`The number in the sentence: computed`, `All six: 514.7`): see the limits of S4.
    Rewrite: `Write R code inside the sentence`, `All six show 514.7`.
14. **Refrain across slides**: one parallel formula repeated as titles and section labels
    (`One header, every format` under the label `One source, every format`, 9 slides). Each line
    alone is fine; repeated, it becomes the slogan of item 4. Rewrite: his own wording, once (W3,
    `Same source, multiple formats`), and a plain heading.
15. **Maxim in notes** (`Change the data, the sentence follows.`, `The number people read is the
    number your code produced.`, `a map, not a ranking`): an aphorism to deliver, not a cue.
    Rewrite: the plain fact (`The sentence updates with new data.`) or nothing.
16. **Question set up for a one-word answer on the slide** (`Which one did you forget? None.`):
    a question to the room (item 7) used as a punch line. Rewrite: show the state (`One is still
    wrong.`, then `All six show 514.7`).
17. **Notes that repeat the slide or stage the delivery** (`What if you only had to fix it once?
    Pause, no answer.`): drop the repeat, keep only what the slide does not say (N2).

## 15. Where the corpus is silent or contradictory

Absence is information. In 12 hand-written talks there is:

- **No show of hands, no question that waits for an answer** (Q1).
- **No speaker "I" on slides, no anecdote, no bio slide in the Quarto era** (bio slides in 3 of 4
  xaringan talks). A persona "I" opener is attested in 2025 (T12; T3 in 2021). The spoken intro
  says why he is here (F2).
- **Call to action: one talk.** The v1 claim "no imperative CTA" is contradicted by T12 (`Do
  consider Lua ﬁlters next time you are stuck!`, `Go try it !`, `Solve your own problems`, p. 54).
  It calls back the opening word; it is not a slogan.
- **No three-beat slogan on any slide.** Three-beat lines appear only in 2026 speaker documents
  (`Une ligne. PDF généré. Pas d'install LaTeX.`, `tuto-quarto-typst-rr-2026/_speaker/pilotage.qmd:87`).
  The first candidate closing line in CLAUDE.md had this shape; it was replaced and, per F4, lives in the notes as a spoken line.
- **No emoji in Quarto-era EN slide text** (xaringan used `emo::ji()`; T11 and T12 use icons).
- **No domain vocabulary on every slide.** The talk for official statisticians (T10) never says
  "statistique" or "official statistics" on a slide; the framing is in the title (`Pour des travaux
  scientifiques reproductibles`, `2024-quarto-evolution-rmd/index.qmd:2`) and the "Pourquoi" section.
- **No narrative nouns for structure** ("story", "chapter", "journey") on slides.
- **Durations are not on disk.** T6 is the shortest deck by slide count; whether any talk was under
  20 minutes is an assumption.
- **The spoken layer is missing.** Few spoken bridges are on disk (B4) and no hook sentence. The
  YouTube recordings (`.claude/talk-inventory.md` lists PyData Paris 2024 and posit::conf 2025) are
  the next evidence to add, as transcripts: the hook sentence, the bridges between slides, the
  spoken conclusion.

Contradictions to keep in mind:

1. **`# Let's dive now !` (`raukr-2021-rmd-boost/slides/slides.Rmd:158`) vs the house-voice ban on
   "Let's dive in".** Not in any later deck. Keep the ban; use "Let's" + concrete verb (B5).
2. **Ellipsis**: "sparingly" in prose (house-voice), frequent on slides (U1). Both hold.
3. **Notes labels**: prose-voice.md asks for Say/Do/Ask cues (workshops). No talk note has labels;
   with F1 a one-line memory aid per idea is enough.
4. **Bold vs `{.hl}`** on "unifies + extends": bold in every deck. `{.hl}` is sparse (about 5 per
   deck in T5) and sits on a phrase inside a sentence.
5. **Gerund headings**: the review advice "avoid them, they read as agenda items" vs T12, which has
   six, each under a section label. Use them under a label, not as a list of section titles.
6. **2026 material** diverges from the hand-written decks on em-dashes (69 lines in the two 2026
   tutorial decks), note length, bold-lead bullets, slogans and words such as "pépite". A 2026 FR
   line that translates T12 is evidence; a line added in 2026 is weak (section 12).

## 16. For a 15-minute story-driven talk: keep, adapt, drop

From the speaking-coach review, checked against T12.

- **Keep:** O2, O3 (the hook: a real publication, the doubt in a persona line), B1 (at most 3
  question headings), B2, B4, B6 (one callback to the opening artefact, shown), P1 register, P2,
  P3, P4, P5 (once), S1 to S6, S8, W2 to W6, U1 (about 6 ellipses), U2, U3, U4, Q2, Q3, C3, C4,
  H2, N1, N2, and hidden backup slides.
- **Adapt:** section 11 (one definition line, after the first result, as T8 did at
  `pydata-paris-2025-quarto-publish/index.qmd:81` and `:110`); B3 (prefer T12's position cues, F7: a
  section label or a recurring diagram with the current step marked; at most two `#` dividers, no
  agenda lists); B5 (one or two "Let's" headings); S7 (keep `+`, `->`;
  drop `w/` for an international room); H1 (at most one visual gag); C2 (T8's three-bullet
  `# Takeaways` or T12's callback, not both); Q1 (if a question that waits is wanted, ask him).
- **Drop:** the definition-first opening (`# What is Quarto?` -> definition -> schematic -> "With
  Quarto..." -> build: six slides of shared wording); the dense `## Learning More {.smaller}` list
  (slides URL, two links, `#### Questions?`); the xaringan agenda slide; `.make-smaller` on a full
  `--help` listing; a three-beat closing slogan on a slide (F4).

## 17. What the uRos organisers' guidelines imply for writing

Case: uRos 2026 (CLAUDE.md, "This talk", "Organisers' guidelines"); reusable for similar rules.
"New constraint" means no precedent in the corpus.

- **Briefly define every term that is not common R knowledge** (Quarto, Typst, PDF/UA,
  `_brand.yml`, cross-reference). His devices: a heading that states what it does (`Quarto does not
  work on text directly`), label + colon (`Under the hood: the Abstract Syntax Tree`), the plain
  word before the term (`called   Blocks`, `positconf/slides.txt:154`), a comparison (`like R
  packages with R Markdown`, `raukr-2025-quarto/index.qmd:671`), a parenthesis or link (`New PDF
  rendering through Typst (<https://typst.app>)`, `user2024-quarto-talk/index.qmd:375`), and a
  closing gloss (`Lua Filters` / `are functions`). New constraint: he glosses main terms only; here
  each non-R term needs one short gloss on its first slide (PDF/UA and cross-reference have no
  precedent). One line, not a definition slide each.
- **One message per slide, read in a few seconds.** S1, S2, S6: label heading, 0 to 5 word body or
  one takeaway, the result shown (`## No source code cell in output` + two YAML lines,
  `pydata-paris-2025-quarto-publish/index.qmd:260-268`). The dense `{.smaller}` slides of T5 are the
  counter-model.
- **Readable code and screenshots.** Very short code (one command, a 2-line YAML block), step
  highlighting or one callout per build (S3), one command in `.r-fit-text`
  (`pydata-paris-2025-quarto-publish/index.qmd:86`), full-bleed screenshots with `footer=false`,
  the changed result circled (T12 p. 18), details in a footer link or QR. Avoid `.make-smaller` on
  long output (`user2024-quarto-talk/index.qmd:101`).
- **No bio, no self-introduction slide.** His practice in all 8 Quarto-era talks. The title slide
  carries name and affiliation; the next slide is the hook (O3). The spoken "welcome everyone" and
  why he is here (F2) replace any "about me".
- **15 min strict, aim 12:30 spoken.** New constraint: no talk on disk is known to be this short.
  His ways to fit time: a few picked features, one slide each (T6 "Focus:"); a result or link
  instead of explanation (P4, T12's QR links); a section shrunk to one slide (`# Figures and
  Tables?` -> `## Tooling to use brand`, `pydata-paris-2025-quarto-publish/index.qmd:427-435`);
  backup slides kept with `visibility="hidden"` (18 in `raukr-2023-quarto/index.qmd`, 20 in
  `2024-quarto-evolution-rmd/index.qmd`). Cut middle sections first; keep the hook and the resource
  slide; conclude by speaking (F4). Notes stay memory aids (F1), except in a deck where they are
  the learned script (F11, §18).

## 18. Spoken script (speaker notes that are learned)

Applies when the notes are the learned script (F11). Agreed with Christophe on 2026-11-17, after
three reviews and a coach verdict on the uRos 2026 script. [C] = his own choice in that session,
[I] = inferred from the script and one timed rehearsal; revise [I] rules after the next rehearsal.

1. **Only punctuation the ear can hear.** [C] Full stops and commas. No colon, parenthesis, dash
   or slash in a spoken line: it is speech, not text to read.
   Good: `The data are real, from Eurostat.` Bad: `One example for the rest of the talk: a
   statistical bulletin.`
2. **One idea per sentence, subject first, plain verbs.** [I] About 6 to 12 words, a pronoun next
   to its noun, no idioms or phrasal verbs: many in the room, and the speaker, are non-native.
   Good: `You fix it in the R code.` Bad: a French construction such as `you are Thursday evening`
   (say `it is Thursday evening`).
3. **The plain word first, and no word that means something else to an R user.** [I]
   Good: `your analysis and your method note`. Bad: `the comment` (heard as a `#` line), `pipe`
   (heard as `|>`).
4. **The voice says what the screen does not; point at code, do not read it.** [C] for F3, [I]
   for symbols. Do not name signs aloud, do not read fragments word for word.
   Good: `The highlighted lines are options for Quarto.` Bad: `The lines that start with hash and
   pipe are options for Quarto.`
5. **Few numbers, each with one meaning and one spoken form.** [I] A year said once for one thing;
   a time or a figure said the same way every time it comes back, or not said at all.
   Good: `2014` only for R Markdown; `Thursday evening` in the intro and in the callback. Bad:
   `since 2014` for the programmes, then `In 2014, R Markdown`.
6. **A bridge is one spoken line and does not tell the room what to do.** [C] "Let's" with a
   concrete verb, `This is where ...`, or a question the next slide answers.
   Good: `This is where Quarto can help.`, `Let's open the source file.` Bad: `The tool for this
   is Quarto.` (judged too directive by Christophe).
7. **Words fit the slide's seconds, and the slide ends on a stop line.** [I] for the rate, [C] for
   the format. About 2 words per second until his rate is measured, less about 2 words per click;
   `(click)` where the fragment fires; one line in italics names what not to explain (the method,
   the roadmap, the screenshots). Story-role notes stay out of the deck (tracker).
   Good: #publishing-needs at 38 words for 0:20, ending on `Do not explain the method or the
   counts.` Bad: 52 words and a caption that invites the method (1:21 in rehearsal).

