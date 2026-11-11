# Bias: unbiased single DGP vs biased joint DGP (omitted variable)
# PLSC 502, Week 11 notes (Part 14, slide "Bias"; Part 2).
# Run: Rscript r/02_bias_omitted_variable.R   (plots are written to Rplots.pdf when run non-interactively)

library(mvtnorm)                                 # >> package that provides rmvnorm(), draws from a multivariate normal
set.seed(123); n <- 1000                         # >> reproducible; 1,000 observations

beta_true <- 2                                   # >> the true slope

# Single DGP (unbiased)
x_single <- rnorm(n)                             # >> x: 1,000 standard-normal draws
y_single <- beta_true * x_single + rnorm(n)      # >> y = 2x + noise. Nothing else affects y, so nothing is omitted
unbiased_estimate <- coef(lm(y_single ~ x_single - 1))   # >> regress y on x; "- 1" removes the intercept so we estimate only the slope

# Joint DGP (biased)
mu <- c(0, 0)                                    # >> both variables have mean 0
sigma <- matrix(c(1, 0.8, 0.8, 1), nrow=2)       # >> covariance matrix: variances 1 on the diagonal, covariance (= correlation) 0.8 off it
joint_data <- rmvnorm(n, mean=mu, sigma=sigma)   # >> 1,000 rows, 2 columns that move together (correlation 0.8)
x_joint <- joint_data[,1]                        # >> column 1 is x
z_joint <- joint_data[,2]                        # >> column 2 is z, a second variable correlated with x
y_joint <- beta_true * x_joint + z_joint + rnorm(n)   # >> y = 2x + 1*z + noise: z truly affects y
biased_estimate <- coef(lm(y_joint ~ x_joint - 1))    # >> regress y on x ONLY, leaving z out

cat("True beta:", beta_true, " Unbiased est:", unbiased_estimate, " Biased est: ", biased_estimate)
# >> prints True beta: 2   Unbiased est: 2.088721   Biased est: 2.755098
