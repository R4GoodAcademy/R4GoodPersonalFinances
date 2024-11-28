#' Calculate purchasing power
#' 
#' @param x A numeric. The initial amount of money.
#' @param years A numeric. The number of years.
#' @param real_interest_rate A numeric. The yearly avarage real interest rate.
#' The real interest rate is the interest rate after inflation.
#' If negative (e.g. equal to the avarage yearly inflation rate) 
#' it can show deminishing purchasing power over time.
#' @return A numeric. The purchasing power.
#' 
#' @export
calc_purchasing_power <- function(x, years, real_interest_rate) {
  
  purchasing_power <- ifelse(real_interest_rate < 0, 
                             x / (1 + abs(real_interest_rate)) ^ years, 
                             x * (1 + real_interest_rate) ^ years)
  
  return(purchasing_power)
}