# High vs low MSE illustrated with noisy points around a true line
# PLSC 502, Week 11 notes (Part 14, slide "MSE plot examples"; Part 2).
# Run: Rscript r/06_mse_plot.R   (plots are written to Rplots.pdf when run non-interactively)

set.seed(123)
x <- seq(0, 10, length.out = 100)                # >> 100 evenly spaced x values from 0 to 10
true_slope <- 2
true_intercept <- 1
y_true <- true_slope * x + true_intercept        # >> the true line: y = 1 + 2x

# Low MSE: small noise, low bias
y_low_mse <- y_true + rnorm(length(x), mean = 0, sd = 2)       # >> true line plus noise with sd 2

# High MSE: biased upward + higher variance
y_high_mse <- y_low_mse + rnorm(length(x), mean = 0, sd = 4)   # >> the same points plus MORE noise (sd 4); total sd is about 4.5

plot(x, y_true, type = "l", lwd = 2, col = "black",
     main = "High vs Low Mean Squared Error (MSE)", xlab = "X", ylab = "Y")   # >> black line = the truth
points(x, y_low_mse, col = rgb(0, 0, 1, 0.5), pch = 19)    # >> blue dots; rgb(.., 0.5) makes them half-transparent
points(x, y_high_mse, col = rgb(1, 0, 0, 0.5), pch = 19)   # >> red dots
legend("topleft", legend = c("True Line", "Lower MSE", "Higher MSE"),
       col = c("black", "blue", "red"), lwd = c(2, NA, NA), pch = c(NA, 19, 19))   # >> key
