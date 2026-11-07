# uRos2018 (The Hague): archived conference page raw/2018/conference2018.html.
#
# Two sources inside the page:
# - the programme grid (3rd table): day 1 (12 Sep) holds the tutorials, one per room,
#   each spanning two slots; we keep each distinct tutorial title once;
# - the "Sessions" table (inside div#sessions): rows with two cells; a session header has an empty
#   second cell, a talk row has a shaded background (#d6dce4) with title | speakers.
#   Speakers are only used to detect cancellations and are never returned.
# Cancelled talks (marked "(CANCELLED)" / "[CANCELED]") are dropped: they were not given.
# The page lists no affiliations and no abstracts (abstracts are in a separate book PDF
# that is not downloaded), so both columns are NA.

parse_2018 <- function() {
  file <- file.path("raw", "2018", "conference2018.html")
  html <- xml2::read_html(file, encoding = "UTF-8")
  tables <- rvest::html_elements(html, "table")

  # --- Tutorials from the grid (day 1 = rows before the "13-sep-18" header) -------------
  grid <- tables[[3]]
  grid_rows <- rvest::html_elements(grid, "tr")
  cells <- map(grid_rows, \(r) squish(rvest::html_text2(rvest::html_elements(r, "td"))))
  day2 <- which(map_lgl(cells, \(x) any(str_detect(x, "^13-sep-18$"), na.rm = TRUE)))[1]
  tut <- unlist(map(cells[seq_len(day2 - 1)], \(x) x[-1]))
  tut <- unique(tut[!is.na(tut)])
  tut <- tut[!str_detect(tut, regex("^(registration|break|lunch|\\d{2}-sep-18)$|zaal$",
                                    ignore_case = TRUE))]
  tutorials <- tibble(session = "Tutorials", type = "tutorial", title = tut)

  # --- Talks from the Sessions table -----------------------------------------------------
  sess_tab <- rvest::html_element(html, "div#sessions table")
  rows <- rvest::html_elements(sess_tab, "tr")
  td <- function(r, i) {
    x <- rvest::html_elements(r, "td")
    if (length(x) >= i) x[[i]] else NULL
  }
  txt <- function(node) if (is.null(node)) NA_character_ else rvest::html_text2(node)
  first <- squish(map_chr(rows, \(r) txt(td(r, 1))))
  second <- squish(map_chr(rows, \(r) txt(td(r, 2))))
  shaded <- map_lgl(rows, \(r) str_detect(coalesce(rvest::html_attr(td(r, 1), "style"), ""), "d6dce4"))

  rows_df <- tibble(first, second, shaded) |>
    filter(!is.na(first)) |>
    mutate(
      is_header = !shaded & is.na(second),
      session = if_else(is_header, first, NA_character_)
    ) |>
    fill(session) |>
    filter(!is_header)

  talks <- rows_df |>
    mutate(cancelled = str_detect(coalesce(second, ""), regex("cancel", ignore_case = TRUE)) |
             str_detect(first, regex("cancel", ignore_case = TRUE))) |>
    filter(!cancelled) |>
    transmute(
      session,
      type = if_else(str_detect(session, regex("keynote", ignore_case = TRUE)), "keynote", "talk"),
      # Typo in the source ("Cooridination") kept as published.
      title = first
    )

  bind_rows(tutorials, talks) |>
    mutate(
      year = 2018L,
      talk_no = seq_len(n()),
      title = squish(title),
      abstract = NA_character_,
      affiliations = NA_character_,
      source_file = basename(file)
    ) |>
    select(year, talk_no, session, type, title, abstract, affiliations, source_file)
}
