# uRos2025 (Bucharest): book of abstracts v3 + detailed agenda v10.
#
# - raw/2025/book-of-abstracts-uRos2025_v3.pdf gives titles, abstracts, affiliations
#   (38 entries, parse_book() in R/parse/book_helpers.R). Rows follow book order.
# - raw/2025/Detailed_agenda_uRos2025_v10.pdf gives sessions and types (tutorial and keynote
#   slots, "EMOS Session", "Lightning talk:" prefix). match_agenda() matches all 38 entries
#   on normalised titles ("Designing Effective Visualizations: ..." matches on its first
#   words: the agenda subtitle differs from the book).
#   The session "Automating and Operationalizing, Advanced Analytics and AI" runs twice
#   (25 and 26 November) under the same name.

source(file.path("R", "parse", "book_helpers.R"))

parse_2025 <- function() {
  book_file <- "book-of-abstracts-uRos2025_v3.pdf"
  b <- parse_book(file.path("raw", "2025", book_file))
  a <- agenda_lines(file.path("raw", "2025", "Detailed_agenda_uRos2025_v10.pdf"), "BRIEF AGENDA")
  m <- match_agenda(b, a)
  stopifnot(all(m$matched))
  tibble(
    year = 2025L,
    talk_no = seq_len(nrow(m)),
    session = m$session,
    type = m$type,
    title = squish(m$title),
    abstract = m$abstract,
    affiliations = m$affiliations,
    source_file = book_file
  )
}
