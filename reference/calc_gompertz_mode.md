# Calculate Gompertz mode for a given life expectancy

Calculate Gompertz mode for a given life expectancy

## Usage

``` r
calc_gompertz_mode(life_expectancy, current_age, dispersion, max_age = 120)
```

## Arguments

- life_expectancy:

  A numeric. Desired life expectancy.

- current_age:

  A numeric. Current age.

- dispersion:

  A numeric. Dispersion of the Gompertz distribution.

- max_age:

  A numeric. Maximum age. Defaults to 120.

## Value

A numeric. Mode of the Gompertz distribution.

## Examples

``` r
calc_gompertz_mode(
 life_expectancy = 86,
  current_age    = 25,
  dispersion     = 8.88,
  max_age        = 115
)
#> [1] 91.08473
```
