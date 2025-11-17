# Rendering a scenario snapshot

Rendering a scenario snapshot

## Usage

``` r
render_scenario_snapshot(scenario, index = 0, currency = "", big_mark = " ")
```

## Arguments

- scenario:

  A `tibble` with nested columns - the result of
  [`simulate_scenario()`](https://r4goodacademy.github.io/R4GoodPersonalFinances/reference/simulate_scenario.md).
  Data for a single scenario.

- index:

  The index of the scenario year to render. By default, it is 0, which
  corresponds to the current year.

- currency:

  The currency symbol to use as a suffix.

- big_mark:

  The character to use as a big mark. It separates thousands.

## Value

A [`gt::gt()`](https://gt.rstudio.com/reference/gt.html) object.

## Examples

``` r
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
    "members$older$age <= 65 ~ 9000 * 12"
  )
)
household$expected_spending <- list(
  "spending" = c(
    "members$older$age <= 65 ~ 5000 * 12",
    "TRUE ~ 4000 * 12"
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
#> 
#> ── Simulating scenario: default 
#> ℹ Current date: 2020-07-15
#> ! Caching is NOT enabled.
#> → Simulating scenario based on expected returns (sample_id == 0)
render_scenario_snapshot(scenario)


  


Scenario Summary (2020)
```

Scenario: **default**

*Expected cashflow (monthly)*

Income

9 000

Spending

7 041

Non-discretionary spending

5 000

Discretionary spending

2 041

Savings

1 959

Saving rate

21.8%

*Balance sheet*

Financial wealth

40 000

Human capital

1 926 274

Liabilities

1 507 938

Net Worth

458 337

*Date: 2020-07-15*
