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
    "Cite the package: citation('R4GoodPersonalFinances')"
  )

  packageStartupMessage(
    "Package documentation: https://r4goodacademy.github.io/R4GoodPersonalFinances/"
  )

  packageStartupMessage(
    "To learn more, visit: https://www.r4good.academy/"
  )

  packageStartupMessage(
    "... and Make Better Financial Decisions!"
  )
}

ignore_unused_imports <- function() {
   bsicons::bs_icon
   bslib::card
   shiny::a
}
