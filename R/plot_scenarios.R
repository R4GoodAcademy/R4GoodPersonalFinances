#' @export

plot_scenarios <- function(
  scenarios,
  period = c("yearly", "monthly")
) {

  period        <- rlang::arg_match(period)
  period_factor <- if (period == "yearly") 1 else 12
  
  discretionary_spending_metrics <- 
    scenarios |> 
    dplyr::group_by(scenario) |> 
    dplyr::summarise(
      utility  = sum(discretionary_spending_utility_weighted),
      constant = calc_inverse_utility(
        sum(discretionary_spending_utility_weighted) / 
          sum(survival_prob * time_value_discount),
        parameter = unique(smooth_consumption_preference)
        ) / period_factor
    ) |> 
    dplyr::mutate(
      utility_normalized = normalize(
        utility, 
        min = min(constant), 
        max = max(constant)
      )
    )
  
  ordered_scenario_levels <- 
    discretionary_spending_metrics |>
    dplyr::arrange(utility_normalized) |> 
    dplyr::pull(scenario) |> 
    unique()
    
  discretionary_spending_metrics_long <- 
    discretionary_spending_metrics |> 
    dplyr::select(-utility) |> 
    tidyr::pivot_longer(
      cols      = -"scenario",
      names_to  = "metric",
      values_to = "value"
    ) |> 
    dplyr::mutate(
      scenario = factor(scenario, levels = ordered_scenario_levels)
    ) 
  
    colors <- PrettyCols::prettycols("Bold")
    
    discretionary_spending_metrics_long |>
      ggplot2::ggplot(
        ggplot2::aes(
          x     = scenario, 
          y     = value, 
          color = metric,
          group = metric
        )
      ) +
      ggplot2::geom_line(linetype = "dotted") +
      ggplot2::geom_point(size = 2) +
      ggrepel::geom_label_repel(
        ggplot2::aes(
          label = ifelse(
            metric == "constant", 
            paste0(round(value / 1000, 1), "k"), 
            ""
          )
        ),
        nudge_x     = 0.5,
        nudge_y     = -0.5,
        na.rm       = TRUE,
        show.legend = FALSE
      ) +
      ggplot2::scale_y_continuous(
        labels = print_currency
      ) +
      ggplot2::scale_color_manual(
        values = colors[c(4, 5)],
        labels = c(
          "constant" = "constant / certainty equivalent level of spending",
          "utility_normalized" = "normalized utility of spending"
        )
      ) +
      ggplot2::theme_minimal() +
      ggplot2::labs(
        title = glue::glue("Scenario Metrics for Discretionary Spending"),
        subtitle = glue::glue(
          "Spending period: <strong>{period}</strong>"
        ),
        x     = "Scenario",
        y     = "Discretionary spending",
      ) +
      ggplot2::theme(
        legend.position  = "bottom",
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
