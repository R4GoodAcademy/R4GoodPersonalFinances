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
  ...
) {
  
  if (is.list(x)) {
    return(
      purrr::map(
        x, 
        print_currency, 
        suffix   = suffix, 
        big.mark = big.mark,
        accuracy = accuracy,
        prefix   = prefix,
        ...
      )
    )
  }

  if (!is.numeric(x)) {
    return(x)
  }
  
  scales::dollar(
    x        = x, 
    prefix   = prefix, 
    suffix   = suffix,
    big.mark = big.mark,
    accuracy = accuracy,
    ...
  )
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
  
  if (is.list(x)) {
    return(
      purrr::map(x, print_percent, accuracy = accuracy, ...)
    )
  }

  if (!is.numeric(x)) {
    return(x)
  }
  
  percents <- scales::percent(
    x = x,
    accuracy = accuracy,
    ...
  )

  names(percents) <- names(x)
  percents
}

#' @export
get_current_date <- function() {
  current_data <- getOption("R4GPF.current_date", default = Sys.Date())
  lubridate::as_date(current_data)
}

normalize <- function(x, min = 0, max = 1) {

  (x - min(x, na.rm = TRUE)) /
    (max(x, na.rm = TRUE) - min(x, na.rm = TRUE)) * (max - (min)) + (min)
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

    test_asset_correlations <- tibble::tribble(
      ~DomesticStocks, ~InternationalStocks, ~Bonds,
      1.00,            0.87,                 0.21,
      0.87,            1.00,                 0.37,
      0.21,            0.37,                 1.00
    )
    
  } else if (n == 2) {
    
    portfolio <- 
      tibble::tribble(
        ~name,        ~expected_return, ~standard_deviation, 
        "GlobalStock", 0.0449,          0.15,                
        "EDOBonds",    0.02,            0,                  
      ) |> 
      dplyr::mutate(
        accounts = tibble::tribble(
          ~taxable, ~taxadvantaged,
          200000,   50000,
          100000,   25000,
        ),
        weights = tibble::tribble(
          ~human_capital, ~liabilities, 
          0.5,            0.5,          
          0.5,            0.5,          
        )
      )
      portfolio <- 
        portfolio |> 
        dplyr::mutate(
          correlations = {
            matrix <- diag(1, NROW(portfolio), NROW(portfolio)) 
            colnames(matrix) <- portfolio$name
            rownames(matrix) <- portfolio$name
            matrix
          },
          aftertax = tibble::tibble(
            effective_tax_rate = rep(0.19, NROW(portfolio))
          )
        )
    
    test_asset_returns      <- portfolio
    test_asset_correlations <- portfolio$correlations

  } else if (n == 9) {

    test_asset_returns <- 
      tibble::tribble(
        ~name,                  ~expected_return, ~standard_deviation, 
        "USLargeCapStocks",     0.0468,           0.1542,
        "USMidSmallCapStocks",  0.0501,           0.1795, 
        "GlobalDMxUSStocks",    0.0505,           0.1671, 
        "EmergingMarketStocks", 0.0540,           0.2142,
        "USBonds",              0.0269,           0.0379,
        "InflationLinkedBonds", 0.0288,           0.0581,
        "MuniBonds",            0.0190,           0.03138274,
        "GlobalBondsxUS",       0.0329,           0.0833,
        "Cash",                 0.0250,           0.0055
      )
    
      test_asset_returns <- 
        test_asset_returns |> 
        dplyr::mutate(
          pretax = tibble::tibble(
            capital_gains    = c(0.0349, 0.0387, 0.0336, 0.0388, rep(0, 5)),
            income           = expected_return - capital_gains,
            turnover         = c(0.3300, 0.3652, 0.1800, 0.3300, rep(1, 5)),
            cost_basis       = c(0.9364, 0.9393, 0.8750, 0.9301, rep(1, 5)),
            income_qualified = c(0.9762, 0.9032, 0.7998, 0.7387, rep(0, 5)),
            capital_gains_long_term = 
              c(0.9502, 0.9032, 0.8951, 0.9023, rep(0, 5))
          )
        )|> 
        dplyr::mutate(
          accounts = tibble::tibble(
            taxable       = rep(1000, n), 
            taxadvantaged = rep(1000, n)
          ),
          weights = tibble::tibble(
            human_capital = 1 / n, 
            liabilities   = 1 / n, 
          )
        ) 
    
      test_asset_correlations <- 
        diag(rep(1, length(test_asset_returns$expected_return)))
    
      test_asset_returns <- 
        test_asset_returns |> 
        dplyr::mutate(
          correlations = test_asset_correlations,
          effective_tax_rates = 0.19
        ) 
        
  }

  if (!is.null(test_asset_correlations)) {
    test_asset_correlations <- as.matrix(test_asset_correlations)
    rownames(test_asset_correlations) <- colnames(test_asset_correlations)
  }

  list(
    returns      = test_asset_returns,
    correlations = test_asset_correlations
  )

}