# Run every script in order. Plots go to Rplots.pdf when run with Rscript.
# From the repo root:  Rscript r/run_all.R
scripts <- sort(list.files("r", pattern = "^[0-9]{2}_.*\\.R$", full.names = TRUE))
for (f in scripts) {
  cat("\n=====", f, "=====\n")
  source(f, echo = FALSE)
}
