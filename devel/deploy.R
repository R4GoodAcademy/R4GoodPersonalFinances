renv::status()
renv::upgrade()
renv::update()
renv::snapshot()

devtools::dev_sitrep()

usethis::use_version()
# usethis::use_version(which = "patch")
# usethis::use_version(which = "minor")

source("data-raw/internal.R")

rstudioapi::restartSession()
# pak::local_install(upgrade = FALSE, ask = FALSE)

devtools::document()
devtools::build_readme()
pkgdown::build_site(preview = FALSE)
pkgdown::preview_site()

# roxygen2md::roxygen2md()

spelling::spell_check_package()
spelling::update_wordlist()

citation("R4GoodPersonalFinances")

urlchecker::url_check()
urlchecker::url_update()

usethis::use_tidy_description()

devtools::test_coverage()

# usethis::use_github_action()
# usethis::use_pkgdown_github_pages()


citation <- readLines("inst/CITATION")
citation
current_year <- lubridate::year(Sys.Date())
current_year <- 2025
citation[5] <- glue::glue("  year     = {current_year},")
citation[6] <- glue::glue("  note     = \"{sprintf(\"R package version %s, https://r4goodacademy.github.io/R4GoodPersonalFinances/\", as.character(packageVersion(\"R4GoodPersonalFinances\")))} \",")
citation
writeLines(citation, "inst/CITATION")
devtools::load_all()
citation('R4GoodPersonalFinances')

usethis::use_cran_comments()

devtools::check(remote = TRUE, manual = TRUE)

