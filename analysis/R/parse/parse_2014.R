# uRos 2014 (2nd workshop, Bucharest): programme PDF, titles only, no abstracts.
#
# This file also defines the helpers shared by the Bucharest programme PDFs of
# 2014, 2015, 2016, 2017 and 2019 (all prefixed `ro_`). parse_2015.R and the
# others source this file when the helpers are missing.
#
# Speakers' names are never kept: author lines are reduced to the
# institutions that follow the names.

# ---- shared helpers ---------------------------------------------------------

# Words that mark an institution, so that a segment holding one is never taken
# for a person's name.
ro_inst_kw <- regex(paste0(
  "Univ|Institu|Statisti|Office|Bureau|Cent(er|re)|Department|Dept|Faculty|",
  "Facultad|Escuela|School|Academy|Bank|Commission|Committee|Agency|Ltd|",
  "Division|Minist|EUROSTAT|Eurostat|Organi[sz]ation|Research|Program|",
  "Technolog|National|Federal|Council|Records|Services|Microsoft|Laborator|",
  "Romania|Netherlands|Austria|Germany|Italy|France|Spain|Japan|Switzerland|",
  "Scotland|Canada|Serbia|Portugal|Colombia|Lithuania|Ireland|Denmark|",
  "Poland|Malaysia|Turkey|TURKEY|Morocco|Hungary|Norway|Slovenia|Latvia|",
  "Kazakhstan|Iraq|Moldova|Croatia|Luxemb"
))

ro_countries <- paste0(
  "Romania|Italy|Germany|France|Spain|Japan|Austria|Netherlands|Switzerland|",
  "Scotland|Canada|Serbia|Portugal|Colombia|Lithuania|Ireland|USA|Denmark|",
  "Poland|United Kingdom|Turkey|TURKEY|Morocco|Malaysia|Luxembourg|Hungary|",
  "Norway|Slovenia|Latvia|Iraq|Czech Republic|Kazakhstan|Croatia|",
  "United Nations"
)

# Lines of the given pages, without page headers, footers and blank lines.
ro_lines <- function(path, pages) {
  txt <- pdftools::pdf_text(path)[pages]
  l <- unlist(str_split(txt, "\n"))
  junk <- regex(paste0(
    "International (Workshop|Conference)|The Use of R in Official Statistics|",
    "^\\s*uRos20\\d\\d\\s*$|^\\s*[0-9-]+ \\w+, 20\\d\\d, Bucharest, Romania\\s*$|",
    "^\\s*\\d{1,2}\\s*$|^\\s*\\d{2}\\s+\\d{2}\\s*$|^SPONSORS|",
    "Supporting the R Language|^\\s*$|^\\s*(DETAILED )?PROGRAMME\\s*$|",
    "Conference Room (of|and) |",
    "^\\s*(March|April|May|November) \\d+, \\w+day( \\(Parallel Session\\))?\\s*$"
  ))
  l[!str_detect(l, junk)]
}

# Time-slot line ("1130 - 1145 Coffee Break"): returns the text after the
# times, NA when the line is not a time slot.
ro_time_rest <- function(line) {
  m <- str_match(line, "^\\s*\\d{2,4}\\s*[–-]\\s*\\d{2,4}\\s+(\\S.*)$")[, 2]
  m
}
ro_is_lone_time <- function(line) str_detect(line, "^\\s*\\d{3,4}\\s{2,}\\S")

# Is a segment of an author line a person's name? Two to six tokens, each
# capitalised (initials allowed), a name particle or a parenthesised alias,
# and no institution keyword.
ro_is_name <- function(seg) {
  seg <- str_squish(seg)
  if (is.na(seg) || seg == "" || str_detect(seg, ro_inst_kw)) return(FALSE)
  tok <- str_split(seg, " ")[[1]]
  if (length(tok) < 2 || length(tok) > 6) return(FALSE)
  ok <- str_detect(tok, "^\\p{Lu}[\\p{L}'’`.-]*$") |
    str_detect(tok, "^(van|der|den|de|ten|von|al|la|le|du|da|di)$") |
    str_detect(tok, "^\\(\\p{Lu}\\p{L}*\\)$")
  all(ok) && sum(str_detect(tok, "^\\p{Lu}")) >= 1
}
ro_has_caps <- function(seg) {
  any(str_detect(str_split(str_squish(seg), " ")[[1]], "^\\p{Lu}[\\p{Lu}'’-]*\\p{Lu}$"))
}

# Strip the leading person names of an author line.
# Returns n (names removed), rest (text after them), caps (an upper-case
# surname was seen).
ro_strip_names <- function(line) {
  line <- str_squish(str_remove_all(line, "\\S+@\\S*"))
  n <- 0
  caps <- FALSE
  repeat {
    m <- str_match(line, "^(.*?)(\\s*,\\s*|\\s+and\\s+|\\s+[–-]\\s+)(.*)$")
    if (!is.na(m[1, 1]) && ro_is_name(m[1, 2])) {
      n <- n + 1
      caps <- caps || ro_has_caps(m[1, 2])
      line <- m[1, 4]
    } else {
      break
    }
  }
  if (ro_is_name(line)) {
    n <- n + 1
    caps <- caps || ro_has_caps(line)
    line <- ""
  }
  list(n = n, rest = str_squish(line), caps = caps)
}

# An author line: names followed by an institution (needs an upper-case
# surname, or an institution keyword after the names).
ro_is_author <- function(line, need_caps = TRUE) {
  r <- ro_strip_names(line)
  if (r$n == 0 || r$rest == "") return(FALSE)
  if (need_caps) r$caps else (r$caps || str_detect(r$rest, ro_inst_kw))
}

ro_ends_open <- function(line) {
  str_detect(str_squish(line), "([,/&-]|\\b(of|and|the|The|de|for|in|at|Ecological))$")
}
ro_is_aff_cont <- function(line, prev) {
  ro_ends_open(prev) ||
    str_detect(str_squish(line), paste0("(^|,\\s*|^\\(.*\\),\\s*)(", ro_countries, ")\\.?$"))
}

# Reduce author lines to institutions: one entry per author (or per group of
# authors sharing an institution), joined with "; ". Lines holding only names
# are dropped; a line that is neither names nor "names, institution" continues
# the previous institution.
ro_affiliations <- function(lines) {
  affs <- character()
  prev_aff <- FALSE
  prev_line <- ""
  for (l in lines) {
    l <- str_squish(str_remove_all(l, "\\S+@\\S*"))
    r <- ro_strip_names(l)
    open <- prev_aff && ro_ends_open(prev_line)
    if (r$n > 0 && r$rest != "" && (r$caps || !open)) {
      affs <- c(affs, r$rest)
    } else if (open) {
      affs[length(affs)] <- paste(affs[length(affs)], l)
    } else if (r$n > 0 && r$rest == "") {
      prev_aff <- FALSE
      prev_line <- l
      next
    } else if (prev_aff) {
      affs[length(affs)] <- paste(affs[length(affs)], l)
    } else {
      affs <- c(affs, l)
    }
    prev_aff <- TRUE
    prev_line <- l
  }
  affs <- str_squish(str_remove_all(affs, "^[,;\\s]+|[,;\\s]+$"))
  affs <- unique(affs[affs != ""])
  if (length(affs) == 0) NA_character_ else paste(affs, collapse = "; ")
}

ro_row <- function(year, session, type, title, aff, file) {
  tibble(
    year = as.integer(year), session = session, type = type,
    title = squish(title), abstract = NA_character_, affiliations = aff,
    source_file = file
  )
}

# Numbered programmes (2014, 2015, 2016): "N.  Title" lines, title wrapping on
# following lines until the first author line ("Given SURNAME, Institution").
ro_parse_numbered <- function(lines, year, file) {
  rows <- list()
  session <- NA_character_
  cur <- NULL
  flush <- function() {
    if (!is.null(cur)) {
      rows[[length(rows) + 1]] <<- ro_row(
        year, cur$session, "talk", paste(cur$title, collapse = " "),
        ro_affiliations(cur$authors), file
      )
    }
    cur <<- NULL
  }
  for (l in lines) {
    rest <- ro_time_rest(l)
    num <- str_match(l, "^\\s*\\d{1,2}\\.\\s+(\\S.*)$")[, 2]
    if (!is.na(rest)) {
      flush()
      if (str_detect(rest, "Session")) session <- str_squish(rest)
    } else if (ro_is_lone_time(l) ||
      str_detect(l, "Discussions|closing conference|^Contact|Lecture:|Chairman")) {
      flush()
    } else if (!is.na(num)) {
      flush()
      cur <- list(session = session, title = num, authors = character(), in_title = TRUE)
    } else if (!is.null(cur)) {
      if (cur$in_title && !ro_is_author(l, need_caps = TRUE)) {
        cur$title <- c(cur$title, l)
      } else {
        cur$in_title <- FALSE
        cur$authors <- c(cur$authors, l)
      }
    }
  }
  flush()
  list_rbind(rows)
}

# Unnumbered blocks (2017 workshops, 2019): a title (possibly wrapped), then
# author lines; a non-author line after an author line continues the
# institution when it ends a place ("..., Romania") or the previous line is
# left open ("... University of"), otherwise it starts the next title.
ro_unnumbered_step <- function(st, l) {
  if (ro_is_author(l, need_caps = FALSE)) {
    if (is.null(st$cur)) st$cur <- list(title = character(), authors = character())
    st$cur$authors <- c(st$cur$authors, l)
    st$last <- "author"
  } else if (st$last == "author" && ro_is_aff_cont(l, st$prev)) {
    st$cur$authors <- c(st$cur$authors, l)
  } else if (st$last == "title") {
    st$cur$title <- c(st$cur$title, l)
  } else {
    st <- ro_unnumbered_flush(st)
    st$cur <- list(title = l, authors = character())
    st$last <- "title"
  }
  st$prev <- l
  st
}
ro_unnumbered_flush <- function(st) {
  if (!is.null(st$cur) && length(st$cur$title) > 0) {
    st$rows[[length(st$rows) + 1]] <- ro_row(
      st$year, st$session, st$type, paste(st$cur$title, collapse = " "),
      ro_affiliations(st$cur$authors), st$file
    )
  }
  st$cur <- NULL
  st$last <- "none"
  st$prev <- ""
  st
}

# ---- 2014 -------------------------------------------------------------------

parse_2014 <- function() {
  file <- "workshop_programme_R_RO_2014.pdf"
  lines <- ro_lines(file.path("raw", "2014", file), 3:5)
  x <- ro_parse_numbered(lines, 2014, file)
  # Talks 1-2 sit in the "Open Session" with the welcome addresses; they are
  # numbered talks like the others, so they keep type "talk".
  x |>
    mutate(talk_no = row_number(), .after = year) |>
    select(year, talk_no, session, type, title, abstract, affiliations, source_file)
}
