#' Calculate optimal risky asset allocation
#' 
#' @param risky_asset_return_mean A numeric. The expected return of the risky asset.
#' @param risky_asset_return_sd A numeric. The standard deviation of the returns of the risky asset.
#' @param safe_asset_return A numeric. The expected return of the safe asset.
#' @param risk_aversion A numeric. The risk aversion coefficient.
#' 
#' @export
#' 
calc_optimal_risky_asset_allocation <- function(risky_asset_return_mean,
                                                risky_asset_return_sd,
                                                safe_asset_return,
                                                risk_aversion) {
  
  risky_asset_excess_return <- risky_asset_return_mean - safe_asset_return

  optimal_risky_asset_allocation <-
    risky_asset_excess_return / (risk_aversion * risky_asset_return_sd ^ 2)

  optimal_risky_asset_allocation[is.nan(optimal_risky_asset_allocation)] <- 0

  optimal_risky_asset_allocation
}