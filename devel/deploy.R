devtools::dev_sitrep()


renv::upgrade()
renv::update()

usethis::use_version(which = "dev")
# usethis::use_version(which = "patch")
# usethis::use_version(which = "minor")

devtools::build_readme()
pkgdown::build_site(preview = FALSE)
pkgdown::preview_site()

spelling::spell_check_package()


  rstudioapi::restartSession()
  {
    pak::local_install(upgrade = FALSE, ask = FALSE)
    devtools::document()
    devtools::load_all()
    ?calc_optimal_risky_asset_allocation
  }

  rstudioapi::restartSession()
  pkgdown::build_site(preview = FALSE)
