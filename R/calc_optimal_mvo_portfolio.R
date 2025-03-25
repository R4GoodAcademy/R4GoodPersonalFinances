calc_optimal_mvo_portfolio <- function(
  risk_tolerance,
  expected_returns,
  standard_deviations,
  correlations
) {

  covariance_matrix <- calc_covariance_matrix(
    standard_deviations = standard_deviations,
    correlations        = correlations
  )
    
  objective_function <- function(params) {
    
    allocations     <- params
    expected_return <- t(allocations) %*% expected_returns
    variance        <- t(allocations) %*% covariance_matrix %*% allocations

    expected_utility <- calc_expected_utility(
      expected_return = expected_return,
      variance        = variance,
      risk_tolerance  = risk_tolerance
    )

    -expected_utility
  }
  
  assets_number       <- length(expected_returns)

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

  initial_allocations <- rep(1 / assets_number, assets_number)

  # Set lower bounds for allocations (non-negativity)
  lower_bounds <- rep(0, assets_number)

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
  names(optimal_allocations) <- names(expected_returns) 
  optimal_allocations
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