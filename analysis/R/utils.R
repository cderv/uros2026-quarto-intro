# Shared helpers for the uRos programme analysis.
# Run every script from the analysis/ directory (the rig project root).

suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(stringr)
  library(purrr)
  library(tidyr)
})

raw_dir <- "raw"
data_dir <- "data"
dir.create(raw_dir, showWarnings = FALSE)
dir.create(data_dir, showWarnings = FALSE)

# Download a source once into raw/<year>/ and return the local path.
# raw/ is not committed: data/sources.csv records each URL with its SHA-256.
fetch <- function(url, year, file = basename(sub("[?#].*$", "", url))) {
  dest_dir <- file.path(raw_dir, year)
  dir.create(dest_dir, showWarnings = FALSE, recursive = TRUE)
  dest <- file.path(dest_dir, file)
  if (!file.exists(dest)) {
    message("Downloading ", url)
    utils::download.file(url, dest, mode = "wb", quiet = TRUE)
  }
  dest
}

sha256 <- function(path) {
  out <- system2("sha256sum", shQuote(path), stdout = TRUE)
  sub(" .*$", "", out)
}

# Normalise whitespace in titles and abstracts.
squish <- function(x) {
  x <- str_replace_all(x, "[ \t\r\n]+", " ")
  x <- str_squish(x)
  ifelse(x == "", NA_character_, x)
}

# Harmonised talk types across editions.
talk_type <- function(x) {
  x <- str_to_lower(x)
  case_when(
    str_detect(x, "keynote|invited") ~ "keynote",
    str_detect(x, "tutorial|workshop|training") ~ "tutorial",
    str_detect(x, "lightning|flash|short") ~ "lightning",
    str_detect(x, "poster") ~ "poster",
    str_detect(x, "panel|round ?table|discussion") ~ "panel",
    str_detect(x, "emos") ~ "emos",
    is.na(x) | x == "" ~ "talk",
    TRUE ~ "talk"
  )
}
