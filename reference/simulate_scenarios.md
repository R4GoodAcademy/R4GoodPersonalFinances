# Simulate multiple scenarios of household lifetime finances

Simulate multiple scenarios of household lifetime finances

## Usage

``` r
simulate_scenarios(
  scenarios_parameters,
  household,
  portfolio,
  current_date = get_current_date(),
  monte_carlo_samples = NULL,
  seeds = NULL,
  auto_parallel = FALSE,
  use_cache = FALSE,
  debug = FALSE,
  ...
)
```

## Arguments

- scenarios_parameters:

  A `tibble` with column `scenario_id` and nested column `events`. Each
  scenario has defined one or more events in the tibbles that are stored
  in as a list in the `events` column.

- household:

  An R6 object of class `Household`.

- portfolio:

  A nested `tibble` of class `Portfolio`.

- current_date:

  A character. Current date in the format `YYYY-MM-DD`. By default, it
  is the output of
  [`get_current_date()`](https://r4goodacademy.github.io/R4GoodPersonalFinances/reference/get_current_date.md).

- monte_carlo_samples:

  An integer. Number of Monte Carlo samples. If `NULL` (default), no
  Monte Carlo samples are generated.

- seeds:

  An integer or integer vector. If integer vector, it is a vector of
  random seeds for the random number generator used to generate random
  portfolio returns for each Monte Carlo sample. If `NULL` (default),
  random seed is generated automatically. If a single integer is
  provided, it is used to generate a vector of random seeds for each
  Monte Carlo sample.

- auto_parallel:

  A logical. If `TRUE`, the function automatically detects the number of
  cores and uses parallel processing to speed up the Monte Carlo
  simulations. The results are cached in the folder set by
  [`set_cache()`](https://r4goodacademy.github.io/R4GoodPersonalFinances/reference/cache.md).

- use_cache:

  A logical. If `TRUE`, the function uses memoised functions to speed up
  the simulation. The results are cached in the folder set by
  [`set_cache()`](https://r4goodacademy.github.io/R4GoodPersonalFinances/reference/cache.md).

- debug:

  A logical. If `TRUE`, additional information is printed during the
  simulation.

- ...:

  Additional arguments passed to simulation and optimization functions.
  You can pass a list named `opts` as parameter to the optimization
  function to select the optimization algorithm and its parameters. See
  [`nloptr::nloptr()`](https://astamm.github.io/nloptr/reference/nloptr.html)
  and
  [`nloptr::nloptr.print.options()`](https://astamm.github.io/nloptr/reference/nloptr.print.options.html)
  for more information.

## Value

A `tibble` with nested columns.

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
portfolio <- 
  portfolio |> 
  calc_effective_tax_rate(
    tax_rate_ltcg = 0.20, 
    tax_rate_ordinary_income = 0.40
  )
start_ages <- c(60, 65, 70)
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

scenarios_parameters

scenarios <- 
  simulate_scenarios(
    scenarios_parameters = scenarios_parameters,
    household            = household,
    portfolio            = portfolio,
    current_date         = "2020-07-15"
  )
scenarios$scenario_id |> unique()
}
```
