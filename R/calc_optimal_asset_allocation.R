calc_optimal_asset_allocation <- function(
  household,
  portfolio,
  current_date
) {

  scenario <- 
    simulate_scenario(
      household    = household,
      portfolio    = portfolio,
      current_date = current_date
    )

  financial_wealth <- scenario$financial_wealth[1]
  human_capital    <- scenario$human_capital[1]
  liabilities      <- scenario$liabilities[1]
  net_worth        <- financial_wealth + human_capital - liabilities
  
  nondiscretionary_consumption <- scenario$nondiscretionary_spending[1]

  fraction_in_taxable_accounts <- 
    sum(portfolio$accounts$taxable) / sum(portfolio$accounts)
  
  discretionary_spending <- 
    scenario$discretionary_spending[1]
  income <- 
    scenario$total_income[1]
  
  optimal_joint_networth_portfolio <- calc_optimal_portfolio(
    risk_tolerance      = household$risk_tolerance,
    expected_returns    = portfolio$expected_return,
    standard_deviations = portfolio$standard_deviation,
    correlations        = portfolio$correlations,
    effective_tax_rates = portfolio$effective_tax_rates,
    in_taxable_accounts = fraction_in_taxable_accounts,
    financial_wealth    = financial_wealth,
    human_capital       = human_capital,
    liabilities         = liabilities,
    nondiscretionary_consumption = nondiscretionary_consumption,
    discretionary_consumption    = discretionary_spending,
    income                       = income,
    life_insurance_premium       = 0,
    human_capital_weights = portfolio$weights$human_capital,
    liabilities_weights   = portfolio$weights$liabilities,
    asset_names           = portfolio$asset_class
  ) 
  optimal_joint_networth_portfolio
}
