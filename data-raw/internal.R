apps <- list()

apps$`risk-adjusted-returns` <- list()
apps$`risk-adjusted-returns`$ui <- 
  readLines(
    system.file(
      "apps", "risk-adjusted-returns", "ui.R", 
      package = "R4GoodPersonalFinances"
    )
  )
apps$`risk-adjusted-returns`$server <- 
  readLines(
    system.file(
      "apps", "risk-adjusted-returns", "server.R", 
      package = "R4GoodPersonalFinances"
    )
  )
  
apps$`purchasing-power` <- list()
apps$`purchasing-power`$ui <-
  readLines(
    system.file(
      "apps", "purchasing-power", "ui.R", 
      package = "R4GoodPersonalFinances"
    )
  )
apps$`purchasing-power`$server <-
  readLines(
    system.file(
      "apps", "purchasing-power", "server.R", 
      package = "R4GoodPersonalFinances"
    )
  )

apps$package_version <- utils::packageVersion("R4GoodPersonalFinances")

usethis::use_data(
  apps,
  overwrite = TRUE, 
  internal = TRUE
)
