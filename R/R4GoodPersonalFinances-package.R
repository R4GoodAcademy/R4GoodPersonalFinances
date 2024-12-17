#' @keywords internal
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL

.onAttach <- function(libname, pkgname) {

  pkg_version <- utils::packageVersion(pkgname)
  packageStartupMessage(
    glue::glue("Welcome to {pkgname} version {pkg_version}!")
  )
  packageStartupMessage(
    "To learn more, visit: https://www.r4good.academy/"
  )
}

ignore_unused_imports <- function() {
   bsicons::bs_icon
   bslib::card
   shiny::a
}
