calc_optimal_portfolio <- function(
  risk_tolerance,
  expected_returns,
  standard_deviations,
  correlations,
  asset_names                  = NULL,
  effective_tax_rates          = NULL,
  in_taxable_accounts          = NULL,
  financial_wealth             = NULL,
  human_capital                = NULL,
  human_capital_weights        = NULL,
  liabilities                  = NULL,
  liabilities_weights          = NULL,
  nondiscretionary_consumption = NULL,
  discretionary_consumption    = NULL,
  income                       = NULL,
  life_insurance_premium       = NULL
) {

  covariance_matrix <- calc_covariance_matrix(
    standard_deviations = standard_deviations,
    correlations        = correlations
  )

  if (!is.null(effective_tax_rates)) {
    tax_matrix <- diag(1 - effective_tax_rates)
  }
    
  objective_function <- function(params) {

    if (is.null(effective_tax_rates)) {

      expected_return <- calc_mvo_portfolio_expected_return(
        params           = params,
        expected_returns = expected_returns
      )
      variance <- calc_mvo_portfolio_variance(
        params            = params,
        covariance_matrix = covariance_matrix
      )
    }

    if (!is.null(effective_tax_rates) && is.null(financial_wealth)) {

      expected_return <- calc_joint_portfolio_expected_return(
        params           = params,
        expected_returns = expected_returns,
        tax_matrix       = tax_matrix
      )
      variance <- calc_joint_portfolio_variance(
        params            = params,
        covariance_matrix = covariance_matrix,
        tax_matrix        = tax_matrix
      )
    }
    
    if (!is.null(effective_tax_rates) && !is.null(financial_wealth)) {

      financial_wealth_prime <- 
        financial_wealth + income - discretionary_consumption - 
        nondiscretionary_consumption - life_insurance_premium

      human_capital_prime <- human_capital - income

      liabilities_prime <- 
        liabilities - nondiscretionary_consumption - life_insurance_premium

      net_worth <- financial_wealth + human_capital - liabilities
      net_worth_prime <- 
        financial_wealth_prime + human_capital_prime - liabilities_prime

      financial_wealth_frac <- financial_wealth_prime / net_worth_prime
      human_capital_frac    <- human_capital_prime / net_worth_prime
      liabilities_frac      <- liabilities_prime / net_worth_prime
      
      expected_return <- calc_joint_networth_portfolio_expected_return(
        params                = params,
        expected_returns      = expected_returns,
        tax_matrix            = tax_matrix,
        financial_wealth_frac = financial_wealth_frac,
        human_capital_frac    = human_capital_frac,
        human_capital_weights = human_capital_weights,
        liabilities_frac      = liabilities_frac,
        liabilities_weights   = liabilities_weights
      )
      variance <- calc_joint_networth_portfolio_variance(
        params                = params,
        covariance_matrix     = covariance_matrix,
        tax_matrix            = tax_matrix,
        financial_wealth_frac = financial_wealth_frac,
        human_capital_frac    = human_capital_frac,
        human_capital_weights = human_capital_weights,
        liabilities_frac      = liabilities_frac,
        liabilities_weights   = liabilities_weights
      )
    }
    
    expected_utility <- calc_expected_utility(
      expected_return = expected_return,
      variance        = variance,
      risk_tolerance  = risk_tolerance
    )

    -expected_utility
  }
  
  assets_number <- length(expected_returns)
  
  if (is.null(effective_tax_rates)) {

    total_assets <- assets_number
    
    # Equality constraint: sum(allocations) = 1
    equality_constraint <- function(allocations) {
      return(sum(allocations) - 1)
    }
    # Jacobian of the equality constraint
    equality_jacobian <- function(allocations) {
      return(rep(1, assets_number))
    }

    # Inequality constraint: allocation_i >= 0
    inequality_constraint <- function(allocations) {
      return(allocations)
    }
    # Jacobian of the inequality constraint
    inequality_jacobian <- function(allocations) {
      return(diag(assets_number))
    }

  } else {

    total_assets <- assets_number * 2 

    # Equality constraints:
    # 1. sum(allocations_taxable) = in_taxable_accounts
    # 2. sum(allocations_taxadvantaged) = 1 - in_taxable_accounts
    equality_constraint <- function(params) {
      allocations_taxable <- get_allocations_taxable(params)
      allocations_taxadvantaged <- get_allocations_taxadvantaged(params)
      return(c(sum(allocations_taxable) - in_taxable_accounts, sum(allocations_taxadvantaged) - (1 - in_taxable_accounts)))
    }
    # Jacobian of the equality constraints
    equality_jacobian <- function(params) {
      jacobian <- matrix(0, nrow = 2, ncol = total_assets)
      # Derivative of sum(taxable) - 1 w.r.t. taxable allocations
      jacobian[1, 1:assets_number] <- 1 
      # Derivative of sum(tax-advantaged) - 1 w.r.t. tax-advantaged allocations
      jacobian[2, (assets_number + 1):total_assets] <- 1 
      return(jacobian)
    }

    # Inequality constraint: allocation_i >= 0 for all assets in both accounts
    inequality_constraint <- function(params) {
      return(params)
    }
    # Jacobian of the inequality constraint
    inequality_jacobian <- function(params) {
      return(diag(total_assets))
    }
  }

  initial_allocations <- rep(1 / total_assets, total_assets)

  # Set lower bounds for allocations (non-negativity)
  lower_bounds <- rep(0, total_assets)

  optimization_result <- nloptr::nloptr(
    x0          = initial_allocations,
    eval_f      = objective_function,
    opts        = list(
      algorithm = "NLOPT_LN_COBYLA", 
      xtol_rel  = 1e-15,
      ftol_rel  = 1e-15,
      maxeval   = 10000 
    ),
    eval_g_eq   = equality_constraint,
    lb          = lower_bounds
  )

  optimal_allocations <- optimization_result$solution

  if (is.null(effective_tax_rates)) {
    
    names(optimal_allocations) <- asset_names
    return(optimal_allocations)
  }

  optimal_taxable_allocations <- 
    get_allocations_taxable(optimal_allocations)
  names(optimal_taxable_allocations) <- asset_names

  optimal_taxadvantaged_allocations <- 
    get_allocations_taxadvantaged(optimal_allocations)
  names(optimal_taxadvantaged_allocations) <- asset_names

  list(
    taxable_accounts       = optimal_taxable_allocations,
    taxadvantaged_accounts = optimal_taxadvantaged_allocations
  )
}

calc_expected_utility <- function(
  expected_return, 
  variance,
  risk_tolerance
) {

  if (risk_tolerance == 1) {
    crra_utility <- log(1 + expected_return)
  } else {
    crra_utility <- 
      (risk_tolerance / (risk_tolerance - 1)) * 
      (1 + expected_return) ^ ((risk_tolerance - 1) / risk_tolerance)
  }

  crra_utility_second_derivative <- 
    -1 / (
      risk_tolerance * 
        (1 + expected_return) ^ ((1 + risk_tolerance) / risk_tolerance)
    )

  expected_utility <- 
    crra_utility + 1/2 * crra_utility_second_derivative * variance

  as.numeric(expected_utility)
}

calc_mvo_portfolio_expected_return <- function(...) {

  args             <- list(...)
  allocations      <- args$params
  expected_returns <- args$expected_returns

  t(allocations) %*% expected_returns
}

calc_joint_portfolio_expected_return <- function(...) {

  args                      <- list(...)
  params                    <- args$params
  allocations_taxable       <- get_allocations_taxable(params)
  allocations_taxadvantaged <- get_allocations_taxadvantaged(params)

  expected_returns <- args$expected_returns
  tax_matrix       <- args$tax_matrix

  t(tax_matrix %*% allocations_taxable + allocations_taxadvantaged) %*% 
  expected_returns


}

calc_joint_networth_portfolio_expected_return <- function(...) {

  args                      <- list(...)
  params                    <- args$params
  allocations_taxable       <- get_allocations_taxable(params)
  allocations_taxadvantaged <- get_allocations_taxadvantaged(params)

  expected_returns      <- args$expected_returns
  tax_matrix            <- args$tax_matrix
  financial_wealth_frac <- args$financial_wealth_frac
  human_capital_frac    <- args$human_capital_frac
  human_capital_weights <- args$human_capital_weights
  liabilities_frac      <- args$liabilities_frac
  liabilities_weights   <- args$liabilities_weights

  financial_wealth_frac * 
    t(tax_matrix %*% allocations_taxable + allocations_taxadvantaged) %*%
    expected_returns + 
    human_capital_frac * t(human_capital_weights) %*% expected_returns - 
    liabilities_frac * t(liabilities_weights) %*% expected_returns
}

calc_mvo_portfolio_variance <- function(...) {
  
  args              <- list(...)
  allocations       <- args$params
  covariance_matrix <- args$covariance_matrix

  t(allocations) %*% covariance_matrix %*% allocations
}

calc_joint_portfolio_variance <- function(...) {
  
  args                      <- list(...)
  params                    <- args$params
  allocations_taxable       <- get_allocations_taxable(params)
  allocations_taxadvantaged <- get_allocations_taxadvantaged(params)
  covariance_matrix         <- args$covariance_matrix
  tax_matrix                <- args$tax_matrix

  t(tax_matrix %*% allocations_taxable + allocations_taxadvantaged) %*% 
    covariance_matrix %*% 
    (tax_matrix %*% allocations_taxable + allocations_taxadvantaged)
}

calc_joint_networth_portfolio_variance <- function(...) {
  
  args                      <- list(...)
  params                    <- args$params
  allocations_taxable       <- get_allocations_taxable(params)
  allocations_taxadvantaged <- get_allocations_taxadvantaged(params)

  covariance_matrix     <- args$covariance_matrix
  tax_matrix            <- args$tax_matrix
  financial_wealth_frac <- args$financial_wealth_frac
  human_capital_frac    <- args$human_capital_frac
  human_capital_weights <- args$human_capital_weights
  liabilities_frac      <- args$liabilities_frac
  liabilities_weights   <- args$liabilities_weights

  financial_wealth_frac^2 * (
    t(tax_matrix %*% allocations_taxable + allocations_taxadvantaged) %*%
    covariance_matrix %*%
    (tax_matrix %*% allocations_taxable + allocations_taxadvantaged)
  ) + 
  2 * financial_wealth_frac * t(
    human_capital_frac * (
      covariance_matrix %*% human_capital_weights
    ) - 
    liabilities_frac * (
      covariance_matrix %*% liabilities_weights
    )
  ) %*% (
    tax_matrix %*% allocations_taxable + allocations_taxadvantaged
  ) +
  human_capital_frac^2 * (
    t(human_capital_weights) %*% covariance_matrix %*% human_capital_weights
  ) +
  liabilities_frac^2 * (
    t(liabilities_weights) %*% covariance_matrix %*% liabilities_weights
  ) - 
  2 * human_capital_frac * liabilities_frac * (
    t(human_capital_weights) %*% covariance_matrix %*% liabilities_weights
  )
}
