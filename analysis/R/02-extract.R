# Step 2: parse every edition into one talk-by-talk table, data/talks.csv.
#
# One parser per edition in R/parse/parse_<year>.R (formats differ every
# year). Each returns the same columns; speakers' names are never kept.
#
# Usage, from analysis/: Rscript R/02-extract.R

source("R/utils.R")
walk(list.files("R/parse", pattern = "^parse_\\d{4}\\.R$", full.names = TRUE), source)

years <- as.integer(str_extract(ls(pattern = "^parse_\\d{4}$"), "\\d{4}"))

talks <- map(sort(years), \(y) get(paste0("parse_", y))()) |>
  list_rbind() |>
  mutate(
    year = as.integer(year),
    talk_no = as.integer(talk_no),
    id = sprintf("%d-%03d", year, talk_no),
    has_abstract = !is.na(abstract) & nchar(abstract) > 50
  ) |>
  relocate(id)

# Sanity checks: unique ids, every talk has a title, allowed types only.
stopifnot(
  !anyDuplicated(talks$id),
  all(!is.na(talks$title) & nchar(talks$title) > 5),
  all(talks$type %in% c("talk", "keynote", "tutorial", "lightning", "poster", "panel", "emos"))
)

write_csv(talks, file.path(data_dir, "talks.csv"), na = "")

talks |>
  count(year, has_abstract) |>
  pivot_wider(names_from = has_abstract, values_from = n, names_prefix = "abstract_") |>
  print(n = Inf)
