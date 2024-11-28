#' Printing currency value
#' 
#' @inheritParams scales::dollar
#' @inheritParams scales::percent
#' 
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
    
#' Printing percent value
#' 
#' @inheritParams scales::percent
#' @inheritParams scales::dollar
#' @export

print_percent <- function(x, 
                          accuracy = 0.1,
                          ...) {
  
  scales::percent(x = x,
                  accuracy = accuracy,
                  ...)
}
