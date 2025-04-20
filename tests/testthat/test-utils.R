test_that("printing percent", {

  print_percent(0.52366) |> expect_snapshot()
  print_percent(0.52366, accuracy = 0.01) |> expect_snapshot()
  print_percent(list(a = 0.52366, b = 0.23456, c = "test")) |> 
    expect_snapshot()
  print_percent(
    list(
      a = 0.52366, 
      b = 0.23456, 
      c = "test", 
      d = list(
        a = 0.52366, 
        b = 0.23456, 
        c = "test"
      )), 
    accuracy = 0.01
  ) |> 
    expect_snapshot()
})

test_that("printing currency", {

  print_currency(234) |> expect_snapshot()
  print_currency(234, prefix = "$") |> expect_snapshot()
  print_currency(234, suffix = " PLN") |> expect_snapshot()
  print_currency(1234567.123456) |> expect_snapshot()
  print_currency(1234567.123456, accuracy = 0.01) |> expect_snapshot()
  print_currency(list(a = 234, b = 1234567.123456, c = "test")) |> 
    expect_snapshot()
  print_currency(
    list(
      a = 234, 
      b = 1234567.123456, 
      c = "test", 
      d = list(
        a = 234, 
        b = 1234567.123456, 
        c = "test"
      )), 
    accuracy = 0.01
  ) |> 
    expect_snapshot()
})

test_that("getting default current date", {

  withr::local_options(
    R4GPF.current_date = NULL
  )

  expect_equal(
    get_current_date(),
    Sys.Date()
  )
})

test_that("getting custom current date", {

  test_current_date <- "2020-01-01"

  withr::local_options(
    R4GPF.current_date = test_current_date
  )

  expect_equal(
    get_current_date(),
    lubridate::as_date(test_current_date)
  )
})
