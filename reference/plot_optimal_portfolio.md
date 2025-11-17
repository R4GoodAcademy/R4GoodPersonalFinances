# Plot optimal portfolio allocations

The function plots current versus optimal portfolio allocations for each
asset class and for taxable and tax-advantaged accounts.

## Usage

``` r
plot_optimal_portfolio(portfolio)
```

## Arguments

- portfolio:

  A nested `tibble` of class `Portfolio`.

## Value

A
[`ggplot2::ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html)
object.

## Examples

``` r
if (FALSE) { # interactive()
older_member <- HouseholdMember$new(
  name       = "older",  
  birth_date = "1980-02-15",
  mode       = 80,
  dispersion = 10
)  
household <- Household$new()
household$add_member(older_member)  

household$expected_income <- list(
  "income" = c(
    "members$older$age <= 65 ~ 7000 * 12"
  )
)
household$expected_spending <- list(
  "spending" = c(
    "TRUE ~ 5000 * 12"
  )
)

portfolio <- create_portfolio_template() 
portfolio$accounts$taxable <- c(10000, 30000)
portfolio$accounts$taxadvantaged <- c(0, 20000)
portfolio <- 
  portfolio |> 
  calc_effective_tax_rate(
    tax_rate_ltcg = 0.20, 
    tax_rate_ordinary_income = 0.40
  )

portfolio <- 
  calc_optimal_asset_allocation(
   household = household,
   portfolio = portfolio,
   current_date = "2020-07-15"
  )

plot_optimal_portfolio(portfolio)
}
```
