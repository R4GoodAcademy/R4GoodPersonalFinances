#' @export
calc_portfolio_parameters <- function(
  portfolio
) {

  weights <- rowSums(portfolio$accounts) / sum(portfolio$accounts)
  names(weights) <- portfolio$name

  portfolio_expected_return <- calc_portfolio_expected_return(
    weights = weights,
    returns = portfolio$expected_return
  )

  portfolio_standard_deviation <- calc_portfolio_sd(
    weights             = weights,
    standard_deviations = portfolio$standard_deviation,
    correlations        = portfolio$correlations
  )

  list(
    value              = sum(portfolio$accounts),
    weights            = weights, 
    expected_return    = portfolio_expected_return,
    standard_deviation = portfolio_standard_deviation
  )
}


calc_portfolio_expected_return <- function(
  weights,
  returns
) {

  stopifnot(length(weights) == length(returns))
  stopifnot(sum(weights) - 1 < 0.001)

  sum(weights * returns)
}

calc_portfolio_sd <- function(
  weights,
  standard_deviations,
  correlations
) {

  stopifnot(sum(weights) - 1 < 1e-10)
  stopifnot(length(weights) == length(standard_deviations))
  stopifnot(length(weights) == NROW(standard_deviations))

  weights <- matrix(weights, nrow = 1)

  covariances <- calc_covariance_matrix(
    correlations        = correlations,
    standard_deviations = standard_deviations
  )
  
  portfolio_variance <- weights %*% covariances %*% t(weights)

  as.numeric(sqrt(portfolio_variance))
}

calc_covariance_matrix <- function(correlations, standard_deviations) {

  correlations        <- as.matrix(correlations)
  standard_deviations <- diag(standard_deviations)

  covariances <- 
    standard_deviations %*% correlations %*% standard_deviations

  covariances
}
