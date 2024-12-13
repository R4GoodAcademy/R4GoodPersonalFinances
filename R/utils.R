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
