# Plotting the results of Gompertz model calibration for joint survival

Plotting the results of Gompertz model calibration for joint survival

## Usage

``` r
plot_joint_survival(params, include_gompertz = FALSE)
```

## Arguments

- params:

  A list returned by
  [`calc_gompertz_joint_parameters()`](https://r4goodacademy.github.io/R4GoodPersonalFinances/reference/calc_gompertz_joint_parameters.md)
  function.

- include_gompertz:

  A logical. Should the Gompertz survival curve be included in the plot?

## Value

A
[`ggplot2::ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html)
object showing the survival probabilities for two individuals and their
joint survival probability.

## Examples

``` r
params <- calc_gompertz_joint_parameters(
  p1 = list(
    age        = 65,
    mode       = 88,
    dispersion = 10.65
  ),
  p2 = list(
    age        = 60,
    mode       = 91,
    dispersion = 8.88
  ),
  max_age = 110
)

plot_joint_survival(params = params, include_gompertz = TRUE)
```
