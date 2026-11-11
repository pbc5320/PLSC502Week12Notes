# PLSC 502 Week 11 Notes: Estimation and Maximum Likelihood

Nov 11, 2026

## Read me first

This sheet covers everything in the Week 11 slides, the Exponential/Poisson MLE handout, both code tutorials and Practice Quiz 11. I also read the transcripts of all three lecture videos (lecture 11, 11 02, 11 03), so what the instructor said out loud is in Parts 14 to 16.

- **Built from:** week\_11.pdf (the slides, "Recovering properties of the DGP"), exponential\_poisson\_mle.pdf, code\_tutorial\_11.R / .py, practice\_quiz\_11.pdf, and the Week 10 quiz key you attached.
- **Not found:** the answer key for Practice Quiz 11 was not in the folder. Every solution in the practice section is my own, and every number was checked by computer.
- **Labels you will see:** "Slides" = taken from the lecture. "Handout" = the MLE handout. "Extension" = a standard result I added to help you understand, not on the slides. "My example" = an example I made up to connect an idea to something concrete.
- **Equations** are written in LaTeX blocks so they render properly.
- **Quiz-time lookup:** Part 17 (last section) maps the key words in a word problem to the concept and equation you should reach for.

**Heads up:** videos 2 and 3 are about regression diagnostics and multiple regression, which are not in the week\_11 slides in your folder. Parts 15 and 16 are built from the transcripts alone. If you upload those two lectures' slides, I can check the formulas and thresholds against them.

## The big picture: why this week exists

Week 11 answers one question: **the data came from some process we cannot see (the data generating process, or DGP). How do we recover its unknown parameters from a sample, and how do we judge whether our recovery is any good?**

The whole week is two jobs:

1. **Build an estimate.** Either a single best guess (a *point estimate*, like the sample mean) or a range of plausible values (an *interval estimate*, like a confidence interval). The big recipe for building point estimates is **maximum likelihood (MLE)**.
2. **Grade the estimator.** Ask five questions: is it centered on the truth (*bias*), how much does it bounce around (*variance / precision*), is it the least bouncy one available (*efficiency*), does it combine both into one score (*MSE*), and does it home in on the truth with more data (*consistency*)?

A vocabulary map you should be able to say out loud:

| Term | Plain meaning | Example from this week |
| --- | --- | --- |
| Parameter | A fixed, unknown number describing the population | true mean = 10, true slope = 2 |
| Estimator | A rule (a formula applied to a random sample), so it is itself random | the sample mean, the OLS formula |
| Estimate | The one number the rule gives on your actual sample | 10.18081 in the lecture simulation |
| Sampling distribution | The pile of estimates you would get across many samples | the histogram of 1,000 sample means |

**How this connects to earlier weeks.**

- **Week 5 (probability and distributions):** the Exponential and Poisson distributions you learned there are exactly the two models you will fit by MLE this week.
- **Week 10 (confidence intervals, testing, and where the OLS estimator comes from):** you derived the least-squares line by setting derivatives to zero. This week you do the *same calculus recipe* on a different function (the log-likelihood) and discover that, with normal errors, you get the *same answer*. That is the punchline of the final slides: OLS is a special case of MLE.
- **Calculus recipe you will use over and over:** (1) write the function, (2) take the derivative, (3) set it to zero and solve, (4) check the second derivative to confirm you found a maximum, not a minimum.

**One-line roadmap of the slides, in order:** confidence intervals, point estimation, bias, variance, precision, regression variance, efficiency, MSE, Gauss-Markov / BLUE, consistency, law of large numbers, MLE idea, log-likelihood, Normal MLE, regression MLE, likelihood ratio tests, MLE properties, OLS = MLE.

## Part 1: Interval estimation (confidence intervals)

A confidence interval (CI) gives a range of plausible values for an unknown parameter, instead of one number. Think of the point estimate as a dart and the CI as the dart plus a margin of error on each side.

### CI when the population standard deviation is known (Slides)

```math
\mathrm{CI} = \bar{x} \pm z_{\alpha/2}\,\frac{\sigma}{\sqrt{n}}
```

- x-bar is the sample mean (your center).
- z\_(alpha/2) is the critical value from the standard normal: 1.645 for 90%, **1.96 for 95%**, 2.576 for 99%.
- sigma / sqrt(n) is the *standard error*: how much a sample mean typically wobbles from sample to sample.
- Margin of error = critical value × standard error. The interval is center ± margin.

### CI when sigma is unknown (Slides): the realistic case

```math
\mathrm{CI} = \bar{x} \pm t_{\alpha/2,\,df}\,\frac{s}{\sqrt{n}}, \qquad df = n-1
```

You swap the true sigma for the sample standard deviation s. Because s is itself noisy, you pay a price: the t critical value is a bit larger than z (fatter tails), so the interval is a bit wider. As n grows, the t distribution converges to the standard normal and the two intervals agree.

### Worked example A: tie it to the lecture simulation (My example)

In the lecture, 100 draws from a normal with true mean 10 and sd 2 gave a sample mean of 10.18081. Treat sigma = 2 as known.

```math
SE = \frac{2}{\sqrt{100}} = 0.2, \qquad \mathrm{CI}_{95\%} = 10.18081 \pm 1.96(0.2) = [9.789,\ 10.573]
```

The true value 10 sits inside, as it should about 95% of the time. Notice the point estimate was off by 0.18 but the interval still caught the truth.

### Worked example B: unknown sigma (My example)

n = 16, x-bar = 20, s = 8. Then SE = 8/sqrt(16) = 2, df = 15, and t(0.025, 15) = 2.131.

```math
20 \pm 2.131(2) = [15.74,\ 24.26]
```

### What controls the width

Width = 2 × critical value × sigma / sqrt(n). So the interval gets **narrower** with a larger n, a smaller sigma, or a *lower* confidence level, and **wider** if you demand more confidence. To cut the width in half you need four times the sample size, because n sits under a square root.

### How to read a CI correctly

- Right: "If we repeated this sampling procedure many times, about 95% of the intervals built this way would contain the true parameter."
- Wrong: "There is a 95% probability that the true mean is in *this* interval." The true mean is fixed; the interval is the random thing before you collect data.

### CIs and hypothesis tests are two views of one idea (Slides)

- If the CI **includes** the null value (often 0), **do not reject** H0.
- If the CI **excludes** the null value, **reject** H0.

The lecture example: a 95% CI of \[0.3, 1.2\] for a mean difference excludes 0, so reject H0 that the true difference is 0. A CI of \[-0.2, 0.5\] includes 0, so do not reject.

Why this works: a two-sided test at level 0.05 rejects exactly the null values that sit more than 1.96 standard errors from your estimate, which are exactly the values *outside* the 95% interval. This is the same logic as Question 3 on the Week 10 quiz, where |t| = 3.2 exceeded 1.96.

## Part 2: Point estimation and the report card for an estimator

A **point estimate** is single best guess of an unknown parameter from sample data. Examples: the sample mean for a population mean, a regression coefficient for a slope. In the lecture's first simulation, the true mean was 10 and the sample mean of 100 draws was 10.18081: close, not exact. Every estimate carries sampling error, which is why we grade estimators by how they behave *across many samples*, not on one sample.

**The mental model.** Imagine repeating your study 1,000 times and plotting all 1,000 estimates. That histogram is the *sampling distribution*. Bias, variance, efficiency and MSE are all descriptions of that histogram: where its center is, how wide it is, and how it compares with other estimators' histograms.

### Bias (Slides)

```math
\mathrm{Bias}(\hat{\theta}) = E[\hat{\theta}] - \theta
```

Bias is the systematic miss: the center of the histogram minus the true value. **Unbiased** means the center sits exactly on the truth (bias = 0). Unbiased does not mean any single estimate is right; it means the estimator is right *on average*.

**The lecture's bias simulation, explained.** True slope beta = 2.

- *Unbiased case:* x is random noise and y = 2x + noise. Regressing y on x recovers 2.088721, close to 2.
- *Biased case:* now x and a second variable z are correlated (correlation 0.8, both with variance 1), and y = 2x + z + noise. The researcher forgets z and regresses y on x alone. The estimate comes back **2.755098**, far from 2.
- *Why:* x now carries the effect of z with it. The leftover slope is the true 2 plus the slope of z on x: 2 + 0.8 = 2.8, and the simulation landed near that. This is **omitted variable bias**, and it does *not* go away with more data. It is a flaw in the DGP assumptions, not in sample size.

### Variance (Slides)

Variance measures the spread of the sampling distribution. For the sample mean:

```math
\mathrm{Var}(\bar{x}) = \frac{\sigma^2}{n}
```

Two things to notice. The variance depends on the DGP through sigma-squared (noisier world, noisier estimate), and it shrinks as n grows. In the lecture simulation (1,000 repeats, n = 100, sd = 2), the variance of the 1,000 sample means should be near 4/100 = 0.04.

### Precision (Slides)

Precision is just the flip side of variance:

```math
\mathrm{Precision}(\bar{x}) = \frac{1}{\mathrm{Var}(\bar{x})} = \frac{n}{\sigma^2}
```

The lecture compares n = 30, 100, 500 with sd = 2. Theory gives variances of 0.133, 0.04 and 0.008, so precision rises from 7.5 to 25 to 125. Bigger sample, tighter histogram.

### Variance of regression coefficients (Slides)

```math
\mathrm{Var}(\hat{\beta}) = \sigma^2 (X'X)^{-1}
```

Plain-English reading: the uncertainty in your slopes goes **up** with noise in the errors (sigma-squared) and **down** when your predictors have lots of variation (a large X'X). For a one-predictor regression this simplifies to:

```math
\mathrm{Var}(\hat{\beta}_1) = \frac{\sigma^2}{\sum_i (x_i - \bar{x})^2}
```

(Extension.) Example: on the Week 10 quiz data, x = 0, 1, 2, so the sum of squared deviations is 2. If sigma-squared were 1, the slope variance would be 0.5. If x had been spread wider, say 0, 5, 10, the sum is 50 and the variance drops to 0.02. **Spread out your x values and you learn the slope more precisely.**

### Efficiency (Slides)

Among **unbiased** estimators, the one with the lowest variance is the most **efficient**. The lecture compares two unbiased estimators of the center of a normal distribution, with n = 30 and sd = 2:

| Estimator | Variance in the simulation |
| --- | --- |
| Sample mean | 0.126 |
| Sample median | 0.186 |

The mean is more efficient: it uses every number's exact value, while the median only uses their rank. (Theory for the mean: 4/30 = 0.133.) The median earns its keep when data have outliers or heavy tails, because one wild value can drag the mean but barely moves the median.

### Mean Squared Error (Slides)

MSE grades an estimator on bias and variance together:

```math
\mathrm{MSE}(\hat{\theta}) = E\big[(\hat{\theta}-\theta)^2\big] = \mathrm{Var}(\hat{\theta}) + \big[\mathrm{Bias}(\hat{\theta})\big]^2
```

Think of archery. Bias is how far the *center* of your arrow cluster is from the bullseye; variance is how scattered the cluster is. MSE is the average squared distance from the bullseye, so it punishes both. Lower MSE is better.

The lecture simulation (n = 50, true mean 5, sd 2, 1,000 repeats) gave: bias-squared about 0.0000122, variance 0.0712, so **MSE about 0.0712**. Almost all of the MSE is variance because the sample mean is unbiased. A slightly biased estimator can still win on MSE if it has much lower variance, which is why "unbiased" is not the only goal.

**Fast self-check.** An estimator has bias 0.5 and variance 0.04. Its MSE is 0.04 + 0.25 = 0.29.

## Part 3: Gauss-Markov and BLUE

**The claim (Slides).** Under five assumptions, the OLS estimator beta-hat is **BLUE**: the **B**est **L**inear **U**nbiased **E**stimator.

Read the acronym one word at a time:

- **Linear:** the estimate is a weighted sum of the y values.
- **Unbiased:** its sampling distribution is centered on the true beta.
- **Best:** among *all* linear unbiased estimators, it has the smallest variance (it is the most efficient one, in the sense from Part 2).
- **Estimator:** it is a rule, not a number.

### The five assumptions (Slides)

| # | Assumption | Formula | What it means in plain words |
| --- | --- | --- | --- |
| 1 | Linearity | y = X beta + epsilon | The true relationship is a straight-line (linear-in-parameters) model plus error |
| 2 | Random sampling | (y\_i, X\_i) are i.i.d. | Each observation is an independent draw from the same population |
| 3 | No perfect collinearity | rank(X) = k | No predictor is an exact combination of the others; otherwise you cannot separate their effects |
| 4 | Zero conditional mean | E(epsilon given X) = 0 | The errors are unrelated to the predictors. **This is the unbiasedness assumption** |
| 5 | Homoscedastic errors | Var(epsilon given X) = sigma-squared times I | Errors have constant spread and are uncorrelated across observations |

**Which assumption does which job?** Assumption 4 is what delivers *unbiasedness*. The lecture's omitted-variable example broke exactly this one: z was left in the error term and was correlated with x, so the error was no longer unrelated to x, and the slope came out at 2.755 instead of 2. Assumption 5 is what delivers the *minimum variance* part and the clean variance formula.

**What Gauss-Markov does not require.** It does **not** require the errors to be normally distributed. Normality is only needed when you want OLS to *equal* the maximum likelihood estimator (the last slides of the week) or want exact small-sample t tests.

**What "best" does not mean.** Best only means best *within linear unbiased* estimators. A biased estimator, or a nonlinear one, can sometimes have lower MSE. This links back to the MSE slide.

## Part 4: Consistency and the Law of Large Numbers

### Consistency (Slides)

An estimator is **consistent** if it converges in probability to the true parameter as the sample size grows:

```math
\hat{\theta}_n \xrightarrow{\;p\;} \theta \quad \text{as } n \to \infty
```

The precise meaning of "converges in probability" (Extension): for any small tolerance epsilon you pick, the chance that the estimate misses the truth by more than epsilon goes to zero as n grows.

```math
P\big(|\hat{\theta}_n - \theta| > \epsilon\big) \to 0
```

**Consistency is about the future (infinite data); unbiasedness is about the average (any sample size).** They are different properties, which is the single most testable idea in this section. All four combinations exist:

|  | Consistent | Not consistent |
| --- | --- | --- |
| **Unbiased** | Sample mean of n observations | "Just use the first observation x1 as your estimate of mu" |
| **Biased** | MLE of the variance, dividing by n (biased low by a factor of (n-1)/n, but the bias vanishes as n grows) | "Report the sample mean plus 1" |

The top-right cell is a good one to remember: x1 is correct on average, but no matter how much data you collect, you throw it all away and the spread never shrinks.

The slides show this as a simulation: sample sizes from 10 up to 3,000, true mean 10, and a line that wiggles wildly at small n and then flattens onto the dashed line at 10.

### The Law of Large Numbers (LLN) (Slides)

The LLN is the most famous example of consistency. The sample mean converges to the population mean:

```math
\bar{x}_n \xrightarrow{\;p\;} \mu \quad \text{as } n \to \infty
```

The lecture plot draws a **running average**: keep drawing from a normal with mean 15 and sd 5, and after each draw compute the average of everything so far (in code, `cumsum(draws)/(1:n)`). Early on the running mean lurches; after a few thousand draws it hugs 15.

**Link back to variance.** The reason the LLN works is the variance formula from Part 2: Var(x-bar) = sigma-squared / n shrinks to zero, so the sampling distribution collapses onto mu. Zero bias plus variance heading to zero is the standard recipe for showing consistency.

**Why consistency matters for you.** Real samples are finite, so you can never be sure of an exact answer, but consistency is the minimum promise that collecting more data actually helps. An estimator that is inconsistent can be broken no matter how large your dataset is.

## Part 5: Maximum likelihood estimation (MLE)

### The idea in one sentence (Slides)

Pick the parameter value that makes the data you actually observed **most probable**.

```math
\hat{\theta}(x) = \arg\max_{\theta} \; L(\theta \mid x), \qquad L(\theta \mid x) = f(x \mid \theta)
```

**Reading the notation.** f(x given theta) is the usual probability model: theta is fixed, x varies. The likelihood L(theta given x) is the *same formula* flipped around: the data x is now **fixed** (you already saw it) and theta is the thing that varies. The likelihood scores how plausible each candidate theta is, given what you saw. Practice Quiz problem 1 tests this exact point: the likelihood is **not** the probability that theta is true, and it does not add up to 1 across theta values.

### A tiny example to feel it (My example)

Flip a coin 10 times and see 7 heads. Let p be the chance of heads. The likelihood of that result is p^7 (1-p)^3.

- If p = 0.5: likelihood = 0.5^10 = 0.000977
- If p = 0.7: likelihood = 0.7^7 × 0.3^3 = 0.002224

p = 0.7 makes the observed data about 2.3 times more probable than a fair coin does. Try every p between 0 and 1 and the peak lands at p = 0.7 = 7/10, the sample proportion. That peak is the MLE. Every MLE in this week is that same "slide along the parameter axis until the likelihood peaks" idea.

### Why we use the log-likelihood (Slides)

For independent observations the likelihood is a **product** of one term per data point:

```math
L(\theta) = \prod_{i=1}^{n} f(x_i \mid \theta), \qquad \ell(\theta) = \log L(\theta) = \sum_{i=1}^{n} \log f(x_i \mid \theta)
```

Three reasons the lecture gives, in plain words:

1. A product of many small numbers is awkward to differentiate; a sum is easy.
2. The log turns multiplication into addition: log(ab) = log a + log b.
3. The log is monotonic (always rising), so the peak of log L sits at the **same theta** as the peak of L. Nothing is lost.

(Extension: it also avoids numerical underflow. Multiply 1,000 probabilities near 0.01 and a computer rounds it to zero; add their logs and it is fine.)

### The five-step MLE recipe (Handout)

1. Write the likelihood L(theta) as a product.
2. Take the log to get l(theta), simplifying with log rules.
3. Differentiate with respect to theta.
4. Set the derivative to zero and solve (the stationary point).
5. Check the second derivative is negative, to confirm a maximum.

The log and exponent rules you need (Handout): log(ab) = log a + log b; log(a/b) = log a - log b; log(a^n) = n log a; log(e^y) = y; and e^a × e^b = e^(a+b), so a product of exponentials becomes e to the sum.

### Worked derivation: MLE for a Normal distribution (Slides)

Data x1, ..., xn are a sample from a normal with unknown mean mu and unknown variance sigma-squared.

**Step 1. Likelihood.**

```math
L(\mu,\sigma^2 \mid x) = \prod_{i=1}^{n} \frac{1}{\sqrt{2\pi\sigma^2}} \exp\!\left(-\frac{(x_i-\mu)^2}{2\sigma^2}\right)
```

**Step 2. Log-likelihood.** The log of each factor is -(1/2) log(2 pi sigma-squared) minus (x\_i - mu)^2 over 2 sigma-squared. Summing n copies gives:

```math
\ell(\mu,\sigma^2) = -\frac{n}{2}\log(2\pi\sigma^2) - \frac{1}{2\sigma^2}\sum_{i=1}^{n}(x_i-\mu)^2
```

**Step 3a. Differentiate in mu and set to zero.**

```math
\frac{\partial \ell}{\partial \mu} = \frac{1}{\sigma^2}\sum_{i=1}^{n}(x_i-\mu) = 0 \;\Rightarrow\; \sum x_i = n\mu \;\Rightarrow\; \hat{\mu} = \bar{x}
```

The MLE of the mean is the sample mean. Notice sigma-squared cancels out of this equation, so you can find mu without knowing sigma.

**Step 3b. Differentiate in sigma-squared and set to zero.**

```math
\frac{\partial \ell}{\partial \sigma^2} = -\frac{n}{2\sigma^2} + \frac{1}{2(\sigma^2)^2}\sum_{i=1}^{n}(x_i-\mu)^2 = 0
```

Multiply both sides by 2(sigma-squared)^2 to get -n sigma-squared + sum of (x\_i - mu)^2 = 0. Plug in mu-hat = x-bar:

```math
\hat{\sigma}^2_{MLE} = \frac{1}{n}\sum_{i=1}^{n}(x_i-\bar{x})^2
```

**Step 4. Second-derivative check (Slides).** At the solution, the matrix of second derivatives (the Hessian) is diagonal:

```math
\frac{\partial^2 \ell}{\partial \mu^2} = -\frac{n}{\hat{\sigma}^2} < 0, \qquad \frac{\partial^2 \ell}{\partial (\sigma^2)^2} = -\frac{n}{2\hat{\sigma}^4} < 0, \qquad \frac{\partial^2 \ell}{\partial \mu\,\partial \sigma^2} = 0
```

Both diagonal entries are negative and the off-diagonal is zero, so the Hessian is **negative definite**: the log-likelihood is shaped like a hill (concave) at this point, so it really is a maximum. (The slide states this conclusion; the entries above are my work-out, which I checked by hand.)

**A key gotcha.** The MLE of the variance divides by **n**, not n - 1. That makes it biased downward: its expected value is ((n-1)/n) sigma-squared. It is still consistent, since the factor (n-1)/n goes to 1.

**Numbers (My example).** Data 2, 4, 6, 8. The mean is 5 and the sum of squared deviations is 9 + 1 + 1 + 9 = 20. The MLE variance is 20/4 = 5. The unbiased sample variance is 20/3 = 6.67. In small samples they differ a lot; with n = 1,000 they would be nearly identical.

### Summary of the Normal MLE (Slides)

```math
\hat{\mu}_{MLE} = \bar{x}, \qquad \hat{\sigma}^2_{MLE} = \frac{1}{n}\sum_{i=1}^{n}(x_i-\bar{x})^2
```

## Part 6: MLE for the Exponential and the Poisson (Handout)

These two are the favorites for a quiz because the algebra is short and every step is a rule you already know. Both are models from Week 5: the **Exponential** is for *waiting time until an event* (a cabinet collapsing, a war ending), and the **Poisson** is for *counts of events in a fixed window* (coups per decade, protests per month). Each has one parameter, lambda, a rate.

### Example 1: Exponential(lambda)

**Model:** density f(x given lambda) = lambda e^(-lambda x) for x at least 0. The mean waiting time is 1/lambda.

**Step 1. Likelihood.** Independent data means multiply:

```math
L(\lambda) = \prod_{i=1}^{n} \lambda e^{-\lambda x_i} = \lambda^n \prod_{i=1}^{n} e^{-\lambda x_i} = \lambda^n e^{-\lambda \sum_{i=1}^{n} x_i}
```

The last equality uses e^a × e^b = e^(a+b): a product of exponentials becomes one exponential whose power is the **sum** of the powers.

**Step 2. Log-likelihood.**

```math
\ell(\lambda) = n\log\lambda - \lambda\sum_{i=1}^{n} x_i
```

(log of lambda^n is n log lambda; log of e to a power is the power itself.)

**Step 3. Differentiate, set to zero, solve.**

```math
\frac{\partial \ell}{\partial \lambda} = \frac{n}{\lambda} - \sum_{i=1}^{n} x_i = 0 \;\Rightarrow\; \frac{n}{\lambda} = \sum x_i \;\Rightarrow\; \hat{\lambda}_{MLE} = \frac{n}{\sum_{i=1}^{n} x_i} = \frac{1}{\bar{X}}
```

**Step 4. Confirm it is a maximum.**

```math
\frac{\partial^2 \ell}{\partial \lambda^2} = -\frac{n}{\lambda^2} < 0 \quad \text{for every } \lambda > 0
```

The second derivative is negative everywhere, so the log-likelihood is a hill with one peak: a **global** maximum.

**Intuition (Handout).** The Exponential's mean is 1/lambda. MLE matches the model's mean to the observed mean: if you observe long waits (large x-bar), lambda-hat is small; short waits give a big lambda-hat.

**Numbers (My example).** Three cabinets survive 2, 4 and 6 years before collapsing. Here n = 3 and the sum is 12, so x-bar = 4 and lambda-hat = 3/12 = 0.25 per year. The implied mean wait is 1/0.25 = 4 years, matching the data. The log-likelihood at the peak is 3 log(0.25) - 0.25(12) = -7.159. With that rate, the chance a cabinet survives past 2 years is e^(-0.25 × 2) = e^(-0.5) = 0.607, which connects directly back to the Week 5 survival question.

### Example 2: Poisson(lambda)

**Model:** probability mass function p(x given lambda) = e^(-lambda) lambda^x / x! for x = 0, 1, 2, ... The mean *and* the variance both equal lambda.

**Step 1. Likelihood.**

```math
L(\lambda) = \prod_{i=1}^{n} \frac{e^{-\lambda}\lambda^{x_i}}{x_i!} = e^{-n\lambda}\,\lambda^{\sum x_i}\,\prod_{i=1}^{n}\frac{1}{x_i!}
```

Three simplifications happened: n copies of e^(-lambda) multiply to e^(-n lambda); the lambda^(x\_i) terms add their powers to lambda^(sum of x); and the product of 1/x\_i! does not involve lambda at all, so it is a **constant** that vanishes when you differentiate.

**Step 2. Log-likelihood.**

```math
\ell(\lambda) = -n\lambda + \Big(\sum_{i=1}^{n} x_i\Big)\log\lambda - \sum_{i=1}^{n}\log(x_i!)
```

**Step 3. Differentiate, set to zero, solve.**

```math
\frac{\partial \ell}{\partial \lambda} = -n + \frac{\sum x_i}{\lambda} = 0 \;\Rightarrow\; \frac{\sum x_i}{\lambda} = n \;\Rightarrow\; \hat{\lambda}_{MLE} = \frac{1}{n}\sum_{i=1}^{n} x_i = \bar{X}
```

**Step 4. Confirm it is a maximum.**

```math
\frac{\partial^2 \ell}{\partial \lambda^2} = -\frac{\sum x_i}{\lambda^2} < 0 \quad \text{for } \lambda > 0
```

(This is negative as long as at least one count is above zero. If every observation were 0, the log-likelihood would just be -n lambda and the peak would sit at the boundary lambda = 0.)

**Intuition (Handout).** For the Poisson, E\[X\] = lambda, so MLE again lines the model's mean up with the sample mean.

**Numbers (My example).** Coups in each of five decades: 1, 3, 2, 0, 4. The sum is 10 and n = 5, so lambda-hat = 2 coups per decade. The second derivative at the peak is -10/4 = -2.5, which is negative, so it is a maximum. Under this fitted model, P(no coups in a decade) = e^(-2) = 0.135.

### Side-by-side summary (Handout)

|  | Exponential | Poisson |
| --- | --- | --- |
| Data type | Waiting times, continuous, at least 0 | Counts, discrete, 0, 1, 2, ... |
| Log-likelihood | n log(lambda) - lambda sum(x) | -n lambda + sum(x) log(lambda) - sum(log x!) |
| MLE | 1 / x-bar | x-bar |
| Second derivative | -n / lambda^2 | -sum(x) / lambda^2 |
| Why it makes sense | Mean is 1/lambda, so set 1/lambda = x-bar | Mean is lambda, so set lambda = x-bar |

**The trap to avoid:** the two answers look similar but flip. A waiting time **averages** to 1/lambda, so you **invert** x-bar. A count averages to lambda, so you **keep** x-bar.

## Part 7: MLE in regression, OLS = MLE, and likelihood ratio tests

### Stretching the Normal MLE to regression (Slides)

In the Normal example every observation had the same mean mu. In regression, each observation gets its **own** mean that depends on x:

```math
y_i = \beta_0 + \beta_1 x_i + \epsilon_i, \qquad \epsilon_i \sim N(0,\sigma^2) \quad\Longrightarrow\quad y_i \sim N(\beta_0+\beta_1 x_i,\ \sigma^2)
```

So the only change from the Normal MLE is replacing the constant mu by the line mu\_i = beta\_0 + beta\_1 x\_i. The log-likelihood is:

```math
\ell(\beta,\sigma^2) = -\frac{n}{2}\log(2\pi\sigma^2) - \frac{1}{2\sigma^2}\sum_{i=1}^{n}(y_i-\beta_0-\beta_1 x_i)^2
```

### Deriving the estimates (Slides)

Differentiate in each beta and set to zero:

```math
\frac{\partial \ell}{\partial \beta_0} = \frac{1}{\sigma^2}\sum_i (y_i-\beta_0-\beta_1 x_i) = 0, \qquad \frac{\partial \ell}{\partial \beta_1} = \frac{1}{\sigma^2}\sum_i x_i(y_i-\beta_0-\beta_1 x_i) = 0
```

Multiply both by sigma-squared (it is just a positive constant) and you have the **normal equations from Week 10**: the residuals sum to zero, and the residuals are uncorrelated with x. Solving gives the familiar answers:

```math
\hat{\beta}_1 = \frac{\mathrm{Cov}(x,y)}{\mathrm{Var}(x)} = \frac{\sum(x_i-\bar{x})(y_i-\bar{y})}{\sum(x_i-\bar{x})^2}, \qquad \hat{\beta}_0 = \bar{y} - \hat{\beta}_1\bar{x}
```

### The punchline: OLS is maximum likelihood (Slides, last two slides)

With normal errors, the log-likelihood is

```math
\ell(\beta_0,\beta_1,\sigma^2) = -\frac{n}{2}\log(2\pi) - \frac{n}{2}\log(\sigma^2) - \frac{1}{2\sigma^2}\sum_{i=1}^{n}(y_i-\beta_0-\beta_1 x_i)^2
```

The only place beta\_0 and beta\_1 appear is in the **negative sum of squared residuals** (the minus sign matters). So:

```math
\max_{\beta_0,\beta_1}\ \ell \iff \min_{\beta_0,\beta_1}\ \sum_{i=1}^{n}(y_i-\beta_0-\beta_1 x_i)^2
```

Maximizing the likelihood **is** minimizing the sum of squared errors. The MLE of the regression line **is** the OLS line. The slides then add one more fact: the MLE of the error variance is

```math
\hat{\sigma}^2_{MLE} = \frac{1}{n}\sum_i e_i^2
```

which divides by n, so it is biased downward, "just like the variance MLE earlier today" (the Normal example). The unbiased regression version divides by n - 2 instead (two estimated coefficients).

**Why this is a big deal.** You no longer have two separate recipes. Least squares was one idea; maximum likelihood is another; and for normal errors they land on the same line. The slides close by saying the same recipe covers the sample mean, the regression line, and logit and Poisson regression (next week).

### Tying it to your Week 10 quiz data (My example)

The Week 10 quiz used (x, y) = (0, 2), (1, 3), (2, 7), with OLS estimates beta-1-hat = 2.5 and beta-0-hat = 1.5. Residuals are 0.5, -1, 0.5, so the sum of squared residuals is 0.25 + 1 + 0.25 = 1.5.

- **MLE of sigma-squared** = 1.5 / 3 = **0.5** (divide by n).
- **Unbiased version** = 1.5 / (3 - 2) = **1.5** (divide by n - 2).

Same line, two different variance answers. That is the "biased downward" statement in numbers.

### Likelihood ratio (LR) tests (Slides)

The LR test compares two **nested** models: a *full* model, and a *reduced* model that is the full model with some parameters forced to a particular value (usually zero).

```math
LR = 2\left[\ell(\hat{\theta}_{full}) - \ell(\hat{\theta}_{reduced})\right] \sim \chi^2(df), \quad df = \text{number of parameters removed}
```

The idea: the full model always fits at least as well, so its log-likelihood is at least as high. If dropping the parameters costs you *a lot* of log-likelihood, the LR statistic is large and you reject the reduced model. If it costs almost nothing, the extra parameters are not earning their keep.

The slide's example: test beta\_1 = 0 in a regression. Full model has (beta\_0, beta\_1); reduced model has only beta\_0. LR follows a chi-squared distribution with **1** degree of freedom (one parameter removed). The 5% critical value for chi-squared(1) is **3.841**.

**Worked example with the Week 10 data (My example).** Maximized log-likelihood for a normal-error regression, with the MLE variance plugged in, is -(n/2) log(2 pi) - (n/2) log(sigma-hat-squared) - n/2.

| Model | Sum of squared residuals | MLE sigma-hat-squared | Log-likelihood |
| --- | --- | --- | --- |
| Full (intercept + slope) | 1.5 | 0.5 | -3.217 |
| Reduced (intercept only, so beta\_1 = 0) | 14 | 4.667 | -6.567 |

```math
LR = 2\,[-3.217 - (-6.567)] = 6.70 > 3.841
```

Since 6.70 exceeds 3.841, you would reject beta\_1 = 0. (With only three observations the chi-squared approximation is rough, so treat this as a mechanics demo, not a real test.) A handy shortcut (Extension): for normal-error regression, LR = n log(SSR\_reduced / SSR\_full) = 3 log(14/1.5) = 6.70, the same answer without computing the log-likelihoods.

**Where this sits in the course.** The t test, the Wald-style test from Week 10, and the LR test answer the same question (is this coefficient zero?) from different angles, and they agree in large samples.

## Part 8: Why MLE is trusted: its three large-sample properties (Slides)

Under regular conditions, the MLE has three attractive properties. Notice that all three are **large-sample** (as n grows) promises, not small-sample ones, which is why the MLE of the variance can be biased in small samples and still be fine.

**1. Consistency.**

```math
\hat{\theta}_{MLE} \xrightarrow{\;p\;} \theta
```

With enough data, the MLE homes in on the truth. This is the same idea as Part 4. The lecture's last simulation shows it: the Normal MLE of the mean (which is the sample mean) for sample sizes 10 to 1,000 wobbles at small n, then settles on the true value 5.

**2. Asymptotic efficiency.** As n goes to infinity, the MLE reaches the **Cramer-Rao lower bound**, the smallest variance that *any* well-behaved unbiased estimator could have. In plain words: for big samples, nobody can beat it.

**3. Asymptotic normality.**

```math
\sqrt{n}\,(\hat{\theta}_{MLE} - \theta) \xrightarrow{\;d\;} N\!\left(0,\ I(\theta)^{-1}\right)
```

where I(theta) is the **Fisher information**. In plain words: no matter what the original distribution looks like (exponential, Poisson, anything), the sampling distribution of the MLE looks like a bell curve for large n, centered on the truth. That is exactly what justifies building confidence intervals and z tests around MLEs.

### What is Fisher information? (Extension)

I(theta) measures how sharply peaked the log-likelihood is: how much information a single observation carries about theta. A sharp peak means the data pin theta down tightly (small variance); a flat peak means they do not. Formally, it is the average of the negative second derivative of the log-likelihood for one observation. That is why we kept checking the second derivative in Parts 5 to 7: the same quantity that confirms a maximum also tells you the precision.

For n observations, the MLE's approximate variance is 1 / (n I(theta)). Results for the models in this week:

| Model | Fisher info per observation, I(theta) | Approx. variance of the MLE |
| --- | --- | --- |
| Normal mean, sigma-squared known | 1 / sigma-squared | sigma-squared / n |
| Poisson rate lambda | 1 / lambda | lambda / n |
| Exponential rate lambda | 1 / lambda-squared | lambda-squared / n |

Check the first row against Part 2: it reproduces Var(x-bar) = sigma-squared / n. Check the second: for a Poisson, the variance equals the mean, so Var(x-bar) = lambda / n. Both agree.

**Link to the code tutorial.** The log-likelihood curve in the tutorial (Section 2) is that hill. The peak is the MLE; how pointed the hill is tells you the precision. A bigger sample makes the hill taller and narrower around the same peak.

**Link to the quiz.** Practice Quiz problem 7(b) asks why we check the second-order condition: it is the test that the stationary point is a **maximum**, not a minimum or a saddle, because setting a derivative to zero finds *any* flat spot.

## Part 9: Bootstrap and Bayesian estimation

The slide text I could read does not cover these two, but both show up in Practice Quiz 11 (problems 9 and 10) and the bootstrap is half of the code tutorial. I checked the lecture video transcripts too: neither topic is narrated there, so learn them as below.

### The nonparametric bootstrap (Practice Quiz + R tutorial Sections 4 and 5)

**The problem it solves.** You have one sample and want to know how much your estimate (say, a regression slope) would wobble across samples, but you cannot go collect 1,000 new datasets. The bootstrap **pretends your sample is the population** and re-samples from it.

**The algorithm for the standard error of a slope:**

1. Your data has n rows (each row is a pair x\_i, y\_i). Draw n rows **with replacement** from your own data. Some rows appear twice or more, some not at all. This is one "bootstrap sample."
2. Run the regression on that bootstrap sample and save the slope.
3. Repeat steps 1 and 2 many times (the tutorial uses **B = 1,000**).
4. You now have 1,000 slopes. Their **standard deviation is the bootstrap standard error**.
5. For a **95% percentile interval**, sort the 1,000 slopes and take the 2.5th percentile and the 97.5th percentile as the lower and upper endpoints.

The key point: it is **rows** (cases) that are resampled, not the residuals or the numbers x and y separately, so each x stays attached to its y.

**Why it is attractive.** It needs no formula for the standard error and no assumption that errors are normal, so it works for messy statistics (medians, ratios, anything you can compute from data). It is easy to code: a for loop. The cost is computing time and the fact that it still relies on your sample being representative.

**What the tutorial does.** The data are generated as y = 1 + 3x + noise (so the truth is intercept 1, slope 3), with n = 100. The loop in R is:

```r
idx <- sample(length(x), size = length(x), replace = TRUE)   # pick n row numbers with replacement
fit <- lm(y[idx] ~ x[idx])                                   # refit the regression on that bootstrap sample
boot_coef[b, ] <- coef(fit)                                  # store intercept and slope
# after the loop:
apply(boot_coef, 2, quantile, probs = c(0.025, 0.975))       # 95% percentile intervals
```

The intervals should bracket 1 and 3. Section 5 does the same thing with the `boot` package: `boot(...)` runs the resampling for you and `boot.ci(..., type = "perc")` returns the percentile interval. The Python version uses `scipy.stats.bootstrap` with `paired=True` (which means resample the (x, y) *pairs* together) and `method="percentile"`.

### Maximum likelihood vs Bayesian estimation (Practice Quiz problem 10)

|  | Maximum likelihood | Bayesian |
| --- | --- | --- |
| Extra ingredient needed | None. Just the likelihood. | A **prior distribution** p(theta): what you believe about theta before seeing data |
| What it reports | A single **point estimate** theta-hat (plus a standard error or interval) | A whole **posterior distribution** over theta |
| Formula | theta-hat = argmax L(theta given x) | posterior = likelihood × prior, normalized |
| What happens as n grows | The likelihood dominates | The prior washes out and the posterior concentrates near the MLE, so the two methods converge |

```math
p(\theta \mid x) \;\propto\; L(\theta \mid x)\; p(\theta)
```

(Extension.) If the prior is completely flat, the posterior has the same shape as the likelihood, so the posterior's peak is the MLE. A good way to remember it: Bayesian = likelihood plus a starting belief, and with lots of data the starting belief stops mattering.

**Spot the difference in the word "probability."** In the Bayesian approach, it is legitimate to say "there is a 95% probability that theta lies in this credible interval," because theta has a probability distribution. In the frequentist (MLE / confidence interval) approach, theta is a fixed number and the probability statement is about the *procedure*, as in Part 1.

## Part 10: Code tutorial walkthrough (code\_tutorial\_11.R / .py)

The quiz is paper-only (no computer), but the code is the easiest way to *see* the ideas. I read the R file in full and checked the Python file's structure; they have the same five sections.

| Section | What the code does | What idea it demonstrates |
| --- | --- | --- |
| 1. Poisson MLE by simulation | Draws 1,000,000 Poisson values with true lambda = 4 and takes the mean | The Poisson MLE **is** the sample mean (Part 6), and with a huge n it lands almost exactly on 4 (consistency, LLN) |
| 2. Log-likelihood curve | Draws 50 Poisson values; for each lambda from 2 to 7 in steps of 0.01 it adds up the log probability of the data; plots it and marks the sample mean with a dashed line | The MLE is the **peak** of the log-likelihood hill. The dashed line (sample mean) lines up with the top of the curve |
| 3. Beta MLE by numerical optimization | Draws 1,000 values from a Beta(2, 5); minimizes the **negative** log-likelihood with `optim` starting at (1, 1); then repeats for the Normal and compares to the closed form | When there is **no closed-form** answer, a computer climbs the hill for you. The result lands near (2, 5). For the Normal, the numerical answer matches x-bar and the divide-by-n standard deviation |
| 4. Bootstrap, for loop | Resamples rows 1,000 times, refits `lm`, stores coefficients, takes the 2.5% and 97.5% quantiles | Part 9: percentile bootstrap interval |
| 5. Bootstrap, package | Same result using `boot()` and `boot.ci(type = "perc")` in R, or `scipy.stats.bootstrap` in Python | Same idea, less typing |

**Three things to notice**

- **`optim` minimizes, so we hand it the negative log-likelihood.** Minimizing the negative is the same as maximizing the original. Forgetting the minus sign is the classic bug.
- **`dpois(x, lambda, log = TRUE)` and `dnorm(..., log = TRUE)`** compute the log of each observation's probability. Wrapping them in `sum()` is literally the log-likelihood formula: a sum of logs.
- **The Normal check in Section 3** computes the standard deviation with `sqrt(mean((x - mean(x))^2))`. That is the divide-by-n version, matching the MLE formula, not R's built-in `sd()`, which divides by n - 1.

**Likely paper-quiz translations.** You will not be asked to write R, but you may be asked what the code *shows* (for example, "the dashed line sits at the peak of the curve; what is that value called?" Answer: the MLE, and for the Poisson it equals the sample mean).

## Part 11: Practice Quiz 11, all ten problems worked

Each problem below starts with the question exactly as it is worded in practice_quiz_11.pdf, followed by the worked answer. The answer key was not in your folder, so these solutions are mine. Try each problem cold first, then check. Where a problem has numbers, I verified them by computer.

### Problem 1. "The likelihood is the probability that theta is true."

> **Question.** Your classmate says “the likelihood L(θ) is the probability that θ is true.” Correct this statement: what is the likelihood a function of, what does it hold fixed, and how does it differ from a probability distribution over θ?

**Answer.**

**Correction.** The likelihood L(theta given x) = f(x given theta) is a function of the **parameter theta**, holding the **observed data x fixed**. It measures how well each candidate theta explains the data you saw. It is *not* a probability distribution over theta: it does not have to sum or integrate to 1 across theta, and it says nothing about how probable a given theta is. A probability distribution (the pdf) goes the other way: it holds theta fixed and varies the data, and it integrates to 1 over the data. (Only a Bayesian, with a prior, can talk about the probability of theta.)

### Problem 2. Mean vs median as estimators of a center

> **Question.** Two unbiased estimators of the center of a symmetric distribution are available: the sample mean and the sample median. For normal data the mean has the smaller sampling variance. (a) Which estimator is preferred on efficiency grounds? (b) When might you prefer the median anyway?

**Answer.**

(a) The **mean**. Both are unbiased, so choose by efficiency: the one with smaller variance. The lecture simulation had 0.126 for the mean and 0.186 for the median.

(b) Prefer the median when the data may contain **outliers or heavy tails** (for example, incomes, or protest counts with a few huge events), because one extreme value pulls the mean a lot but barely moves the median. In that case the mean's efficiency advantage disappears or reverses.

### Problem 3. n = 100, x-bar = 30, sigma = 10

> **Question.** A sample of n = 100 has x̄ = 30; the population standard deviation is σ = 10. (a) Construct the 95% confidence interval for µ. (b) Using the interval, test H0 : µ = 33 at the 5% level and state your conclusion.

**Answer.**

(a) Standard error = 10 / sqrt(100) = 1.

```math
30 \pm 1.96(1) = [28.04,\ 31.96]
```

(b) Test H0: mu = 33. The value 33 is **outside** \[28.04, 31.96\], so **reject H0** at the 5% level. (Check with a z statistic: (30 - 33)/1 = -3, and |-3| > 1.96.)

### Problem 4. Parameter, estimator, estimate, and bias

> **Question.** Distinguish the three terms: parameter, estimator, and estimate. Then write the bias formula for an estimator θ̂ and state what unbiasedness requires.

**Answer.**

- **Parameter:** a fixed, unknown number describing the population (for example mu).
- **Estimator:** a rule, a formula applied to a random sample (for example x-bar = (sum of x)/n). It is a random variable with a sampling distribution.
- **Estimate:** the specific number that rule produces on one actual sample (for example 10.18).

```math
\mathrm{Bias}(\hat{\theta}) = E[\hat{\theta}] - \theta
```

Unbiasedness requires **E\[theta-hat\] = theta**, that is, bias equal to zero, for every possible true value of theta.

### Problem 5. Biased in small samples, right in the limit

> **Question.** An estimator is biased in small samples but converges to the true parameter as n → ∞. (a) Which property does it possess: unbiasedness or consistency? (b) Give a standard example of such an estimator.

**Answer.**

(a) **Consistency.** (It is not unbiased, because the problem says it is biased.)

(b) The standard example is the **MLE of the variance**, (1/n) times the sum of (x\_i - x-bar)^2. Its expected value is ((n-1)/n) sigma-squared, so it is biased low, but (n-1)/n tends to 1, so it converges to sigma-squared.

### Problem 6. Poisson MLE with a maximum check

> **Question.** Let X1, . . . , Xn be iid Poisson(λ), with log-likelihood ℓ(λ) = Σᵢ (xᵢ log λ − λ − log xᵢ!). Derive the MLE of λ by differentiating, setting the score to zero, and solving. Confirm the solution is a maximum.

**Answer.**

Given the log-likelihood:

```math
\ell(\lambda) = \sum_i \big(x_i\log\lambda - \lambda - \log x_i!\big)
```

**Differentiate** (the log x! term does not depend on lambda, so it drops out):

```math
\ell'(\lambda) = \frac{\sum x_i}{\lambda} - n
```

**Set to zero and solve:** sum of x over lambda = n, so lambda = (sum of x)/n.

```math
\hat{\lambda}_{MLE} = \bar{x}
```

**Confirm maximum:**

```math
\ell''(\lambda) = -\frac{\sum x_i}{\lambda^2} < 0
```

The second derivative is negative, so the log-likelihood is concave and the solution is a maximum (provided at least one x is above zero).

### Problem 7. Normal mean with known variance

> **Question.** For iid N(µ, σ²) data with σ² known, the log-likelihood in µ is ℓ(µ) = c − (1/2σ²) Σᵢ (xᵢ − µ)². (a) Derive the MLE of µ. (b) In one sentence, what does checking the second-order condition establish, and why is it needed?

**Answer.**

(a) With the log-likelihood in mu:

```math
\ell(\mu) = c - \frac{1}{2\sigma^2}\sum_i (x_i-\mu)^2
```

```math
\ell'(\mu) = \frac{1}{\sigma^2}\sum_i (x_i-\mu) = 0 \;\Rightarrow\; \sum x_i = n\mu \;\Rightarrow\; \hat{\mu}_{MLE} = \bar{x}
```

(b) The second-order condition, ell''(mu) = -n / sigma-squared < 0, establishes that the stationary point is a **maximum** (not a minimum or an inflection). You need it because setting the first derivative to zero finds *every* flat point, and it does not say which kind of flat point you have found.

### Problem 8. n = 225, x-bar = 52, sigma = 15, 99% CI

> **Question.** A survey of n = 225 respondents yields mean approval x̄ = 52 with known population standard deviation σ = 15. (a) Construct the 99% confidence interval for µ (z = 2.576). (b) A 95% interval from the same data would be [50.04, 53.96]. Compare the two widths and state the general confidence–precision trade-off.

**Answer.**

Standard error = 15 / sqrt(225) = 15/15 = 1.

(a)

```math
52 \pm 2.576(1) = [49.424,\ 54.576]
```

(b) Widths:

| Confidence level | Interval | Width |
| --- | --- | --- |
| 95% | \[50.04, 53.96\] | 3.92 |
| 99% | \[49.424, 54.576\] | 5.152 |

The 99% interval is wider. **Trade-off:** for a fixed sample size, higher confidence buys you more certainty of capturing the true mean but costs precision (a wider, less informative interval). The only way to gain both is to increase n.

### Problem 9. Nonparametric bootstrap for a regression slope

> **Question.** Describe the nonparametric bootstrap for the standard error of a regression slope: what is resampled, how often, what is computed each time, and how a 95% percentile interval is formed. Why is the method attractive?

**Answer.**

See Part 9. Short answer: **resample** the n rows (x, y pairs) of your data **with replacement** to make a bootstrap dataset of the same size; do this **B times** (say 1,000); each time **refit the regression and store the slope**; the **standard deviation** of those B slopes is the bootstrap standard error, and the **2.5th and 97.5th percentiles** form the 95% percentile interval. **Attractive** because it needs no formula for the standard error and no normal-errors assumption, and works for almost any statistic.

### Problem 10. Maximum likelihood vs Bayesian in two sentences

> **Question.** Contrast maximum likelihood and Bayesian estimation in two sentences: what extra ingredient does the Bayesian approach require, and what object does each approach report? What typically happens to the difference between them as n grows large?

**Answer.**

The Bayesian approach needs an extra ingredient, a **prior distribution** over theta, and it reports a full **posterior distribution** for theta, whereas maximum likelihood needs only the likelihood and reports a **single point estimate** (the value that maximizes it). As n grows, the data overwhelm the prior, so the posterior concentrates near the MLE and **the two approaches converge**.

## Part 12: Quiz strategy and extra practice

### What the Week 10 quiz looked like (from the key you attached)

The quiz was 15 minutes, notes allowed, no computer, "show all work." It had three questions on a difficulty ramp:

| Question | Difficulty and points | Type | What it asked |
| --- | --- | --- | --- |
| 1 | Easy, 2 pts | Definition + short list | Define the power of a test; list two factors that raise power |
| 2 | Medium, 4 pts | Derive then compute by hand | Write the least-squares objective and the two normal equations; compute OLS estimates for three data points |
| 3 | Hard, 6 pts | Multi-part: compute, decide, interpret | Compute a t statistic; decide using the critical value 1.96; explain why "the p-value is the probability H0 is true" is wrong |

The pattern to notice: **one definition, one derive-and-compute, one compute-decide-explain.** Practice Quiz 11 is built the same way, so expect to be asked for a *calculus derivation* where last week it was a *least-squares derivation*.

**Update after reading the videos:** two of your three lecture videos (Parts 15 and 16) cover regression diagnostics and multiple regression, and Practice Quiz 11 does not test them. I cannot tell from the materials whether the quiz will, so skim the self-test questions at the end of Parts 15 and 16 as well, especially omitted variable bias, heteroskedasticity and robust standard errors, and leverage versus influence.

### Likely Week 11 question shapes (my prediction, not from your instructor)

- **Easy (2 pts):** a definition. Candidates: bias, consistency, efficiency, MSE, likelihood vs probability, "why the log-likelihood," or "what does the MLE maximize." Practice Quiz problems 1, 4, 5, 10 are this type.
- **Medium (4 pts):** derive an MLE (Poisson, Exponential or Normal mean) with the second-derivative check, then plug in numbers. Practice Quiz problems 6 and 7 are this type.
- **Hard (6 pts):** a multi-part problem, such as build a CI, use it to decide a test, and explain a trade-off or an interpretation. Practice Quiz problems 3 and 8 are this type, with problems 2 and 9 as add-ons.

### Time plan for 15 minutes

- Spend about 2 minutes on the easy one, then stop.
- Spend about 5 to 6 minutes on the medium one. Write each step of the recipe (likelihood, log, derivative, solve, second derivative) on its own line so partial credit is easy to give.
- Spend the rest on the hard one. Do the arithmetic parts first; the explanation part can be short as long as it names the key idea.

### Extra practice written by me (in the style of the above)

**Extra 1 (Easy, 2 pts).** Define consistency and unbiasedness, and name an estimator that is unbiased but not consistent.

**Extra 2 (Medium, 4 pts).** Cabinet lifetimes (years) of four governments are 1, 2, 3, 6, modeled as i.i.d. Exponential(lambda). Derive the MLE of lambda and confirm it is a maximum, then compute it.

**Extra 3 (Hard, 6 pts).** A country had 3, 5, 4, 6 and 2 protests in five consecutive months, modeled as i.i.d. Poisson(lambda). (a) Derive and compute the MLE. (b) Verify it is a maximum. (c) Using the approximate standard error square root of (lambda-hat / n), build a 95% interval. (d) Does the interval support H0: lambda = 3?

**Extra 4 (True or false, one sentence each).**

1. The likelihood integrates to 1 across values of theta.
2. The MLE of sigma-squared for normal data is unbiased.
3. Gauss-Markov requires normally distributed errors.
4. Every consistent estimator is unbiased.
5. The log-likelihood has its maximum at the same theta as the likelihood.
6. A 99% interval is narrower than a 95% interval for the same data.
7. MSE equals variance plus squared bias.

### Answers to the extra practice

**Extra 1.**

> **Question.** Define consistency and unbiasedness, and name an estimator that is unbiased but not consistent.

**Answer.** Unbiased: E\[theta-hat\] = theta at every sample size. Consistent: theta-hat converges in probability to theta as n goes to infinity. Unbiased but not consistent: the first observation x1 as an estimate of mu (right on average, but it never improves as n grows).

**Extra 2.**

> **Question.** Cabinet lifetimes (years) of four governments are 1, 2, 3, 6, modeled as i.i.d. Exponential(lambda). Derive the MLE of lambda and confirm it is a maximum, then compute it.

**Answer.** Likelihood and log-likelihood:

```math
L(\lambda)=\lambda^n e^{-\lambda\sum x_i}, \qquad \ell(\lambda)=n\log\lambda-\lambda\sum x_i
```

Derivative set to zero: n / lambda - sum of x = 0, so lambda-hat = n / (sum of x). Second derivative: -n / lambda^2 < 0, so it is a maximum. Numbers: n = 4, sum = 1 + 2 + 3 + 6 = 12, so lambda-hat = 4/12 = **1/3 per year** (about 0.333). The implied mean lifetime is 1/lambda-hat = 3 years, which equals x-bar = 3, as it should. At lambda-hat the second derivative is -4 / (1/9) = -36, negative.

**Extra 3.**

> **Question.** A country had 3, 5, 4, 6 and 2 protests in five consecutive months, modeled as i.i.d. Poisson(lambda). (a) Derive and compute the MLE. (b) Verify it is a maximum. (c) Using the approximate standard error square root of (lambda-hat / n), build a 95% interval. (d) Does the interval support H0: lambda = 3?

**Answer.** (a) For a Poisson, lambda-hat = x-bar = (3 + 5 + 4 + 6 + 2) / 5 = 20/5 = **4**. (b) The second derivative is -sum of x / lambda^2 = -20/16 = -1.25 < 0, so it is a maximum. (c) The approximate variance of the MLE is lambda / n, so the standard error is the square root of 4/5 = 0.894. The interval is 4 ± 1.96(0.894) = 4 ± 1.754 = **\[2.25, 5.75\]**. (d) The value 3 sits inside \[2.25, 5.75\], so you **do not reject** H0: lambda = 3. (Equivalent z = (4 - 3)/0.894 = 1.12, which is less than 1.96.) The standard-error shortcut here comes from Fisher information (Part 8, an extension), so on a real quiz the standard error would be given to you.

**Extra 4.** True or false, one sentence each.

1. *The likelihood integrates to 1 across values of theta.* **False.** The likelihood need not integrate to 1 over theta; it is not a distribution over theta.
2. *The MLE of sigma-squared for normal data is unbiased.* **False.** It divides by n and is biased downward by the factor (n-1)/n.
3. *Gauss-Markov requires normally distributed errors.* **False.** Gauss-Markov needs the five assumptions, none of which is normality.
4. *Every consistent estimator is unbiased.* **False.** The MLE of the variance is consistent but biased.
5. *The log-likelihood has its maximum at the same theta as the likelihood.* **True.** The log is monotonic, so it does not move the peak.
6. *A 99% interval is narrower than a 95% interval for the same data.* **False.** A 99% interval is *wider*.
7. *MSE equals variance plus squared bias.* **True.**

## Part 13: One-page formula sheet and pre-quiz checklist

Since the quiz is notes-allowed, this is the page to copy onto your own sheet.

### Formula sheet

```math
\begin{aligned}
&\textbf{CI (known }\sigma):\ \bar{x}\pm z_{\alpha/2}\frac{\sigma}{\sqrt n} \qquad \textbf{CI (unknown }\sigma):\ \bar{x}\pm t_{\alpha/2,\,n-1}\frac{s}{\sqrt n}\\[4pt]
&z_{0.05}=1.645,\ \ z_{0.025}=1.96,\ \ z_{0.005}=2.576\\[4pt]
&\mathrm{Bias}(\hat\theta)=E[\hat\theta]-\theta \qquad \mathrm{Var}(\bar x)=\frac{\sigma^2}{n} \qquad \mathrm{Precision}=\frac{1}{\mathrm{Var}}\\[4pt]
&\mathrm{MSE}(\hat\theta)=\mathrm{Var}(\hat\theta)+\mathrm{Bias}(\hat\theta)^2 \qquad \mathrm{Var}(\hat\beta)=\sigma^2(X'X)^{-1}\\[4pt]
&\text{Consistency: }\hat\theta_n\xrightarrow{p}\theta \qquad \text{LLN: }\bar x_n\xrightarrow{p}\mu\\[4pt]
&L(\theta\mid x)=\prod_i f(x_i\mid\theta) \qquad \ell(\theta)=\sum_i\log f(x_i\mid\theta) \qquad \hat\theta=\arg\max\ell\\[4pt]
&\text{Normal: }\hat\mu=\bar x,\ \ \hat\sigma^2=\tfrac1n\sum(x_i-\bar x)^2\\[4pt]
&\text{Exponential: }\ell=n\log\lambda-\lambda\sum x_i,\ \hat\lambda=\tfrac{1}{\bar x}\\[4pt]
&\text{Poisson: }\ell=-n\lambda+\sum x_i\log\lambda-\sum\log x_i!,\ \hat\lambda=\bar x\\[4pt]
&\text{Regression: }\hat\beta_1=\frac{\sum(x_i-\bar x)(y_i-\bar y)}{\sum(x_i-\bar x)^2},\ \hat\beta_0=\bar y-\hat\beta_1\bar x,\ \hat\sigma^2_{MLE}=\tfrac1n\sum e_i^2\\[4pt]
&LR=2[\ell(\hat\theta_{full})-\ell(\hat\theta_{red})]\sim\chi^2(df)\\[4pt]
&\sqrt n(\hat\theta_{MLE}-\theta)\xrightarrow{d}N(0,I(\theta)^{-1})
\end{aligned}
```

### Gauss-Markov five assumptions, in order

1. Linearity: y = X beta + epsilon
2. Random sampling: (y\_i, X\_i) i.i.d.
3. No perfect collinearity: rank(X) = k
4. Zero conditional mean: E(epsilon given X) = 0
5. Homoscedastic errors: Var(epsilon given X) = sigma-squared I

Memory aid: **L**inear, **R**andom, **N**o collinearity, **Z**ero mean, **H**omoscedastic.

### The MLE recipe, every time

1. Write L(theta) as a product.
2. Take the log; simplify with the log rules.
3. Differentiate with respect to theta.
4. Set to zero and solve.
5. Second derivative negative? Then it is a maximum.

### The five estimator properties at a glance

| Property | One-line meaning | Lecture example |
| --- | --- | --- |
| Bias | Is the center on the truth? | Omitted variable gave 2.755 instead of 2 |
| Variance | How wide is the sampling distribution? | sigma-squared / n |
| Efficiency | Smallest variance among unbiased | Mean 0.126 vs median 0.186 |
| MSE | Variance + bias squared, one score | About 0.0712 in the n = 50 simulation |
| Consistency | Converges to the truth as n grows | Running mean flattening at the true value |

### Pre-quiz checklist

- [ ] I can say, without notes, the difference between a parameter, an estimator and an estimate.
- [ ] I can write the bias formula and say what "unbiased" requires.
- [ ] I can explain why unbiased and consistent are different, with an example of each combination.
- [ ] I can derive the Poisson MLE and the Exponential MLE from scratch, including the second-derivative check.
- [ ] I can derive the Normal mean MLE and state that the variance MLE divides by n (and is biased).
- [ ] I can explain why maximizing the normal-error likelihood equals minimizing the sum of squared residuals.
- [ ] I can build a 95% CI by hand and use it to decide a two-sided test.
- [ ] I can explain the likelihood vs probability difference in two sentences.
- [ ] I can describe the bootstrap in five steps and the MLE-vs-Bayesian difference in two sentences.
- [ ] I know the five Gauss-Markov assumptions and which one gives unbiasedness (zero conditional mean).

### Common traps

- **Exponential vs Poisson:** invert x-bar for the Exponential (1 / x-bar); keep x-bar for the Poisson.
- **Divide by n or n - 1?** The MLE of the variance divides by n; the unbiased sample variance divides by n - 1; the regression error variance divides by n - 2 for an unbiased version.
- **"Probability that H0 is true"** is never what a p-value or a confidence level means.
- **Wider interval = more confident but less precise.**
- **Forgetting the second-derivative check.** It is cheap, and it is usually worth points.

## Part 14: Lecture 1 slide by slide: the lecturer's code explained, plus what he said out loud

This part follows the order of the first lecture video ("lecture 11"). For every slide with code, I show the lecturer's code with my plain-English comments added after `# >>`. Under each slide, **"Said in the lecture"** lists points from the video transcript that are *not* on the slide. The captions are auto-generated, so a few words are garbled (the lecturer's "MLE" appears as "MLA" or "Emily"); I corrected those silently where the meaning was obvious and flagged the ones I was unsure about.

### Slides: Interval Estimation, CI for a Normal sampling distribution

No code. **Said in the lecture:**

- A point estimate gives one best guess but says nothing about uncertainty. The CI "communicates both the estimate and the uncertainty around it" and "balances precision with honesty." His example: instead of "the mean is 10," say "we're 95% confident the mean is between 9.2 and 10.8."
- The formula has three ingredients in the margin of error: the **critical value**, the **population standard deviation**, and the **sample size**.
- *Where 1.96 comes from:* for 95%, alpha = 0.05, split across two tails to alpha/2 = 0.025 each; the z-score that cuts off the top 2.5% is about **1.96**. For 90%, alpha = 0.10, each tail 0.05, cutoff about **1.65**. For 99%, alpha = 0.01, each tail 0.005, cutoff about **2.58**. "Alpha divided by two just means we take the probability we're leaving out and split it equally between the two tails."
- A more spread-out population means each sample is more variable, so intervals are **wider**; a tightly clustered population gives a **narrower** interval.
- The square root of n in the denominator "reflects the law of large numbers": more data makes the sample mean more stable, so the standard error shrinks and the interval narrows.
- Caveat: this version assumes sigma is known, which is "almost never true in practice," so it is "mostly pedagogical."

### Slide: CI with estimated standard errors (t)

No code. **Said in the lecture:**

- Same recipe, three swaps: sigma becomes the sample standard deviation s; the z critical value becomes a **t critical value**; and you must include **degrees of freedom = n - 1**.
- The t critical value *depends on the sample size* (through df); the z critical value does not.
- The t distribution has **heavier tails** because we are estimating the standard deviation from the sample, which adds uncertainty. So t intervals are somewhat wider.
- The four rules for width, restated: larger n shrinks the interval; noisier data widens it; more precise (lower variability) data shrinks it; going from 90% to 95% confidence widens it.

### Slide: Confidence intervals and hypothesis testing

No code. **Said in the lecture:** "Two sides of the same coin." The CI is a *range* of possible values; the test asks whether one specific value (the null) falls inside the range. If the 95% CI is 0.3 to 1.2, zero is outside, so reject at the 5% level. If it runs from -0.2 to 0.5, zero is inside, so do not reject. A CI also gives a **richer picture** than a test alone, because it shows the whole range of plausible values and not just reject / do not reject.

### Slide: Point estimation (code)

```r
set.seed(123)                                   # >> fix the random-number generator so the "random" draws are the same every run
n <- 100                                        # >> sample size
true_mu <- 10                                   # >> the true parameter (we know it only because we are simulating the data)

sample_data <- rnorm(n, mean=true_mu, sd=2)     # >> draw 100 values from a Normal(mean 10, sd 2): our one "survey"
sample_mean <- mean(sample_data)                # >> the estimator (mean) applied to this sample gives the estimate

cat("True parameter (mu):", true_mu, "\n")                    # >> prints 10
cat("Estimated parameter (sample mean):", sample_mean, "\n")  # >> prints 10.18081
```

**What it shows:** the estimate (10.18) is near, but not equal to, the truth (10). That gap is sampling error. **Said in the lecture:** "Point estimates are not the truth. They are random variables themselves. Every time we take a different sample, we get a slightly different estimate." In regression, the coefficients we compute by least squares are point estimates. The gap between truth and estimate is what drives the need for confidence intervals (the caption here is garbled; I read it as "confidence intervals").

### Slide: Bias (code)

```r
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
```

**How to read it.** Each estimate comes from one sample of 1,000. In the first case the only thing separating 2.089 from 2 is ordinary sampling noise. In the second, x and z are correlated, and because z is left out, the slope on x absorbs part of z's effect: roughly 2 + 0.8 = 2.8. With n = 1,000 that gap is too big to be luck; it is **bias**, and it would persist with more data.

**Said in the lecture:** Bias "asks if we repeated the sampling process many, many times, would the average of those estimates land right at the true parameter?" Unbiased means each sample may be off "but the misses cancel each other out over time." Biased means the estimator "systematically overshoots or undershoots the truth." **His analogy:** a properly calibrated scale reads a bit high or low each time but is right on average (unbiased); a scale that always reads 2 lbs too heavy misses in the same direction every time (biased).

### Slide: Variance (code)

```r
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
```

(The slide does not print `variance_estimate`; it should come out near 0.04.) **Said in the lecture:** the histogram "clusters tightly around 10, but there's still some spread. That's the variance of the estimator." Bias is systematic error; variance is *random error*. Bigger population variance means bigger sampling variance; bigger n reduces it because "larger samples average out the noise." High variance means noisy, unstable estimates (the caption says "very stable" at one point, but the context shows he meant *un*stable: "if you collect the data twice, you might get wildly different estimates"). Researchers reduce variance by **increasing sample size, improving measurement, or carefully choosing estimators**.

### Slide: Precision (code)

```r
set.seed(123)
n_sim <- 1000
sample_sizes <- c(30, 100, 500)                  # >> three sample sizes to compare
true_mu <- 10

variances <- sapply(sample_sizes, function(n) {  # >> sapply() runs the function once per sample size and collects the answers into a vector
  estimates <- replicate(n_sim, mean(rnorm(n, mean=true_mu, sd=2)))   # >> 1,000 sample means at this n
  var(estimates)                                 # >> their variance (the last line is what the function returns)
})

barplot(variances, names.arg=sample_sizes, main="Variance by Sample Size",
        xlab="Sample Size", ylab="Variance", col="lightgreen")   # >> three bars, labeled 30, 100, 500
```

**What it shows:** the bars are *variances* (about 0.133, 0.04, 0.008 by theory), which fall as n rises. Precision is the inverse, n / sigma-squared, so it *rises*. **Said in the lecture:** n = 30 gives a relatively large variance (low precision); n = 500 gives a "tiny" variance (highly precise). Precise estimates give **narrower CIs and more power** in hypothesis tests. If an estimate is imprecise, the CI will be wide, "and you may fail to reject the null even when real effects exist."

### Slide: Variance of regression coefficients

No code. **Said in the lecture:**

- sigma-squared is the **error (residual) variance**. If the model leaves lots of unexplained noise, coefficient estimates bounce around more from sample to sample.
- (X'X) to the power -1 "captures how much information the predictors give us." If predictors are **highly correlated**, X'X is close to singular (nearly non-invertible), its inverse becomes unstable, and the coefficient variances **inflate**. So **multicollinearity makes estimates less precise**.
- More rows in X means X'X gets bigger, its inverse shrinks, and coefficient variance falls, so bigger data sets give more precise regression estimates.
- Practical takeaway: wide CIs for coefficients can come from a small sample *or* from collinearity among predictors.

### Slide: Efficiency (code)

```r
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
```

**Said in the lecture:** efficiency compares estimators. "If two estimates are both hitting the bullseye on average, efficiency tells us which one has a tighter cluster around the bullseye." The mean wins under normality. **Efficiency is not universal:** it depends on the data generating process. "Under normality, the mean is more efficient, but if the population has heavy tails, the median might perform better." If two estimators are unbiased, prefer the more efficient one.

### Slide: Mean Squared Error

No code. **Said in the lecture:** bias is systematic error and variance is random error, but "in practice both matter at the same time," so MSE combines them into one measure of accuracy. An estimator can have low variance but high bias, or low bias but high variance. If bias is zero, MSE reduces to variance. If bias is large, MSE stays large even when variance is small. "The best estimator is the one with the lowest mean squared error overall." MSE judges not just whether you hit the target on average but how widely you scatter around it.

### Slide: MSE plot examples (code)

```r
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
```

**A trap in the code comment.** The comment says "biased upward + higher variance," but the code only adds noise with mean zero, so there is **no bias**, only extra variance. The lecturer says the same out loud: "In this case there is no bias in our estimate, but they're much more scattered, so higher variance." He then summarizes: low MSE means estimates "close to the truth and stable across samples"; high MSE means a scattered (and/or biased) cloud far from the truth.

### Slide: Simulation of MSE (code)

```r
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
```

**Reading the output:** 1.2e-05 is 0.000012, essentially zero, so the sample mean is unbiased; nearly all of the MSE (0.0712) is variance. (Theory predicts sigma-squared / n = 4 / 50 = 0.08; with only 1,000 repeats, the simulation lands in that neighborhood.) **Said in the lecture:** three quantities are computed: squared bias, variance across samples, and MSE as their sum. "Even if the bias is zero, variance contributes to the error." When comparing estimators, ask what the MSE is: "that's the metric that fully captures accuracy."

### Slide: Gauss-Markov theorem and BLUE

No code. **Said in the lecture:** "Best" means minimum variance among all linear unbiased estimators; "linear" means a linear function of the observed outcomes y; "unbiased" means hits the true value on average. On the assumptions: if the true relationship is nonlinear, OLS is not BLUE; "without random sampling, bias and inefficiency creep in"; with perfect collinearity "the matrix X cannot be inverted and OLS breaks down"; zero conditional mean "ensures no omitted variable bias"; homoscedasticity means consistent error variance across observations. **If any assumption fails, "OLS may still work but it loses its optimality."**

### Slide: Consistency (code)

```r
true_mu <- 10; sample_sizes <- seq(10, 3000, by=5)    # >> sample sizes 10, 15, 20, ..., 3000 (599 of them)
estimates <- sapply(sample_sizes, function(n) mean(rnorm(n, mean=true_mu, sd=2)))
# >> for each sample size, draw a brand-new sample of that size and store its mean
plot(sample_sizes, estimates, type="l", col="blue", lwd=2,
     xlab="Sample Size", ylab="Estimate", main="Consistency of the Sample Mean")   # >> line plot of estimate against n
abline(h=true_mu, col="red", lwd=2, lty=2)        # >> dashed red line at the truth, 10
```

There is no `set.seed` here, so your picture will differ slightly each run. **Said in the lecture:** small samples bounce around a lot, then tighten toward the red line. "Consistency is a large-sample property. Even if an estimator is not perfectly unbiased in small samples, it may still be consistent; the bias may shrink toward zero as n grows." Collecting more data "isn't just helpful, it guarantees that eventually our estimates will be correct."

### Slide: Law of Large Numbers (code)

```r
set.seed(123)
true_mu <- 15; max_sample_size <- 3000; sample_sizes <- 1:max_sample_size   # >> counts 1, 2, 3, ..., 3000
sample_means <- cumsum(rnorm(max_sample_size, mean=true_mu, sd=5)) / sample_sizes
# >> rnorm draws ONE sequence of 3,000 values. cumsum() gives the running total after each draw.
# >> dividing by 1, 2, 3, ... gives the running average after each draw
plot(sample_sizes, sample_means, type="l", col="purple", lwd=2,
     xlab="Sample Size", ylab="Sample Mean",
     main="Law of Large Numbers: Convergence of Sample Mean")   # >> running average against n
abline(h=true_mu, col="orange", lwd=2, lty=2)                    # >> dashed orange line at the truth, 15
```

**Difference from the consistency slide:** there, each point was a *fresh* sample; here every point reuses the *same* growing data set (draw 51 = draw 50 plus one more value), so the line is smoother. **Said in the lecture:** the LLN is "the formal justification for consistency of the sample mean"; "without the law of large numbers, inference would not be possible."

### Slides: What is MLE, and why the log-likelihood

No code. **Said in the lecture:**

- The likelihood is "the probability of observing the data given some parameter values." MLE asks "what parameter value makes the data we observe the most probable?"
- **His example:** flip a coin 100 times and get 60 heads. The MLE for the probability of heads is **0.6**, because that value maximizes the likelihood of the observed outcome.
- The product of many probabilities causes two problems: **numerically**, the product becomes tiny and unstable; **mathematically**, differentiating a long product is messy. Taking logs fixes both: logs turn products into sums ("instead of multiplying 100 terms, we just add 100 log terms"), keep numbers manageable (log of 0.00001 versus 0.00001 itself), and are monotonic, so the maximizer does not change.

### Slide: The four steps, and what derivatives mean

No code. **Said in the lecture:** (1) write the log-likelihood; (2) differentiate with respect to the parameters; (3) set the derivatives to zero and solve; (4) use the second derivative test. **Intuition for the derivative:** it asks "if I nudge the parameter slightly up or down, does the likelihood increase or decrease?" Where the derivative is zero, "the slope is flat," a candidate peak or valley. **Second derivative:** negative means concave down, "shaped like an upside-down bowl," so the flat spot is a **maximum**; positive means concave up, shaped like a U, so the flat spot is a **minimum, which we don't want**.

### Slides: Deriving the Normal MLE

No code. **Said in the lecture:**

- Because observations are independent, you take the **product** of the normal densities. The log-likelihood simplifies using three tools: log(ab) = log a + log b; log(e to the z) = z; and the log is monotonic.
- *Differentiating in mu:* treat mu as the only variable. The first term has no mu, so it is a constant and disappears. For the second term, the derivative of (x\_i - mu)^2 is -2(x\_i - mu); the -2 cancels the 1/2 out front, leaving a positive 1. Set to zero and solve: **mu-hat = x-bar** ("I'll let you work through that at home").
- *Differentiating in sigma-squared:* now sigma-squared is the variable and mu is fixed. Two terms contain sigma-squared; differentiate each, add them, set to zero, solve: **sigma-hat-squared = (1/n) times the sum of (x\_i - x-bar)^2**.
- **Why divide by n and not n - 1?** "Because maximum likelihood is about maximizing the likelihood, not about correcting for finite-sample bias." Dividing by n - 1 is the later correction that makes the variance unbiased.
- **Step 4, the second derivative check, was left to you as homework:** "I'm going to let you work through this example at home." That is a likely quiz item, and the full answer is in Part 5 of these notes.

### Slides: MLE for regression, and likelihood ratio tests

No code. **Said in the lecture:**

- In regression the mean is no longer constant: mu\_i = beta\_0 + beta\_1 x\_i. "This setup is just an extension of the normal distribution case." "Everything other than \[the mean\] should look the same: regression is just applying MLE to the conditional mean model."
- Solving gives the familiar answers (beta-1-hat = Cov(x,y)/Var(x); beta-0-hat = y-bar minus beta-1-hat times x-bar). **"Under the assumption of normally distributed errors, OLS and MLE produce the same coefficient estimates. MLE provides a theoretical justification for why OLS is optimal in this case."**
- **LR test:** compare a full model with a reduced model that imposes restrictions (like a coefficient set to zero). The statistic follows a chi-squared distribution with degrees of freedom equal to **the number of restrictions**. For beta\_1 = 0, the reduced model has only beta\_0. "If the improvement \[in log-likelihood\] is large, we reject the null that beta\_1 equals zero."

### Slide: Properties of MLE

No code. **Said in the lecture:** consistency; **asymptotic efficiency** (as n grows, MLE reaches the lowest possible variance among consistent estimators, the Cramer-Rao lower bound); **asymptotic normality**, with the Fisher information in the variance, which "is what allows us to construct confidence intervals and conduct hypothesis testing using MLE." "MLE is consistent, efficient and asymptotically normal. These are the gold-standard properties for an estimator."

### Slide: Simulation of MLE consistency (code)

```r
set.seed(123)
true_theta <- 5; sample_sizes <- seq(10, 1000, by=10)    # >> truth is 5; sample sizes 10, 20, ..., 1000 (100 of them)
mle_estimates <- sapply(sample_sizes, function(n) mean(rnorm(n, mean=true_theta, sd=2)))
# >> for each n, draw a fresh sample from Normal(5, sd 2) and take the mean.
# >> The mean IS the MLE of a normal mean (Part 5), which is why the variable is named mle_estimates
plot(sample_sizes, mle_estimates, type="l", col="darkgreen", lwd=2,
     xlab="Sample Size", ylab="MLE Estimate", main="Consistency of MLE Estimates")   # >> green line
abline(h=true_theta, col="red", lwd=2, lty=2)                                       # >> dashed red line at the truth, 5
```

**Said in the lecture:** "At small sample sizes the estimates bounce around. As the sample size increases, the estimate stabilizes and converges towards the true value of five." Even though individual small-sample estimates are noisy, "the MLE will zero in on the true parameter."

### What the first video does *not* cover

The transcript ends right after the MLE consistency simulation (about 43 minutes in). The slides' final two pages ("OLS Is Maximum Likelihood (Normal Errors)" and "The Punchline"), the bootstrap, and Bayesian estimation are **not narrated** in any of the three videos. I explained them from the slides and practice quiz in Parts 7 and 9.

## Part 15: Video 2 ("lecture 11 02"): Regression diagnostics, heteroskedasticity, influence and leverage

**Important:** this video is on a different topic from the week\_11 slides in your folder. The slides and code for it were not in the folder, so these notes come **only from the transcript**. Where I show a formula or R command that the lecturer did not read aloud, I label it "extension." If you can upload this lecture's slides, I will check the formulas and thresholds against them.

### The goal of the lecture

Evaluate whether a regression model fits the data and meets OLS's assumptions. Three linked problems: **heteroskedasticity** (unequal error variance), **non-normality** (matters mainly in small samples), and **leverage / influence** (a few observations dominating the fitted line). Then fixes: **robust standard errors** and **weighted least squares**. "The goal isn't just to memorize tests. It's to build an intuition for when your model looks trustworthy and when it doesn't."

### The OLS assumptions (and what each protects)

| Assumption | Plain meaning | If violated |
| --- | --- | --- |
| Linearity | The relationship between y and x is correctly specified | A straight line "systematically misestimates" a curved relationship |
| Independence | Errors are independent (uncorrelated) across observations | You are "reusing information" |
| Homoskedasticity | Error variance is constant across all values of x | Standard errors are wrong; **this is the main focus of the lecture** |
| Normality of errors | Errors are normally distributed | Matters mostly for small-sample t and F tests |
| No perfect multicollinearity | No predictor is an exact combination of others | OLS cannot be computed |
| Zero conditional mean | E(error given X) = 0 (the transcript garbles this one) | Bias, such as omitted variable bias |

When the assumptions hold, OLS gives **unbiased, consistent, efficient (BLUE)** estimates. When they fail, "the coefficients might still be biased, but the standard errors, and therefore our inference, could go badly wrong." Notice the key distinction that appears all lecture: **heteroskedasticity does not bias the coefficients, but it makes the standard errors, t values and p values unreliable.**

### The simulation he builds (the code, explained)

The code is run on two simulated data sets of **180 observations** each, so you can see "good versus bad" side by side.

- **Good data:** x drawn from a standard normal; y = **2 + 3x** plus a constant-variance error. Well behaved: homoskedastic, roughly normal, no leverage points.
- **Bad data:** x again standard normal, but the **error's standard deviation grows as x grows** (heteroskedastic), and **three extra high-leverage points** are added by hand far from the rest of the data.
- He fits `lm` to each (a "good model" and a "bad model"). The scatterplot of the good data shows a clean line with constant spread; the bad data **fans out** as x rises, and a few points sit far to the right.

### Diagnostic plot 1: residuals versus fitted values

- **What to look for:** if variance is constant, residuals look like random noise around zero, "a horizontal band," and the smooth (loess) line is nearly flat at zero.
- **Good model:** flat blue line, even spread. **Bad model:** a **funnel** shape: residuals fan out as fitted values increase. "That's classic heteroskedasticity."
- **Consequence:** "If you see this in your own model, it's a strong hint that your standard errors aren't reliable, even if the coefficients themselves seem fine."

### Diagnostic plot 2: scale-location (spread-location)

It plots the **square root of the absolute standardized residuals** against fitted values. Taking the square root "helps stabilize the variance, making the patterns easier to see." Good model: flat red line, no trend. Bad model: a clear **upward** curve, meaning the spread of residuals increases with the fitted values. Residuals-vs-fitted and scale-location together are "the frontline defense when evaluating model assumptions."

### Formal tests for heteroskedasticity

Null hypothesis for both tests: **constant variance (homoskedasticity)**.

- **Breusch-Pagan (BP) test:** checks whether the variance of the residuals is related to one or more regressors.
- **White test:** a more general version that also includes **squared fitted values**, so it picks up *nonlinear* forms of heteroskedasticity.
- Packages used (per the transcript): `lmtest` (for the BP test) and `sandwich` (for robust standard errors).
- **Reading the results:** the good model's p value is above any conventional threshold, so you do **not** reject constant variance (model looks fine). The bad model's p value is far below any threshold, so you **reject** homoskedasticity. As he says, "the good model is going to pass our test and the bad model is going to be rejected."

Typical R syntax for reference (extension, not read aloud): `bptest(model)` for BP; the White test is `bptest(model, ~ fitted(model) + I(fitted(model)^2))`.

### Fix 1: robust standard errors (the default in applied work)

- Also called **heteroskedasticity-consistent (HC) standard errors**; he uses the **HC1** version via the `sandwich` package.
- **Logic:** OLS coefficients remain **unbiased** under heteroskedasticity, but the **variance estimates are wrong**, so you adjust the variance-covariance matrix with a robust estimator.
- **What changes:** "the coefficients themselves barely change, but the standard errors, and therefore the t values and p values, are corrected."
- Typical syntax (extension): `coeftest(model, vcov = vcovHC(model, type = "HC1"))`.

### Fix 2: weighted least squares (WLS)

Use when you **know the source** of the unequal variance and can model it (weight each observation inversely to its error variance). "Often that's not the case in social data," so "the convention is to just do standard error corrections," meaning robust SEs.

### Normality of residuals

- In **large samples** the assumption is less critical because the **central limit theorem** makes the estimates asymptotically normal.
- In **small samples (under about 50)** it matters for the validity of **t and F tests**.
- **QQ plot:** compares sample residuals to what a normal distribution would give. In a good model the points hug the **45-degree line**. In a bad model you often see an **S shape** or the **tails peeling away**, evidence of **heavy-tailed residuals or outliers**.
- **Heteroskedasticity** distorts the *variance* of residuals; **non-normality** distorts their *shape*. "Both are going to distort inference in different ways."

### Influence diagnostics: leverage, studentized residuals, Cook's distance

```math
\text{(extension) simple regression: } h_{ii} = \frac{1}{n} + \frac{(x_i-\bar{x})^2}{\sum_j (x_j-\bar{x})^2}, \qquad \text{rule of thumb: high leverage if } h_{ii} > \frac{2p}{n}
```

| Concept | What it measures | Rule of thumb he gives |
| --- | --- | --- |
| **Leverage** | How far an observation's x value is from the mean of x. A high-leverage point has an *unusual predictor value* and can "pull the regression line toward itself" | Above **2p / n**, where p = number of parameters including the intercept |
| **Studentized residual** | The raw residual divided by its estimated standard deviation, so residuals are comparable across observations | Absolute value above **2 or 3** |
| **Cook's distance** | Combines leverage *and* residual size: how much the fitted model would change if that point were deleted | A threshold is shown on the slide (not captured in the transcript); common rules are 4/n or 1 (extension) |

**Worked check (my example):** with n = 180 observations and p = 2 parameters (intercept and slope), the leverage cutoff is 2p/n = 4/180 = **0.022**. The average leverage is p/n = 0.011, so the cutoff is twice the average.

**Key sentence:** "Not all outliers are influential and not all influential points are outliers. It matters both on their position on X and their residual on Y." The cutoffs "aren't strict" but "help us dig deeper."

### The three influence plots

1. **Leverage plot (leverage against observation index, with a dashed 2p/n line):** in the good model almost all points sit below the line. In the bad model, several cross it: these are the three artificially added points. (He warns that the left and right panels have **different scales**, which can look misleading.)
2. **Cook's distance plot:** good model, all tiny; bad model, "a few cases spike dramatically above the dashed threshold." Removing them "would substantially change your regression coefficients."
3. **Bubble plot:** x-axis leverage, y-axis studentized residuals, **bubble size = Cook's distance**. Large bubbles are points that are extreme in x *and* y, hence highly influential. Again the panels use different bubble scales, so don't compare sizes across panels.

**What to do with influential points:** "you don't automatically delete them. You just want to investigate. Are they data errors? Are they real phenomena?" Practical test: **refit the model without them and compare**, or use bootstrap estimation; if coefficients or significance change substantially, a handful of points is driving your model. Political science example: "a single country-year with extreme economic growth or conflict intensity is distorting your results," which is "something you definitely want to know before publishing."

### Built-in diagnostics in R

Wrapping a fitted linear model in `plot()` (for example `plot(model)`) produces a series of the standard diagnostic plots automatically: residuals vs fitted, QQ, scale-location, and residuals vs leverage.

### The lecturer's diagnostic workflow (his summary slide)

1. Fit the model and plot **y versus x** to check linearity.
2. **Residuals vs fitted** and **scale-location** plots for heteroskedasticity.
3. **QQ plot** for normality (especially important in small samples).
4. **Leverage and Cook's distance** plots to flag influential cases.
5. **Confirm with tests:** BP or White.
6. **Remedy:** usually **robust standard errors** ("the norm"); WLS if the variance is predictable; **revisit specification** (transformations, add missing terms) if patterns persist; **investigate influential points** (data-quality problem or real case?).

### Quick self-test for this lecture

1. Does heteroskedasticity bias the OLS coefficients? *(No: it makes the standard errors unreliable.)*
2. A residuals-vs-fitted plot shows a funnel. Name the problem and the standard fix. *(Heteroskedasticity; robust / HC standard errors.)*
3. What is the difference between the BP and White tests? *(BP: variance related to regressors. White: more general, adds squared fitted values to catch nonlinear forms.)*
4. Define leverage and give the cutoff he uses. *(How far x\_i is from the mean of x; above 2p/n.)*
5. Can a point be an outlier but not influential? *(Yes: if its x is near the mean, it has low leverage, so it barely moves the line.)*

## Part 16: Video 3 ("lecture 11 03"): Multiple regression, confounding and partial effects

As with Part 15, the slides and code for this video were not in your folder, so these notes come **only from the transcript** and are labeled where I add anything ("extension"). Several numbers in the captions are garbled; I flag those.

### The goal

Move from **bivariate regression** (one predictor, one outcome) to **multiple regression** (several predictors at once), and understand what happens when you condition on other variables, "especially confounders." Two ideas drive everything: (1) conditioning on confounders gets you closer to a causal estimate, and failing to do so biases results; (2) multiple regression is "not just adding more variables. It's actually **partialing out** the overlapping variance between predictors."

### The model and how to read a coefficient

```math
y = \beta_0 + \beta_1 x_1 + \beta_2 x_2 + \cdots + \beta_p x_p + \epsilon
```

**Beta\_j is the effect of x\_j on y holding all other x's constant.** "That phrase, holding other variables constant, is crucial. It's what allows us to talk about conditional relationships rather than simple correlations."

### Confounders and omitted variable bias

A **confounder** Z is a variable that affects **both** your predictor X and your outcome Y. If you leave it out, its effect "gets absorbed in our error term, making our beta-hat coefficient biased." The bias in the slope of x1 when you omit x2 depends on **two things**: (a) whether x1 and x2 are **correlated**, and (b) whether x2 itself **affects y**. If both are true, the bivariate estimate is systematically wrong, "often overstating or understating the real effect." Conditioning on confounders "isn't just about adding variables. It's about removing spurious associations that distort your inference."

The formula (extension; the lecturer wrote it on the slide, the transcript only describes it):

```math
\tilde{\beta}_1 = \hat{\beta}_1 + \hat{\beta}_2\,\tilde{\delta}_1 , \qquad \tilde{\delta}_1 = \frac{\mathrm{Cov}(x_1,x_2)}{\mathrm{Var}(x_1)}
```

Beta-tilde-1 is the slope when x2 is omitted; beta-hat-1 and beta-hat-2 are from the full model; delta-tilde-1 is the slope from regressing x2 on x1. **This is exactly the Week 11 bias simulation:** there beta\_2 = 1 (z's effect) and the slope of z on x was 0.8, so the omitted-variable estimate was about 2 + 1 × 0.8 = 2.8, and the simulation returned 2.755.

### Two equivalent ways to see what multiple regression does

**1. Residual-on-residual (also called partialing out, or Frisch-Waugh-Lovell).** To get the coefficient on x1: (a) regress x1 on all the other x's and keep the residuals, which are the part of x1 that is **uncorrelated** with the others; (b) regress y on those same other x's and keep the residuals; (c) regress the y-residuals on the x1-residuals. **The slope equals the multiple-regression coefficient exactly.** You "strip away the shared variance among predictors, leaving only the unique variance that belongs to x1."

**2. Geometry.** OLS **projects y onto the space spanned by all your predictors**. Each coefficient measures how much of y's variation lies along that predictor's *unique, orthogonal direction*.

### The simulation (the code, explained)

- Uses the **MASS** package to draw **three predictors from a multivariate normal** distribution: **400 samples**, all means zero, with a covariance matrix **sigma** that sets how correlated the three predictors are (the heat map later shows correlations of **0.3 to 0.5**).
- The outcome is built from an intercept, a coefficient vector, and an error term. The **true effects are 1, 0.8 and 0.5** (the caption garbles the first mention, but the lecturer repeats these three numbers a few minutes later).
- The data are bound into one data frame.

**Results he reports:**

| Model | x1 slope | x2 slope | x3 slope | Comment |
| --- | --- | --- | --- | --- |
| True values | 1 | 0.8 | 0.5 | what was simulated |
| Three separate bivariate regressions | **1.6** | **1.36** | **1.11** | all **too high**: "each predictor is also picking up some of the effect of the others" |
| One joint model with all three | about **1.1** | (garbled in the caption) | (garbled in the caption) | back near the true values |

**Why:** because the predictors are correlated, each bivariate slope "is partially absorbing the influence" of the other two. "Multiple regression is going to remove omitted variable bias by explicitly controlling for correlated predictors." The omitted-variable demonstration in the video shows the same thing in one line: the x1-only slope is about **1.61**, while the true effect in the joint model is about **1.1**.

### The plots, in order

1. **Three bivariate scatter plots** (y against each x): all strongly positive, but these are **marginal** relationships "inflated by shared variance with the others." Real-world analogy: the effect of **education on income** looks strong in a bivariate regression partly because education correlates with experience and age.
2. **Partial-relationship plots (residual-on-residual, a.k.a. added-variable plots):** for each x\_j, plot the residuals of y (after removing the other predictors) against the residuals of x\_j (after removing the other predictors). The **slope of each line equals that variable's coefficient** in the multiple regression. They are "one of the best ways to build intuition for what holding constant actually means."
3. **Fitted vs observed y with a 45-degree line:** points clustering tightly around the red diagonal means a good fit; the joint model gives both more accurate slopes and better prediction.
4. **Marginal vs partial slope plot:** the **blue** line is the bivariate (marginal) slope of y on x1; the **red** line is the partial slope of x1 holding x2 and x3 at their means. The **red line is shallower**: once you control for the others, x1's effect shrinks. "If you take away one visualization for the lecture, let it be this."
5. **Correlation heat map:** x1, x2, x3 are positively correlated (0.3 to 0.5), which is realistic. This shared variance "doesn't bias our coefficients, but it does increase uncertainty." Correlations around **0.9** would raise multicollinearity worries (unstable coefficients, flipping signs).
6. **3D regression plot:** with two predictors the fitted model is a **plane**; with more, a **hyperplane**. Each axis's tilt is a **partial slope**. "A higher-dimensional generalization of a regression line."

### Collinearity and VIF

- **Collinearity does not bias your coefficients, but it inflates their standard errors**, so you lose precision and power. It can also change the magnitude or even the **sign** of coefficients.
- The **variance inflation factor (VIF)** tells you how much each predictor's variance is inflated because of its correlation with the other predictors. In the simulation the VIFs are about **1.3 to 1.4**, "really excellent." **Rule of thumb: above 5 is a warning, above 10 signals strong collinearity.**

```math
\mathrm{VIF}_j = \frac{1}{1-R_j^2}
```

(Extension: R\_j-squared is the R-squared from regressing x\_j on the other predictors. A VIF of 1.35 means the variance is only 35% larger than with uncorrelated predictors; a VIF of 10 means R\_j-squared = 0.9.)

- With collinearity, "this doesn't necessarily mean our model is wrong. It means that our coefficients now reflect the conditional effects of x1 after controlling for x2." Interpretation "depends on theory and research design."

### The causal-reasoning example: campaign spending and vote share

Outcome: **vote share**. Main variable X1: **campaign spending**. Confounder Z: **district competitiveness**. Competitive districts both **attract more spending** and **have closer outcomes**, so ignoring competitiveness makes spending look strongly tied to winning partly because competitive districts drive the effect. By conditioning on Z, "we compare districts of equal competitiveness but with different spending levels. So that's the **comparison among equals** idea that makes regression a tool for causal inference." (This is the same setting as Question 3 of your Week 10 quiz.)

### R-squared decomposition and the nested F test

- **R-squared decomposes incrementally:** total R-squared is the sum of the variance each variable adds in order, **conditional on those already in the model**. "Multiple regression doesn't tell us the total R-squared. It tells us how much each variable contributes once the others are accounted for." This is the idea of **partial R-squared**.
- **Nested model comparison (ANOVA / F test):** compare model M1 (x1 only) with the joint model (x1, x2, x3). The F test asks "does adding x2 and x3 significantly improve the fit beyond x1 alone?" Result: **F about 152 with a p value below 0.01** (the lecturer says "anatomically small"; the caption garbled "astronomically"). So the extra predictors add substantial, significant explanatory power.

```math
F = \frac{(RSS_{reduced} - RSS_{full})/q}{RSS_{full}/(n-k-1)}
```

(Extension: q = number of added predictors; k + 1 = parameters in the full model; RSS = residual sum of squares. The F test and the likelihood ratio test from Week 11 answer the same "does the bigger model fit better?" question.)

### The summary table he ends with

|  | Bivariate regression | Multiple regression |
| --- | --- | --- |
| Coefficient | Marginal slope | Partial (conditional) slope |
| Omitted variable risk | **High**; an experiment (a lab or natural experiment) can get around it | Reduced by conditioning |
| Picture | A line | A plane or hyperplane |
| Variance explained | R-squared | Partial R-squared, nested F tests |
| Interpretation | Association with x | Effect of x **holding the others fixed** |

"Bivariate regression is going to tell you **total associations**; multiple regression is going to tell you **conditional effects**: how one variable matters while the others are controlled." The choice of controls "should be driven by theory: what other variables, or Z's, are confounders for your outcome?" This is "the foundation for causal inference," which "becomes much more sophisticated and harder to prove" in later lectures.

### Quick self-test for this lecture

1. Two conditions make an omitted variable cause bias. Name them. *(It is correlated with the included predictor, and it affects y.)*
2. Why were all three bivariate slopes (1.6, 1.36, 1.11) larger than the true effects (1, 0.8, 0.5)? *(Positively correlated predictors each absorb part of the others' effects.)*
3. Does collinearity bias coefficients? *(No; it inflates standard errors.) What VIF is a warning sign? (Above 5; above 10 is strong.)*
4. Describe the residual-on-residual method in three steps.
5. What question does the nested F test answer? *(Whether added predictors significantly improve fit over the smaller model.)*

## Part 17: Word-problem decoder: key words, what they mean, what to write

Use this during the quiz. Scan the problem for the words in the left column, then jump to the concept and the line to write. Wording is taken from Practice Quiz 11 and the lecture notes above. Part A is about the **command word** (what the problem wants you to do), Part B is about the **story words** (what kind of data or estimator it is), and Part C is a fast decision path.

### Part A. Command words: what you are being asked to do

| If the problem says... | It wants... | Write this |
| --- | --- | --- |
| "Correct this statement", "your classmate says" | Spot the misconception and give the right definition | Likelihood L(θ) is a function of θ with the data held fixed; it is not the probability θ is true and need not integrate to 1 over θ. Same family of errors: "p-value = probability H0 is true" and "95% probability μ is in this interval" are both wrong |
| "Distinguish", "define", "what is the difference between" | Plain definitions, side by side | Parameter: fixed unknown number. Estimator: a rule applied to a random sample (random). Estimate: the number the rule gives on one sample. Bias(θ̂) = E[θ̂] − θ; unbiased means bias = 0 |
| "Derive the MLE", "differentiate, set the score to zero, solve" | The five-step recipe, one step per line | L(θ) as a product → ℓ(θ) = log L → ℓ′(θ) → set ℓ′ = 0 and solve → ℓ″(θ) < 0. The "score" is the first derivative of the log-likelihood |
| "Confirm it is a maximum", "second-order condition" | The second derivative check | Poisson: ℓ″ = −Σx/λ². Exponential: ℓ″ = −n/λ². Normal mean (σ² known): ℓ″ = −n/σ². Negative means a hill, so a maximum. Why it is needed: setting ℓ′ = 0 finds any flat point (maximum, minimum or inflection) |
| "Construct the 95% (or 99%) confidence interval" | x̄ ± critical value × standard error | Compute SE = σ/√n first. z = 1.645 (90%), 1.96 (95%), 2.576 (99%) |
| "Using the interval, test H0: μ = [value] at the 5% level" | The CI–test link | Value outside the 95% interval means reject H0; inside means do not reject. Cross-check: z = (x̄ − μ0)/SE and compare the absolute value of z with 1.96 |
| "Compare the widths", "trade-off" | Confidence vs precision | Higher confidence means a wider, less precise interval. Only a larger n narrows it without losing confidence (halving the width takes 4 times the n) |
| "Contrast ML and Bayesian" | Two-sentence comparison | Bayesian needs a prior and reports a whole posterior distribution; ML needs only the likelihood and reports one point estimate. As n grows the prior washes out and the two converge |
| "Describe the bootstrap" | Five steps | Resample the n rows (x, y pairs) with replacement → refit and save the slope → repeat B times (about 1,000) → SD of the slopes is the standard error → 2.5th and 97.5th percentiles give the 95% interval. Attractive: no SE formula, no normal-errors assumption |
| "Which property", "which is preferred" | Name the property from Part B, then justify in one line | See the table below |

### Part B. Story words: what kind of problem is this?

**Which distribution or model (MLE problems)**

| Key words in the problem | Recognize it as | Estimator and check |
| --- | --- | --- |
| "lifetime", "duration", "how long until", "waiting time", "survival", "time until the cabinet collapses or the war ends" | **Exponential**(λ), continuous, at least 0, mean 1/λ | λ̂ = n/Σx = 1/x̄ (invert x̄). ℓ = n log λ − λΣx. ℓ″ = −n/λ² |
| "number of", "counts", "events per month / decade / year", "coups", "protests" | **Poisson**(λ), discrete counts, mean = variance = λ | λ̂ = x̄ (keep x̄). ℓ = −nλ + Σx log λ − Σlog x!. ℓ″ = −Σx/λ² |
| "normal", "N(μ, σ²)", "mean with known variance" | **Normal** | μ̂ = x̄. If σ² is also unknown: σ̂² = (1/n)Σ(x − x̄)², which divides by n and is biased low |
| "coin", "heads out of n", "proportion" | Proportion MLE | p̂ = successes/n (the likelihood p^k (1−p)^(n−k) peaks at the sample proportion) |
| "regression", "normal errors", "least squares", "residuals" | **OLS = MLE** when errors are normal | Maximizing ℓ is the same as minimizing Σ(y − β0 − β1x)². σ̂²_MLE = (1/n)Σe² (biased); unbiased version divides by n − 2 |
| "numerical", "no closed form", "optim", "Beta" | Numerical MLE | Computer climbs the hill; hand `optim` the **negative** log-likelihood |
| "log-likelihood", "why take logs" | Log trick | Product becomes a sum, easier to differentiate, same peak (log is monotonic), avoids underflow |

**Which estimator property (definition problems)**

| Key words in the problem | Recognize it as | One-line answer |
| --- | --- | --- |
| "on average equals the true value", "E[θ̂] = θ", "centered on the truth" | **Unbiased** | Bias = E[θ̂] − θ = 0 |
| "systematically too high or too low", "left out a variable", "omitted", "confounder" | **Bias, usually omitted variable bias** | Needs both: the omitted variable is correlated with x and it affects y. β̃1 = β̂1 + β̂2·δ̃1. More data does not fix it |
| "spread across samples", "sampling distribution", "repeated samples", "how much it bounces" | **Variance** | Var(x̄) = σ²/n. Precision = 1/Var |
| "both unbiased", "smaller sampling variance", "which is preferred", "mean vs median" | **Efficiency** | Prefer the smaller variance (mean for normal data). Prefer the median with outliers or heavy tails |
| "overall accuracy", "bias and variance together", "squared error" | **MSE** | MSE = Var + Bias². A slightly biased estimator can win on MSE |
| "as n → ∞", "in large samples", "converges to the true value", "biased in small samples but" | **Consistency** | Biased can still be consistent. Standard example: the variance MLE dividing by n, with E = ((n−1)/n)σ² |
| "sample mean converges", "running average", "law of large numbers" | **LLN** | x̄ₙ → μ in probability because Var(x̄) = σ²/n shrinks to 0 |
| "best linear unbiased", "BLUE", "Gauss-Markov" | **Five assumptions** | Linear, Random sampling, No perfect collinearity, Zero conditional mean (this one gives unbiasedness), Homoscedastic. Normality is not required |
| "reaches the lowest possible variance in large samples", "Cramér-Rao" | **MLE asymptotic efficiency** | One of three MLE properties: consistent, asymptotically efficient, asymptotically normal (Fisher information) |
| "approximate standard error of the MLE", "Fisher information" | **SE = √(1/(n·I(θ)))** | Poisson: √(λ̂/n). Exponential: λ̂/√n. Normal mean: σ/√n |

**Which interval or test (inference problems)**

| Key words in the problem | Recognize it as | Use |
| --- | --- | --- |
| "population standard deviation is known", "σ = ..." given | **z interval** | x̄ ± z·σ/√n |
| "sample standard deviation s", "σ unknown", small n | **t interval**, df = n − 1 | x̄ ± t·s/√n (a little wider than z) |
| "95% confident", "interpret the interval" | Correct reading | Across repeated samples, about 95% of intervals built this way contain the true value. Not "95% probability μ is in this one" |
| "compare a full and a restricted model", "nested", "drop a parameter", "chi-squared" | **Likelihood ratio test** | LR = 2[ℓ(full) − ℓ(reduced)] ~ χ²(df), df = number of parameters removed. 5% critical value for χ²(1) is 3.841. Big LR means reject the reduced model |
| "resample", "with replacement", "no formula for the standard error" | **Bootstrap** | See Part A |
| "prior", "posterior", "update beliefs" | **Bayesian** | posterior ∝ likelihood × prior |

**If the quiz reaches into the regression lectures (Parts 15 and 16)**

| Key words in the problem | Recognize it as | One-line answer |
| --- | --- | --- |
| "non-constant variance", "funnel or fan shape in residuals vs fitted", "spread grows with x" | **Heteroskedasticity** | Coefficients stay unbiased but SEs, t and p are wrong. Test: Breusch-Pagan or White (H0 is constant variance). Fix: robust (HC1) standard errors; WLS only if you know the source |
| "outlier in x", "unusual predictor value", "pulls the line" | **Leverage** | High if h > 2p/n, p = number of parameters including the intercept |
| "outlier in y", "large residual" | **Studentized residual** | Be concerned above about 2 or 3 in absolute value |
| "how much would the fit change if this point were deleted" | **Cook's distance** | Combines leverage and residual size. Not every outlier is influential |
| "predictors are highly correlated", "inflated standard errors", "VIF" | **Collinearity** | Does not bias coefficients, inflates SEs. VIF above 5 is a warning, above 10 is strong |
| "holding other variables constant", "controlling for", "partial effect" | **Multiple regression** | Coefficient is the effect of xⱼ with the others fixed |
| "does adding x2 and x3 improve the fit" | **Nested F test** | Same question as the LR test, using sums of squared residuals |

### Part C. Fast decision path

1. **Given raw data values (a list, or n and a sum) and asked for an MLE?** Look at what the numbers measure. Times or lifetimes: Exponential, so λ̂ = 1/x̄. Counts: Poisson, so λ̂ = x̄.
2. **Given n, x̄ and a known σ?** It is a z interval. Compute SE = σ/√n first, then x̄ ± z·SE.
3. **Asked to test a specific value?** Check whether the value is inside the interval you just built.
4. **Asked to "derive"?** Five lines: L, ℓ, ℓ′ = 0, solve, ℓ″ < 0. Put each on its own line for partial credit.
5. **Asked "which property" or "why"?** Match the story words in Part B, name the property, then give the one-line meaning.
6. **Last check before moving on:** units and direction (invert x̄ for Exponential only; divide by n for the variance MLE; wider interval for higher confidence).
