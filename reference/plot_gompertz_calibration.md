# Plotting the results of Gompertz model calibration

Plotting the results of Gompertz model calibration

## Usage

``` r
plot_gompertz_calibration(params, mode, dispersion, max_age)
```

## Arguments

- params:

  A list returned by
  [`calc_gompertz_parameters()`](https://r4goodacademy.github.io/R4GoodPersonalFinances/reference/calc_gompertz_parameters.md)
  function.

- mode:

  A numeric. The mode of the Gompertz model.

- dispersion:

  A numeric. The dispersion of the Gompertz model.

- max_age:

  A numeric. The maximum age of the Gompertz model.

## Value

A
[`ggplot2::ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html)
object showing the comparison between actual survival rates from life
tables and the fitted Gompertz model.

## Examples

``` r
mortality_rates <- 
  dplyr::filter(
    life_tables,
    country == "USA" & 
    sex     == "female" &
    year    == 2022
  )
  
params <- calc_gompertz_parameters(
  mortality_rates = mortality_rates,
  current_age     = 65
)

plot_gompertz_calibration(params = params)
```
