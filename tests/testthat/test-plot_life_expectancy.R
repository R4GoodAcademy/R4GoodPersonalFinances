
test_that("plotting life expectancy", {

  params <- list(
    default = list(mode = 91,       dispersion = 8.88),
    isabela = list(mode = 99.16564, dispersion = 8.88)
  )
  
  plot1 <- function() plot_life_expectancy(
    household = params
  ); if (interactive()) print(plot1())
  vdiffr::expect_doppelganger("plot1", plot1)
})

test_that("plotting life expectancy of a household", {


  household <- Household$new()
  household$add_member(
    HouseholdMember$new(
      name       = "isabela",  
      birth_date = Sys.Date() - lubridate::years(25),
      mode       = 99.10791, 
      dispersion = 8.88
    )  
  )  
  
  plot1 <- function() plot_life_expectancy(
    household = household
  ); if (interactive()) print(plot1())
  vdiffr::expect_doppelganger("plot1", plot1)
})
