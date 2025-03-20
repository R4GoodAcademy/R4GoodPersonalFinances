test_that("calculating discretionary spending", {

  expect_equal(
    calc_discretionary_spending(
      net_worth                         = 400000,
      discount_rate                     = 0.03,
      consumption_impatience_preference = 0.02,
      smooth_consumption_preference     = 0.50,
      current_age                       = 35,
      max_age                           = 120,
      gompertz_mode                     = 90,
      gompertz_dispersion               = 10
    ),
    13167.59957
  )
})
