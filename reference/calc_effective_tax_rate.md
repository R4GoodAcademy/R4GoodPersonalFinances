# Calculate Effective Tax Rate

Calculate Effective Tax Rate

## Usage

``` r
calc_effective_tax_rate(portfolio, tax_rate_ltcg, tax_rate_ordinary_income)
```

## Arguments

- portfolio:

  A nested `tibble` of class `Portfolio`.

- tax_rate_ltcg:

  A numeric. Tax rate for long-term capital gains.

- tax_rate_ordinary_income:

  A numeric. Tax rate for ordinary income.

## Value

A `portfolio` object augmented with nested columns with effective tax
rates calculations.

## Examples

``` r
 portfolio <- create_portfolio_template()
 portfolio$accounts$taxable <- c(10000, 30000)
 portfolio <- 
   calc_effective_tax_rate(
     portfolio,
     tax_rate_ltcg = 0.20, 
     tax_rate_ordinary_income = 0.40
   )
 portfolio$aftertax$effective_tax_rate 
#> [1] 0.2011292 0.2335788
```
