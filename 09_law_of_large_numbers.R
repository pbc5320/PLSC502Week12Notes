# Law of Large Numbers: running average converges
# PLSC 502, Week 11 notes (Part 14, slide "Law of Large Numbers"; Part 4).
# Run: Rscript r/09_law_of_large_numbers.R   (plots are written to Rplots.pdf when run non-interactively)

set.seed(123)
true_mu <- 15; max_sample_size <- 3000; sample_sizes <- 1:max_sample_size   # >> counts 1, 2, 3, ..., 3000
sample_means <- cumsum(rnorm(max_sample_size, mean=true_mu, sd=5)) / sample_sizes
# >> rnorm draws ONE sequence of 3,000 values. cumsum() gives the running total after each draw.
# >> dividing by 1, 2, 3, ... gives the running average after each draw
plot(sample_sizes, sample_means, type="l", col="purple", lwd=2,
     xlab="Sample Size", ylab="Sample Mean",
     main="Law of Large Numbers: Convergence of Sample Mean")   # >> running average against n
abline(h=true_mu, col="orange", lwd=2, lty=2)                    # >> dashed orange line at the truth, 15
