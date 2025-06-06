% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calc_risk_adjusted_return.R
\name{calc_risk_adjusted_return}
\alias{calc_risk_adjusted_return}
\title{Calculate risk adjusted return}
\usage{
calc_risk_adjusted_return(
  safe_asset_return,
  risky_asset_return_mean,
  risky_asset_allocation,
  risky_asset_return_sd = NULL,
  risk_aversion = NULL
)
}
\arguments{
\item{safe_asset_return}{A numeric.
The expected yearly return of the safe asset.}

\item{risky_asset_return_mean}{A numeric.
The expected (average) yearly return of the risky asset.}

\item{risky_asset_allocation}{A numeric.
The allocation to the risky asset. Could be a vector.
If it is the optimal allocation then parameters
\code{risky_asset_return_sd} and \code{risk_aversion}
can be omitted.}

\item{risky_asset_return_sd}{A numeric.
The standard deviation of the yearly returns of the risky asset.}

\item{risk_aversion}{A numeric.
The risk aversion coefficient.}
}
\value{
A numeric. The risk adjusted return.
}
\description{
Calculates the risk adjusted return for portfolio
of given allocation to the risky asset.
}
\examples{
calc_risk_adjusted_return(
  safe_asset_return = 0.02,
  risky_asset_return_mean = 0.04,
  risky_asset_return_sd = 0.15,
  risky_asset_allocation = 0.5,
  risk_aversion = 2
)

calc_risk_adjusted_return(
  safe_asset_return = 0.02,
  risky_asset_return_mean = 0.04,
  risky_asset_allocation = c(0.25, 0.5, 0.75),
  risky_asset_return_sd = 0.15,
  risk_aversion = 2
)
}
\seealso{
\itemize{
\item \href{https://www.r4good.academy/en/blog/optimal-asset-allocation/index.en.html#how-much-risk-is-enough}{How to Determine Our Optimal Asset Allocation?}
\item Haghani V., White J. (2023) "The Missing Billionaires: A Guide to Better Financial Decisions." ISBN:978-1-119-74791-8.
}
}
