calc_portfolio_expected_return <- function(
  weights,
  returns
) {

  stopifnot(sum(weights) == 1)
  stopifnot(length(weights) == length(returns))

  sum(weights * returns)
}

calc_portfolio_sd <- function(
  weights,
  standard_deviations,
  correlations
) {

  stopifnot(sum(weights) == 1)
  stopifnot(length(weights) == length(standard_deviations))
  stopifnot(length(weights) == NROW(standard_deviations))

  weights <- matrix(weights, nrow = 1)

  standard_deviations <- diag(standard_deviations)

  correlations <- as.matrix(correlations)

  covariances <- 
    standard_deviations %*% correlations %*% standard_deviations

  portfolio_variance <- weights %*% covariances %*% t(weights)

  as.numeric(sqrt(portfolio_variance))
}

  
