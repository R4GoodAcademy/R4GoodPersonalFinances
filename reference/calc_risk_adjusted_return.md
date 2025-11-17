# Calculate risk adjusted return

Calculates the risk adjusted return for portfolio of given allocation to
the risky asset.

## Usage

``` r
calc_risk_adjusted_return(
  safe_asset_return,
  risky_asset_return_mean,
  risky_asset_allocation,
  risky_asset_return_sd = NULL,
  risk_aversion = NULL
)
```

## Arguments

- safe_asset_return:

  A numeric. The expected yearly return of the safe asset.

- risky_asset_return_mean:

  A numeric. The expected (average) yearly return of the risky asset.

- risky_asset_allocation:

  A numeric. The allocation to the risky asset. Could be a vector. If it
  is the optimal allocation then parameters `risky_asset_return_sd` and
  `risk_aversion` can be omitted.

- risky_asset_return_sd:

  A numeric. The standard deviation of the yearly returns of the risky
  asset.

- risk_aversion:

  A numeric. The risk aversion coefficient.

## Value

A numeric. The risk adjusted return.

## See also

- [How to Determine Our Optimal Asset
  Allocation?](https://www.r4good.academy/en/blog/optimal-asset-allocation/index.en.html#how-much-risk-is-enough)

- Haghani V., White J. (2023) "The Missing Billionaires: A Guide to
  Better Financial Decisions." ISBN:978-1-119-74791-8.

## Examples

``` r
calc_risk_adjusted_return(
  safe_asset_return = 0.02,
  risky_asset_return_mean = 0.04,
  risky_asset_return_sd = 0.15,
  risky_asset_allocation = 0.5,
  risk_aversion = 2
)
#> [1] 0.024375

calc_risk_adjusted_return(
  safe_asset_return = 0.02,
  risky_asset_return_mean = 0.04,
  risky_asset_allocation = c(0.25, 0.5, 0.75),
  risky_asset_return_sd = 0.15,
  risk_aversion = 2
)
#> [1] 0.02359375 0.02437500 0.02234375
```
