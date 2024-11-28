#' Plotting changes to purchasing power over time
#' 
#' @inheritParams calc_purchasing_power
#' 
#' @param legend_title A character. Could be "Inflation rate" if real interest
#' rate is negative.
#' @param seed A numeric. Seed passed to \code{geom_label_repel()}.
#' 
#' @export
plot_purchasing_power <- function(x, 
                                  real_interest_rate, 
                                  years = 50,
                                  legend_title = "Real interest rate",
                                  seed = NA
                                  ) {
  
  year <- purchasing_power <- NULL

  data <- 
    tidyr::expand_grid(
      x = x, 
      year = 0:years, 
      real_interest_rate = real_interest_rate
    ) |> 
    dplyr::mutate(
      purchasing_power = calc_purchasing_power(
        x = x, 
        years = year, 
        real_interest_rate = real_interest_rate
      )
    ) 
  
  data |> 
    ggplot2::ggplot(
      ggplot2::aes(
        x     = year, 
        y     = purchasing_power, 
        color = as.factor(real_interest_rate)
      )
    ) + 
    ggplot2::geom_line(linewidth = 0.7) + 
    ggrepel::geom_label_repel(
      max.overlaps = 20,
      show.legend  = FALSE,
      seed = seed,
      data = 
        data |> 
        dplyr::group_by(real_interest_rate) |> 
        dplyr::filter(year == round(max(year), 0)),
      ggplot2::aes(
        label = paste0(
          "", real_interest_rate * 100, "%: ",
          round(purchasing_power, 1)
        )
      )
    ) +
    ggrepel::geom_label_repel(
      show.legend = FALSE,
      color       = "grey60",
      seed = seed,
      data = 
        data |> 
        dplyr::filter(
          year == min(year),
          real_interest_rate == min(real_interest_rate)
        ),
      ggplot2::aes(
        label = paste0(round(purchasing_power, 1))
      )
    ) +
    PrettyCols::scale_colour_pretty_d("Summer") +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      legend.position  = "bottom",
      panel.grid.minor = ggplot2::element_line(color = "grey90"),
      plot.caption     = ggplot2::element_text(color = "grey60"),
      plot.subtitle    = ggplot2::element_text(color = "grey60")
    ) +
    ggplot2::labs(
      title    = "Purchasing Power Over Time",
      subtitle = glue::glue("Label at the end of the plotted line shows real interest rate for the line\nand real value (purchasing power) after {years} years. The initial value now (at year 0) is {x}."), 
      y        = "Purchasing power", 
      x        = "Year", 
      color    = legend_title, 
      linetype = legend_title
    )
}