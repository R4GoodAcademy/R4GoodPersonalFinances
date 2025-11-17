# Calculating the Gompertz model parameters for joint survival

Calculating the Gompertz model parameters for joint survival

## Usage

``` r
calc_gompertz_joint_parameters(
  p1 = list(age = NULL, mode = NULL, dispersion = NULL),
  p2 = list(age = NULL, mode = NULL, dispersion = NULL),
  max_age = 120
)
```

## Arguments

- p1:

  A list with `age`, `mode` and `dispersion` parameters for the first
  person (p1).

- p2:

  A list with `age`, `mode` and `dispersion` parameters for the second
  person (p2).

- max_age:

  A numeric. The maximum age for the Gompertz model.

## Value

A list containing:

- data:

  A data frame with survival rates for 'p1', 'p2', 'joint' survival, and
  the fitted Gompertz model

- mode:

  The mode of the joint Gompertz distribution

- dispersion:

  The dispersion parameter of the joint Gompertz distribution

## Examples

``` r
calc_gompertz_joint_parameters(
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
#> $data
#> # A tibble: 51 × 5
#>     year    p1    p2 joint gompertz
#>    <int> <dbl> <dbl> <dbl>    <dbl>
#>  1     0 1     1     1        1    
#>  2     1 0.989 0.996 1.000    0.999
#>  3     2 0.976 0.992 1.000    0.998
#>  4     3 0.963 0.988 1.000    0.996
#>  5     4 0.949 0.983 0.999    0.995
#>  6     5 0.933 0.977 0.998    0.993
#>  7     6 0.916 0.971 0.998    0.990
#>  8     7 0.898 0.964 0.996    0.988
#>  9     8 0.879 0.956 0.995    0.985
#> 10     9 0.858 0.948 0.993    0.981
#> # ℹ 41 more rows
#> 
#> $mode
#> [1] 92.94554
#> 
#> $dispersion
#> [1] 6.501515
#> 
```
