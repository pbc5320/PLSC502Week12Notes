# Variance of the sample mean: the sampling distribution
# PLSC 502, Week 11 notes (Part 14, slide "Variance"; Part 2).
# Run: Rscript r/03_variance.R   (plots are written to Rplots.pdf when run non-interactively)

set.seed(123)
n_sim <- 1000; sample_size <- 100; true_mu <- 10      # >> 1,000 repeated studies, each with 100 observations, true mean 10

# Repeat sampling
estimates <- replicate(n_sim, mean(rnorm(sample_size, mean=true_mu, sd=2)))
# >> replicate() runs the inside expression 1,000 times. Each time: draw 100 values, compute their mean.
# >> Result: a vector of 1,000 sample means = the sampling distribution

variance_estimate <- var(estimates)              # >> the variance of those 1,000 means. Theory says sigma^2/n = 4/100 = 0.04

hist(estimates, breaks=30, main="Distribution of Estimator (Sample Mean)",
     xlab="Estimator Values", col="lightblue", border="darkblue")   # >> histogram with 30 bins
abline(v=true_mu, col="red", lwd=2)              # >> red vertical line at the truth, 10
