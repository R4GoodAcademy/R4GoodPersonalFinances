test_that("plotting expected allocation", {
  
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
    "income_older" = c(
      "members$older$age < 60 ~ 40000",
      "members$older$age >= 60 ~ 20000"
    ),
    "income_younger" = c(
      "members$younger$age < 50 ~ 40000"
    )
  )
  household$expected_spending <- list(
    "spending1" = c(
      "TRUE ~ 10000"
    )
  )
  test_current_date <- "2020-07-15"

  portfolio <- generate_test_asset_returns(2)$returns

  scenario <- 
    simulate_scenario(
      household    = household,
      portfolio    = portfolio,
      current_date = test_current_date
    )
  
  plot1 <- function() plot_expected_allocation(
    scenario = scenario
  ); if (interactive()) print(plot1())
  vdiffr::expect_doppelganger("plot1", plot1)

  plot2 <- function() plot_expected_allocation(
    scenario = scenario,
    accounts = "taxable"
  ); if (interactive()) print(plot2())
  vdiffr::expect_doppelganger("plot2", plot2)

  plot3 <- function() plot_expected_allocation(
    scenario = scenario,
    accounts = "taxadvantaged"
  ); if (interactive()) print(plot3())
  vdiffr::expect_doppelganger("plot3", plot3)
})
