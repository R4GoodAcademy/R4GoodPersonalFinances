# Calculate Life Expectancy

Calculate Life Expectancy

## Usage

``` r
calc_life_expectancy(current_age, mode, dispersion, max_age = 120)
```

## Arguments

- current_age:

  A numeric. Current age.

- mode:

  A numeric. Mode of the Gompertz distribution.

- dispersion:

  A numeric. Dispersion of the Gompertz distribution.

- max_age:

  A numeric. Maximum age. Defaults to 120.

## Value

A numeric. Total life expectancy in years.

## Examples

``` r
calc_life_expectancy(
  current_age = 65, 
  mode        = 80, 
  dispersion  = 10
)
#> [1] 79.17742
```
