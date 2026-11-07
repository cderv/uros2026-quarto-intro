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
- 2026 marks a shift: 7 of the 112 abstracts in `abstracts.csv` (programme repository) mention
  Quarto, against about one a year before. They are the OECD country notes talk, the Positron
  tutorial, a time-series production workflow, an R-based survey fieldwork early-warning system,
  "What makes the R community unique?", this talk, and a lightning talk titled "Using Quarto
  Documents in Agricultural Surveys" (Thursday 14:00, after ours). R Markdown appears in 4
  abstracts. This talk is still the first regular talk dedicated to Quarto.
- The OECD talk in our session uses "RMarkdown, quarto and officer" (its abstract) and focuses on
  non-technical constraints: corporate standards, fragmented pipelines, many stakeholders.

## Recurring needs seen in past programmes

- Corporate design for outputs (Bundesbank graphics, Destatis tables following design guidelines).
- Print-ready PDF without LaTeX expertise (UNIDO yearbook rebuilt with R Markdown + LaTeX).
- One source for several outputs (HTML, PDF, Word); automated recurring publications (Eurostat).
- Accessibility (in our session title; health-data publication talk).
- Multilingual outputs; migration away from SAS and Excel.

## Themes across editions

Rebuilt reproducibly on 2026-11-07 in `analysis/` (R scripts, data, method in
`analysis/README.md`; claims used in the talk, with their numbers and caveats, in
`analysis/claims.md`). It replaces an earlier one-off classification (about 480 talks, single
coder) whose figures should no longer be quoted.

- 532 programme items, 2014–2026 (the speaker's own talk left out); abstracts for 2020–2021 and
  2023–2026, titles only for 2014–2019 and 2022 (2018, 2019 and 2022 books of abstracts not
  archived). Sources: Common Crawl copies of r-project.ro and the uRosConf GitHub repositories.
- Classification by two independent language-model coders, an adjudicator and an independent
  fact-check; agreement 96% on "publishing or not" (kappa 0.85).
- Every edition since 2017 had at least one talk centred on publishing statistics, about 35 in
  all (66 counting talks where publishing is a part).
- The needs that come back: automating recurring publications, the institute's corporate design,
  less manual work. Ten publishing talks present an in-house package (Statistics Austria,
  Bundesbank, Destatis, Eurostat, Ministry of Justice, Public Health Scotland...).
- Reproducibility: in years with abstracts, about 1 talk in 6 (2020) to about 1 in 3 (2026), not
  a steady rise, mostly partial.
- Quarto before 2026: one abstract for producing publications (2023, a university) and one for an
  internal report (2025). R Markdown-family publishing talks cluster in 2017–2019 and 2023–2024.
- No past tutorial was on R Markdown or Quarto.

*Inference:* publishing is a steady minority topic, and the same needs keep being solved with
in-house pipelines; uRos remains a practitioners' conference about methods and production.

## Quarto already in use in official statistics

Public products checked on 2026-11-05: each page carries Quarto's `<meta name="generator">` tag,
or its source repository builds it with Quarto. Candidates for the "one source, many products"
grid; ask the institutions before showing screenshots if in doubt.

| Institution | Product | Type | URL |
|---|---|---|---|
| Insee (DEE) | Working paper on time-varying coefficient regressions for nowcasting, also on insee.fr | report, HTML + PDF | <https://inseefrlab.github.io/DT-tvcoef/> |
| Insee | Working paper *Introduction aux méthodes ensemblistes* (PDF built with Typst) | book, HTML + PDF | <https://inseefrlab.github.io/DT_methodes_ensemblistes/> |
| Insee / SSP | *Manuel de protection des tableaux* | book, HTML + PDF | <https://inseefrlab.github.io/manuel-protection-tableaux/> |
| SSM Agriculture (Agreste) | Dataviz catalogue (Closeread scrollytelling) | website | <https://ssm-agriculture.github.io/site-DataViz/> |
| ONS | Weekly deaths data explorer (prototype) | dashboard | <https://onsdigital.github.io/weekly_deaths_data_explorer/> |
| ONS | Health Insight Survey dashboard (official statistics in development) | dashboard | <https://onsdigital.github.io/health-insight-survey-dashboard/> |
| NISRA | Weekly deaths in Northern Ireland | dashboard | <https://nisra-explore.github.io/weekly-deaths/> |
| NISRA / Dept of Education | NI Childcare Survey 2024 results | report | <https://nisra-explore.github.io/childcare-survey/> |
| Statistics Norway | Documentation report with an ISBN (register-based wage statistics) | book | <https://doc.ameld.ssb.no/> |
| OECD (CFE) | Regional Outlook 2023 country profiles | website | <https://oecd-cfe-eds.github.io/ro2023-country-pages/> |
| UNECE HLG-MOS | Statistical Open Source Software principles, endorsed by the CES in 2025 | website | <https://unece.github.io/OSS/> |
| JDemetra+ (Insee, Bundesbank, NBB...) | JDemetra+ documentation, with a PDF | book | <https://jdemetra-new-documentation.netlify.app/> |
| SSPHub, utilitR, Insee and ENSAE courses | Network site, R documentation, training | website, book | <https://ssphub.netlify.app/>, <https://www.utilitr.org/> |

Also: Insee's `InseeFrLab/etudes.pdf` (Quarto + Typst formats reproducing the *Insee Flash* and
*Insee Analyses* layouts, not yet used for a published issue), the UK Analysis Function's RAP
guidance and AQuA Book draft, Statistics Norway's Dapla manual, the DfE analysts' guide. Not found
(not a proof of absence): Eurostat, ECB, Bundesbank, Banque de France, StatCan, CBS, SCB, ISTAT,
DREES, DARES, SDES, DEPP; the OECD country notes of our session have no public output.

## Material from previous talks

- `cderv/2024-quarto-evolution-rmd` (SSP Hub / INSEE 2024, FR, 62 slides): a feature tour with
  generic examples, nothing specific to official statistics. Reuse the "why" block (computational
  documents and reproducibility, scientific Markdown, single-source publishing) and the
  "unifies + extends" opening, compressed. Leave out CLI help, engines, projects and tools.
- `cderv/user2024-quarto-talk` (useR! 2024, ~20 slides): short format; focus slides on Typst
  tables (gt to PDF) and `quarto publish`.
- `cderv/raukr-2025-quarto`: `_brand.yml` slide (HTML and PDF through Typst), syntax comparison
  with `auto-animate`, formats slides.
