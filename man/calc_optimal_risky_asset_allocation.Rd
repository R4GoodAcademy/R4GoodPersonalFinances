% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calc_optimal_risky_asset_allocation.R
\name{calc_optimal_risky_asset_allocation}
\alias{calc_optimal_risky_asset_allocation}
\title{Calculate optimal risky asset allocation}
\usage{
calc_optimal_risky_asset_allocation(
  risky_asset_return_mean,
  risky_asset_return_sd,
  safe_asset_return,
  risk_aversion
)
}
\arguments{
\item{risky_asset_return_mean}{A numeric.
The expected (average) yearly return of the risky asset.}

\item{risky_asset_return_sd}{A numeric.
The standard deviation of the yearly returns of the risky asset.}

\item{safe_asset_return}{A numeric.
The expected yearly return of the safe asset.}

\item{risk_aversion}{A numeric.
The risk aversion coefficient.}
}
\value{
A numeric.
The optimal allocation to the risky asset.
In case of \code{\link[=NaN]{NaN()}} (because of division by zero)
the optimal allocation to the risky asset is set to 0.
}
\description{
Calculates the optimal allocation to the risky asset
using the Merton Share formula.
}
\details{
Can be used to calculate the optimal allocation to the risky asset
for vectors of inputs.
}
\examples{
calc_optimal_risky_asset_allocation(
  risky_asset_return_mean = 0.05,
  risky_asset_return_sd   = 0.15,
  safe_asset_return       = 0.02,
  risk_aversion           = 2
)

calc_optimal_risky_asset_allocation(
  risky_asset_return_mean = c(0.05, 0.06),
  risky_asset_return_sd   = c(0.15, 0.16),
  safe_asset_return       = 0.02,
  risk_aversion           = 2
)
}
\seealso{
\itemize{
\item \href{https://www.r4good.academy/en/blog/optimal-asset-allocation/index.en.html#what-do-you-need-to-calculate-your-optimal-asset-allocation}{How to Determine Our Optimal Asset Allocation?}
\item Haghani V., White J. (2023) "The Missing Billionaires: A Guide to Better Financial Decisions." ISBN:978-1-119-74791-8.
}
}
