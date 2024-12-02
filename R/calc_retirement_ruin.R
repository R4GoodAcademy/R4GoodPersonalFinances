#' @export
calc_retirement_ruin <- function(
  yearly_spendings,
  portfolio_value,
  portfolio_return_mean,
  portfolio_return_sd,
  expected_lifetime
) {
  
  spending_rate <- yearly_spendings / portfolio_value
  
  lambda <- 1 / expected_lifetime # implied mortality rate

  alpha <- 
    (2 * portfolio_return_mean + 4 * lambda) / 
    (portfolio_return_sd^2 + lambda) - 1

  beta <-
    (portfolio_return_sd^2 + lambda) / 2

  pgamma(
    q = spending_rate,
    shape = alpha,
    scale = beta
  )

}
