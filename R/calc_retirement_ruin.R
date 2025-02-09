# See: Milevsky, M.A. (2020). Retirement Income Recipes in R: From Ruin Probabilities to Intelligent Drawdowns. Use R! Series. https://doi.org/10.1007/978-3-030-51434-1
#' @export
calc_retirement_ruin <- function(
  portfolio_return_mean,
  portfolio_return_sd,
  age,
  gompertz_mode,
  gompertz_dispersion,
  portfolio_value,
  monthly_spendings,
  yearly_spendings = 12 * monthly_spendings,
  spending_rate    = yearly_spendings / portfolio_value
) {

    nu    <- portfolio_return_mean
    sigma <- portfolio_return_sd
    x     <- age
    m     <- gompertz_mode
    b     <- gompertz_dispersion
  
    mu <- nu + (0.5) * sigma^2 

    M1 <- calc_a(mu - sigma^2, x, m, b)
  
    M2 <- 
      # (calc_a(mu - sigma^2, x, m, b)
      (M1 - calc_a(2 * mu - 3 * sigma^2, x, m, b)) / (mu / 2 - sigma^2)
    
    alpha <- (2 * M2 - M1^2) / (M2 - M1^2)
    beta  <- (M2 - M1^2) / (M2 * M1)

  pgamma(
    q          = spending_rate,
    shape      = alpha,
    scale      = beta,
    lower.tail = TRUE
  )
}

calc_a <- function(v, x, m, b) {
  
  b * exp(exp((x - m) / b) + (x - m) * v) * 
    calc_incomplete_gamma(-b * v, exp((x - m) / b))
}

calc_incomplete_gamma <- function(a, c) {

  integrand <- function(t) {
    t^(a - 1) * exp(-t)
  }

  integrate(integrand, c, Inf)$value
}
