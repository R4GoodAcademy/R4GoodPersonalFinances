# Get default Gompertz parameters

Calculates default Gompertz parameters for a given age, country and sex,
based on the package build-in HMD life tables.

## Usage

``` r
get_default_gompertz_parameters(
  age,
  country = unique(life_tables$country),
  sex = c("both", "male", "female")
)
```

## Arguments

- age:

  A numeric. The age of the individual.

- country:

  A character. The name of the country.

- sex:

  A character. The sex of the individual.

## Value

A list containing:

- mode:

  The mode of the Gompertz distribution

- dispersion:

  The dispersion parameter of the Gompertz distribution

- current_age:

  The current age parameter

- max_age:

  The maximum age parameter

## See also

[`calc_gompertz_parameters()`](https://r4goodacademy.github.io/R4GoodPersonalFinances/reference/calc_gompertz_parameters.md)

## Examples

``` r
get_default_gompertz_parameters(
  age     = 65,
  country = "USA",
  sex     = "male"
)
```
