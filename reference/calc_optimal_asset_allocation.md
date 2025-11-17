# Calculate optimal asset allocation

Calculate optimal asset allocation

## Usage

``` r
calc_optimal_asset_allocation(
  household,
  portfolio,
  current_date = get_current_date()
)
```

## Arguments

- household:

  An R6 object of class `Household`.

- portfolio:

  A nested `tibble` of class `Portfolio`.

- current_date:

  A character. Current date in the format `YYYY-MM-DD`. By default, it
  is the output of
  [`get_current_date()`](https://r4goodacademy.github.io/R4GoodPersonalFinances/reference/get_current_date.md).

## Value

The `portfolio` with additional nested columns:

- `allocations$optimal` - optimal joint net-worth portfolio allocations

- `allocations$current` - current allocations

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

portfolio <- 
  calc_optimal_asset_allocation(
   household = household,
   portfolio = portfolio,
   current_date = "2020-07-15"
  )

portfolio$allocations
}
```
