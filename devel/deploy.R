renv::upgrade()
renv::update()

devtools::dev_sitrep()

usethis::use_version()
# usethis::use_version(which = "patch")
# usethis::use_version(which = "minor")

rstudioapi::restartSession()
# pak::local_install(upgrade = FALSE, ask = FALSE)

devtools::document()
devtools::build_readme()
pkgdown::build_site(preview = FALSE)
pkgdown::preview_site()

roxygen2md::roxygen2md()

spelling::spell_check_package()
spelling::update_wordlist()

citation("R4GoodPersonalFinances")

urlchecker::url_check()

usethis::use_tidy_description()

devtools::test_coverage()

usethis::use_github_action()
usethis::use_pkgdown_github_pages()
