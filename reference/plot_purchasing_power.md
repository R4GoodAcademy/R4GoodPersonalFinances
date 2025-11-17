# Plotting changes to the purchasing power over time

Plots the effect of real interest rates (positive or negative) on the
purchasing power of savings over the span of 50 years (default).

## Usage

``` r
plot_purchasing_power(
  x,
  real_interest_rate,
  years = 50,
  legend_title = "Real interest rate",
  seed = NA
)
```

## Arguments

- x:

  A numeric. The initial amount of money.

- real_interest_rate:

  A numeric. The yearly real interest rate.

- years:

  A numeric. The number of years.

- legend_title:

  A character.

- seed:

  A numeric. Seed passed to `geom_label_repel()`.

## Value

A
[`ggplot2::ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html)
object.

## See also

- [How to Determine Our Optimal Asset
  Allocation?](https://www.r4good.academy/en/blog/optimal-asset-allocation/index.en.html#why-keeping-all-your-savings-in-cash-isnt-the-best-idea)

## Examples

``` r
plot_purchasing_power(
  x = 10,
  real_interest_rate = seq(-0.02, 0.04, by = 0.02)
)
#> Ignoring unknown labels:
#> • linetype : "Real interest rate"
```
