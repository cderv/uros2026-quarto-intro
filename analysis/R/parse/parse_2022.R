# uRos2022 (virtual, hosted by Statistics Canada): raw/2022/uRos_full_agenda_EN_v3.pdf.
# Full agenda, no abstracts. Structure of the layout text (pages 3-10; the "BRIEF AGENDA"
# page that follows repeats the sessions and is skipped):
# - session headers "Scientific Session: <name>", "Keynote: ...", "Tutorial: <title>",
#   and "Pre-recorded presentations";
# - inside a session, numbered titles "1. <title>" (sometimes in quotes) that wrap onto
#   lines indented at least as far as the number; author lines "First LAST, Affiliation"
#   start further left;
# - keynote titles are on the line 'Presentation - "<title>"' (may wrap);
# - tutorial titles follow "Tutorial:" and wrap onto a line starting in lower case.
# Time columns on the left are blanked (same width, so the columns stay aligned).
# Affiliations: text after the first comma of each author line (plus its continuation
# lines); for a block of name-only lines, the trailing non-name line. Names are dropped.
# Known limitation: the title "Histogram and Copula Synthetic Data Generation Methods in"
# ends like that in the PDF (no continuation line); kept as printed.

parse_2022 <- function() {
  file <- file.path("raw", "2022", "uRos_full_agenda_EN_v3.pdf")
  pages <- pdftools::pdf_text(file)
  last <- which(str_detect(pages, "BRIEF AGENDA"))[1] - 1
  lines <- unlist(str_split(pages[3:last], "\n"))

  # Blank the time columns (4-digit times and dashes at line start), keeping widths.
  time_re <- "^\\s*(\\d{3,4}\\s*[\u2013-]?\\s*)+"
  lines <- map_chr(lines, \(l) {
    m <- str_extract(l, time_re)
    if (is.na(m) || !str_detect(m, "\\d{3,4}")) l else paste0(strrep(" ", nchar(m)), str_sub(l, nchar(m) + 1))
  })
  lines <- str_remove(lines, "\\s+$")
  lines <- lines[lines != ""]
  noise <- str_detect(str_trim(lines),
    paste0("^$|^The 10th International Conference|^uRos2022$|VIRTUAL CONFERENCE$|^Canada\\s+CET|",
           "^\\(GMT-4\\)|^\\d{1,2}$|^PROGRAMME$|^December \\d|^Break$|^Tutorials\u2019 day$|",
           "^Welcome message|^Good bye|^Anil ARORA|^Chairman"))
  # Chairman lines can wrap: drop the continuation line that follows them as well.
  chair <- which(str_detect(str_trim(lines), "^Chairman"))
  chair_cont <- chair + 1
  chair_cont <- chair_cont[!str_detect(str_trim(lines[chair_cont]), "^\\d+\\.\\s|^Scientific Session|^Keynote|^Presentation")]
  # a continuation of the chair line is not an author line (no comma-led name)
  chair_cont <- chair_cont[!str_detect(str_trim(lines[chair_cont]), "^\\p{Lu}[\\p{L}'.-]*( \\p{Lu}[\\p{L}'.-]*)* \\p{Lu}{2,}")]
  noise[chair_cont] <- TRUE
  lines <- lines[!noise]

  indent <- str_length(str_extract(lines, "^\\s*"))
  txt <- str_trim(lines)

  is_name_line <- function(x) {
    head <- str_trim(str_remove(x, ",.*$"))
    words <- str_split(head, "\\s+")[[1]]
    length(words) >= 2 &&  # a lone acronym ("PCA") ending a wrapped title is not a name
      all(str_detect(words, "^(\\p{Lu}|de$|ten$|van$|der$|di$|da$|von$|la$)")) &&
      any(str_detect(words, "^[\\p{Lu}'\u2019.-]{2,}$") & str_detect(words, "\\p{Lu}{2}"))
  }

  talks <- list()
  session <- NA_character_
  i <- 1
  n <- length(txt)
  while (i <= n) {
    t <- txt[i]
    if (str_detect(t, "^Scientific Session:")) {
      session <- str_remove(t, "^Scientific Session:\\s*")
      i <- i + 1
      next
    }
    if (t == "Pre-recorded presentations") {
      session <- "Pre-recorded presentations"
      i <- i + 1
      next
    }
    if (str_detect(t, "^Keynote:")) {
      # Keynote speaker line: affiliation after " - " or ", " following the name.
      aff <- str_remove(t, "^Keynote:\\s*\\S.*?\\p{Lu}{2,}\\s*[-,]\\s*")
      j <- i + 1
      title <- str_remove(txt[j], "^Presentation\\s*-\\s*")
      while (!str_detect(title, "\u201d$") && j < n) {
        j <- j + 1
        title <- paste(title, txt[j])
      }
      talks[[length(talks) + 1]] <- tibble(session = "Keynote", type = "keynote", title = title,
                                           affiliations = aff)
      i <- j + 1
      next
    }
    if (str_detect(t, "^Tutorial:")) {
      title <- str_remove(t, "^Tutorial:\\s*")
      j <- i + 1
      if (str_detect(txt[j], "^\\p{Ll}")) {  # "in R" continuation
        title <- paste(title, txt[j])
        j <- j + 1
      }
      aff <- if (is_name_line(txt[j])) str_remove(txt[j], "^[^,]*,\\s*") else NA_character_
      talks[[length(talks) + 1]] <- tibble(session = "Tutorials", type = "tutorial", title = title,
                                           affiliations = aff)
      i <- j + 1
      next
    }
    if (str_detect(t, "^\\d+\\.\\s") && !is.na(session)) {
      num_col <- indent[i]
      title <- str_remove(t, "^\\d+\\.\\s*")
      j <- i + 1
      while (j <= n && indent[j] >= num_col - 1 && !str_detect(txt[j], "^\\d+\\.\\s") &&
             !is_name_line(txt[j])) {
        title <- paste(title, txt[j])
        j <- j + 1
      }
      # Author block: until the next numbered title or header.
      block <- character()
      while (j <= n && !str_detect(txt[j], "^(\\d+\\.\\s|Scientific Session:|Keynote:|Tutorial:|Pre-recorded presentations$)")) {
        block <- c(block, txt[j])
        j <- j + 1
      }
      entries <- character()
      for (b in block) {
        if (is_name_line(b) || length(entries) == 0) entries <- c(entries, b)
        else entries[length(entries)] <- paste(entries[length(entries)], b)
      }
      affs <- map_chr(entries, \(e) {
        if (str_detect(e, ",")) return(str_remove(e, "^[^,]*,\\s*"))
        # name-only entry: whatever follows the name (a trailing affiliation line)
        rest <- str_remove(e, "^(\\S+\\s+)*?\\p{Lu}[\\p{Lu}'\u2019-]+(\\s+\\p{Lu}[\\p{Lu}'\u2019-]+)*\\s*")
        if (rest == "") NA_character_ else rest
      })
      affs <- unique(squish(affs[!is.na(affs)]))
      talks[[length(talks) + 1]] <- tibble(
        session = session,
        type = if_else(session == "Lightning talks", "lightning", "talk"),
        title = title,
        affiliations = if (length(affs) == 0) NA_character_ else paste(affs, collapse = "; ")
      )
      i <- j
      next
    }
    i <- i + 1
  }

  bind_rows(talks) |>
    mutate(
      title = squish(str_remove_all(title, "^[\u201c\"]|[\u201d\"]$")),
      year = 2022L,
      talk_no = seq_len(n()),
      abstract = NA_character_,
      affiliations = squish(affiliations),
      source_file = basename(file)
    ) |>
    select(year, talk_no, session, type, title, abstract, affiliations, source_file)
}
