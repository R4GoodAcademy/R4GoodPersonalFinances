# Create Portfolio Template

Creates a template for default portfolio with two asset classes:

- `GlobalStocksIndexFund`

- `InflationProtectedBonds`

## Usage

``` r
create_portfolio_template()
```

## Value

A nested `tibble` of class 'Portfolio' with columns:

- `name`

- `expected_return`

- `standard_deviation`

- `accounts`

  - `taxable`

  - `taxadvantaged`

- `weights`

  - `human_capital`

  - `liabilities`

- `correlations`

- `pretax`

  - `turnover`

  - `income_qualified`

  - `capital_gains_long_term`

  - `income`

  - `capital_gains`

  - `cost_basis`

## Details

The template is used as a starting point for creating a portfolio. The
asset classes have some reasonable default values of expected returns
and standard deviations of returns. The template assumes no correlations
between asset classes in the `correlations` matrix. Please check and
update the template assumptions if necessary.

The nested `pretax` columns contain default values for parameters needed
for calculating effective tax rates. The template assumes only capital
gains tax is paid. Please customise this template to your individual
situation.

The `accounts` nested columns have zero values for all assets by default
in both taxable and tax-advantaged accounts. The template assumes that
there is currently no financial wealth allocated to those accounts.
Please customise this template to your individual situation.

The `weights` nested columns define weights of assets in portfolios
representative of the household human capital and liabilities. The
template assumes equal weights for all assets for both portfolios.
Please customise this template to your individual situation.

## See also

Possible sources of market assumptions:

- <https://elmwealth.com/capital-market-assumptions/>

- <https://www.obligacjeskarbowe.pl/oferta-obligacji/obligacje-10-letnie-edo/>

- <https://www.msci.com/indexes/index/664204>

- (PDF)
  https://research.ftserussell.com/Analytics/FactSheets/Home/DownloadSingleIssue?issueName=AWORLDS&isManual=False

## Examples

``` r
  portfolio <- create_portfolio_template()
  portfolio$accounts$taxable <- c(10000, 30000)
  portfolio
#> 
#> ── Portfolio ───────────────────────────────────────────────────────────────────
#> 
#> ── Market assumptions ──
#> 
#> ── Expected real returns: 
#> # A tibble: 2 × 3
#>   name                    expected_return standard_deviation
#>   <chr>                             <dbl>              <dbl>
#> 1 GlobalStocksIndexFund            0.0461               0.15
#> 2 InflationProtectedBonds          0.02                 0   
#> 
#> ── Correlation matrix: 
#>                         GlobalStocksIndexFund InflationProtectedBonds
#> GlobalStocksIndexFund                       1                       0
#> InflationProtectedBonds                     0                       1
#> 
#> ── Weights ──
#> 
#>                         human_capital liabilities
#> GlobalStocksIndexFund             0.5         0.5
#> InflationProtectedBonds           0.5         0.5
#> 
#> ── Accounts ──
#> 
#> # A tibble: 3 × 4
#>   name                    taxable taxadvantaged total
#>   <chr>                     <dbl>         <dbl> <dbl>
#> 1 GlobalStocksIndexFund     10000             0 10000
#> 2 InflationProtectedBonds   30000             0 30000
#> 3 total                     40000             0 40000
#> 
#> ── Pre-tax ──
#> 
#> # A tibble: 2 × 7
#>   name                    turnover income_qualified capital_gains_long_term
#>   <chr>                      <dbl>            <dbl>                   <dbl>
#> 1 GlobalStocksIndexFund       0.04                0                       1
#> 2 InflationProtectedBonds     0.04                0                       1
#>   income capital_gains cost_basis
#>    <dbl>         <dbl>      <dbl>
#> 1      0        0.0461      0.637
#> 2      0        0.02        0.820
#> 
#> ── After-tax ──
#> 
#> ! After-tax information is not available yet.
#> ℹ Use `calc_effective_tax_rate()` to calculate it.
#> 
#> 
#> ── Allocation ──
#> 
#> ! Allocation information is not available yet.
#> ℹ Use `calc_optimal_asset_allocation()` to calculate it.
```
