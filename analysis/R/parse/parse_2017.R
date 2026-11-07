# uRos 2017 (5th conference, Bucharest): agenda PDF, titles only, no
# abstracts. Shared ro_* helpers live in parse_2014.R. (The file starts with a
# few junk bytes before %PDF; pdftools reads it anyway.)
#
# Two kinds of sessions:
# - "Workshops Session (I-IV)": unnumbered title + "Name - Institution" lines,
#   kept as type "tutorial";
# - "Conference Working Session (I-IV)": numbered talks, names in mixed case
#   (often alone on a line, institution on the next line), type "talk".
# Left out: welcome and open-session addresses, the "Keynote Speakers
# Address" (no title given), the Asia-Pacific video-conference welcome and the
# attendance list (people without papers).

if (!exists("ro_parse_numbered")) source("R/parse/parse_2014.R")

parse_2017 <- function() {
  file <- "agenda_uRos2017.pdf"
  lines <- ro_lines(file.path("raw", "2017", file), 3:7)
  stop_at <- which(str_detect(lines, "Attendance list"))
  if (length(stop_at)) lines <- lines[seq_len(stop_at[1] - 1)]

  # Title continuation in the numbered sessions: the next line starts in
  # lower case, or the previous one ends on a word that cannot end a title.
  # Hand fix-up: one wrapped title whose second line starts with a capital.
  is_title_cont <- function(l, prev) {
    l <- str_squish(l)
    str_detect(l, "^\\p{Ll}") ||
      str_detect(str_squish(prev), "\\b(and|of|the|in|for|to|with|on|a)$") ||
      str_detect(l, "^Intentions among Balkan")
  }

  rows <- list()
  st <- list(rows = list(), cur = NULL, last = "none", prev = "", year = 2017,
             session = NA_character_, type = "tutorial", file = file)
  mode <- "skip"
  session <- NA_character_
  cur <- NULL
  flush_num <- function() {
    if (!is.null(cur)) {
      rows[[length(rows) + 1]] <<- ro_row(
        2017, cur$session, "talk", paste(cur$title, collapse = " "),
        ro_affiliations(cur$authors), file
      )
    }
    cur <<- NULL
  }
  for (l in lines) {
    rest <- ro_time_rest(l)
    num <- str_match(l, "^\\s*\\d{1,2}\\.\\s+(\\S.*)$")[, 2]
    if (!is.na(rest) || ro_is_lone_time(l) ||
      str_detect(l, "Discussions and closing|^\\s*Chairman")) {
      flush_num()
      st <- ro_unnumbered_flush(st)
      if (!is.na(rest) && str_detect(rest, "Workshops Session")) {
        mode <- "ws"
        st$session <- str_squish(rest)
        st$type <- "tutorial"
      } else if (!is.na(rest) && str_detect(rest, "Conference Working Session")) {
        mode <- "num"
        session <- str_squish(str_remove(rest, "\\s*\u2013\\s*parallel section.*$"))
      } else if (!str_detect(l, "^\\s*Chairman")) {
        mode <- "skip"
      }
      next
    }
    if (mode == "ws") {
      st <- ro_unnumbered_step(st, l)
    } else if (mode == "num") {
      if (!is.na(num)) {
        flush_num()
        cur <- list(session = session, title = num, authors = character(), in_title = TRUE)
      } else if (!is.null(cur)) {
        prev <- if (cur$in_title) cur$title[length(cur$title)] else ""
        if (cur$in_title && is_title_cont(l, prev)) {
          cur$title <- c(cur$title, l)
        } else {
          cur$in_title <- FALSE
          cur$authors <- c(cur$authors, l)
        }
      }
      # lines before the first numbered talk (chairman's institution) are skipped
    }
  }
  flush_num()
  st <- ro_unnumbered_flush(st)

  x <- bind_rows(c(rows, st$rows))
  # Restore programme order: workshops and sessions were collected separately.
  pos <- map_int(x$title, \(t) {
    w <- str_sub(t, 1, 30)
    which(str_detect(str_squish(lines), fixed(w)))[1]
  })
  x |>
    mutate(.pos = pos) |>
    arrange(.pos) |>
    select(-.pos) |>
    mutate(talk_no = row_number(), .after = year) |>
    select(year, talk_no, session, type, title, abstract, affiliations, source_file)
}
