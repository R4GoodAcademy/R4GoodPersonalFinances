# Reading HMD life tables

Reading HMD life tables

## Usage

``` r
read_hmd_life_tables(
  path = getwd(),
  files = c("mltper_1x1.txt", "fltper_1x1.txt", "bltper_1x1.txt")
)
```

## Arguments

- path:

  A character. Path to the folder with life tables.

- files:

  A character. Names of files with life tables.

## Value

A data frame containing mortality data with columns:

- sex:

  Character - sex ('male', 'female', or 'both')

- year:

  Integer - the year of the data

- age:

  Integer - age

- mortality_rate:

  Numeric - mortality rate

- life_expectancy:

  Numeric - life expectancy

## References

HMD. Human Mortality Database. Max Planck Institute for Demographic
Research (Germany), University of California, Berkeley (USA), and French
Institute for Demographic Studies (France). Available at
www.mortality.org

## Examples

``` r
if (FALSE) { # \dontrun{
# Download 'txt' files 
# ("mltper_1x1.txt", "fltper_1x1.txt", "bltper_1x1.txt") 
# for a given country to the working directory
# from https://www.mortality.org after registration.

read_hmd_life_tables(path = getwd())
} # }
```
