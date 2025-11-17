# Calculate purchasing power

Calculates changes in purchasing power over time, taking into account
the real interest rate.

## Usage

``` r
calc_purchasing_power(x, years, real_interest_rate)
```

## Arguments

- x:

  A numeric. The initial amount of money.

- years:

  A numeric. The number of years.

- real_interest_rate:

  A numeric. The yearly real interest rate.

## Value

A numeric. The purchasing power.

## Details

The real interest rate is the interest rate after inflation. If negative
(e.g. equal to the average yearly inflation rate) it can show
diminishing purchasing power over time. If positive, it can show
increasing purchasing power over time, and effect of compounding
interest on the purchasing power.

## See also

- [How to Determine Our Optimal Asset
  Allocation?](https://www.r4good.academy/en/blog/optimal-asset-allocation/index.en.html#why-keeping-all-your-savings-in-cash-isnt-the-best-idea)

## Examples

``` r
calc_purchasing_power(x = 10, years = 30, real_interest_rate = -0.02)
#> [1] 5.520709
calc_purchasing_power(x = 10, years = 30, real_interest_rate = 0.02)
#> [1] 18.11362
```
