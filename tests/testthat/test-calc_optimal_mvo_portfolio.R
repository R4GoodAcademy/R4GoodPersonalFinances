test_that("calculating expected utility", {

  expect_equal(
    calc_expected_utility(
      expected_return = 0.04,
      variance        = 0.15,
      risk_tolerance  = 0.50
    ),
    -1.0948879
  )

  expect_equal(
    calc_expected_utility(
      expected_return = 0.05,
      variance        = 0.15,
      risk_tolerance  = 0.50
    ),
    -1.08195659
  )
})


test_that("calculating optimal allocations for 2 assets", {

  n <- 2
  test_asset_returns <- generate_test_asset_returns(n)$returns
  if (interactive()) print(test_asset_returns)
  test_asset_correlations <- generate_test_asset_returns(n)$correlations
  if (interactive()) print(test_asset_correlations)

  optimal_allocations <- 
    calc_optimal_mvo_portfolio(
    risk_tolerance      = 0.50,
    expected_returns    = test_asset_returns$expected_return,
    standard_deviations = test_asset_returns$standard_deviation,
    correlations        = test_asset_correlations
  ) 
  if (interactive()) print(print_percent(optimal_allocations))

  expect_equal(
    round(optimal_allocations, 4),
    c(0.58480, 0.41520)
  )
  expect_equal(sum(optimal_allocations), 1)
})

test_that("calculating optimal allocations for 3 assets", {

  n <- 3
  test_asset_returns <- generate_test_asset_returns(n)$returns
  if (interactive()) print(test_asset_returns)
  test_asset_correlations <- generate_test_asset_returns(n)$correlations
  if (interactive()) print(test_asset_correlations)

  optimal_allocations <- 
    calc_optimal_mvo_portfolio(
    risk_tolerance      = 0.35,
    expected_returns    = test_asset_returns$expected_return,
    standard_deviations = test_asset_returns$standard_deviation,
    correlations        = test_asset_correlations
  ) 
  if (interactive()) print(print_percent(optimal_allocations))

  expect_equal(
    round(optimal_allocations, 3),
    c(0.273, 0.089, 0.638)
  )
  expect_equal(sum(optimal_allocations), 1)
})

test_that("calculating optimal allocations for 9 assets", {

  n <- 9
  test_asset_returns <- generate_test_asset_returns(n)$returns
  if (interactive()) print(test_asset_returns)
  test_asset_correlations <- generate_test_asset_returns(n)$correlations
  if (interactive()) print(test_asset_correlations)

  optimal_allocations <- 
    calc_optimal_mvo_portfolio(
    risk_tolerance      = 0.35,
    expected_returns    = test_asset_returns$expected_return,
    standard_deviations = test_asset_returns$standard_deviation,
    correlations        = test_asset_correlations
  ) 
  if (interactive()) print(print_percent(optimal_allocations))

  expect_equal(
    round(optimal_allocations, 3),
    c(0.247, 0.221, 0.26, 0.187, 0, 0, 0, 0.085, 0)
  )
  expect_equal(sum(optimal_allocations), 1)
})
