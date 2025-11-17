# Plot expected allocation over household life cycle

If multiple Monte Carlo samples are provided in the `scenario` argument,
the normalized median of expected allocation is plotted.

## Usage

``` r
plot_expected_allocation(
  scenario,
  accounts = c("all", "taxable", "taxadvantaged")
)
```

## Arguments

- scenario:

  A `tibble` with nested columns - the result of
  [`simulate_scenario()`](https://r4goodacademy.github.io/R4GoodPersonalFinances/reference/simulate_scenario.md).
  Data for a single scenario.

- accounts:

  A character. Plot allocation for specified types of accounts.

## Value

A
[`ggplot2::ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html)
object.

## Examples

``` r
if (FALSE) { # interactive()
older_member <- HouseholdMember$new(
  name       = "older",  
  birth_date = "2000-02-15",
  mode       = 80,
  dispersion = 10
)  
household <- Household$new()
household$add_member(older_member)  

household$expected_income <- list(
  "income" = c(
    "members$older$age <= 65 ~ 10000 * 12"
  )
)
household$expected_spending <- list(
  "spending" = c(
    "TRUE ~ 5000 * 12"
  )
)

portfolio <- create_portfolio_template() 
portfolio$accounts$taxable <- c(10000, 30000)
portfolio$weights$human_capital <- c(0.2, 0.8)
portfolio$weights$liabilities <- c(0.1, 0.9)
portfolio <- 
  portfolio |> 
  calc_effective_tax_rate(
    tax_rate_ltcg            = 0.20, 
    tax_rate_ordinary_income = 0.40
  )

scenario <- 
  simulate_scenario(
   household    = household,
   portfolio    = portfolio,
   current_date = "2020-07-15"
  )

plot_expected_allocation(scenario)
}
```
