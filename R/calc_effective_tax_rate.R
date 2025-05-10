#' @export
calc_effective_tax_rate <- function(
  portfolio,
  tax_rate_ltcg,
  tax_rate_ordinary_income
) {

  aftertax <- 
    portfolio$pretax |> 
    dplyr::transmute(
      blended_tax_rate_income = 
        income_qualified * tax_rate_ltcg + (1 - income_qualified) * tax_rate_ordinary_income,
      blended_tax_rate_capital_gains =
        capital_gains_long_term * tax_rate_ltcg + 
          (1 - capital_gains_long_term) * tax_rate_ordinary_income,
      preliquidation_aftertax_expected_return = 
        (1 - blended_tax_rate_income) * income + 
          capital_gains - 
          turnover * (1 + capital_gains - cost_basis) * blended_tax_rate_capital_gains,
      initial_value        = rep(1000, NROW(portfolio)),
      investment_years     = rep(20,   NROW(portfolio)),
      preliquidation_value = 
        initial_value * 
          (1 + preliquidation_aftertax_expected_return)^investment_years,
      capital_gain_taxed = 
        (capital_gains / portfolio$expected_return) * (1 - turnover),
      capital_gain_tax_paid = 
        (preliquidation_value - initial_value) * 
          capital_gain_taxed * tax_rate_ltcg,
      postliquidation_value = 
        preliquidation_value - capital_gain_tax_paid,
      postliquidation_aftertax_expected_return =
        (postliquidation_value / initial_value) ^ (1 / investment_years) - 1,
      effective_tax_rate = 
        1 - (postliquidation_aftertax_expected_return  / portfolio$expected_return),
      aftertax_standard_deviation = 
        (1 - effective_tax_rate) * portfolio$standard_deviation
    )
  
  portfolio <- 
    portfolio |>
    dplyr::mutate(aftertax = aftertax)

  portfolio
}
