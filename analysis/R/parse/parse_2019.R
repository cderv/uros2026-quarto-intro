# uRos 2019 (7th conference, Bucharest): final agenda PDF, titles only, no
# abstracts. Shared ro_* helpers live in parse_2014.R.
#
# Titles are not numbered: each title (possibly wrapped) is followed by its
# author lines "Given SURNAME, Institution". Heuristics (ro_unnumbered_step):
# a line is an author line when it starts with person names followed by an
# institution; a non-author line after an author line continues the
# institution when it ends on a country or the previous line is left open,
# otherwise it is the next title.
#
# Types: the two keynotes ("Keynote Speaker N", title on the "Presentation -"
# line) are taken by hand; "Parallel Tutorial Sessions" and the Conference
# Room slot of "Parallel Tutorial and Scientific Sessions" are tutorials;
# "Scientific Session ..." and the "Project Presentation" are talks.
# Left out: welcome, breaks, dinner, closing remarks and the satellite
# unconference (no presentations listed).

if (!exists("ro_parse_numbered")) source("R/parse/parse_2014.R")

parse_2019 <- function() {
  file <- "Final_agenda_uRos2019_v3.pdf"
  lines <- ro_lines(file.path("raw", "2019", file), 3:8)
  stop_at <- which(str_detect(lines, "^Contact"))
  if (length(stop_at)) lines <- lines[seq_len(stop_at[1] - 1)]

  # Keynotes, by hand: title on the "Presentation - " line, one wrapped line
  # for the second keynote. Institutions taken from the speaker lines.
  k <- which(str_detect(lines, "^\\s*Presentation - "))
  stopifnot(length(k) == 2)
  k_title <- map_chr(k, \(i) {
    t <- str_remove(lines[i], "^\\s*Presentation - ")
    nxt <- lines[i + 1]
    if (is.na(ro_time_rest(nxt))) t <- paste(t, nxt)
    t
  })
  keynotes <- list(
    ro_row(2019, "Keynote Speaker 1", "keynote", k_title[1],
           "Ecole Polytechnique, France", file),
    ro_row(2019, "Keynote Speaker 2", "keynote", k_title[2],
           "Italian National Institute of Statistics (Istat), Italy", file)
  )

  st <- list(rows = list(), cur = NULL, last = "none", prev = "", year = 2019,
             session = NA_character_, type = "talk", file = file)
  mode <- "skip"
  chair_cont <- "^(Bucharest, Romania|University of Bucharest, Romania|United Nations)$"
  after_chair <- FALSE
  for (l in lines) {
    s <- str_squish(l)
    rest <- ro_time_rest(l)
    if (!is.na(rest)) s <- str_squish(rest)

    if (after_chair && str_detect(s, chair_cont)) {
      # chairman's institution wrapped on a second line
      after_chair <- FALSE
      next
    }
    after_chair <- FALSE

    if (ro_is_lone_time(l)) {
      st <- ro_unnumbered_flush(st)
      mode <- "skip"
    } else if (str_detect(s, "^(Conference Room|Blue Hall), Ground Floor$")) {
      # a room change starts a new parallel track inside the same slot
      st <- ro_unnumbered_flush(st)
      if (!is.na(rest)) mode <- "skip"
    } else if (str_detect(s, "^Parallel Tutorial Sessions")) {
      st <- ro_unnumbered_flush(st)
      mode <- "items"
      st$session <- s
      st$type <- "tutorial"
    } else if (str_detect(s, "^Parallel Tutorial and Scientific Sessions")) {
      # Conference Room: one tutorial; Blue Hall: a scientific session (below)
      st <- ro_unnumbered_flush(st)
      mode <- "items"
      st$session <- s
      st$type <- "tutorial"
    } else if (str_detect(s, "^Scientific Session ")) {
      st <- ro_unnumbered_flush(st)
      mode <- "items"
      st$session <- str_remove(s, "^Scientific Session ")
      st$type <- "talk"
    } else if (s == "Project Presentation") {
      st <- ro_unnumbered_flush(st)
      mode <- "items"
      st$session <- s
      st$type <- "talk"
    } else if (str_detect(s, "^Chairman")) {
      st <- ro_unnumbered_flush(st)
      after_chair <- TRUE
    } else if (!is.na(rest)) {
      # any other time slot: registration, welcome, keynote, breaks, closing
      st <- ro_unnumbered_flush(st)
      mode <- "skip"
    } else if (mode == "items") {
      st <- ro_unnumbered_step(st, l)
    }
  }
  st <- ro_unnumbered_flush(st)

  x <- bind_rows(c(keynotes, st$rows))
  # Programme order: keynote 1 comes before the tutorials, keynote 2 opens day
  # two; place rows by the line where their title appears.
  first_line <- map_int(x$title, \(t) {
    w <- str_sub(t, 1, 25)
    which(str_detect(str_squish(lines), fixed(w)))[1]
  })
  x |>
    mutate(.pos = first_line) |>
    arrange(.pos) |>
    select(-.pos) |>
    mutate(talk_no = row_number(), .after = year) |>
    select(year, talk_no, session, type, title, abstract, affiliations, source_file)
}
