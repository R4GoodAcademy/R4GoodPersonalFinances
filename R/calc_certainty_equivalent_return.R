calc_certainty_equivalent_return <- function(
  safe_asset_return,
  risky_asset_sd,
  risk_tolerance
) {

  (1 + safe_asset_return) * exp(
    (0.5 * risk_tolerance * risky_asset_sd^2)
  ) - 1

}
