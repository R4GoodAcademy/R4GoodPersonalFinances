# Plot future income structure over household life cycle

Plot future income structure over household life cycle

## Usage

``` r
plot_future_income(
  scenario,
  period = c("yearly", "monthly"),
  y_limits = c(NA, NA)
)
```

## Arguments

- scenario:

  A `tibble` with nested columns - the result of
  [`simulate_scenario()`](https://r4goodacademy.github.io/R4GoodPersonalFinances/reference/simulate_scenario.md).
  Data for a single scenario.

- period:

  A character. The amounts can be shown as yearly values (default) or
  averaged per month values.

- y_limits:

  A numeric vector of two values. Y-axis limits.

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
    "members$older$age <= 65 ~ 7000 * 12",
    "members$older$age > 65 ~ 3000 * 12"
  )
)
household$expected_spending <- list(
  "spending" = c(
    "TRUE ~ 5000 * 12"
  )
)

portfolio <- create_portfolio_template() 
portfolio$accounts$taxable <- c(10000, 30000)
portfolio <- 
  portfolio |> 
  calc_effective_tax_rate(
    tax_rate_ltcg = 0.20, 
    tax_rate_ordinary_income = 0.40
  )

scenario <- 
  simulate_scenario(
   household = household,
   portfolio = portfolio,
   current_date = "2020-07-15"
  )

plot_future_income(scenario, "monthly")
}
```
