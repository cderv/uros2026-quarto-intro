# uRos2021 (online): book of abstracts raw/2021/book-of-abstracts-uros2021.pdf.
#
# Parsed with parse_book() (R/parse/book_helpers.R): one entry per presentation, 41 entries
# (matches the 41 lines of the Contents). No agenda was downloaded for 2021, so session is NA
# and every entry is typed "talk" (the book does not label keynotes or tutorials).
# Affiliations come from the parentheses of the author bullets; names are never returned.

source(file.path("R", "parse", "book_helpers.R"))

parse_2021 <- function() {
  file <- "book-of-abstracts-uros2021.pdf"
  b <- parse_book(file.path("raw", "2021", file))
  # Hand fix: the first title is typeset with dotless i ("Reportıng And Comparıng ...").
  b$title <- str_replace_all(b$title, "ı", "i")
  tibble(
    year = 2021L,
    talk_no = seq_len(nrow(b)),
    session = NA_character_,
    type = "talk",
    title = squish(b$title),
    abstract = b$abstract,
    affiliations = b$affiliations,
    source_file = file
  )
}
