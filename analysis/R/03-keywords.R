# Step 3: deterministic keyword flags per talk, data/keywords.csv.
#
# Searches title + abstract (title only when the source has no abstract).
# These flags do not depend on any judgement and serve to cross-check the
# LLM-assisted classification (step 4).
#
# Usage, from analysis/: Rscript R/03-keywords.R

source("R/utils.R")

talks <- read_csv(file.path(data_dir, "talks.csv"), col_types = cols(.default = "c"))

patterns <- c(
  quarto       = "\\bquarto\\b",
  rmarkdown    = "\\br ?markdown\\b|\\.rmd\\b|\\bknitr\\b|\\bbookdown\\b|\\bpagedown\\b|\\bblogdown\\b|\\bflexdashboard\\b",
  sweave_latex = "\\bsweave\\b|\\blatex\\b",
  word_office  = "\\bofficer\\b|\\bms word\\b|\\bword document|\\bdocx\\b|\\bpowerpoint\\b|\\bflextable\\b",
  shiny        = "\\bshiny\\b",
  dashboard    = "\\bdashboards?\\b",
  reproducib   = "\\breproducib\\w*|\\breplicab\\w*|\\breproducible analytical pipeline|\\brap\\b",
  publication  = "\\bpublication(s)?\\b|\\bpublishing\\b|\\bdissemination\\b|\\breport(s|ing)?\\b|\\bbulletin\\b|\\bpress release",
  typst        = "\\btypst\\b",
  sas          = "\\bsas\\b",
  excel        = "\\bexcel\\b|\\bspreadsheets?\\b",
  git          = "\\bgit\\b|\\bgithub\\b|\\bgitlab\\b|\\bversion control"
)

text <- str_to_lower(paste(talks$title, coalesce(talks$abstract, "")))

keywords <- talks |>
  select(id, year, has_abstract) |>
  bind_cols(map(patterns, \(p) str_detect(text, p)) |> as_tibble())

write_csv(keywords, file.path(data_dir, "keywords.csv"))

keywords |>
  group_by(year) |>
  summarise(talks = n(), with_abstract = sum(has_abstract == "TRUE"), across(all_of(names(patterns)), sum)) |>
  print(n = Inf, width = Inf)
