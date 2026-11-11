# Nonparametric bootstrap for a regression slope (percentile interval)
# PLSC 502, Week 11 notes (Part 9; Practice Quiz problem 9).
# Run: Rscript r/11_bootstrap_slope.R
#
# Data are generated as y = 1 + 3x + noise (true intercept 1, true slope 3), n = 100.
# The data-generation lines below are a stand-in so the script runs on its own;
# the resampling loop is the one from the notes.

set.seed(123)
n <- 100
x <- rnorm(n)
y <- 1 + 3 * x + rnorm(n)

B <- 1000                                                    # number of bootstrap samples
boot_coef <- matrix(NA, nrow = B, ncol = 2)                  # one row per bootstrap sample: intercept, slope

for (b in 1:B) {
  idx <- sample(length(x), size = length(x), replace = TRUE)   # pick n row numbers with replacement
  fit <- lm(y[idx] ~ x[idx])                                   # refit the regression on that bootstrap sample
  boot_coef[b, ] <- coef(fit)                                  # store intercept and slope
}

# after the loop:
print(apply(boot_coef, 2, quantile, probs = c(0.025, 0.975)))      # 95% percentile intervals
print(sd(boot_coef[, 2]))                                          # bootstrap standard error of the slope
