test_that("simulating multiple scenarios", {

  older_member <- HouseholdMember$new(
    name       = "older",  
    birth_date = "1980-02-15"
  )  
  older_member$mode       <- 80
  older_member$dispersion <- 10
  older_member$set_event("retirement", 65)

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
      "!members$older$events$retirement ~ 10000 * 12",
      "members$older$events$retirement ~ 1000 * 12"
    )
  )
  household$expected_spending <- list(
    "spending1" = c(
      "TRUE ~ 6000 * 12"
    )
  )
  
  portfolio <- generate_test_asset_returns(2)$returns

  start_ages <- c(60, 65, 70, 75, 80)

  scenarios_parameters <- 
    tibble::tibble(
      member    = "older",
      event      = "retirement",
      start_age = start_ages,
      years     = Inf,
      end_age   = Inf
    ) |> 
    dplyr::mutate(
      scenario_id = start_age
    ) |> 
    tidyr::nest(events = -scenario_id)
  
  if (interactive()) print(scenarios_parameters)
  if (interactive()) scenarios_parameters |> tidyr::unnest(events) |> print()
    
  test_current_date <- "2020-07-15"

  scenarios <- 
    simulate_scenarios(
      scenarios_parameters = scenarios_parameters,
      household            = household,
      portfolio            = portfolio,
      current_date         = test_current_date
    )
  
  expect_equal(
    unique(scenarios$scenario_id),
    start_ages
  )
  expect_equal(
    scenarios |> dplyr::count(scenario_id) |> dplyr::pull(n),
    rep(
      household$get_lifespan(current_date = test_current_date) + 1, 
      NROW(scenarios_parameters)
    )
  )
  expect_snapshot(
    scenarios |> 
      dplyr::group_by(scenario_id) |> 
      dplyr::summarise(total_income = sum(total_income)) 
  )
})
