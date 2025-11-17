# Calculating retirement ruin probability

Calculating retirement ruin probability

## Usage

``` r
calc_retirement_ruin(
  portfolio_return_mean,
  portfolio_return_sd,
  age,
  gompertz_mode,
  gompertz_dispersion,
  portfolio_value,
  monthly_spendings,
  yearly_spendings = 12 * monthly_spendings,
  spending_rate = yearly_spendings/portfolio_value
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

- yearly_spendings:

  A numeric. Yearly spendings.

- spending_rate:

  A numeric. Spending rate (initial withdrawal rate).

## Value

A numeric. The probability of retirement ruin (between 0 and 1),
representing the likelihood of running out of money during retirement.

## References

Milevsky, M.A. (2020). Retirement Income Recipes in R: From Ruin
Probabilities to Intelligent Drawdowns. Use R! Series.
[doi:10.1007/978-3-030-51434-1](https://doi.org/10.1007/978-3-030-51434-1)
.

## Examples

``` r
calc_retirement_ruin(
  age                   = 65,
  gompertz_mode         = 88,
  gompertz_dispersion   = 10,
  portfolio_value       = 1000000,
  monthly_spendings     = 3000,  
  portfolio_return_mean = 0.02,
  portfolio_return_sd   = 0.15
)
#> [1] 0.1326
```
