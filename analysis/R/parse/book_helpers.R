# Shared helper for the uRos "Book of Abstracts" PDFs (2021, 2023, 2024, 2025).
#
# The books share one generated layout:
# - a "Contents" list (title ... page number) on the first pages;
# - then one entry per presentation, each starting on a new page:
#     <title, possibly wrapped and hyphenated>
#     Authors
#       • Name (Affiliation)
#     Abstract
#     <text, possibly over several pages>
#     References
#     <references>
#   with the page number alone on the last line of each page.
#
# parse_book() returns one row per entry, in book order, with title, abstract and
# affiliations (the text inside the parentheses of each author bullet; person names are
# never returned).

# The PDFs encode "ff" as the U+FB00 ligature (e.g. "Oﬀicial"); expand all ligatures.
book_unligature <- function(x) {
  x <- str_replace_all(x, "ﬀ", "ff")
  x <- str_replace_all(x, "ﬁ", "fi")
  x <- str_replace_all(x, "ﬂ", "fl")
  x <- str_replace_all(x, "ﬃ", "ffi")
  x <- str_replace_all(x, "ﬄ", "ffl")
  x
}

# Join lines; a line ending in "-" is joined without a space, and the hyphen is dropped
# unless the hyphenated word appears with its hyphen in `keep_ref` (e.g. the Contents text,
# which wraps at other places).
book_join_lines <- function(lines, keep_ref = "") {
  lines <- str_trim(lines)
  lines <- lines[lines != ""]
  if (length(lines) == 0) return(NA_character_)
  out <- lines[1]
  if (length(lines) > 1) {
    for (l in lines[-1]) {
      if (str_detect(out, "[[:alpha:]]-$")) {
        left <- str_extract(out, "[^ ]+-$")
        right <- str_extract(l, "^[^ ]+")
        hyph <- paste0(left, right)
        if (!is.na(keep_ref) && str_detect(keep_ref, fixed(hyph))) {
          out <- paste0(out, l)
        } else {
          out <- paste0(str_remove(out, "-$"), l)
        }
      } else {
        out <- paste(out, l)
      }
    }
  }
  squish(out)
}

# Affiliations from the author bullets: text between the first "(" and the last ")" of each
# bullet, unique, joined with "; ".
book_affiliations <- function(author_lines) {
  txt <- book_join_lines(author_lines)
  if (is.na(txt)) return(NA_character_)
  bullets <- squish(str_split(txt, "\u2022")[[1]])
  bullets <- bullets[!is.na(bullets)]
  aff <- map(bullets, function(b) {
    if (!str_detect(b, "\\(")) return(character())
    a <- str_sub(b, str_locate(b, fixed("("))[1, 1] + 1)
    a <- str_remove(a, "\\)[^)]*$")
    a <- squish(str_split(a, ";")[[1]])
    a <- str_remove(a, "^[ ,;]+")
    a[!is.na(a) & str_detect(a, "[[:alpha:]]")]
  })
  aff <- unique(unlist(aff))
  if (length(aff) == 0) NA_character_ else paste(aff, collapse = "; ")
}

parse_book <- function(path) {
  pages <- pdftools::pdf_text(path)
  pages <- book_unligature(pages)
  page_lines <- str_split(pages, "\n")

  # Contents text, used to decide whether a line-end hyphen is a real hyphen.
  is_authors <- function(l) str_detect(l, "^\\s*Authors\\s*$")
  start <- which(map_lgl(page_lines, \(l) any(is_authors(l))))
  contents_ref <- squish(paste(unlist(page_lines[seq_len(start[1] - 1)]), collapse = " "))
  # contents wraps with "-" at line end too: also keep the joined-without-space form
  contents_ref <- paste(contents_ref, str_replace_all(contents_ref, "- ", "-"))

  # An entry runs from its start page to the page before the next start.
  ends <- c(start[-1] - 1, length(pages))
  map2_dfr(start, ends, function(s, e) {
    lines <- unlist(page_lines[s:e])
    # drop the page-number footers
    lines <- lines[!str_detect(lines, "^\\s*\\d+\\s*$")]
    a <- which(is_authors(lines))[1]
    b <- which(str_detect(lines, "^\\s*Abstract\\s*$"))
    b <- b[b > a][1]
    r <- which(str_detect(lines, "^\\s*References\\s*$"))
    r <- r[r > coalesce(b, a)][1]
    if (is.na(r)) r <- length(lines) + 1
    title <- book_join_lines(lines[seq_len(a - 1)], contents_ref)
    authors <- if (!is.na(b)) lines[(a + 1):(b - 1)] else lines[(a + 1):(r - 1)]
    abstract <- if (!is.na(b) && r - 1 >= b + 1) book_join_lines(lines[(b + 1):(r - 1)]) else NA_character_
    tibble(
      page = s,
      title = title,
      abstract = abstract,
      affiliations = book_affiliations(authors)
    )
  })
}

# Normalised key for fuzzy title matching between a book and an agenda.
title_key <- function(x) {
  x <- str_to_lower(book_unligature(x))
  x <- stringi::stri_trans_general(x, "Latin-ASCII")
  x <- str_replace_all(x, "[^a-z0-9]+", " ")
  str_squish(x)
}

# --- Agendas (2023 brief agenda, 2024 and 2025 detailed agendas) ---------------------------
#
# agenda_lines() reads an agenda PDF and returns one row per text line with the session it
# belongs to, carried forward from the last session header:
#   "Tutorial session I" -> tutorial, "Keynote speaker 1" -> keynote, "EMOS Session" -> emos,
#   "Scientific Session <name>" -> talk (the name may wrap until the "Chairman" line).
# Breaks, meals, walk-in, welcome and closing lines reset the session to NA.
# Lines from `stop_at` onwards (e.g. the brief agenda that follows a detailed one) are dropped.
agenda_lines <- function(path, stop_at = NULL) {
  lines <- unlist(str_split(book_unligature(pdftools::pdf_text(path)), "\n"))
  if (!is.null(stop_at)) {
    cut <- which(str_detect(lines, stop_at))[1]
    if (!is.na(cut)) lines <- lines[seq_len(cut - 1)]
  }
  lines <- str_trim(lines)
  drop <- lines == "" | str_detect(lines, "^\\d+$") |
    str_detect(lines, "International Conference (The )?Use of R in Official Statistics") |
    str_detect(lines, "^uRos20\\d\\d$|^\\d+-\\d+ \\w+ 20\\d\\d, |Libertatii Bvd")
  lines <- lines[!drop]

  time <- "^(\\d[\\d:]*\\s*[–-]\\s*\\d[\\d:]*|\\d{3,4}|\\d{1,2}:\\d\\d)?\\s*"
  brk <- regex(paste0(time, "(lunch|coffee|official dinner|closing|walk in|registration|welcome|handover)"),
               ignore_case = TRUE)
  session <- rep(NA_character_, length(lines))
  kind <- rep(NA_character_, length(lines))
  cur_s <- NA_character_
  cur_k <- NA_character_
  i <- 1
  while (i <= length(lines)) {
    l <- lines[i]
    if (str_detect(l, brk)) {
      cur_s <- NA_character_
      cur_k <- NA_character_
    } else if (str_detect(l, regex("Tutorial session [IVX]+", ignore_case = TRUE))) {
      cur_s <- paste("Tutorial session", str_match(l, regex("Tutorial session ([IVX]+)", ignore_case = TRUE))[, 2])
      cur_k <- "tutorial"
    } else if (str_detect(l, regex("Keynote speaker\\s*\\d", ignore_case = TRUE))) {
      cur_s <- paste("Keynote", str_match(l, regex("Keynote speaker\\s*(\\d)", ignore_case = TRUE))[, 2])
      cur_k <- "keynote"
    } else if (str_detect(l, regex("EMOS Session", ignore_case = TRUE))) {
      cur_s <- "EMOS session"
      cur_k <- "emos"
    } else if (str_detect(l, regex("Scientific Session", ignore_case = TRUE))) {
      nm <- str_match(l, regex("Scientific Session\\s+(.*)$", ignore_case = TRUE))[, 2]
      # wrapped session name: continue until the "Chairman" line (detailed agendas only)
      j <- i + 1
      while (j <= length(lines) && j <= i + 2 && !str_detect(lines[j], "^Chairm") &&
             str_detect(lines[min(j + 1, length(lines))], "^Chairm")) {
        nm <- paste(nm, lines[j])
        j <- j + 1
      }
      cur_s <- squish(str_remove(nm, "^[IVX]+\\s+"))
      cur_k <- "talk"
    }
    session[i] <- cur_s
    kind[i] <- cur_k
    i <- i + 1
  }
  tibble(line = lines, session = session, kind = kind)
}

# Match book entries to agenda lines on normalised titles. Each book title is searched in the
# concatenated agenda text (normalised with title_key()); when the full title is not found,
# shorter prefixes (8, 5, then 3 words) are tried. An agenda position is used once, so a title
# listed twice (e.g. a tutorial and a talk) takes the occurrences in order.
# Adds columns session, type ("lightning" when preceded by "Lightning talk") and matched.
match_agenda <- function(book, agenda) {
  keys <- title_key(agenda$line)
  keys[is.na(keys)] <- ""
  text <- paste0(" ", paste(keys, collapse = " "), " ")
  starts <- cumsum(c(2, nchar(keys[-length(keys)]) + 1))
  line_at <- function(pos) max(which(starts <= pos))
  used <- integer()
  res <- map(book$title, function(t) {
    k <- title_key(t)
    w <- str_split(k, " ")[[1]]
    for (n in unique(c(length(w), pmin(length(w), c(8, 5, 3))))) {
      pat <- paste0(" ", paste(w[seq_len(n)], collapse = " "), " ")
      loc <- str_locate_all(text, fixed(pat))[[1]][, 1]
      loc <- setdiff(loc, used)
      if (length(loc) > 0) {
        used <<- c(used, loc[1])
        li <- line_at(loc[1] + 1)
        before <- str_sub(text, max(1, loc[1] - 20), loc[1])
        light <- str_detect(before, "lightning talk\\s*$")
        return(list(session = agenda$session[li],
                    type = if (light) "lightning" else coalesce(agenda$kind[li], "talk"),
                    matched = TRUE))
      }
    }
    list(session = NA_character_, type = "talk", matched = FALSE)
  })
  book$session <- map_chr(res, "session")
  book$type <- map_chr(res, "type")
  book$matched <- map_lgl(res, "matched")
  book
}
