# Calculating Gompertz model parameters

Calculating Gompertz model parameters

## Usage

``` r
calc_gompertz_parameters(
  mortality_rates,
  current_age,
  estimate_max_age = FALSE
)
```

## Arguments

- mortality_rates:

  A data frame with columns `mortality_rate` and `age`. Usually the
  output of
  [`read_hmd_life_tables()`](https://r4goodacademy.github.io/R4GoodPersonalFinances/reference/read_hmd_life_tables.md)
  function or filtered data from
  [life_tables](https://r4goodacademy.github.io/R4GoodPersonalFinances/reference/life_tables.md)
  object.

- current_age:

  A numeric. Current age.

- estimate_max_age:

  A logical. Should the maximum age be estimated?

## Value

A list containing:

- data:

  The input mortality rates data frame with additional columns like
  'survival_rate' and 'probability_of_death'

- mode:

  The mode of the Gompertz distribution

- dispersion:

  The dispersion parameter of the Gompertz distribution

- current_age:

  The current age parameter

- max_age:

  The maximum age parameter

## References

Blanchet, David M., and Paul D. Kaplan. 2013. "Alpha, Beta, and Now...
Gamma." Journal of Retirement 1 (2): 29-45.
[doi:10.3905/jor.2013.1.2.029](https://doi.org/10.3905/jor.2013.1.2.029)
.

## Examples

``` r
mortality_rates <- 
  dplyr::filter(
    life_tables,
    country == "USA" & 
    sex     == "male" &
    year    == 2022
  )
  
calc_gompertz_parameters(
  mortality_rates = mortality_rates,
  current_age     = 65
)
#> $data
#> # A tibble: 46 × 8
#>    country sex    year   age mortality_rate life_expectancy survival_rate
#>    <chr>   <chr> <int> <int>          <dbl>           <dbl>         <dbl>
#>  1 USA     male   2022    65         0.0178            17.7         1    
#>  2 USA     male   2022    66         0.0187            17.0         0.981
#>  3 USA     male   2022    67         0.0200            16.3         0.962
#>  4 USA     male   2022    68         0.0214            15.6         0.941
#>  5 USA     male   2022    69         0.0228            14.9         0.920
#>  6 USA     male   2022    70         0.0246            14.3         0.897
#>  7 USA     male   2022    71         0.0264            13.6         0.873
#>  8 USA     male   2022    72         0.0282            13.0         0.849
#>  9 USA     male   2022    73         0.0306            12.3         0.823
#> 10 USA     male   2022    74         0.0331            11.7         0.796
#> # ℹ 36 more rows
#> # ℹ 1 more variable: probability_of_death <dbl>
#> 
#> $mode
#> [1] 86
#> 
#> $dispersion
#> [1] 8.816627
#> 
#> $current_age
#> [1] 65
#> 
#> $max_age
#> NULL
#> 
```
