test_that("calculating retirement ruin probability", {

  ruin_probability <- 
    calc_retirement_ruin(
      spending_rate         = 1/20,
      portfolio_value       = 20,
      portfolio_return_mean = 0.07,
      portfolio_return_sd   = 0.20,
      expected_lifetime     = 1 / (log(2) / 28.1)
    )

  expect_equal(round(ruin_probability, 3), 0.268)


  ruin_probs <- 
    calc_retirement_ruin(
      spending_rate         = seq(0.02, 0.07, by = 0.01),
      portfolio_value       = 20,
      portfolio_return_mean = 0.07,
      portfolio_return_sd   = 0.20,
      expected_lifetime     = 1 / (log(2) / 28.1)
    )

    ruin_probs
    
})
   



  

