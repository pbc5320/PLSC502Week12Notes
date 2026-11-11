# Parameter, estimator, estimate: one simulated survey
# PLSC 502, Week 11 notes (Part 14, slide "Point estimation").
# Run: Rscript r/01_point_estimate.R   (plots are written to Rplots.pdf when run non-interactively)

set.seed(123)                                   # >> fix the random-number generator so the "random" draws are the same every run
n <- 100                                        # >> sample size
true_mu <- 10                                   # >> the true parameter (we know it only because we are simulating the data)

sample_data <- rnorm(n, mean=true_mu, sd=2)     # >> draw 100 values from a Normal(mean 10, sd 2): our one "survey"
sample_mean <- mean(sample_data)                # >> the estimator (mean) applied to this sample gives the estimate

cat("True parameter (mu):", true_mu, "\n")                    # >> prints 10
cat("Estimated parameter (sample mean):", sample_mean, "\n")  # >> prints 10.18081
