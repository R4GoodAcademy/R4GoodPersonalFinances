% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calc_gompertz.R
\name{plot_gompertz_calibration}
\alias{plot_gompertz_calibration}
\title{Plotting the results of Gompertz model calibration}
\usage{
plot_gompertz_calibration(params, mode, dispersion, max_age)
}
\arguments{
\item{params}{A list returned by \code{\link[=calc_gompertz_parameters]{calc_gompertz_parameters()}} function.}

\item{mode}{A numeric. The mode of the Gompertz model.}

\item{dispersion}{A numeric. The dispersion of the Gompertz model.}

\item{max_age}{A numeric. The maximum age of the Gompertz model.}
}
\value{
A \code{\link[ggplot2:ggplot]{ggplot2::ggplot()}} object showing the comparison between
actual survival rates from life tables and the fitted Gompertz model.
}
\description{
Plotting the results of Gompertz model calibration
}
\examples{
mortality_rates <- 
  dplyr::filter(
    life_tables,
    country == "USA" & 
    sex     == "female" &
    year    == 2022
  )
  
params <- calc_gompertz_parameters(
  mortality_rates = mortality_rates,
  current_age     = 65
)

plot_gompertz_calibration(params = params)
}
