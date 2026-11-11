# Consistency of the sample mean
# PLSC 502, Week 11 notes (Part 14, slide "Consistency"; Part 4).
# Run: Rscript r/08_consistency.R   (plots are written to Rplots.pdf when run non-interactively)

true_mu <- 10; sample_sizes <- seq(10, 3000, by=5)    # >> sample sizes 10, 15, 20, ..., 3000 (599 of them)
estimates <- sapply(sample_sizes, function(n) mean(rnorm(n, mean=true_mu, sd=2)))
# >> for each sample size, draw a brand-new sample of that size and store its mean
plot(sample_sizes, estimates, type="l", col="blue", lwd=2,
     xlab="Sample Size", ylab="Estimate", main="Consistency of the Sample Mean")   # >> line plot of estimate against n
abline(h=true_mu, col="red", lwd=2, lty=2)        # >> dashed red line at the truth, 10
