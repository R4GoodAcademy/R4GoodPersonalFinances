#' @export
plot_expected_allocation <- function(
  scenario,
  account_type = c("total", "taxable", "taxadvantaged")
) {

  account_type <- rlang::arg_match(account_type)
  
  data_to_plot <- 
    scenario$allocation |> 
    dplyr::bind_rows(.id = "index") |> 
    dplyr::mutate(index = as.integer(index) - 1) |>
    dplyr::select(
      index, 
      asset, 
      allocation = account_type
    )
  
  colors <- 
    grDevices::colorRampPalette(
      rev(PrettyCols::prettycols("Bold"))
    )(
      length(unique(data_to_plot$asset))
    )
  
  data_to_plot |> 
    ggplot2::ggplot(
    ggplot2::aes(
      x    = index, 
      y    = allocation, 
      fill = factor(asset, levels = unique(asset)))
      ) +
    ggplot2::geom_area() +
    ggplot2::scale_fill_manual(values = colors) +
    ggplot2::scale_x_continuous() +
    ggplot2::scale_y_continuous(labels = scales::percent) + 
    ggplot2::theme_minimal() +
    ggplot2::theme(
      legend.position  = "bottom",
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      legend.title     = ggplot2::element_blank(),
      plot.caption = 
        ggtext::element_markdown(
          color = "grey60", 
          size  = 10
        ),
      plot.subtitle = ggtext::element_markdown(color = "grey60")
    ) +
    ggplot2::labs(
      x        = "Year index", 
      y        = "Allocation",
      title    = glue::glue(paste0(
        "Optimal Asset Allocation Over Time",
        ifelse(
          account_type != "total",
          " (in {account_type} accounts)",
          ""
        )
      )), 
      subtitle = glue::glue(paste0(
        "Scenario: <strong>'{unique(scenario$scenario_id)}'</strong><br>"
      ))
    )
}
