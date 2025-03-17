calc_present_value <- function(
  cashflow,
  discount_rate
) {

  data <- 
    tibble::tibble(
      cashflow = cashflow,
      v        = seq_len(length(cashflow)) - 1
    ) |> 
    dplyr::mutate(
      time_value_discount = 
        1 / (
          (1 + discount_rate)^(v - 0)
        ),
      pv = time_value_discount * cashflow
    ) 
  
  sum(data$pv)
}
