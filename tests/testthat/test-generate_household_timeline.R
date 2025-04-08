test_that("generating household timeline", {
  
  h <- Household$new()

  older_member <- 
    HouseholdMember$new(
      name       = "older",  
      birth_date = "1980-02-15"
    )  
  h$add_member(older_member)  
  
  younger_member <- 
  HouseholdMember$new(
    name       = "younger",  
    birth_date = "1990-07-15"
  )
  h$add_member(younger_member)  

  test_current_date <- "2020-07-15"

  timeline <- 
    generate_household_timeline(
      household    = h, 
      current_date = test_current_date
    ) 
  
  if (interactive()) timeline |> print(width = Inf)
  if (interactive()) tail(timeline, 3) |> print()

  expect_equal(
    NROW(timeline), 
    h$get_lifespan(current_date = test_current_date) + 1
  )

  expect_equal(min(timeline$index), 0)
  expect_equal(
    max(timeline$index), 
    h$get_lifespan(current_date = test_current_date)
  )

  expect_equal(min(timeline$years_left), 0)
  expect_equal(
    timeline$years_left[1], 
    h$get_lifespan(current_date = test_current_date) 
  )

  expect_equal(
    range(timeline$year),
    c(
      lubridate::year(test_current_date), 
      lubridate::year(test_current_date) + 
        h$get_lifespan(current_date = test_current_date)
    )
  )

  expect_true(
    tibble::is_tibble(timeline$hm)
  )
  expect_equal(
    names(timeline$hm),
    h$get_members() |> names()
  )
  expect_true(timeline$hm[[1]]$age |> is.numeric())
  expect_true(timeline$hm[[2]]$age |> is.numeric())
})

test_that("generating household timeline with flags", {
  
  h <- Household$new()

  older_member <- 
    HouseholdMember$new(
      name       = "older",  
      birth_date = "1980-02-15"
    )  
  older_member$set_age_flag("retirement", 45)
  older_member$set_age_flag("social_security", 47)
  h$add_member(older_member)  
  
  younger_member <- 
  HouseholdMember$new(
    name       = "younger",  
    birth_date = "1990-07-15"
  )
  younger_member$set_age_flag("retirement", 35)
  younger_member$set_age_flag("kid", 35, years = 2)
  h$add_member(younger_member)  

  test_current_date <- "2020-07-15"

  timeline <- 
    generate_household_timeline(
      household    = h, 
      current_date = test_current_date
    ) 
  
  if (interactive()) timeline |> print(width = Inf)
  
  expect_true(is.logical(timeline$hm[[1]]$flags$retirement))
  expect_true(is.logical(timeline$hm[[1]]$flags$social_security))
  
  expect_true(is.logical(timeline$hm[[2]]$flags$retirement))
})
