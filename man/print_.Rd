% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{print_currency}
\alias{print_currency}
\alias{print_percent}
\title{Printing currency values or percentages}
\usage{
print_currency(
  x,
  suffix = "",
  big.mark = ",",
  accuracy = NULL,
  prefix = NULL,
  ...
)

print_percent(x, accuracy = 0.1, ...)
}
\arguments{
\item{x}{A numeric vector}

\item{big.mark}{Character used between every 3 digits to separate thousands.}

\item{accuracy}{A number to round to. Use (e.g.) \code{0.01} to show 2 decimal
places of precision. If \code{NULL}, the default, uses a heuristic that should
ensure breaks have the minimum number of digits needed to show the
difference between adjacent values.

Applied to rescaled data.}

\item{prefix, suffix}{Symbols to display before and after value.}

\item{...}{Other arguments passed on to \code{\link[base:format]{base::format()}}.}
}
\value{
A character. Formatted value.

A character. Formatted value.
}
\description{
Wrapper functions for printing nicely formatted values.
}
\examples{
print_currency(2345678, suffix = " PLN")
print_percent(0.52366)
}
\seealso{
\code{\link[scales:dollar_format]{scales::dollar()}}

\code{\link[scales:percent_format]{scales::percent()}}
}
