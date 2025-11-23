# Get current date

If `R4GPF.current_date` option is not set, the current system date is
used.

## Usage

``` r
get_current_date()
```

## Value

A date.

## Examples

``` r
get_current_date()
#> [1] "2025-11-23"
# Setting custom date using `R4GPF.current_date` option
options(R4GPF.current_date = as.Date("2023-01-01"))
get_current_date()
#> [1] "2023-01-01"
options(R4GPF.current_date = NULL) # Reset default date#' Working with cache

get_current_date()
#> [1] "2025-11-23"
```
