# Step 4b: compare the two independent codings and list what to adjudicate.
#
# Inputs: data/coding-a-*.csv and data/coding-b-*.csv (step 4a, coders A and
# B). Outputs: data/coding-a.csv, data/coding-b.csv (merged), data/agreement.csv
# (per-variable agreement), data/disagreements.csv (rows for the adjudicator).
# After adjudication, data/adjudication.csv holds the settled values; this
# script then writes data/coding-final.csv.
#
# Usage, from analysis/: Rscript R/04-agreement.R

source("R/utils.R")

talks <- read_csv(file.path(data_dir, "talks.csv"), col_types = cols(.default = "c"))

read_coder <- function(coder) {
  files <- list.files(data_dir, pattern = paste0("^coding-", coder, "-\\d+\\.csv$"), full.names = TRUE)
  x <- map(files, \(f) read_csv(f, col_types = cols(.default = "c"), na = "")) |> list_rbind()
  stopifnot(!anyDuplicated(x$id), setequal(x$id, talks$id))
  arrange(x, match(id, talks$id))
}

a <- read_coder("a")
b <- read_coder("b")
write_csv(a, file.path(data_dir, "coding-a.csv"), na = "")
write_csv(b, file.path(data_dir, "coding-b.csv"), na = "")

single <- c("publishing", "reproducibility", "theme", "confidence")
multi <- c("outputs", "tools", "needs")
vars <- c(single, multi)

# Lists are compared as sets.
norm_set <- function(x) {
  map_chr(str_split(coalesce(x, ""), "\\s*;\\s*"), \(v) paste(sort(unique(v[v != ""])), collapse = ";"))
}
for (v in multi) {
  a[[v]] <- norm_set(a[[v]])
  b[[v]] <- norm_set(b[[v]])
}

# Cohen's kappa for one categorical variable.
kappa <- function(x, y) {
  lv <- union(x, y)
  tab <- table(factor(x, lv), factor(y, lv))
  po <- sum(diag(tab)) / sum(tab)
  pe <- sum(rowSums(tab) * colSums(tab)) / sum(tab)^2
  if (pe == 1) NA_real_ else (po - pe) / (1 - pe)
}

agreement <- map(vars, \(v) tibble(
  variable = v,
  agreement = mean(a[[v]] == b[[v]]),
  kappa = if (v %in% single) kappa(a[[v]], b[[v]]) else NA_real_
)) |> list_rbind()

# The variables the talk relies on, collapsed to yes/no.
yes <- function(x) x %in% c("central", "partial")
agreement <- bind_rows(
  agreement,
  tibble(
    variable = c("publishing (central or partial)", "reproducibility (central or partial)"),
    agreement = c(mean(yes(a$publishing) == yes(b$publishing)), mean(yes(a$reproducibility) == yes(b$reproducibility))),
    kappa = c(kappa(yes(a$publishing), yes(b$publishing)), kappa(yes(a$reproducibility), yes(b$reproducibility)))
  )
)
write_csv(agreement, file.path(data_dir, "agreement.csv"))
print(agreement)

# Disagreements on the variables used for the talk (confidence is not adjudicated).
to_settle <- setdiff(vars, "confidence")
disagreements <- map(to_settle, \(v) {
  d <- a[[v]] != b[[v]]
  tibble(id = a$id[d], variable = v, value_a = a[[v]][d], value_b = b[[v]][d])
}) |> list_rbind() |> arrange(match(id, talks$id), variable)
write_csv(disagreements, file.path(data_dir, "disagreements.csv"), na = "")
message(nrow(disagreements), " disagreements over ", n_distinct(disagreements$id), " talks")


# Keyword cross-check: a tool named in the text (step 3) that neither coder
# recorded. Reviewed by the adjudicator together with the disagreements.
keywords <- read_csv(file.path(data_dir, "keywords.csv"), col_types = cols(.default = "c"))
tool_map <- c(quarto = "quarto", rmarkdown = "rmarkdown_knitr", sweave_latex = "sweave_latex",
              word_office = "word_officer", shiny = "shiny")
crosscheck <- imap(tool_map, \(tool, kw) {
  flagged <- keywords$id[keywords[[kw]] == "TRUE"]
  seen <- a$id[str_detect(a$tools, fixed(tool)) | str_detect(b$tools, fixed(tool))]
  tibble(id = setdiff(flagged, seen), keyword = kw, tool = tool)
}) |> list_rbind() |> arrange(match(id, talks$id))
write_csv(crosscheck, file.path(data_dir, "keyword-crosscheck.csv"))
message(nrow(crosscheck), " keyword flags with no matching tool in either coding")

# Final coding: coder A's values where both agree, the adjudicated value otherwise.
adj_file <- file.path(data_dir, "adjudication.csv")
if (file.exists(adj_file)) {
  adj <- read_csv(adj_file, col_types = cols(.default = "c"), na = "")
  stopifnot(!anyDuplicated(adj[c("id", "variable")]))
  missing <- anti_join(disagreements, adj, by = c("id", "variable"))
  if (nrow(missing) > 0) stop(nrow(missing), " disagreements not adjudicated yet")
  final <- a
  for (i in seq_len(nrow(adj))) {
    final[[adj$variable[i]]][final$id == adj$id[i]] <- adj$value[i]
  }
  # need_quote follows the final needs: keep A's quote, or B's when only B saw a need.
  only_b <- final$needs != a$needs & final$needs == b$needs
  final$need_quote[only_b] <- b$need_quote[only_b]
  final$need_quote[final$needs %in% c("", "none")] <- NA
  write_csv(final, file.path(data_dir, "coding-final.csv"), na = "")
  message("Wrote data/coding-final.csv")
}
