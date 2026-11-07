# Step 5: the tables the talk relies on, from data/coding-final.csv.
#
# Outputs (all in data/):
# - summary-by-year.csv: talks, publishing and reproducibility talks per year
# - summary-tools.csv: tools named by publishing talks, per period
# - summary-needs.csv: needs stated by publishing talks, per period
# - publishing-talks.csv: every talk coded publishing = central, for reading
# The speaker's own talk (2026-075) is left out of every table.
#
# Usage, from analysis/: Rscript R/05-summarise.R

source("R/utils.R")

talks <- read_csv(file.path(data_dir, "talks.csv"), col_types = cols(.default = "c"))
coding <- read_csv(file.path(data_dir, "coding-final.csv"), col_types = cols(.default = "c"), na = "")

d <- talks |>
  select(id, year, type, title, affiliations, has_abstract) |>
  inner_join(coding, by = "id") |>
  mutate(
    year = as.integer(year),
    has_abstract = has_abstract == "TRUE",
    pub = publishing %in% c("central", "partial"),
    pub_central = publishing == "central",
    repro = reproducibility %in% c("central", "partial"),
    # Titles only before 2020 (and in 2022): the two periods are not comparable.
    source_kind = if_else(year %in% c(2020, 2021, 2023:2026), "abstracts", "titles only"),
    period = case_when(year <= 2019 ~ "2014-2019", year <= 2025 ~ "2020-2025", TRUE ~ "2026")
  )
stopifnot(nrow(d) == nrow(talks))

# Leave out the speaker's own talk: the claims are about the community.
own_talk <- "2026-075"
d <- filter(d, id != own_talk)

by_year <- d |>
  group_by(year, source_kind) |>
  summarise(
    talks = n(),
    publishing = sum(pub),
    publishing_central = sum(pub_central),
    reproducibility = sum(repro),
    publishing_and_reproducibility = sum(pub & repro),
    .groups = "drop"
  ) |>
  mutate(
    publishing_share = round(publishing / talks, 3),
    reproducibility_share = round(reproducibility / talks, 3)
  )
write_csv(by_year, file.path(data_dir, "summary-by-year.csv"))
print(by_year, n = Inf, width = Inf)

explode <- function(x, var) {
  x |>
    select(id, period, value = all_of(var)) |>
    separate_longer_delim(value, ";") |>
    mutate(value = str_trim(value)) |>
    filter(value != "", !value %in% c("none", "not_stated"))
}

pub_talks <- filter(d, pub)
n_by_period <- count(pub_talks, period, name = "publishing_talks")

tools <- explode(pub_talks, "tools") |>
  count(period, tool = value) |>
  left_join(n_by_period, by = "period") |>
  arrange(period, desc(n))
write_csv(tools, file.path(data_dir, "summary-tools.csv"))
print(tools, n = Inf)

needs <- explode(pub_talks, "needs") |>
  count(period, need = value) |>
  left_join(n_by_period, by = "period") |>
  arrange(period, desc(n))
write_csv(needs, file.path(data_dir, "summary-needs.csv"))
print(needs, n = Inf)

d |>
  filter(pub_central) |>
  select(id, year, type, title, affiliations, reproducibility, outputs, tools, needs, need_quote) |>
  write_csv(file.path(data_dir, "publishing-talks.csv"), na = "")
