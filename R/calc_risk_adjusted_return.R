#' Calculate risk adjusted return
#' 
#' @inheritParams calc_optimal_risky_asset_allocation
#' 
#' @param risky_asset_allocation A numeric. The allocation to the risky asset.
#' If it is already optimal allocation then parameters
#' `risky_asset_return_sd` and `risk_aversion` can be omitted.
#' 
#' @export
calc_risk_adjusted_return <- function(safe_asset_return,
                                      risky_asset_return_mean,
                                      risky_asset_allocation,
                                      risky_asset_return_sd = NULL,risk_aversion         = NULL
                                    ) {
  
  risky_asset_excess_return <- risky_asset_return_mean - safe_asset_return
                                      
  if (is.null(risky_asset_return_sd) & is.null(risk_aversion)) {

    return(
      safe_asset_return +
        (risky_asset_allocation * risky_asset_excess_return) / 2
    )
  }

  safe_asset_return + risky_asset_allocation * (
    risky_asset_excess_return - (
      (risky_asset_allocation * risk_aversion * risky_asset_return_sd ^ 2) / 2
    )
  )
}
