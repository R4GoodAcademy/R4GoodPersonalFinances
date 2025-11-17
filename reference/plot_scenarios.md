# Plot scenarios metrics

The plot allows to compare metrics for multiple scenarios.

If scenarios are simulated without Monte Carlo samples, so they are
based only on expected returns of portfolio, two metrics are available
for each scenario:

- constant discretionary spending - certainty equivalent constant level
  of consumption that would result in the same lifetime utility as a
  given series of future consumption in a given scenario (the higher,
  the better).

- utility of discretionary spending - normalized to minimum and maximum
  values of constant discretionary spending (the higher, the better).

If scenarios are simulated with additional Monte Carlo samples, there
are four more metrics available per scenario:

- constant discretionary spending (for Monte Carlo samples),

- normalized median utility of discretionary spending (for Monte Carlo
  samples),

- median of missing funds that need additional income or additional
  savings at the expense of non-discretionary spending, (of yearly
  averages of Monte Carlo samples),

- median of discretionary spending (of yearly averages of Monte Carlo
  samples).

## Usage

``` r
plot_scenarios(scenarios, period = c("yearly", "monthly"))
```

## Arguments

- scenarios:

  A `tibble` with nested columns - the result of
  [`simulate_scenarios()`](https://r4goodacademy.github.io/R4GoodPersonalFinances/reference/simulate_scenarios.md).

- period:

  A character. The amounts can be shown as yearly values (default) or
  averaged per month values.

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
    "is_not_on('older', 'retirement') ~ 7000 * 12"
  )
)
household$expected_spending <- list(
  "spending" = c(
    "TRUE ~ 4000 * 12"
  )
)

portfolio <- create_portfolio_template() 
portfolio$accounts$taxable <- c(100000, 300000)
portfolio <- 
  portfolio |> 
  calc_effective_tax_rate(
    tax_rate_ltcg = 0.20, 
    tax_rate_ordinary_income = 0.40
  )

start_ages <- c(60, 65, 75)
scenarios_parameters <- 
  tibble::tibble(
    member    = "older",
    event      = "retirement",
    start_age = start_ages,
    years     = Inf,
    end_age   = Inf
   ) |> 
  dplyr::mutate(scenario_id = start_age) |> 
  tidyr::nest(events = -scenario_id)

scenarios <- 
  simulate_scenarios(
    scenarios_parameters = scenarios_parameters,
    household            = household,
    portfolio            = portfolio,
    maxeval              = 100,
    current_date         = "2020-07-15"
  )

plot_scenarios(scenarios, "monthly")
}
```
