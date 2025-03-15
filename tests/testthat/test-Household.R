test_that("adding household members", {
  
  h <- Household$new()

  expect_true(is.list(h$get_members()))
  expect_true(length(h$get_members()) == 0)
  
  h$add_member(
    HouseholdMember$new(
      name       = "test_member_1",  
      birth_date = "1980-07-15"
    )
  )
  expect_equal(
    length(h$get_members()), 
    1
  )
  expect_true(
    inherits(h$get_members()[["test_member_1"]], "HouseholdMember")
  )
  
  expect_error(
    h$add_member(
      HouseholdMember$new(
        name       = "test_member_1",  
        birth_date = "1980-07-15"
      )
    )
  )

  h$add_member(
    HouseholdMember$new(
      name       = "test_member_2",  
      birth_date = "1980-07-15"
    )
  )
  expect_equal(
    length(h$get_members()), 
    2
  )
  expect_true(
    inherits(h$get_members()[["test_member_1"]], "HouseholdMember")
  )
  expect_true(
    inherits(h$get_members()[["test_member_2"]], "HouseholdMember")
  )
})

test_that("calculating household max lifespan", {
  
  h <- Household$new()

  h$calc_max_lifespan()
  
  h$add_member(
    HouseholdMember$new(
      birth_date = "1980-07-15"
    )
  )

  h$calc_max_lifespan()
})
