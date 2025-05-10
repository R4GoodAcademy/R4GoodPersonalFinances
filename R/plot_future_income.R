#' @export
plot_future_income <- function(
  scenario,
  period  = c("yearly", "monthly"),
  y_limit = c(NA, NA)
) {

  period        <- rlang::arg_match(period)
  period_factor <- if (period == "yearly") 1 else 12

  return(
    plot_structure(
      scenario, 
      structure_of = "income",
      period = period
    )
  )
}
