# Printing currency values or percentages

Wrapper functions for printing nicely formatted values.

## Usage

``` r
format_currency(
  x,
  prefix = "",
  suffix = "",
  big.mark = ",",
  accuracy = NULL,
  min_length = NULL,
  ...
)

format_percent(x, accuracy = 0.1, ...)
```

## Arguments

- x:

  A numeric vector

- prefix, suffix:

  Symbols to display before and after value.

- big.mark:

  Character used between every 3 digits to separate thousands. The
  default (`NULL`) retrieves the setting from the [number
  options](https://scales.r-lib.org/reference/number_options.html).

- accuracy:

  A number to round to. Use (e.g.) `0.01` to show 2 decimal places of
  precision. If `NULL`, the default, uses a heuristic that should ensure
  breaks have the minimum number of digits needed to show the difference
  between adjacent values.

  Applied to rescaled data.

- min_length:

  A numeric. Minimum number of characters of the string with the
  formatted value.

- ...:

  Other arguments passed on to
  [`base::format()`](https://rdrr.io/r/base/format.html).

## Value

A character. Formatted value.

A character. Formatted value.

## See also

[`scales::dollar()`](https://scales.r-lib.org/reference/dollar_format.html)

[`scales::percent()`](https://scales.r-lib.org/reference/percent_format.html)

## Examples

``` r
format_currency(2345678, suffix = " PLN")
#> [1] "2,345,678 PLN"
format_percent(0.52366)
#> [1] "52.4%"
```
