# uRos2023 (Bucharest): book of abstracts (draft v1) + brief agenda.
#
# - raw/2023/book-of-abstracts-uros2023-draft-v1.pdf gives titles, abstracts, affiliations
#   (24 entries, parse_book() in R/parse/book_helpers.R).
# - raw/2023/uRos2023_Agenda_brief_v3.pdf names only the tutorials and keynotes; the scientific
#   sessions are listed without their talks, so the other talks keep session NA, type "talk".
#   match_agenda() matches 4 book entries: tutorials I and III, keynotes 1 and 2.
# - Tutorial II "Parallel computing in R" is in the agenda but has no entry in the book: it is
#   added at the end with NA abstract and affiliations (the agenda gives only a person name).
# Total: 25 rows.

source(file.path("R", "parse", "book_helpers.R"))

parse_2023 <- function() {
  book_file <- "book-of-abstracts-uros2023-draft-v1.pdf"
  agenda_file <- "uRos2023_Agenda_brief_v3.pdf"
  b <- parse_book(file.path("raw", "2023", book_file))
  a <- agenda_lines(file.path("raw", "2023", agenda_file))
  m <- match_agenda(b, a)
  # Only tutorial/keynote matches are meaningful in a brief agenda.
  m$session[m$type == "talk"] <- NA_character_
  out <- tibble(
    session = m$session,
    type = m$type,
    title = squish(m$title),
    abstract = m$abstract,
    affiliations = m$affiliations,
    source_file = book_file
  )
  extra <- tibble(
    session = "Tutorial session II",
    type = "tutorial",
    title = "Parallel computing in R",
    abstract = NA_character_,
    affiliations = NA_character_,
    source_file = agenda_file
  )
  bind_rows(out, extra) |>
    mutate(year = 2023L, talk_no = row_number(), .before = 1)
}
