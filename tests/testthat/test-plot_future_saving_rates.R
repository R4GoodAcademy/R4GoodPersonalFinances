test_that("plotting future saving rates", {
  
  older_member <- HouseholdMember$new(
    name       = "older",  
    birth_date = "1980-02-15"
  )  
  older_member$mode       <- 80
  older_member$dispersion <- 10

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
    "income_1" = c(
      "members$older$age < 65 ~ 30000",
      "members$older$age >= 65 ~ 1000"
    )
  )
  household$expected_spending <- list(
    "spending1" = c(
      "members$older$age <= 65 ~ 3000"
    ),
    "spending2" = c(
      "TRUE ~ 15000"
    )
  )
  test_current_date <- "2000-07-15"
  portfolio <- generate_test_asset_returns(2)$returns
  portfolio$accounts$taxable <- c(1, 1)
  portfolio$accounts$taxadvantaged <- c(0, 0)

  scenario <- 
    simulate_scenario(
      household    = household,
      portfolio    = portfolio,
      current_date = test_current_date
    )
  
  plot <- plot_future_saving_rates(
    scenario = scenario
  ); if (interactive()) print(plot)
  vdiffr::expect_doppelganger("plot_fsr", plot)
})

test_that("plotting future saving rates for multiple samples", {
  
  older_member <- HouseholdMember$new(
    name       = "older",  
    birth_date = "1980-02-15"
  )  
  older_member$mode       <- 80
  older_member$dispersion <- 10

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
    "income_1" = c(
      "members$older$age < 65 ~ 30000",
      "members$older$age >= 65 ~ 1000"
    )
  )
  household$expected_spending <- list(
    "spending1" = c(
      "members$older$age <= 65 ~ 3000"
    ),
    "spending2" = c(
      "TRUE ~ 15000"
    )
  )
  test_current_date <- "2000-07-15"
  portfolio <- generate_test_asset_returns(2)$returns
  portfolio$accounts$taxable <- c(1, 1)
  portfolio$accounts$taxadvantaged <- c(0, 0)

  scenario <- 
    simulate_scenario(
      household    = household,
      portfolio    = portfolio,
      current_date = test_current_date,
      monte_carlo_samples = 1,
      seeds = 1234
    )
  
  plot <- plot_future_saving_rates(
    scenario = scenario
  ); if (interactive()) print(plot)
  vdiffr::expect_doppelganger("plot_fsrmc", plot)
})
