apps <- list()

apps$`risk-adjusted-returns` <-
  readLines(
    system.file(
      "apps", "risk-adjusted-returns", "app.R", 
      package = "R4GoodPersonalFinances"
    )
  )
  
apps$`purchasing-power` <-
  readLines(
    system.file(
      "apps", "purchasing-power", "app.R", 
      package = "R4GoodPersonalFinances"
    )
  )

apps$package_version <- utils::packageVersion("R4GoodPersonalFinances")

usethis::use_data(
  apps,
  overwrite = TRUE, 
  internal = TRUE
)
