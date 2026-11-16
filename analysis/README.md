# How does the uRos community publish statistics?

A reproducible look at the programmes of uRos (The Use of R in Official Statistics),
2014–2026, made to back the opening of the talk
*Reproducible Statistical Publications with Quarto* (uRos2026).
Question: how often do talks deal with publishing statistics (reports, bulletins,
websites, dashboards) and with reproducibility, which tools do they use to produce
outputs, and what needs do they describe?

Speakers' names are never kept: talks are referred to by year, title and institution.

## Pipeline

Run from this directory after `rig proj sync` (packages pinned in `rproj.lock`):

```bash
Rscript R/01-fetch.R      # download the sources listed in sources.csv into raw/ (not committed)
Rscript R/02-extract.R    # one parser per edition (R/parse/) -> data/talks.csv
Rscript R/03-keywords.R   # deterministic keyword flags -> data/keywords.csv
Rscript R/05-summarise.R  # tables used in the talk -> data/summary-*.csv
```

Step 4, the classification, is not a script: see below.

## Sources

`sources.csv` lists one programme or book of abstracts per edition.
The conference site (urosconf.org, r-project.ro) could not be reached when this was
built, so most files come from the [Common Crawl](https://commoncrawl.org) archive of
r-project.ro: each is one WARC record fetched by byte range from `data.commoncrawl.org`.
2020 and 2026 come from the [uRosConf](https://github.com/uRosConf) GitHub repositories.
`data/sources-fetched.csv` records the SHA-256 of every file used.

| Editions        | Content                                             | Abstracts       |
| --------------- | --------------------------------------------------- | --------------- |
| 2014–2019, 2022 | programme (agenda) only                             | no, titles only |
| 2020            | abstract submissions, checked against the programme | yes             |
| 2021, 2023–2025 | book of abstracts, plus the agenda for talk types   | yes             |
| 2026            | `abstracts.csv` of the programme repository         | yes             |

Not covered: 2013 (no international edition found).
The 2018, 2019 and 2022 books of abstracts were not archived in a usable form.

## Classification (step 4)

Each talk is classified from its title and abstract with the codebook below, by
language-model agents (Claude), not by a script: no API key was used, so this step
cannot be re-run with one command.
To limit the bias of a single coder, and the bias of a coder working for the company
that makes Quarto:

1. **Two independent codings** (`data/coding-a.csv`, `data/coding-b.csv`): two agents
   classify every talk without seeing each other's work.
2. **Adjudication** (`data/coding-final.csv`): a third agent settles each disagreement,
   citing the abstract, and records the reason.
3. **Agreement** between the two codings is reported for every variable
   (`data/agreement.csv`).
4. **Cross-check** against the keyword flags of step 3: a talk flagged `quarto` must not
   be coded as using no tool, and so on.
5. **Claim check**: an agent that did not take part checks every number and sentence
   used in the talk against `data/` and reports what is not supported.

### Codebook

The categories are deliberately neutral: they describe what a talk is about, not whether
it needs a given tool.

| Variable          | Values                                                                                                                                                                  | Meaning                                                                                                                                                                                                            |
| ----------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `publishing`      | central, partial, none                                                                                                                                                  | The talk is about producing or disseminating statistical outputs for readers (reports, bulletins, publications, tables, websites, dashboards, press releases). "partial" when outputs are a part of a broader talk |
| `reproducibility` | central, partial, none                                                                                                                                                  | Reproducible production: code-based pipelines, literate programming, version control, reproducible analytical pipelines                                                                                            |
| `outputs`         | list: print_pdf, web_html, word, dashboard, spreadsheet, slides, open_data_api, none                                                                                    | Output formats the talk mentions producing                                                                                                                                                                         |
| `tools`           | list: quarto, rmarkdown_knitr, sweave_latex, pagedown_bookdown, word_officer, shiny, spreadsheet, sas, desktop_publishing, in_house_package, other, not_stated          | Tools named for producing outputs                                                                                                                                                                                  |
| `needs`           | list: consistency_formats, corporate_design, print_quality, automation_recurring, accessibility, multilingual, timeliness, less_manual_work, interactivity, other, none | Needs or problems the talk describes about publishing                                                                                                                                                              |
| `need_quote`      | text                                                                                                                                                                    | The words of the title or abstract that support `needs`, verbatim, at most 25 words                                                                                                                                |
| `theme`           | methods, editing_imputation, sdc, time_series, production, visualisation, shiny_apps, publication, reproducibility, packages, ml_ai, other                              | Primary theme of the talk, one value                                                                                                                                                                               |
| `confidence`      | high, medium, low                                                                                                                                                       | low when only the title is available and the call is unclear                                                                                                                                                       |

Rules: code what the text says, not what the coder guesses; with only a title, use
`none` and `not_stated` unless the title is explicit.

## Limits

- Titles only for 2014–2019 and 2022: publishing talks are undercounted there, and
  trends across years mix two kinds of source.
- Programmes are not attendance: a talk listed may not have been given.
- The 2026 conference has three parallel tracks and about three times more talks than
  before: compare shares, not counts.
- Language-model classification is reproducible in method, not bit for bit.
