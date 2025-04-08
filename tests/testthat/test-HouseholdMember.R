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
    c("2020-07-15", "2025-01-01", "2080-07-15", 
      "2080-07-16", "2081-07-11", "2081-07-18")

  hm <- HouseholdMember$new(
    name       = "test_name",
    birth_date = test_birth_date
  )
  expect_equal(hm$max_age, 100)
  
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
    hm$get_lifespan(current_date = test_current_date)
  )
})

test_that("setting gompertz parameters", {
  
  test_birth_date   <- "1980-07-15"
  test_current_date <- "2020-07-15"
  
  hm <- HouseholdMember$new(
    name       = "test_name",
    birth_date = test_birth_date
  )
  expect_null(hm$mode)
  expect_null(hm$dispersion)

  hm$mode <- 88
  expect_equal(hm$mode, 88)

  hm$dispersion <- 10
  expect_equal(hm$dispersion, 10)
})

test_that("calculating gompertz survival probability", {

  test_birth_date   <- "1955-07-15"
  test_current_date <- "2020-07-15"
  
  hm <- HouseholdMember$new(
    name       = "test_name",
    birth_date = test_birth_date
  )
  hm$mode       <- 80
  hm$dispersion <- 10
  
  expect_equal(
    hm$calc_survival_probability(
      target_age   = 85,
      current_date = test_current_date
    ),
    0.2404, 
    tolerance = 0.001
  )
})

test_that("setting age flag", {

  test_birth_date <- "1955-07-15"
  
  hm <- HouseholdMember$new(
    name       = "test_name",
    birth_date = test_birth_date
  )

  expect_true(is.list(hm$get_age_flags()))
  expect_equal(NROW(hm$get_age_flags()), 0)
  
  hm$set_age_flag("retirement", 65)
  expect_equal(hm$get_age_flags()$retirement$start_age, 65)
  expect_equal(hm$get_age_flags()$retirement$end_age, Inf)

  hm$set_age_flag("social_security", 70)
  expect_equal(hm$get_age_flags()$social_security$start_age, 70)
  expect_equal(hm$get_age_flags()$social_security$end_age, Inf)

  hm$set_age_flag("kid", 20, years = 20)
  expect_equal(hm$get_age_flags()$kid$start_age, 20)
  expect_equal(hm$get_age_flags()$kid$end_age, 40 - 1)

  expect_equal(NROW(hm$get_age_flags()), 3)
})
