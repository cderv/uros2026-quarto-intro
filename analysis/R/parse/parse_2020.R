# uRos2020 (virtual): two sources.
# - raw/2020/abstracts.xlsx: the abstract submission form (67 rows: 47 contributed,
#   17 lightning, 3 keynote) with clean titles, abstracts and affiliations.
# - raw/2020/Detailed_Programme_Virtual_uRos2020.pdf: the final programme, with sessions.
#   Its text layer drops ligatures ("Sta s cs" for "Statistics": ti, fi, ffi, ff, fl, ft, tt
#   become a space or vanish) and interleaves flag emoji and author lines with titles.
#
# Method: keep only submissions found in the programme. Titles are compared on a condensed
# key (lower case, letters and digits only, ligature letter pairs removed on both sides):
# a submission is in the programme when the first or the last 30 characters of its key
# occur in the condensed programme text (prefix OR suffix, because a few titles are broken
# by the layout, e.g. "R package SamplingStrata" where an author name cuts the first line).
# The session is the last session header before the match.
# (20 characters gave a false match: a cellKey submission ending in "statistical disclosure
# control" matched the sdcLog title.)
# Result: 37 of the 67 submissions are in the programme (2 keynotes, 35 talks); the 3rd
# keynote of the form ("Analyzing Texts with R") and 29 other submissions are not.
# One programme talk has no submission in the form ("A set of R packages to compute
# population count from mobile network data"): it is added by hand below from the PDF,
# without abstract. Total 38, checked by hand against pdftotext -layout.
#
# Type: keynote for the keynote slots, lightning for the "Lightning talks" block; talks in the
# scientific sessions are "talk"; in the pre-recorded session the submission type is used.
# Affiliations: the distinct Affiliation1..6 values of the form (person names are dropped).
#
# readxl is used when installed; otherwise a minimal xml2 reader of the first sheet.

read_2020_form <- function(path) {
  if (requireNamespace("readxl", quietly = TRUE)) {
    x <- readxl::read_excel(path, sheet = 1, col_types = "text")
    return(x)
  }
  tmp <- tempfile()
  dir.create(tmp)
  on.exit(unlink(tmp, recursive = TRUE))
  utils::unzip(path, files = c("xl/sharedStrings.xml", "xl/worksheets/sheet1.xml"), exdir = tmp)
  ss <- xml2::read_xml(file.path(tmp, "xl/sharedStrings.xml"))
  xml2::xml_ns_strip(ss)
  strings <- map_chr(xml2::xml_find_all(ss, "//si"),
                     \(si) paste(xml2::xml_text(xml2::xml_find_all(si, ".//t")), collapse = ""))
  sh <- xml2::read_xml(file.path(tmp, "xl/worksheets/sheet1.xml"))
  xml2::xml_ns_strip(sh)
  cells <- xml2::xml_find_all(sh, "//sheetData/row/c")
  ref <- xml2::xml_attr(cells, "r")
  t <- xml2::xml_attr(cells, "t")
  v <- map_chr(cells, \(c) {
    n <- xml2::xml_find_first(c, "./v|./is")
    if (inherits(n, "xml_missing")) NA_character_ else xml2::xml_text(n)
  })
  v <- ifelse(!is.na(t) & t == "s", strings[as.integer(v) + 1], v)
  col <- sub("[0-9]+$", "", ref)
  row <- as.integer(sub("^[A-Z]+", "", ref))
  cols <- unique(col)
  cols <- cols[order(nchar(cols), cols)]
  m <- matrix(NA_character_, max(row), length(cols))
  m[cbind(row, match(col, cols))] <- v
  df <- as.data.frame(m[-1, , drop = FALSE], stringsAsFactors = FALSE)
  names(df) <- m[1, ]
  tibble::as_tibble(df)
}

# Condensed comparison key; ligature letter groups are removed on both sides.
key_2020 <- function(x) {
  x <- str_to_lower(x)
  x <- str_replace_all(x, "ffi|ffl|ff|fi|fl|ft|tt|ti", "")
  str_replace_all(x, "[^a-z0-9]", "")
}

# Repair the broken words of the programme's session headers.
fix_lig_2020 <- function(x) {
  fixes <- c(" o cial" = " official", "sta s cs" = "statistics", "Classi ca on" = "Classification",
             "Dissemina on" = "Dissemination", "visualiza on" = "visualization",
             "Organiza on" = "Organization", "Produc on" = "Production")
  str_replace_all(x, fixed(fixes))
}

parse_2020 <- function() {
  xlsx <- file.path("raw", "2020", "abstracts.xlsx")
  pdf <- file.path("raw", "2020", "Detailed_Programme_Virtual_uRos2020.pdf")

  # --- Programme: lines with their session -----------------------------------------------
  lines <- unlist(str_split(pdftools::pdf_text(pdf), "\n"))
  lines <- str_remove_all(lines, "[\U0001F1E6-\U0001F1FF]")  # flag emoji
  lines <- str_squish(lines)
  lines <- lines[lines != ""]
  session <- case_when(
    str_detect(lines, "Keynote:") ~ "Keynote",
    str_detect(lines, "Scien c Session ") ~ fix_lig_2020(str_remove(lines, "^.*Scien c Session ")),
    lines == "Lightning talks" ~ "Lightning talks",
    str_detect(lines, "^Pre-recorded scien c session") ~ "Pre-recorded session",
    TRUE ~ NA_character_
  )
  prog <- tibble(line = lines, session = session) |>
    fill(session) |>
    filter(!is.na(session)) |>
    mutate(key = key_2020(line), end = cumsum(nchar(key)))
  stream <- paste(prog$key, collapse = "")

  locate <- function(pattern) {
    pos <- str_locate(stream, fixed(pattern))[1, "start"]
    if (is.na(pos)) NA_integer_ else as.integer(pos)
  }

  # --- Submissions -----------------------------------------------------------------------
  form <- read_2020_form(xlsx)
  aff_cols <- paste0("Affiliation", 1:6)
  subs <- form |>
    mutate(
      form_row = row_number(),
      title = squish(str_remove(Title, "\\.\\s*$")),
      title = str_replace(title, "multi-eponential", "multi-exponential"),  # typo in the form
      abstract = squish(Abstract),
      form_type = talk_type(`Type of talk`),
      affiliations = pmap_chr(pick(all_of(aff_cols)), \(...) {
        a <- squish(c(...))
        a <- unique(a[!is.na(a) & a != "None"])
        if (length(a) == 0) NA_character_ else paste(a, collapse = "; ")
      }),
      key = key_2020(title),
      pos_start = map_int(key, \(k) locate(str_sub(k, 1, 30))),
      pos_end = map_int(key, \(k) locate(str_sub(k, -30, -1))),
      pos = coalesce(pos_start, pos_end)
    ) |>
    filter(!is.na(pos))

  # Hand fix-up.
  # Programme talk missing from the form (title repaired from the PDF's broken ligatures;
  # affiliations from the programme's author lines, names dropped).
  extra_title <- "A set of R packages to compute population count from mobile network data"
  extra <- tibble(
    title = extra_title, abstract = NA_character_, form_type = "talk",
    affiliations = "Statistics Romania; University of Bucharest; Statistics Spain (INE)",
    pos = locate(str_sub(key_2020(extra_title), 1, 30))
  )
  subs <- bind_rows(subs, extra)

  subs |>
    mutate(
      session = prog$session[findInterval(pos - 1, prog$end) + 1],
      type = case_when(
        session == "Keynote" ~ "keynote",
        session == "Lightning talks" ~ "lightning",
        session == "Pre-recorded session" ~ form_type,
        TRUE ~ "talk"
      )
    ) |>
    arrange(pos) |>
    mutate(
      year = 2020L,
      talk_no = seq_len(n()),
      source_file = paste(basename(xlsx), basename(pdf), sep = "; ")
    ) |>
    select(year, talk_no, session, type, title, abstract, affiliations, source_file)
}
