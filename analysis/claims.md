# Claims used in the talk, and what backs them

Each claim was checked by an independent agent that recomputed the numbers from
`data/talks.csv` and `data/coding-final.csv`, and read the titles and abstracts behind
them.
The speaker's own talk (2026-075) is left out.
Numbers count programme items (talks, lightning talks, tutorials, keynotes, EMOS
sessions): 532 from 2014 to 2026.

| #   | Wording for the talk                                                                                                                               | Numbers                                                                                                                                             | Talks behind it                                                                                                                                                                      |
| --- | -------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 1   | Since 2017, every uRos edition had at least one talk centred on publishing statistics.                                                             | Talks coded `publishing = central` per year: 2014 1, 2015 1, 2016 0, 2017 1, 2018 5, 2019 4, 2020 2, 2021 5, 2022 3, 2023 3, 2024 2, 2025 2, 2026 6 | `data/publishing-talks.csv`                                                                                                                                                          |
| 2   | About 35 talks since 2014 were centred on publishing statistics, out of about 530.                                                                 | 35 of 532; 66 counting talks where publishing is a part                                                                                             | 14 of the 35 come from years with titles only                                                                                                                                        |
| 3   | Talks centred on publishing keep naming the same needs: automating recurring publications, the institute's corporate design, and less manual work. | Among the 35: automation 14, corporate design 10, less manual work 8, interactivity 6                                                               | `needs` in `data/coding-final.csv`                                                                                                                                                   |
| 4   | Several institutes built their own in-house package to get there.                                                                                  | 10 talks centred on publishing name an in-house package                                                                                             | Statistics Austria 2021, Bundesbank 2023 (bbkplot), Destatis 2025–2026 (procR), Eurostat 2025, Ministry of Justice (France) 2026, Public Health Scotland 2026 (phsshiny), and others |
| 5   | In years with abstracts, the share of talks touching on reproducibility went from about 1 in 6 (2020) to about 1 in 3 (2026).                      | 2020 15.8%, 2021 14.6%, 2023 20.0%, 2024 26.1%, 2025 21.1%, 2026 35.1% (39 of 111)                                                                  | Not a steady rise; mostly `partial` codes, the softest part of the coding                                                                                                            |
| 6   | Before 2026, only one abstract named Quarto for producing publications (2023), and one other for an internal report (2025).                        | 2023-013 (a university), 2025-028 (an internal report)                                                                                              | Titles only before 2020 and in 2022: a mention there would not show                                                                                                                  |

## Timeline of talks centred on publishing (institutions, never speakers)

- 2017 Destatis: automation of publications using knitr (title only)
- 2018: a corporate design toolbox for R; R Markdown as an alternative to LaTeX for
  high-quality reports (titles only, no affiliation in the programme: do not name an
  institution)
- 2019 Statistical Office of the Canton of Zurich: semi-automatic reports with R
  Markdown
- 2019 Ministry of Justice (France): reproducible corporate publications using pagedown
- 2023 UNIDO: revamped statistical publications (R Markdown and LaTeX)
- 2023 Deutsche Bundesbank: corporate design in R (bbkplot)
- 2024 Eurostat EMOS Coding Lab: automating Statistics Explained articles
- 2024 DG TAXUD: a monthly Statistics Explained article with R Markdown
- 2026 OECD: automating country notes
- 2026 Ministry of Justice (France): from code to print-ready publication

## Caveats to have ready

- Two kinds of source: titles only for 2014–2019 and 2022, abstracts otherwise.
  Early years are undercounted; compare trends only across years with abstracts.
- 2026 is three times bigger (three tracks, 23 lightning talks): use shares, not counts.
- One conference: programmes show what was submitted, not what institutes do.
- Classification by language-model agents: two independent coders, an adjudicator,
  agreement 96% on "publishing or not" (kappa 0.85); method in `README.md`, data in
  `data/`.
- Small numbers: several years rest on one or two talks.
- Not only R Markdown talks: about 10 of the 35 talks centred on publishing name knitr,
  R Markdown, pagedown or Quarto; the other 25 name Shiny, an in-house package, another
  tool, or none. Without those 10, every year from 2018 still has a talk centred on
  publishing. 2017 is one title-only talk (Destatis, knitr).
- Reports for internal use are not counted as publishing (2024-025, 2025-028, 2026-044,
  2026-077), even when they use R Markdown or Quarto.
- Quarto at uRos: up to 2025, two abstracts name it (2023 for publications, 2025 for an
  internal report). In 2026, six other abstracts name it: one for a publication (OECD),
  three for internal reports, two in passing. Tools used inside institutes but not
  presented at uRos do not show here.

These last three caveats were recomputed from `data/coding-final.csv` and
`data/talks.csv` on 17 November 2026, after the independent claim check.
