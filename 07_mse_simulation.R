# MSE = bias^2 + variance by simulation
# PLSC 502, Week 11 notes (Part 14, slide "Simulation of MSE"; Part 2).
# Run: Rscript r/07_mse_simulation.R   (plots are written to Rplots.pdf when run non-interactively)

set.seed(123)
n_sim <- 1000; sample_size <- 50; true_theta <- 5     # >> 1,000 repeats; each sample has 50 observations; true mean 5
estimates <- replicate(n_sim, mean(rnorm(sample_size, mean=true_theta, sd=2)))   # >> 1,000 sample means

bias_sq <- (mean(estimates) - true_theta)^2      # >> (average estimate minus truth), squared = squared bias
variance <- var(estimates)                       # >> variance of the estimates
mse <- bias_sq + variance                        # >> MSE = bias^2 + variance

hist(estimates, breaks=30, main="Distribution of Estimates for MSE",
     xlab="Estimates", col="lightgray", border="darkgray")   # >> histogram
abline(v=true_theta, col="red", lwd=2)                      # >> red line at the truth

cat("Bias squared: ", bias_sq, ", Variance: ", variance, ", MSE: ", mse)
# >> Bias squared: 1.216112e-05, Variance: 0.0712139, MSE: 0.07122606
