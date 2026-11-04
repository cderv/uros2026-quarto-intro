# uRos2026: audience and context

Facts come from the public programmes and books of abstracts of uRos 2023–2026; inferences are
marked as such. Refer to other talks by title and institution, not by speaker name.

## The conference

- 14th edition, Paris, 18–20 November 2026, hosted by INSEE at the Ministry of Economics
  (Centre de conférences Pierre Mendès France). Programme:
  <https://github.com/uRosConf/programme2026> (`uros2026_programme.pdf`).
- Growth: 2024 had 94 participants from 22 countries and about 40 talks in a single track; 2025
  about 35 talks. 2026 runs 3 parallel tracks with about 100 talks and 9 tutorials.
- Speakers are mostly from national statistical institutes (Destatis, Statistics Austria, CBS,
  ISTAT, INE, Statistics Poland, STATEC, Statbel, TurkStat, ELSTAT, INS Romania, INSEE), plus
  Eurostat, OECD, UNIDO, central banks and universities. Several French ministry statistical
  offices join in 2026.
- International room, many non-native English speakers: keep the English simple.

## Our session

Thursday 19 November, 11:30–13:00, session **C1 "Automated and Accessible Statistical Outputs"**,
room Bloch-Lainé 2. Order:

1. Automated public science communication: a Bluesky bot for official statistics visualisation
2. Beyond parametrised reports: automating country notes at the OECD
3. From code to print-ready publication: automating layout at the French Ministry of Justice
4. **Reproducible Statistical Publications with Quarto** (this talk)
5. From data acquisition to harmonised outputs: a reproducible R workflow for official statistics

In parallel: A1 (AI assistants) and B1 (reproducible statistical pipelines). Related talks
elsewhere in 2026: Quarto documents for sampling designs in agricultural surveys (lightning talk,
same day 14:00), an automated R framework for CPI reporting, standardisation and accessibility in
health-data publication. The Positron tutorial (Posit) runs on Wednesday 18.

*Inference:* the two talks just before ours show in-house publication pipelines. Repeating the
"parametrised reports" story or a feature tour would fall flat; the talk should relate to what the
room has just seen.

## Familiarity with R Markdown and Quarto

- R Markdown appears every year, mostly as parametrised reports or inside Shiny apps (Eurostat,
  DG TAXUD, Statistics Sweden, Statistics Latvia, Statistics Portugal). Quarto appears rarely
  (2023: report automation to html/pdf/docx/pptx from a university; 2025: an automated Quarto
  report at STATEC).
- Slides at uRos2025: of 24 published decks, 17 were PowerPoint, 4 LaTeX Beamer, 2 made through
  pandoc, 3 Quarto reveal.js.
- *Inference:* most of the room knows the R Markdown name, few use Quarto, almost nobody knows
  Quarto projects, Typst or `_brand.yml`.

## Recurring needs seen in past programmes

- Corporate design for outputs (Bundesbank graphics, Destatis tables following design guidelines).
- Print-ready PDF without LaTeX expertise (UNIDO yearbook rebuilt with R Markdown + LaTeX).
- One source for several outputs (HTML, PDF, Word); automated recurring publications (Eurostat).
- Accessibility (in our session title; health-data publication talk).
- Multilingual outputs; migration away from SAS and Excel.

## Themes across editions

Keyword counts in the 2023–2025 books of abstracts (lines, not talks):

| Keyword | 2023 | 2024 | 2025 |
|---------|-----:|-----:|-----:|
| R Markdown | 0 | 4 | 0 |
| Quarto | 1 | 0 | 1 |
| reproducib* | 1 | 4 | 7 |
| Shiny | 6 | 14 | 13 |
| dashboard | 0 | 6 | 14 |
| SAS | 10 | 16 | 1 |
| git / GitHub / GitLab | 5 | 7 | 17 |
| Typst | 0 | 0 | 0 |

*Trend (inference):* Shiny dashboards and version control grow, reproducibility is a rising theme
(a "Reproducibility and Open Science" session in 2025, a reproducible pipelines session in 2026),
SAS migration fades, document publishing with R Markdown or Quarto stays marginal.

A talk-by-talk classification of past editions is in progress and will complete this section.

## Material from previous talks

- `cderv/2024-quarto-evolution-rmd` (SSP Hub / INSEE 2024, FR, 62 slides): a feature tour with
  generic examples, nothing specific to official statistics. Reuse the "why" block (computational
  documents and reproducibility, scientific Markdown, single-source publishing) and the
  "unifies + extends" opening, compressed. Leave out CLI help, engines, projects and tools.
- `cderv/user2024-quarto-talk` (useR! 2024, ~20 slides): short format; focus slides on Typst
  tables (gt to PDF) and `quarto publish`.
- `cderv/raukr-2025-quarto`: `_brand.yml` slide (HTML and PDF through Typst), syntax comparison
  with `auto-animate`, formats slides.
