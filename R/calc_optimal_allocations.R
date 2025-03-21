calc_optimal_allocations <- function(
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
    
    allocations <- params

    expected_return <- t(allocations) %*% expected_returns
    variance        <- t(allocations) %*% covariance_matrix %*% allocations

    expected_utility <- calc_expected_utility(
      expected_return = expected_return,
      variance        = variance,
      risk_tolerance  = risk_tolerance
    )

    expected_utility
  }
  
  assets_number       <- length(expected_returns)
  initial_allocations <- rep(1/assets_number, assets_number)
  tolerance           <- 1e-9

  
  # Equality constraint: 
    # sum(allocations) = 1 with tolerance
    # Represented as two inequality constraints:
    # 1. sum(allocations) >= 1 - tolerance
    # 2. sum(allocations) <= 1 + tolerance =>
    # -sum(allocations) >= -(1 + tolerance)  
  # Inequality constraint: 
    # allocation_i >= 0
    # Represented as:
    # diag(assets_number) %*% allocations >= rep(0, assets_number)

  ui <- rbind(
    rep(1,  assets_number), # sum(allocations) >= 1 - tolerance
    rep(-1, assets_number), # -sum(allocations) >= -(1 + tolerance)
    diag(assets_number)     # allocation_i >= 0
  )
  ci <- c(
    1 - tolerance, 
    -(1 + tolerance), 
    rep(0, assets_number)
  )

  optimization_result <- constrOptim(
    theta   = initial_allocations,
    f       = objective_function,
    grad    = NULL, 
    ui      = ui,
    ci      = ci,
    control = list(
      fnscale = -1, 
      reltol  = 1e-15
    )
  )
  
  optimal_allocations <- optimization_result$par
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