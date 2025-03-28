
  # discount_rate (k) - certainty equivalent return for net-worth (h)
  # consumption_impatience_preference - subjective discount rate (rho)
    # Higher values indicate a stronger preference for consumption today versus in the future.
  # smooth_consumption_preference - EOIS (eta)
    # Higher values indicate more flexibility and a lower preference for smooth consumption.
    # usually between 0% (no flexibility) and 100% (high level of flexibility)

#' @export

calc_discretionary_spending <- function(
  allocations_taxable,
  allocations_taxadvantaged,
  expected_returns,
  standard_deviations,
  effective_tax_rates,
  correlations,
  financial_wealth,
  human_capital,
  human_capital_weights,
  liabilities,
  liabilities_weights,
  income,
  nondiscretionary_consumption,
  life_insurance_premium,
  risk_tolerance,
  consumption_impatience_preference,
  smooth_consumption_preference,
  current_age,
  max_age,
  gompertz_mode,
  gompertz_dispersion,
  net_worth     = financial_wealth + human_capital - liabilities, 
  discount_rate = NULL
) {

  # h   <- discount_rate
  # rho <- consumption_impatience_preference
  # eta <- smooth_consumption_preference

  if (is.null(discount_rate)) {

    params <- c(allocations_taxable, allocations_taxadvantaged)
    
    portfolio_expected_return <- calc_joint_networth_portfolio_expected_return(
      params                       = params,
      expected_returns             = expected_returns,
      tax_matrix                   = diag(1 - effective_tax_rates),
      human_capital_weights        = human_capital_weights,
      liabilities_weights          = liabilities_weights,
      financial_wealth             = financial_wealth,
      human_capital                = human_capital,
      liabilities                  = liabilities,
      nondiscretionary_consumption = nondiscretionary_consumption,
      life_insurance_premium       = life_insurance_premium,
      income                       = income
    )
    
    print(print_percent(portfolio_expected_return))
    
    portfolio_variance <- calc_joint_networth_portfolio_variance(
      params = params,
      covariance_matrix =  calc_covariance_matrix(
        standard_deviations = standard_deviations,
        correlations        = correlations
      ),
      tax_matrix                   = diag(1 - effective_tax_rates),
      human_capital_weights        = human_capital_weights,
      liabilities_weights          = liabilities_weights,
      financial_wealth             = financial_wealth,
      human_capital                = human_capital,
      liabilities                  = liabilities,
      nondiscretionary_consumption = nondiscretionary_consumption,
      life_insurance_premium       = life_insurance_premium,
      income                       = income
    )
    
    discount_rate <- calc_certainty_equivalent_return(
      expected_return = portfolio_expected_return,
      variance        = portfolio_variance,
      risk_tolerance  = risk_tolerance
    )
  }
  
  survival_probabilities <- calc_gompertz_survival_probability(
    current_age = current_age,
    target_age  = current_age:max_age,
    max_age     = max_age,
    mode        = gompertz_mode,
    dispersion  = gompertz_dispersion
  )
  
  growth_rate <- calc_growth_rate(
    discount_rate                     = discount_rate,
    consumption_impatience_preference = consumption_impatience_preference,
    smooth_consumption_preference     = smooth_consumption_preference
  )

  delta <- calc_delta(
    survival_probabilities        = survival_probabilities,
    smooth_consumption_preference = smooth_consumption_preference,
    growth_rate                   = growth_rate,
    discount_rate                 = discount_rate
  )

  net_worth / delta
}

calc_growth_rate <- function(
  discount_rate,
  consumption_impatience_preference,
  smooth_consumption_preference
) {

  ((1 + discount_rate) / (1 + consumption_impatience_preference)) ^ smooth_consumption_preference - 1
}

calc_delta <- function(
  survival_probabilities,
  smooth_consumption_preference,
  growth_rate,
  discount_rate
) {

  delta <- 
    tibble::tibble(
      index               = seq_len(length(survival_probabilities)) - 1,
      survival_prob       = survival_probabilities,
      rescheduling_factor = survival_prob ^ smooth_consumption_preference,
      rescheduled = 
        rescheduling_factor * (
          (1 + growth_rate) / (1 + discount_rate)
        )^(index)
    ) 
  
  sum(delta$rescheduled)
}
