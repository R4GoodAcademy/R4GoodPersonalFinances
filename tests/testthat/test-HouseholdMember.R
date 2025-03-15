test_that("setting birth date", {

  test_birth_date <- "1980-07-15"
  
  hm <- HouseholdMember$new(
    name       = "test_name",
    birth_date = test_birth_date
  )
  
  expect_true(
    inherits(hm, "HouseholdMember")
  )
  
  expect_true(
    inherits(hm$get_birth_date(), "Date")
  )
  
  expect_equal(
    as.character(hm$get_birth_date()), 
    test_birth_date
  )

  expect_equal(
    hm$get_name(),
    "test_name"
  )
})

test_that("setting max age", {
  
  test_birth_date <- "1980-07-15"
  test_max_age    <- 120

  hm <- HouseholdMember$new(
    name       = "test_name",
    birth_date = test_birth_date
  )
  expect_equal(hm$max_age, 100)

  hm$max_age <- test_max_age
  expect_equal(
    hm$max_age,
    test_max_age
  )
})

test_that("calculating age", {

  test_birth_date   <- "1980-07-15"
  test_current_date <- 
    c("2020-07-15", "2025-01-01", "2080-07-15", "2080-07-16")
  
  hm <- HouseholdMember$new(
    name       = "test_name",
    birth_date = test_birth_date
  )
  
  expect_snapshot_value(
    style = "json2",
    hm$calc_age(current_date = test_current_date)
  )
})

test_that("calculating max lifespan", {
  
  test_birth_date   <- "1980-07-15"
  test_current_date <- 
    c("2020-07-15", "2025-01-01", "2080-07-15", "2080-07-16")
  
  hm <- HouseholdMember$new(
    name       = "test_name",
    birth_date = test_birth_date
  )

  expect_snapshot_value(
    style = "json2",
    hm$calc_max_lifespan(current_date = test_current_date)
  )
})
