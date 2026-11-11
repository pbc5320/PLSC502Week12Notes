# Efficiency: sample mean vs sample median
# PLSC 502, Week 11 notes (Part 14, slide "Efficiency"; Part 2).
# Run: Rscript r/05_efficiency.R   (plots are written to Rplots.pdf when run non-interactively)

set.seed(123)
n <- 1000; true_mu <- 5                          # >> CAREFUL: here n = 1000 is the number of REPEATS, not the sample size

# Two unbiased estimators
estimator1 <- replicate(n, mean(rnorm(30, mean=true_mu, sd=2)))     # >> 1,000 sample MEANS, each from a fresh sample of 30
estimator2 <- replicate(n, median(rnorm(30, mean=true_mu, sd=2)))   # >> 1,000 sample MEDIANS, each from a fresh sample of 30

var_estimator1 <- var(estimator1)                # >> spread of the 1,000 means
var_estimator2 <- var(estimator2)                # >> spread of the 1,000 medians

cat("Variance of estimator (mean):", var_estimator1, " Variance of estimator (median):", var_estimator2)
# >> prints 0.126094 and 0.1861897

barplot(c(var_estimator1, var_estimator2), names.arg=c("Mean", "Median"),
        main="Efficiency of Estimators", ylab="Variance", col="lightcoral")   # >> two bars; the shorter one is more efficient
