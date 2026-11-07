# uRos 2015 (3rd conference, Bucharest): programme PDF, titles only, no
# abstracts. Same layout as 2014; shared ro_* helpers live in parse_2014.R.
#
# Two days, numbering restarts on 24 April; the parallel session of 24 April
# (Working Session VII) is kept. The 24 April "Workshop (topic to be
# announced)" lecture has no title in the programme and is left out.

if (!exists("ro_parse_numbered")) source("R/parse/parse_2014.R")

parse_2015 <- function() {
  file <- "conference_programme_R_RO_2015.pdf"
  lines <- ro_lines(file.path("raw", "2015", file), 3:7)
  ro_parse_numbered(lines, 2015, file) |>
    mutate(talk_no = row_number(), .after = year) |>
    select(year, talk_no, session, type, title, abstract, affiliations, source_file)
}
