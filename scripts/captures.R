# Screenshots of the rendered bulletin for the slides.
# Run after `quarto render` (just example), from example/: Rscript ../scripts/captures.R
# (just captures), so that the example's R library (example/.rvenv) is used.
# Writes images/bulletin/ at the root of the talk repository.
library(webshot2)
library(pdftools)
library(png)

# Chrome refuses to run as root (containers, CI) without --no-sandbox
if (.Platform$OS.type == "unix" && Sys.info()[["user"]] == "root") {
  chromote::set_chrome_args(c(chromote::default_chrome_args(), "--no-sandbox"))
}

out <- file.path("..", "images", "bulletin")
dir.create(out, showWarnings = FALSE, recursive = TRUE)
html <- normalizePath(file.path("_output", "bulletin.html"))
pdf <- file.path("_output", "bulletin.pdf")

# HTML: a browser window 1280 pixels wide, captured at twice the pixels for
# sharpness. Elements are captured in a window tall enough to hold the whole
# page (the width sets the layout; webshot2 times out below the window).
shot <- function(file, selector = NULL, cliprect = NULL, expand = 12, height = 5000) {
  webshot(html, file.path(out, file), vwidth = 1280, vheight = height, zoom = 2,
          selector = selector, cliprect = cliprect, expand = expand, delay = 1)
}

shot("html-page.png", cliprect = "viewport", expand = NULL, height = 800)
shot("html-key-figure.png", "#kf-nights")
shot("html-rendered.png", c("#sec-eu > p", "#fig-trend figcaption", "#fig-trend img"))
shot("html-trend.png", c("#fig-trend figcaption", "#fig-trend img"))
shot("html-crossref.png", "#sec-eu > p")
shot("html-table.png", "#tbl-countries")
shot("html-map.png", "#fig-map")

# PDF: whole pages, and crops between two lines of text found on the page
dpi <- 150
pdf_page <- function(page, file) {
  writePNG(pdf_render_page(pdf, page = page, dpi = dpi, numeric = TRUE),
           file.path(out, file))
}

# Where a phrase starts on a page: the words that follow each other in the text
find_phrase <- function(words, phrase) {
  parts <- strsplit(phrase, " ")[[1]]
  starts <- seq_len(nrow(words) - length(parts) + 1)
  hits <- Filter(\(i) all(words$text[i + seq_along(parts) - 1] == parts), starts)
  words[hits, ]
}

# Crop from the line where `from` starts to the first line below it where `to`
# starts, across the body column only (left of the margin notes);
# pad: points kept above and below
pdf_crop <- function(page, from, to, file, pad = c(10, 10), left = 40, right = 420,
                     pdf = get("pdf", envir = globalenv())) {
  words <- pdf_data(pdf)[[page]]
  top <- min(find_phrase(words, from)$y)
  below <- find_phrase(words, to)
  below <- below[below$y > top, ][1, ]
  bottom <- below$y + below$height
  bitmap <- pdf_render_page(pdf, page = page, dpi = dpi, numeric = TRUE)
  px <- function(pt) round(pt * dpi / 72)
  rows <- max(1, px(top - pad[1])):min(dim(bitmap)[1], px(bottom + pad[2]))
  cols <- max(1, px(left)):min(dim(bitmap)[2], px(right))
  writePNG(bitmap[rows, cols, ], file.path(out, file))
}

pdf_page(1, "pdf-p1.png")
pdf_page(2, "pdf-p2.png")
# The key figure box: from the big number to its caption ("Key figure 1: ...")
pdf_crop(1, "514.7 million", "Key figure 1:", "pdf-key-figure.png", pad = c(22, 22))
# Table 1: from its caption to its source note
pdf_crop(2, "Table 1:", "Source: Eurostat", "pdf-table.png", pad = c(4, 10))

# Word: LibreOffice turns bulletin.docx into a PDF, then the same crop as above.
# Fonts missing on the machine are replaced, so install the brand fonts first.
soffice <- Sys.which(c("soffice", "libreoffice"))
soffice <- unname(soffice[nzchar(soffice)][1])
if (is.na(soffice)) {
  warning("LibreOffice not found: docx-key-figure.png not updated")
} else {
  tmp <- tempfile("docx-")
  dir.create(tmp)
  system2(soffice, c("--headless", "--convert-to", "pdf", "--outdir", shQuote(tmp),
                     shQuote(file.path("_output", "bulletin.docx"))),
          # R's own library path makes soffice load the wrong shared libraries
          env = "LD_LIBRARY_PATH=", stdout = FALSE)
  pdf_crop(1, "514.7 million", "Key figure 1:", "docx-key-figure.png", pad = c(22, 6),
           left = 55, right = 540, pdf = file.path(tmp, "bulletin.pdf"))
}

message("Screenshots written to ", normalizePath(out))
