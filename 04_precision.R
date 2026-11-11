# Precision: variance shrinks as sample size grows
# PLSC 502, Week 11 notes (Part 14, slide "Precision"; Part 2).
# Run: Rscript r/04_precision.R   (plots are written to Rplots.pdf when run non-interactively)

set.seed(123)
n_sim <- 1000
sample_sizes <- c(30, 100, 500)                  # >> three sample sizes to compare
true_mu <- 10

variances <- sapply(sample_sizes, function(n) {  # >> sapply() runs the function once per sample size and collects the answers into a vector
  estimates <- replicate(n_sim, mean(rnorm(n, mean=true_mu, sd=2)))   # >> 1,000 sample means at this n
  var(estimates)                                 # >> their variance (the last line is what the function returns)
})

barplot(variances, names.arg=sample_sizes, main="Variance by Sample Size",
        xlab="Sample Size", ylab="Variance", col="lightgreen")   # >> three bars, labeled 30, 100, 500
