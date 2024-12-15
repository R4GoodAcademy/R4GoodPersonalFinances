#' Run a package app
#' 
#' @param which A character. The name of the app to run.
#' Currently available:
#' 
#' * `risk-adjusted-returns` - Plotting risk-adjusted returns for various allocations to the risky asset allows you to find the optimal allocation.
#' * `purchasing-power` - Plotting the effect of real interest rates 
#' (positive or negative) on the purchasing power of savings over time.
#' 
#' @param res A numeric. The initial resolution of the plots.
#' 
#' @export
run_app <- function(
  which = c(
    "risk-adjusted-returns",
    "purchasing-power"
  ),
  res = 120
) {

  which <- match.arg(which)

  withr::local_options(
    list(
      R4GPF.plot_res = res
    )
  )

  shiny::runApp(
    system.file("apps", which, package = "R4GoodPersonalFinances"), 
    display.mode = "normal"
  )
}