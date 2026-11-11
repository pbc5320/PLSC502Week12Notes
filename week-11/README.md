# PLSC 502 Week 11: Estimation and Maximum Likelihood

Study notes and runnable R simulations for Week 11 of PLSC 502 (Statistical Methods): interval estimation, the properties of an estimator (bias, variance, efficiency, MSE, consistency), Gauss-Markov, maximum likelihood (Normal, Exponential, Poisson, regression), likelihood ratio tests, the bootstrap, plus notes on regression diagnostics and multiple regression.

## Contents

- [`notes/week-11-estimation-and-mle.md`](notes/week-11-estimation-and-mle.md): the full notes (17 parts, including the practice-quiz questions with worked solutions, a one-page formula sheet, and a quiz-time keyword decoder). Equations use GitHub's math rendering.
- [`r/`](r/): the simulation code from the notes, one script per idea.

| Script | What it shows | Where in the notes |
| --- | --- | --- |
| [`01_point_estimate.R`](r/01_point_estimate.R) | Parameter, estimator, estimate: one simulated survey | Part 14, slide "Point estimation" |
| [`02_bias_omitted_variable.R`](r/02_bias_omitted_variable.R) | Bias: unbiased single DGP vs biased joint DGP (omitted variable) | Part 14, slide "Bias"; Part 2 |
| [`03_variance.R`](r/03_variance.R) | Variance of the sample mean: the sampling distribution | Part 14, slide "Variance"; Part 2 |
| [`04_precision.R`](r/04_precision.R) | Precision: variance shrinks as sample size grows | Part 14, slide "Precision"; Part 2 |
| [`05_efficiency.R`](r/05_efficiency.R) | Efficiency: sample mean vs sample median | Part 14, slide "Efficiency"; Part 2 |
| [`06_mse_plot.R`](r/06_mse_plot.R) | High vs low MSE illustrated with noisy points around a true line | Part 14, slide "MSE plot examples"; Part 2 |
| [`07_mse_simulation.R`](r/07_mse_simulation.R) | MSE = bias^2 + variance by simulation | Part 14, slide "Simulation of MSE"; Part 2 |
| [`08_consistency.R`](r/08_consistency.R) | Consistency of the sample mean | Part 14, slide "Consistency"; Part 4 |
| [`09_law_of_large_numbers.R`](r/09_law_of_large_numbers.R) | Law of Large Numbers: running average converges | Part 14, slide "Law of Large Numbers"; Part 4 |
| [`10_mle_consistency.R`](r/10_mle_consistency.R) | Consistency of the MLE of a Normal mean | Part 14, slide "Simulation of MLE consistency"; Part 8 |
| [`11_bootstrap_slope.R`](r/11_bootstrap_slope.R) | Nonparametric bootstrap for a regression slope | Part 9; Practice Quiz problem 9 |

## Running the code

Requires R. The bias script also needs the `mvtnorm` package (`install.packages("mvtnorm")`).

```sh
Rscript r/01_point_estimate.R   # a single script
Rscript r/run_all.R             # everything, in order
```

Scripts use `set.seed(123)`. Plots are saved to `Rplots.pdf` when run with `Rscript`; run them in RStudio to see plots on screen. Printed values quoted in the comments (for example `# >> prints 10.18081`) came from the original run and can differ slightly across R versions.

## Notes on sources

The notes were built from the course slides, the Exponential/Poisson MLE handout, the code tutorials, Practice Quiz 11, and lecture video transcripts. Solutions to the practice problems are my own (no answer key was available).
