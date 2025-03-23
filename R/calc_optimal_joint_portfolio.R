calc_optimal_joint_portfolio <- function(
  risk_tolerance,
  expected_returns,
  standard_deviations,
  correlations,
  effective_tax_rates,
  in_taxable_accounts
) {

  covariance_matrix <- calc_covariance_matrix(
    standard_deviations = standard_deviations,
    correlations        = correlations
  )

  tax_matrix <- diag(1 - effective_tax_rates)

  get_allocations_taxable <- function(params) {
    params[1:(length(params)/2)]
  }

  get_allocations_taxadvantaged <- function(params) {
    params[(length(params)/2 + 1):length(params)]
  }
    
  objective_function <- function(params) {
    
    allocations_taxable       <- get_allocations_taxable(params)
    allocations_taxadvantaged <- get_allocations_taxadvantaged(params)

    expected_return <- 
      t(tax_matrix %*% allocations_taxable + allocations_taxadvantaged) %*% expected_returns

    variance <- 
      t(tax_matrix %*% allocations_taxable + allocations_taxadvantaged) %*% 
      covariance_matrix %*% 
      (tax_matrix %*% allocations_taxable + allocations_taxadvantaged)
      
    expected_utility <- calc_expected_utility(
      expected_return = expected_return,
      variance        = variance,
      risk_tolerance  = risk_tolerance
    )

    -expected_utility
  }
  
  assets_number <- length(expected_returns)
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

  initial_allocations <- rep(
    1 / total_assets,
    total_assets
  )

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
  optimal_allocations
}
