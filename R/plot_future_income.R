#' @export
plot_future_income <- function(
  scenario,
  period   = c("yearly", "monthly"),
  y_limits = c(NA, NA)
) {

  period <- rlang::arg_match(period)

  return(
    plot_structure(
      scenario, 
      structure_of = "income",
      period       = period,
      y_limits     = y_limits
    )
  )
}
