# Simulate a scenario of household lifetime finances

The function simulates a scenario of household lifetime finances and
returns a `tibble` with nested columns. By default no Monte Carlo
samples are generated, and only single sample based on portfolio
expected returns are returned with column `sample`=`0`. If the
additional Monte Carlo samples are generated, they have consecutive IDs
starting from 1 in the `sample` column.

## Usage

``` r
simulate_scenario(
  household,
  portfolio,
  scenario_id = "default",
  current_date = get_current_date(),
  monte_carlo_samples = NULL,
  seeds = NULL,
  use_cache = FALSE,
  auto_parallel = FALSE,
  debug = FALSE,
  ...
)
```

## Arguments

- household:

  An R6 object of class `Household`.

- portfolio:

  A nested `tibble` of class `Portfolio`.

- scenario_id:

  A character. ID of the scenario.

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

- use_cache:

  A logical. If `TRUE`, the function uses memoised functions to speed up
  the simulation. The results are cached in the folder set by
  [`set_cache()`](https://r4goodacademy.github.io/R4GoodPersonalFinances/reference/cache.md).

- auto_parallel:

  A logical. If `TRUE`, the function automatically detects the number of
  cores and uses parallel processing to speed up the Monte Carlo
  simulations. The results are cached in the folder set by
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

A `tibble` with nested columns including:

- `scenario_id` - (character) ID of the scenario

- `sample` - (integer) ID of the Monte Carlo sample

- `index` - (integer) year index starting from 0

- `years_left` - (integer) years left to the end of the household
  lifespan

- `date` - (date) date after `index` years from the current date

- `year` - (integer) calendar year

- `survival_prob` - (double) survival probability of the household

- `members` - (nested tibble) data of each member in the household

- `income` - (nested tibble) income streams

- `total_income` - (double) total income of the household from all
  income streams

- `spending` - (nested tibble) non-discretionary spending streams

- `nondiscretionary_spending` - (double) total non-discretionary
  spending of the household from all non-discretionary spending streams

- `human_capital` - (double) human capital of the household

- `liabilities` - (double) liabilities of the household

- `portfolio` - (nested tibble) state of investment portfolio

- `financial_wealth` - (double) financial wealth of the household at the
  beginning of the year

- `net_worth` - (double) net worth of the household

- `discretionary_spending` - (double) optimal discretionary spending of
  the household

- `total_spending` - (double) total spending of the household
  (discretionary + non-discretionary)

- `financial_wealth_end` - (double) financial wealth of the household at
  the end of the year

- `risk_tolerance` - (double) risk tolerance of the household

- `smooth_consumption_preference` - (double) smooth consumption
  preference of the household

- `consumption_impatience_preference` - (double) consumption impatience
  preference of the household

- `time_value_discount` - (double) time value discount based on
  consumption impatience of the household

- `discretionary_spending_utility` - (double) discretionary spending
  utility of the household based on the smooth consumption preference

- `discretionary_spending_utility_weighted` - (double) discretionary
  spending utility of the household weighted by survival probability and
  time value discount.

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

scenario <- 
  simulate_scenario(
   household = household,
   portfolio = portfolio,
   current_date = "2020-07-15"
  )
names(scenario)
}
```
