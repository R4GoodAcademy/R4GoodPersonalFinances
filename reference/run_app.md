# Run a package app

Run a package app

## Usage

``` r
run_app(
  which = c("risk-adjusted-returns", "purchasing-power", "retirement-ruin"),
  res = 120,
  shinylive = FALSE
)
```

## Arguments

- which:

  A character. The name of the app to run. Currently available:

  - `risk-adjusted-returns` - Plotting risk-adjusted returns for various
    allocations to the risky asset allows you to find the optimal
    allocation.

  - `purchasing-power` - Plotting the effect of real interest rates
    (positive or negative) on the purchasing power of savings over time.

  - `retirement-ruin` - Plotting the probability of retirement ruin.

- res:

  A numeric. The initial resolution of the plots.

- shinylive:

  A logical. Whether to use `shinylive` for the app.

## Value

A [`shiny::shinyApp()`](https://rdrr.io/pkg/shiny/man/shinyApp.html)
object if `shinylive` is `TRUE`. Runs the app if `shinylive` is `FALSE`
with [`shiny::runApp()`](https://rdrr.io/pkg/shiny/man/runApp.html).

## Examples

``` r
if (FALSE) { # interactive()
run_app("risk-adjusted-returns")
run_app("purchasing-power")
run_app("retirement-ruin")
}
```
