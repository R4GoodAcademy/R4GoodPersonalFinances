test_that("generating cashflows", {

  h <- Household$new()
  h$add_member(
    HouseholdMember$new(
      name       = "older",  
      birth_date = "1980-02-15"
    )  
  )  
  h$add_member(
    HouseholdMember$new(
      name       = "younger",  
      birth_date = "1990-07-15"
    )
  )  

  test_current_date <- "2020-07-15"

  timeline <- 
    generate_household_timeline(
      household    = h, 
      current_date = test_current_date
    ) 
  
  test_triggers <- list(
    "income1" = c(
      "hm$older$age >= 44 & hm$older$age < 46 ~ 100",
      "hm$older$age >= 46 ~ 300"
    ),
    "income2" = c(
      "hm$younger$age >= 34 & hm$younger$age < 36 ~ 44",
      "hm$younger$age >= 36 ~ 55"
    )
  )
  
  cashflows <- generate_cashflow_streams(
    timeline = timeline,
    triggers = test_triggers
  ) 
  expect_equal(
    sum(cashflows$income1),
    16400
  )
  expect_equal(
    sum(cashflows$income2),
    3663
  )
})
