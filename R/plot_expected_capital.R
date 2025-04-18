#' @export

plot_expected_capital <- function(
  scenario
) {

  if (!"scenario" %in% names(scenario)) {
    scenario_id <- NULL
  } else {
    scenario_id <- unique(scenario$scenario)
  }

  colors <- PrettyCols::prettycols("Bold")
  color_values <- c(
    "financial_wealth" = colors[1],
    "human_capital"    = colors[4],
    "liabilities"      = colors[5],
    "total_capital"    = "gray85"
  )
  color_labels <- c(
    "financial_wealth" = "Financial capital",
    "human_capital"    = "Human capital",
    "liabilities"      = "Liabilities",
    "total_capital"    = "Total capital"
  )

  scenario |> 
    dplyr::select(
      index,
      financial_wealth, 
      human_capital, 
      liabilities
    ) |>
    dplyr::add_row(
      index            = max(!!scenario$index) + 1,
      financial_wealth = 0,
      human_capital    = 0,
      liabilities      = 0
    ) |> 
    dplyr::mutate(
      total_capital = financial_wealth + human_capital
    ) |> 
    tidyr::pivot_longer(
      cols      = -c("index"),
      names_to  = "type",
      values_to = "amount"
    ) |>
    ggplot2::ggplot(
      ggplot2::aes(
        x     = index, 
        y     = amount, 
        color = type,
        fill  = type
      )
    ) +
    ggplot2::geom_area(
      alpha    = 0.20, 
      position = "identity"
    ) +
    ggplot2::scale_y_continuous(
      labels = print_currency
    ) +
    ggplot2::scale_color_manual(
      values = color_values,
      labels = color_labels
    ) +
    ggplot2::scale_fill_manual(
      values = color_values,
      labels = color_labels
    ) +
    ggplot2::theme_minimal() +
    ggplot2::labs(
      title = glue::glue(
        "Expected Financial and Human Capital over Household Life Cycle"
      ),
      subtitle = ifelse(is.null(scenario_id), "", glue::glue(
        "Scenario: <strong>{scenario_id}</strong>"
      )),
      x = "Year index",
      y = "Amount",
    ) +
    ggplot2::theme(
      legend.position  = "right",
      legend.title     = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      plot.caption = 
        ggtext::element_markdown(
          color = "grey60", 
          size  = 10
        ),
      plot.subtitle = ggtext::element_markdown(color = "grey60")
    )
    
}
