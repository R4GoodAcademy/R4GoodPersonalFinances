#' Run a package app
#' 
#' @param which A character. The name of the app to run.
#' Currently available:
#' 
#' * `optimal-allocation` - Optimal Risky Asset Allocation
#' 
#' @export
run_app <- function(which = "optimal-allocation") {

  shiny::runApp(
    system.file("apps", which, package = "R4GoodPersonalFinances"), 
    display.mode = "normal"
  )
}