# uRos 2016 (4th conference, Bucharest): programme PDF, titles only, no
# abstracts. Same layout as 2014; shared ro_* helpers live in parse_2014.R.

if (!exists("ro_parse_numbered")) source("R/parse/parse_2014.R")

parse_2016 <- function() {
  file <- "conference_programme_R_RO_2016.pdf"
  lines <- ro_lines(file.path("raw", "2016", file), 3:5)
  x <- ro_parse_numbered(lines, 2016, file)
  # Hand-written row: the Open Session holds one unnumbered talk, printed as
  # the speaker line followed by the title, which the numbered parser skips.
  i <- which(str_detect(lines, "R-based predictive models"))
  stopifnot(length(i) == 1)
  open <- ro_row(
    2016, "Open Session", "talk",
    paste(lines[i], lines[i + 1]), "Microsoft, Romania", file
  )
  bind_rows(open, x) |>
    mutate(talk_no = row_number(), .after = year) |>
    select(year, talk_no, session, type, title, abstract, affiliations, source_file)
}
