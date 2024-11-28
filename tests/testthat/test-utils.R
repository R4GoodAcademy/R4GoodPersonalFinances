test_that("printing percent", {

  print_percent(0.52366) |> expect_snapshot()
  print_percent(0.52366, accuracy = 0.01) |> expect_snapshot()
})

test_that("printing currency", {

  print_currency(234) |> expect_snapshot()
  print_currency(234, prefix = "$") |> expect_snapshot()
  print_currency(234, suffix = " PLN") |> expect_snapshot()
  print_currency(1234567.123456) |> expect_snapshot()
  print_currency(1234567.123456, accuracy = 0.01) |> expect_snapshot()
})
