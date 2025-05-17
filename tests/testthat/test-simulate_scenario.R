test_that("simulating a default scenario with expected returns", {

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
      "members$older$age >= 44 & members$older$age < 46 ~ 100",
      "members$older$age >= 46 ~ 300"
    ),
    "income_younger" = c(
      "members$younger$age >= 34 ~ 200"
    )
  )
  household$expected_spending <- list(
    "spending1" = c(
      "TRUE ~ 6000"
    )
  )
  expect_equal(household$consumption_impatience_preference, 0.04)
  expect_equal(household$smooth_consumption_preference, 1)
  
  test_current_date <- "2020-07-15"

  portfolio <- generate_test_asset_returns(2)$returns
  if (interactive()) portfolio |> print(width = Inf)
  if (interactive()) portfolio$correlations |> print()
  if (interactive()) portfolio$accounts |> print()

  scenario <- 
    simulate_scenario(
      household    = household,
      portfolio    = portfolio,
      current_date = test_current_date
    )
  
  expect_true(tibble::is_tibble(scenario$members))
  expect_true(tibble::is_tibble(scenario$income))
  expect_true(tibble::is_tibble(scenario$spending))
  
  expect_true(is.double(scenario$total_income))
  expect_true(is.double(scenario$nondiscretionary_spending))
  expect_true(is.double(scenario$human_capital))
  expect_true(is.double(scenario$liabilities))
  expect_true(is.double(scenario$discretionary_spending))

  expect_equal(tail(scenario$discretionary_spending, 1), 0)

  expect_equal(unique(scenario$scenario_id), "default")
  expect_equal(unique(scenario$sample), 0)

  if (interactive()) scenario |>  print(width = Inf, n = Inf)
  if (interactive()) scenario |>  head(3) |> print(width = Inf)
  if (interactive()) scenario |>  tail(3) |> print(width = Inf)
})

test_that("simulating a scenario with Monte Carlo samples", {

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
      "members$older$age >= 44 & members$older$age < 46 ~ 100",
      "members$older$age >= 46 ~ 300"
    )
  )
  household$expected_spending <- list(
    "spending1" = c(
      "TRUE ~ 16000"
    )
  )
  test_current_date <- "2020-07-15"
  portfolio <- generate_test_asset_returns(2)$returns

  scenario <- 
    simulate_scenario(
      household    = household,
      portfolio    = portfolio,
      current_date = test_current_date,
      monte_carlo_samples = 2
    )
  
  expect_equal(
    unique(scenario$sample),
    c(0:2)
  )
})
