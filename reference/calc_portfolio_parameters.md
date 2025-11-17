# Calculate Portfolio Parameters

Calculate Portfolio Parameters

## Usage

``` r
calc_portfolio_parameters(portfolio)
```

## Arguments

- portfolio:

  A `tibble` of class `Portfolio`. Usually created using
  `create_portfolio_template` and customised.

## Value

A list with the following elements:

- `value`: The value of the portfolio.

- `weights`: The weights of assets in the portfolio.

- `expected_return`: The expected return of the portfolio.

- `standard_deviation`: The standard deviation of the portfolio.

## Examples

``` r
 portfolio <- create_portfolio_template()
 portfolio$accounts$taxable <- c(10000, 30000)
 calc_portfolio_parameters(portfolio)
#> $value
#> [1] 40000
#> 
#> $weights
#>   GlobalStocksIndexFund InflationProtectedBonds 
#>                    0.25                    0.75 
#> 
#> $expected_return
#> [1] 0.026525
#> 
#> $standard_deviation
#> [1] 0.0375
#> 
```
