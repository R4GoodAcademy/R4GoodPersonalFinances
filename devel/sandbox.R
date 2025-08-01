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

plot_future_saving_rates(scenario)