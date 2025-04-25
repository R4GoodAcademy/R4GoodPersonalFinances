test_that("plotting scenarios metrics", {

  older_member <- HouseholdMember$new(
    name       = "older",  
    birth_date = "1980-02-15"
  )  
  older_member$mode       <- 80
  older_member$dispersion <- 10
  older_member$set_flag("retirement", 65)

  younger_member <- HouseholdMember$new(
    name       = "younger",  
    birth_date = "1990-07-15"
  )
  younger_member$mode       <- 85
  younger_member$dispersion <- 9

  household <- Household$new()
  household$add_member(older_member)  
  household$add_member(younger_member)
  
  household$expected_income <- list(
    "income_older" = c(
      "!hm$older$flags$retirement ~ 10000 * 12",
      "hm$older$flags$retirement ~ 1000 * 12"
    )
  )
  household$expected_spending <- list(
    "spending1" = c(
      "TRUE ~ 6000 * 12"
    )
  )
  
  portfolio <- generate_test_asset_returns(2)$returns

  start_ages <- c(55, 65, 75, 88)

  scenarios_parameters <- 
    tibble::tibble(
      member    = "older",
      flag      = "retirement",
      start_age = start_ages,
      years     = Inf,
      end_age   = Inf
    ) |> 
    dplyr::mutate(
      scenario_id = start_age
    ) |> 
    tidyr::nest(flags = -scenario_id)
  
  test_current_date <- "2020-07-15"

  scenarios <- 
    simulate_scenarios(
      scenarios_parameters = scenarios_parameters,
      household            = household,
      portfolio            = portfolio,
      current_date         = test_current_date
    )
  
    plot1 <- function() plot_scenarios(
      scenarios = scenarios
    ); if (interactive()) print(plot1())
    vdiffr::expect_doppelganger("plot1", plot1)
  
    plot2 <- function() plot_scenarios(
      scenarios = scenarios,
      period    = "monthly"
    ); if (interactive()) print(plot2())
    vdiffr::expect_doppelganger("plot2", plot2)
})
