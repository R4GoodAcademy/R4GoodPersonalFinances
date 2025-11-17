# Plotting risk adjusted returns

Plots the risk adjusted returns for portfolios of various allocations to
the risky asset.

## Usage

``` r
plot_risk_adjusted_returns(
  safe_asset_return,
  risky_asset_return_mean,
  risky_asset_return_sd,
  risk_aversion = 2,
  current_risky_asset_allocation = NULL
)
```

## Arguments

- safe_asset_return:

  A numeric. The expected yearly return of the safe asset.

- risky_asset_return_mean:

  A numeric. The expected (average) yearly return of the risky asset.

- risky_asset_return_sd:

  A numeric. The standard deviation of the yearly returns of the risky
  asset.

- risk_aversion:

  A numeric. The risk aversion coefficient.

- current_risky_asset_allocation:

  A numeric. The current allocation to the risky asset. For comparison
  with the optimal allocation.

## Value

A
[`ggplot2::ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html)
object.

## See also

- [How to Determine Our Optimal Asset
  Allocation?](https://www.r4good.academy/en/blog/optimal-asset-allocation/index.en.html#how-much-risk-is-enough)

- Haghani V., White J. (2023) "The Missing Billionaires: A Guide to
  Better Financial Decisions." ISBN:978-1-119-74791-8.

## Examples

``` r
plot_risk_adjusted_returns(
  safe_asset_return              = 0.02,
  risky_asset_return_mean        = 0.04,
  risky_asset_return_sd          = 0.15,
  risk_aversion                  = 2,
  current_risky_asset_allocation = 0.8
)
```
