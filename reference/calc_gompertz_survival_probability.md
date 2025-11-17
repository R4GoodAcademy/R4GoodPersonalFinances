# Calculating Gompertz survival probability

Calculating Gompertz survival probability

## Usage

``` r
calc_gompertz_survival_probability(
  current_age,
  target_age,
  mode,
  dispersion,
  max_age = NULL
)
```

## Arguments

- current_age:

  Current age

- target_age:

  Target age

- mode:

  Mode of the Gompertz distribution

- dispersion:

  Dispersion of the Gompertz distribution

- max_age:

  Maximum age. Defaults to `NULL`.

## Value

A numeric. The probability of survival from 'current_age' to
'target_age' based on the Gompertz distribution with the given
parameters.

## Examples

``` r
calc_gompertz_survival_probability(
  current_age = 65, 
  target_age  = 85, 
  mode        = 80, 
  dispersion  = 10
)
#> [1] 0.2403663
```
