test_that("simulating single scenario with expected returns", {
  
  older_member <- HouseholdMember$new(
    name       = "older",  
    birth_date = "1980-02-15"
  )  
  older_member$mode       <- 80
  older_member$dispersion <- 10

  household <- Household$new()
  household$add_member(older_member)  
  
  household$expected_income <- list(
    "income_older" = c(
      "members$older$age >= 46 ~ 3000"
    )
  )
  household$expected_spending <- list(
    "spending1" = c(
      "TRUE ~ 6000 * 12"
    )
  )
  test_current_date <- "2020-07-15"
  portfolio <- generate_test_asset_returns(2)$returns

  scenario <- 
    simulate_single_scenario(
      household    = household,
      portfolio    = portfolio,
      current_date = test_current_date
    )

  expect_equal(
    ignore_attr = TRUE,
    scenario$portfolio$returns |> sapply(function(x) unique(x)),
    portfolio$expected_return
  )
})

test_that("simulating single scenario with random returns", {
  
  older_member <- HouseholdMember$new(
    name       = "older",  
    birth_date = "1980-02-15"
  )  
  older_member$mode       <- 80
  older_member$dispersion <- 10

  household <- Household$new()
  household$add_member(older_member)  
  
  household$expected_income <- list(
    "income_older" = c(
      "members$older$age >= 46 ~ 3000"
    )
  )
  household$expected_spending <- list(
    "spending1" = c(
      "TRUE ~ 6000 * 12"
    )
  )
  test_current_date <- "2020-07-15"
  portfolio <- generate_test_asset_returns(2)$returns

  scenario <- 
    simulate_single_scenario(
      household      = household,
      portfolio      = portfolio,
      current_date   = test_current_date,
      random_returns = TRUE,
      seed           = 123
    )
  
  expect_equal(
    ignore_attr = TRUE,
    scenario$portfolio$returns |> 
      sapply(function(x) {
        sd(x) > 0
      }),
    portfolio$standard_deviation > 0
  )
})

test_that("simulating single scenario with event", {
  
  older_member <- HouseholdMember$new(
    name       = "older",  
    birth_date = "1980-02-15"
  )  
  older_member$mode       <- 80
  older_member$dispersion <- 10
  older_member$set_event("retirement", 46)

  household <- Household$new()
  household$add_member(older_member)  
  
  household$expected_income <- list(
    "income_older" = c(
      "members$older$events$retirement$on ~ 3000"
    )
  )
  household$expected_spending <- list(
    "spending1" = c(
      "TRUE ~ 6000 * 12"
    )
  )
  test_current_date <- "2020-07-15"
  portfolio <- generate_test_asset_returns(2)$returns

  scenario <- 
    simulate_single_scenario(
      household      = household,
      portfolio      = portfolio,
      current_date   = test_current_date,
      random_returns = TRUE,
      seed           = 123
    )
  expect_equal(
    sum(scenario$income$income_older),
    165000
  )
  expect_snapshot(scenario$income$income_older)
})

test_that("simulating single scenario with event and id_on helper functions", {
  
  older_member <- HouseholdMember$new(
    name       = "older",  
    birth_date = "1980-02-15"
  )  
  older_member$mode       <- 80
  older_member$dispersion <- 10
  older_member$set_event("retirement", 46)

  household <- Household$new()
  household$add_member(older_member)  
  
  household$expected_income <- list(
    "income_older" = c(
      "is_on('older', 'retirement') ~ 3000"
    ),
    "income_older_negative" = c(
      "!is_on('older', 'retirement') ~ 3000"
    ),
    "income_older_is_off" = c(
      "is_off('older', 'retirement') ~ 3000"
    )
  )
  household$expected_spending <- list(
    "spending1" = c(
      "TRUE ~ 6000 * 12"
    )
  )
  test_current_date <- "2020-07-15"
  portfolio <- generate_test_asset_returns(2)$returns

  scenario <- 
    simulate_single_scenario(
      household      = household,
      portfolio      = portfolio,
      current_date   = test_current_date,
      random_returns = TRUE,
      seed           = 123
    )
  if (interactive()) print(scenario$income, width = Inf)
  
  expect_equal(
    sum(scenario$income$income_older),
    165000
  )
  expect_snapshot(scenario$income$income_older)

  expect_equal(
    sum(scenario$income$income_older_negative),
    18000
  )
  expect_equal(
    sum(scenario$income$income_older_is_off),
    sum(scenario$income$income_older_negative)
  )
})
