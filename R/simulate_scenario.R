simulate_scenario <- function(
  household,
  portfolio,
  scenario_id  = "default",
  current_date = get_current_date(),
  debug        = FALSE
) {

  current_date <- lubridate::as_date(current_date)

  timeline <- 
    generate_household_timeline(
      household    = household, 
      current_date = current_date
    ) 

  income_streams <- 
    generate_cashflow_streams(
      timeline = timeline,  
      triggers = household$expected_income
    )
  spending_streams <- 
    generate_cashflow_streams(
      timeline = timeline,  
      triggers = household$expected_spending
    )
  
  scenario <- 
    timeline |> 
    dplyr::mutate(
      "income"                  = income_streams,
      total_income              = rowSums(income),
      "spending"                = spending_streams,
      nondiscretionary_spending = rowSums(spending)
    ) 

  fraction_in_taxable_accounts <- 
    sum(portfolio$accounts$taxable) / sum(portfolio$accounts)
  
  financial_wealth <- sum(portfolio$accounts)

  weights <- list()
  weights$taxable <- 
    portfolio$accounts$taxable / financial_wealth
  weights$taxadvantaged <- 
    portfolio$accounts$taxadvantaged / financial_wealth
  weights$financial_wealth <- 
    weights$taxable + weights$taxadvantaged

  portfolio_expected_return <- 
    calc_portfolio_expected_return(
      weights = weights$financial_wealth,
      returns = portfolio$expected_return
    )
  
  portfolio_standard_deviation <- 
    calc_portfolio_sd(
      weights             = weights$financial_wealth,
      standard_deviations = portfolio$standard_deviation,
      correlations        = portfolio$correlations
    )
  
  human_capital_discount_rate <- 
    calc_portfolio_expected_return(
      weights = portfolio$weights$human_capital,
      returns = portfolio$expected_return
    )
  liabilities_discount_rate <- 
    calc_portfolio_expected_return(
      weights = portfolio$weights$liabilities,
      returns = portfolio$expected_return
    )

  scenario <- 
    scenario |>
    dplyr::mutate(
      human_capital = calc_present_value(
        cashflow      = total_income,
        discount_rate = human_capital_discount_rate
      ),
      liabilities = calc_present_value(
        cashflow      = nondiscretionary_spending,
        discount_rate = liabilities_discount_rate
      ),
      allocation             = rep(list(NA_real_), NROW(scenario)),
      financial_wealth       = NA_real_,
      net_worth              = NA_real_,
      discretionary_spending = NA_real_,
      total_spending         = NA_real_,
      financial_wealth_end   = NA_real_,
      risk_tolerance         = household$risk_tolerance,
      smooth_consumption_preference = 
        household$smooth_consumption_preference,
      consumption_impatience_preference = 
        household$consumption_impatience_preference
    ) 

  n_rows <- NROW(scenario)

  for (i in seq_len(n_rows)) {

    if (i == 1) {

      scenario[i, ]$financial_wealth <- financial_wealth

      scenario[i, ]$allocation <- list(
        tibble::tibble(
          asset         = portfolio$name,
          taxable       = weights$taxable,
          taxadvantaged = weights$taxadvantaged,
          total         = weights$financial_wealth
        )
      )
      initial_allocation <- c(
        scenario[i, ]$allocation[[1]]$taxable,
        scenario[i, ]$allocation[[1]]$taxadvantaged
      )
      
    } else {

      initial_allocation <- scenario[i - 1, ]$allocation[[1]]
      initial_allocation <- c(
        initial_allocation$taxable,
        initial_allocation$taxadvantaged
      )
    }

    scenario[i, ]$net_worth <- 
      scenario[i, ]$financial_wealth +
      scenario[i, ]$human_capital -
      scenario[i, ]$liabilities

    household_survival <- household$calc_survival(current_date = current_date)

    discretionary_spending <- 
      calc_discretionary_spending(
        allocations_taxable          = weights$taxable,
        allocations_taxadvantaged    = weights$taxadvantaged,
        human_capital_weights        = portfolio$weights$human_capital,
        liabilities_weights          = portfolio$weights$liabilities,
        expected_returns             = portfolio$expected_return,
        standard_deviations          = portfolio$standard_deviation,
        effective_tax_rates          = portfolio$aftertax$effective_tax_rate,
        correlations                 = portfolio$correlations,

        financial_wealth             = scenario[i, ]$financial_wealth,
        human_capital                = scenario[i, ]$human_capital,
        liabilities                  = scenario[i, ]$liabilities,
        nondiscretionary_consumption = scenario[i, ]$nondiscretionary_spending,
        income                       = scenario[i, ]$total_income,
        risk_tolerance               = scenario[i, ]$risk_tolerance,
        consumption_impatience_preference = 
        scenario[i, ]$consumption_impatience_preference,
        smooth_consumption_preference     = 
          household$smooth_consumption_preference,
        current_age = 
          household$get_min_age(current_date = current_date) + 
            scenario[i, ]$index,
        max_age = 
          household$get_min_age(current_date = current_date) + 
            max(scenario$index),
        gompertz_mode       = household_survival$mode,
        gompertz_dispersion = household_survival$dispersion,
        # TODO: life_insurance_premium
        life_insurance_premium = 0
      )

    if (is.nan(discretionary_spending)) {
      discretionary_spending <- 0
    }

    scenario[i, ]$discretionary_spending <- discretionary_spending

    scenario[i, ]$total_spending <- 
      scenario[i, ]$discretionary_spending +
      scenario[i, ]$nondiscretionary_spending

    financial_wealth_end <- 
      scenario[i, ]$financial_wealth +
      scenario[i, ]$total_income -
      scenario[i, ]$total_spending
      
    optimal_joint_networth_portfolio <- tryCatch(
      
      calc_optimal_portfolio(
        risk_tolerance               = household$risk_tolerance,
        expected_returns             = portfolio$expected_return,
        standard_deviations          = portfolio$standard_deviation,
        correlations                 = portfolio$correlations,
        effective_tax_rates          = portfolio$aftertax$effective_tax_rate,
        # TODO: in_taxable_accounts can change?
        in_taxable_accounts          = fraction_in_taxable_accounts,
        financial_wealth             = scenario[i, ]$financial_wealth,
        human_capital                = scenario[i, ]$human_capital,
        liabilities                  = scenario[i, ]$liabilities,
        nondiscretionary_consumption = scenario[i, ]$nondiscretionary_spending,
        discretionary_consumption    = scenario[i, ]$discretionary_spending,
        income                       = scenario[i, ]$total_income,
        # TODO: life_insurance_premium
        life_insurance_premium       = 0,
        human_capital_weights        = portfolio$weights$human_capital,
        liabilities_weights          = portfolio$weights$liabilities,
        asset_names                  = portfolio$name,

        initial_allocation = initial_allocation
        ),

        error = function(e) {
          if (debug) {
            cli::cli_alert_warning(
              cli::col_yellow(
                "{e}Optimal allocation not found for year index {i}. 
                Using optimal allocation from previous period..."
              )
            )
          }
          return(NULL)
        }
    )
      
    if (!is.null(optimal_joint_networth_portfolio$allocations$total)) {

      scenario[i, ]$allocation <- list(
        optimal_joint_networth_portfolio$allocations |> 
          dplyr::rename("asset" = "asset_class")
      )

    } else {

      scenario[i, ]$allocation <- scenario[i - 1, ]$allocation
    }

    financial_wealth_end <- 
      sum(
        rep(financial_wealth_end, NROW(portfolio)) *
          scenario[i, ]$allocation[[1]]$total * 
          (1 + portfolio$expected_return)
      )
    
    scenario[i, ]$financial_wealth_end <- financial_wealth_end

    if (i < n_rows) {

      scenario[i + 1, ]$financial_wealth <- financial_wealth_end
    }
  }

  scenario |> 
    dplyr::mutate(
      time_value_discount = 
        1 / (
          (1 + consumption_impatience_preference)^(index - 0)
        ),
      discretionary_spending_utility = 
        calc_utility(
          x         = discretionary_spending, 
          parameter = smooth_consumption_preference
        ),
      discretionary_spending_utility_weighted = 
        survival_prob * time_value_discount * discretionary_spending_utility,
      scenario_id = scenario_id
    ) |> 
      dplyr::select(
        scenario_id, index, dplyr::everything()
      )

}

