# Step 1: download every source listed in sources.csv into raw/<year>/.
#
# The official site (urosconf.org -> r-project.ro) cannot always be reached,
# so most programmes and books of abstracts come from the Common Crawl
# archive: each one is a single gzip-compressed WARC record, fetched with an
# HTTP Range request on data.commoncrawl.org (offset and length in
# sources.csv). The 2020 and 2026 files come from the uRosConf GitHub
# repositories. Writes data/sources-fetched.csv with the SHA-256 of each file.
#
# Usage, from analysis/: Rscript R/01-fetch.R

source("R/utils.R")

sources <- read_csv("sources.csv", col_types = cols(.default = "c"))

# Fetch one Common Crawl WARC record and return the HTTP response body.
fetch_warc_body <- function(url, offset, length) {
  offset <- as.numeric(offset)
  length <- as.numeric(length)
  h <- curl::new_handle()
  curl::handle_setheaders(
    h,
    Range = sprintf("bytes=%.0f-%.0f", offset, offset + length - 1),
    `User-Agent` = "uros-programme-analysis (R curl)"
  )
  res <- curl::curl_fetch_memory(url, handle = h)
  if (!res$status_code %in% c(200, 206)) {
    stop("HTTP ", res$status_code, " for ", url)
  }
  record <- memDecompress(res$content, type = "gzip")
  # A WARC record is: WARC headers, blank line, HTTP headers, blank line, body.
  sep <- charToRaw("\r\n\r\n")
  find_sep <- function(x, from = 1) {
    n <- length(x)
    for (i in seq(from, n - 3)) {
      if (x[i] == sep[1] && x[i + 1] == sep[2] && x[i + 2] == sep[3] && x[i + 3] == sep[4]) {
        return(i)
      }
    }
    stop("No header separator found")
  }
  end_warc <- find_sep(record)
  end_http <- find_sep(record, end_warc + 4)
  http_head <- rawToChar(record[(end_warc + 4):(end_http - 1)])
  if (!grepl("^HTTP/[0-9.]+ 200", http_head)) {
    stop("Archived response is not a 200: ", strsplit(http_head, "\r\n")[[1]][1])
  }
  record[(end_http + 4):length(record)]
}

fetch_source <- function(year, file, url, warc_offset, warc_length, ...) {
  dest_dir <- file.path(raw_dir, year)
  dir.create(dest_dir, showWarnings = FALSE, recursive = TRUE)
  dest <- file.path(dest_dir, file)
  if (!file.exists(dest)) {
    message("Fetching ", year, " ", file)
    if (!is.na(warc_offset) && nzchar(warc_offset)) {
      writeBin(fetch_warc_body(url, warc_offset, warc_length), dest)
    } else {
      utils::download.file(url, dest, mode = "wb", quiet = TRUE)
    }
  }
  tibble(year = year, file = file, path = dest, bytes = file.size(dest), sha256 = sha256(dest))
}

fetched <- pmap(sources, fetch_source) |> list_rbind()

# A truncated or anti-bot capture would be a few kB only.
stopifnot(all(fetched$bytes > 5000))

write_csv(select(fetched, -path), file.path(data_dir, "sources-fetched.csv"))
print(fetched, n = Inf)
