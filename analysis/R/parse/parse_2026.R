# uRos2026 (Paris): accepted submissions raw/2026/abstracts.csv (uRosConf/programme2026).
#
# Columns: DOCID, SPEAKERS, Authors, LABOS, TYPDOC, TITLE, ABSTRACT. SPEAKERS and Authors
# (person names) are never returned. Type from TYPDOC via talk_type(): "Regular presentation"
# -> talk, "lightning talk (5min)" -> lightning, "Tutorial", "Keynote presentation",
# "EMOS session" -> emos. No session assignment in this file (session NA).
#
# LABOS looks like "1 - ThinkR (address), 2 - Theodo ( France)": split on the numbered
# items, drop the number and the trailing parenthesised address/country. A few submitters
# typed a person's name as their lab: lab entries equal to one of the authors' names (from
# the Authors column, in any word order) are dropped so that no person name reaches the
# output. Note: one TITLE in the source is itself truncated ("for Official Statistics: A
# Method for Data Editing Using Large Language Models"); it is kept as given.

parse_2026 <- function() {
  file <- "abstracts.csv"
  x <- readr::read_csv(file.path("raw", "2026", file), col_types = readr::cols(.default = "c"))

  # order-insensitive ("Thomas Guinhut" == "Guinhut Thomas")
  name_key <- function(s) {
    s <- str_to_lower(stringi::stri_trans_general(s, "Latin-ASCII"))
    map_chr(str_split(str_squish(s), " "), \(w) paste(sort(w), collapse = " "))
  }
  author_names <- x$Authors |>
    str_split(",") |>
    map(\(a) name_key(str_remove_all(a, "\\(\\s*[\\d, ]+\\s*\\)")))

  labs <- map2_chr(x$LABOS, author_names, function(l, nm) {
    if (is.na(l)) return(NA_character_)
    parts <- str_split(l, ",\\s*(?=\\d+\\s+-\\s)")[[1]]
    parts <- str_remove(parts, "^\\s*\\d+\\s+-\\s+")
    parts <- str_remove(parts, "\\s*\\([^()]*\\)\\s*$")
    parts <- squish(str_replace_all(parts, '""', '"'))
    parts <- parts[!is.na(parts) & !(name_key(parts) %in% nm)]
    parts <- unique(parts)
    if (length(parts) == 0) NA_character_ else paste(parts, collapse = "; ")
  })

  tibble(
    year = 2026L,
    talk_no = seq_len(nrow(x)),
    session = NA_character_,
    type = talk_type(x$TYPDOC),
    title = squish(x$TITLE),
    abstract = squish(x$ABSTRACT),
    affiliations = labs,
    source_file = file
  )
}
