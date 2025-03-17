test_that("calculating present value", {

  test_cashflow <- rep(100000, 10)
  
  pv <- calc_present_value(
    cashflow      = test_cashflow,
    discount_rate = 0.02
  )

  expect_equal(
    pv,
    916223.671
  )
})
