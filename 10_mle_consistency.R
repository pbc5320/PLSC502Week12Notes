# Consistency of the MLE of a Normal mean
# PLSC 502, Week 11 notes (Part 14, slide "Simulation of MLE consistency"; Part 8).
# Run: Rscript r/10_mle_consistency.R   (plots are written to Rplots.pdf when run non-interactively)

set.seed(123)
true_theta <- 5; sample_sizes <- seq(10, 1000, by=10)    # >> truth is 5; sample sizes 10, 20, ..., 1000 (100 of them)
mle_estimates <- sapply(sample_sizes, function(n) mean(rnorm(n, mean=true_theta, sd=2)))
# >> for each n, draw a fresh sample from Normal(5, sd 2) and take the mean.
# >> The mean IS the MLE of a normal mean (Part 5), which is why the variable is named mle_estimates
plot(sample_sizes, mle_estimates, type="l", col="darkgreen", lwd=2,
     xlab="Sample Size", ylab="MLE Estimate", main="Consistency of MLE Estimates")   # >> green line
abline(h=true_theta, col="red", lwd=2, lty=2)                                       # >> dashed red line at the truth, 5
