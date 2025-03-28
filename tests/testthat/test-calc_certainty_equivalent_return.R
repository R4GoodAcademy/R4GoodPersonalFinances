test_that("calculating certainty equivalent return (h)", {
  
  # h <- calc_certainty_equivalent_return(
  #   safe_asset_return = 0.02,
  #   risky_asset_sd    = 0.15,
  #   risk_tolerance    = 0.50
  # )
  # expect_equal(
  #   round(h, 6),
  #   0.025754
  # )

  h <- calc_certainty_equivalent_return(
    expected_return = 0.03370865,
    variance        = 0.004088745,
    risk_tolerance  = 0.25
  )
  expect_equal(
    round(h, 6),
    0.02529
  )
})
