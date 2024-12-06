devtools::dev_sitrep()

devtools::build_readme()

renv::upgrade()
renv::update()

usethis::use_version(which = "dev")
# usethis::use_version(which = "patch")
# usethis::use_version(which = "minor")

devtools::build_readme()
pkgdown::build_site(preview = FALSE)
pkgdown::preview_site()

