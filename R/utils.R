#' Printing currency values or percentages
#' 
#' Wrapper functions for printing nicely formatted values.
#' 
#' @seealso [scales::dollar()] 
#' 
#' @inheritParams scales::dollar
#' @inheritParams scales::percent
#' @rdname print_
#' 
#' @return A character. Formatted value.
#' 
#' @examples
#' print_currency(2345678, suffix = " PLN")
#' @export

print_currency <- function(x, 
  suffix = "",
  big.mark = ",",
  accuracy = NULL,
  prefix = NULL,
  ...) {
    
    scales::dollar(x = x, 
      prefix = prefix, 
      suffix = suffix,
      big.mark = big.mark,
      accuracy = accuracy,
      ...)
    }
    
#' @seealso [scales::percent()]
#' 
#' @inheritParams scales::percent
#' @inheritParams scales::dollar
#' @rdname print_
#' 
#' @return A character. Formatted value.
#' 
#' @examples
#' print_percent(0.52366)
#' @export

print_percent <- function(x, 
                          accuracy = 0.1,
                          ...) {
  
  scales::percent(x = x,
                  accuracy = accuracy,
                  ...)
}

generate_test_asset_returns <- function(n = 3) {
  
  if (n == 3) {

    test_asset_returns <- 
      tibble::tribble(
        ~asset_class,          ~expected_return, ~standard_deviation,
        "DomesticStocks",      0.0472,           0.1588, 
        "InternationalStocks", 0.0504,           0.1718,
        "Bonds",               0.0275,           0.0562
      )
    
  } else if (n == 2) {
    
    test_asset_returns <- 
      tibble::tribble(
        ~asset_class,            ~expected_return, ~standard_deviation,
        "GlobalStocks",          0.0449,           0.15,
        "InflationIndexedBonds", 0.02,             0.0
      )
  }

  if (n == 3) {

    test_asset_correlations <- tibble::tribble(
      ~DomesticStocks, ~InternationalStocks, ~Bonds,
      1.00,            0.87,                 0.21,
      0.87,            1.00,                 0.37,
      0.21,            0.37,                 1.00
    )
  } else if (n == 2) {
    
    test_asset_correlations <- tibble::tribble(
      ~GlobalStocks, ~InflationIndexedBonds,
      1.00,          0, 
      0,             1.00
    )
  }

  test_asset_correlations <- as.matrix(test_asset_correlations)
  rownames(test_asset_correlations) <- colnames(test_asset_correlations)

  list(
    returns      = test_asset_returns,
    correlations = test_asset_correlations
  )

}