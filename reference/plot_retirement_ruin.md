# Plotting retirement ruin

Plotting retirement ruin

## Usage

``` r
plot_retirement_ruin(
  portfolio_return_mean,
  portfolio_return_sd,
  age,
  gompertz_mode,
  gompertz_dispersion,
  portfolio_value,
  monthly_spendings = NULL
)
```

## Arguments

- portfolio_return_mean:

  A numeric. Mean of portfolio returns.

- portfolio_return_sd:

  A numeric. Standard deviation of portfolio returns.

- age:

  A numeric. Current age.

- gompertz_mode:

  A numeric. Gompertz mode.

- gompertz_dispersion:

  A numeric. Gompertz dispersion.

- portfolio_value:

  A numeric. Initial portfolio value.

- monthly_spendings:

  A numeric. Monthly spendings.

## Value

A
[`ggplot2::ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html)
object showing the probability of retirement ruin for different monthly
spending levels. If a specific 'monthly_spendings' value is provided, it
will be highlighted on the plot with annotations.

## Examples

``` r
plot_retirement_ruin(
  portfolio_return_mean = 0.034,
  portfolio_return_sd   = 0.15,
  age                   = 65,
  gompertz_mode         = 88,
  gompertz_dispersion   = 10,
  portfolio_value       = 1000000,
  monthly_spendings     = 3000
)
```
