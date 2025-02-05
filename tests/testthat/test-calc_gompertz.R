test_that("calibrating gompertz model parameters for males", {

  mortality_rates <- test_mortality_rates$males

  expect_equal(tail(mortality_rates$mortality_rate, 1), 1)
  
  params <- 
    mortality_rates |> 
      calc_gompertz_paramaters(current_age = 65)
    
  expect_equal(head(params$mortality_rates$survival_rate, 1), 1)
  expect_equal(tail(params$mortality_rates$survival_rate, 1), 0)
  expect_equal(params$mortality_rates$probability_of_death |> sum(), 1)
  
  pod_males <- 
    function() {
      plot(
        x = params$mortality_rates$age,
        y = params$mortality_rates$probability_of_death
      )
    }
  if (interactive()) print(pod_males())
  vdiffr::expect_doppelganger("pod_males", pod_males)
  
  expect_equal(params$mode, 86)
  expect_equal(params$dispersion, 10.48, tolerance = 0.01)

  sr_males <- 
    function() {
      plot(
        x = params$mortality_rates$age,
        y = params$mortality_rates$survival_rate
      )
      lines(
        x = params$mortality_rates$age,
        y = params$mortality_rates$survival_rate_gompertz
      )
    }
  if (interactive()) print(sr_males())
  vdiffr::expect_doppelganger("sr_males", sr_males)
})
test_that("calibrating gompertz model parameters for females", {
  
  mortality_rates <- test_mortality_rates$females
  
  expect_equal(tail(mortality_rates$mortality_rate, 1), 1)
  
  params <- 
    mortality_rates |> 
      calc_gompertz_paramaters(current_age = 65)
    
  expect_equal(head(params$mortality_rates$survival_rate, 1), 1)
  expect_equal(tail(params$mortality_rates$survival_rate, 1), 0)
  expect_equal(params$mortality_rates$probability_of_death |> sum(), 1)

  pod_females <- 
    function() {
      plot(
        x = params$mortality_rates$age,
        y = params$mortality_rates$probability_of_death
      )
    }
  if (interactive()) print(pod_females())
  vdiffr::expect_doppelganger("pod_females", pod_females)

  expect_equal(params$mode, 90)
  expect_equal(params$dispersion, 8.63, tolerance = 0.01)
  
  sr_females <- 
    function() {
      plot(
        x = params$mortality_rates$age,
        y = params$mortality_rates$survival_rate
      )
      lines(
        x = params$mortality_rates$age,
        y = params$mortality_rates$survival_rate_gompertz
      )
    }
  if (interactive()) print(sr_females())
  vdiffr::expect_doppelganger("sr_females", sr_females)
})

