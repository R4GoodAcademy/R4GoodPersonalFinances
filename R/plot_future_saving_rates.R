#' @export
plot_future_saving_rates <- function(scenario) {

  colors <- PrettyCols::prettycols("Bold")

  data_to_plot <-
    scenario |> 
    dplyr::select(index, total_income, total_spending) |> 
    dplyr::mutate(
      savings     = total_income - total_spending,
      saving_rate = savings / total_income,
      saving_rate = dplyr::if_else(saving_rate < 0, 0, saving_rate)
    ) 
  
  data_to_plot |> 
    ggplot2::ggplot(
      ggplot2::aes(
        x      = index, 
        y      = saving_rate,
        color  = saving_rate
      )
    ) +
    ggplot2::geom_point() +
    ggplot2::scale_color_gradient(
      low     = colors[5],
      high    = colors[4],
      limits  = c(0, max(data_to_plot$saving_rate, na.rm = TRUE)),
    ) +
    ggplot2::scale_y_continuous(
      labels = function(x) format_percent(x, accuracy = 1),
      limits = c(0, NA)
    ) +
    ggplot2::scale_x_continuous(
      breaks = seq(0, max(scenario$index), by = 10),
      labels = function(breaks) paste_labels(breaks, scenario = scenario)
    ) +
    ggplot2::labs(
      title = "Future Saving Rates",
      subtitle = glue::glue(paste0(
        paste_scenario_id(scenario),
        "Saving rate at year 0 is <strong>{format_percent(data_to_plot$saving_rate[1])}</strong>."
      )),
      x = "Year Index",
      y = glue::glue("Saving rate"),
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      legend.position  = "none",
      # panel.grid.minor = ggplot2::element_blank(),
      plot.caption = 
        ggtext::element_markdown(
          color = "grey60", 
          size  = 10
        ),
      plot.subtitle = ggtext::element_markdown(color = "grey60")
    )
}

