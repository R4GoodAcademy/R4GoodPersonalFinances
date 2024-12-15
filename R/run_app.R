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
#' @param shinylive A logical. Should the app be run in `shinylive`?
#' Default is `FALSE`. If `TRUE`, the app will use cached code
#' without using filesystem.
#' 
#' @export
run_app <- function(
  which = c(
    "risk-adjusted-returns",
    "purchasing-power"
  ),
  res = 120,
  shinylive = FALSE
) {

  which <- match.arg(which)

  withr::local_options(
    list(
      R4GPF.plot_res = res
    )
  )

  if (shinylive) {

    app <- apps[[which]]
    temp_path <- file.path(tempdir(), "app.R")
    writeLines(app, temp_path)
    app <- temp_path
    shiny::shinyAppFile(app)

  } else {

    app <- system.file("apps", which, package = "R4GoodPersonalFinances")
    shiny::runApp(
      app,
      display.mode = "normal"
    )
  }
    
}