# uRos2024 (Piraeus): book of abstracts v3 + detailed agenda v14.
#
# - raw/2024/book-of-abstracts-uros2024_v3.pdf gives titles, abstracts, affiliations
#   (46 entries, parse_book() in R/parse/book_helpers.R). Rows follow book order.
# - raw/2024/Detailed_agenda_uRos2024_v14.pdf gives sessions and types ("Lightning talk:"
#   prefix, tutorial and keynote slots). match_agenda() matches 44 of 46 book entries on
#   normalised titles; hand fixes below:
#   * "Systematic Data Validation with the validate Package" is tutorial III, listed in the
#     agenda as "Data validation";
#   * "The R Package “Survey Data Quality”" is not in the agenda (kept, session NA, "talk");
#   * "nonprobsvy: ..." appears twice in the book: the entry with two authors (page 31) is the
#     tutorial (given by two people in the agenda), the three-author entry (page 29) is the
#     talk in "Sampling and Estimation"; match_agenda() assigns them the other way round.
#   * the title on page 57 is printed on two lines without the separator used in the agenda.

source(file.path("R", "parse", "book_helpers.R"))

parse_2024 <- function() {
  book_file <- "book-of-abstracts-uros2024_v3.pdf"
  b <- parse_book(file.path("raw", "2024", book_file))
  a <- agenda_lines(file.path("raw", "2024", "Detailed_agenda_uRos2024_v14.pdf"), "BRIEF AGENDA")
  m <- match_agenda(b, a)

  i <- str_detect(m$title, "^Systematic Data Validation with the validate Package")
  m$session[i] <- "Tutorial session III"
  m$type[i] <- "tutorial"
  np <- which(str_detect(m$title, "^nonprobsvy:"))
  stopifnot(length(np) == 2)
  m$session[np] <- c("Sampling and Estimation", "Tutorial session I")
  m$type[np] <- c("talk", "tutorial")
  m$title <- str_replace(m$title, "content production The case", "content production - The case")

  tibble(
    year = 2024L,
    talk_no = seq_len(nrow(m)),
    session = m$session,
    type = m$type,
    title = squish(m$title),
    abstract = m$abstract,
    affiliations = m$affiliations,
    source_file = book_file
  )
}
