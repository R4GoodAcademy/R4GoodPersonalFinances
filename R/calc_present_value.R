calc_present_value <- function(
  cashflow,
  discount_rate
) {
  v <- time_value_discount <- NULL

  n_years        <- length(cashflow)
  present_values <- vector("numeric", n_years)

  for (i in 1:n_years) {
    
    future_income <- cashflow[i:n_years]

    data <-
      dplyr::tibble(
        cashflow = future_income,
        v      = seq_len(length(future_income)) - 1
      ) |>
      dplyr::mutate(
        time_value_discount =
          1 / (
            (1 + discount_rate)^(v - 0)
          ),
        pv = time_value_discount * cashflow
      )
    present_values[i] <- sum(data$pv)
  }
  
  present_values
}
