#' @export
plot_scenarios <- function(
  scenarios,
  period = c("yearly", "monthly")
) {

  period        <- rlang::arg_match(period)
  period_factor <- if (period == "yearly") 1 else 12
    
  expected_returns_scenario <- 
    scenarios |> 
    dplyr::filter(sample == 0) |> 
    dplyr::group_by(scenario_id) |> 
    dplyr::summarise(
      utility_expected  = sum(discretionary_spending_utility_weighted),
      constant_expected = 
        calc_inverse_utility(
          utility = 
            sum(discretionary_spending_utility_weighted) / 
            sum(survival_prob * time_value_discount),
          parameter = unique(smooth_consumption_preference)
        ) / period_factor,
    )
  
  monte_carlo_scenarios <-
    scenarios |> 
    dplyr::filter(sample != 0) |> 
    dplyr::mutate(
      negative_discretionary_spending = 
        dplyr::if_else(
          discretionary_spending < 0,
          abs(discretionary_spending),
          0
        ),
      positive_discretionary_spending = 
        dplyr::if_else(
          discretionary_spending >= 0,
          discretionary_spending,
          0
        )
      ) |> 
    dplyr::group_by(scenario_id, sample) |> 
    dplyr::summarise(
      utility = 
        sum(discretionary_spending_utility_weighted),
      constant = 
        calc_inverse_utility(
          utility = 
            sum(discretionary_spending_utility_weighted) / 
            sum(survival_prob * time_value_discount),
          parameter = unique(smooth_consumption_preference)
        ),
      positive_discretionary_spending = mean(positive_discretionary_spending),
      negative_discretionary_spending = mean(negative_discretionary_spending),
      risk_tolerance = unique(risk_tolerance)
    ) |> 
    dplyr::group_by(scenario_id) |> 
    dplyr::summarise(
      utility         = median(utility),
      constant = 
        calc_inverse_utility(
          mean(
            calc_utility(
            constant,
            parameter = unique(risk_tolerance)
            )
          ),
          parameter = unique(risk_tolerance)
        ) / period_factor,
      positive_discretionary_spending = 
        median(positive_discretionary_spending) / period_factor,
      negative_discretionary_spending = 
        median(negative_discretionary_spending) / period_factor
    ) 
  
  expected_returns_scenario <- 
    expected_returns_scenario |> 
      dplyr::mutate(
        utility_normalized_expected = 
          normalize(
            utility_expected, 
            min = min(constant_expected, monte_carlo_scenarios$constant), 
            max = max(constant_expected, monte_carlo_scenarios$constant)
          )
      )
  
  monte_carlo_scenarios <- 
    monte_carlo_scenarios |> 
      dplyr::mutate(
        utility_normalized = normalize(
          utility, 
          min = min(constant, expected_returns_scenario$constant_expected), 
          max = max(constant, expected_returns_scenario$constant_expected)
        )
      )

  ordered_scenario_levels <- 
    monte_carlo_scenarios |>
    dplyr::arrange(utility_normalized) |> 
    dplyr::pull(scenario_id) |> 
    unique()

  expected_returns_scenario_long <- 
    expected_returns_scenario |> 
    dplyr::select(-utility_expected) |> 
    tidyr::pivot_longer(
      cols      = -"scenario_id",
      names_to  = "metric",
      values_to = "value"
    ) 
    
  monte_carlo_scenarios_long <- 
    monte_carlo_scenarios |> 
    dplyr::select(-utility) |> 
    tidyr::pivot_longer(
      cols      = -"scenario_id",
      names_to  = "metric",
      values_to = "value"
    ) |> 
    dplyr::mutate(
      scenario_id = factor(scenario_id, levels = ordered_scenario_levels)
    ) 
  
  colors <- 
    grDevices::colorRampPalette(
      rev(PrettyCols::prettycols("Bold"))
    )(
      length(unique(monte_carlo_scenarios_long$metric)) + 2
    )

  monte_carlo_scenarios_long |>
    ggplot2::ggplot(
      ggplot2::aes(
        x     = scenario_id, 
        y     = value,
        color = metric,
        group = metric
      )
    ) +
    ggplot2::geom_line(
      linetype = "dotted"
    ) +
    ggplot2::geom_line(
      data    = expected_returns_scenario_long,
      linetype = "dashed"
    ) +
    ggplot2::geom_line(
      data     = expected_returns_scenario_long,
      linetype = "dashed"
    ) +
    ggplot2::geom_point(
      data = expected_returns_scenario_long,
      size = 2
    ) +
    ggplot2::geom_point(size = 2) +
    ggrepel::geom_text_repel(
      data = 
        expected_returns_scenario_long |> 
        dplyr::filter(metric == "constant_expected"),
      ggplot2::aes(
        label = 
          ifelse(
            round(value / 1000)  == 0, 
            "",
            paste0(round(value / 1000, 1), "k")
          )
      ),
      nudge_x     = -0.5,
      nudge_y     = +0.5,
      na.rm       = TRUE,
      show.legend = FALSE
    ) +
    ggplot2::scale_y_continuous(
      labels = print_currency,
      breaks = scales::breaks_extended(n = 10)
    ) +
    ggplot2::scale_color_manual(
      values = colors,
      labels = c(
        "negative_discretionary_spending" = 
          "median of means\nof missing founds\nin Monte Carlo samples",
        "positive_discretionary_spending" = 
          "median of means\nof discretionary spending\nin Monte Carlo samples",
        "constant" = 
          "constant (certainty equivalent)\ndiscretionary spending\n in Monte Carlo samples",
        "constant_expected" = 
          "constant (certainty equivalent)\ndiscretionary spending\n based on expected returns",
        "utility_normalized_expected" = 
          "normalized median utility\nof discretionary spending\nbased on expected returns",
        "utility_normalized" = 
          "normalized median utility\nof discretionary spending\nin Monte Carlo samples"
      )
    ) +
    ggplot2::theme_minimal() +
    ggplot2::labs(
      title    = glue::glue("Comparison of Scenario Metrics"),
      subtitle = glue::glue("Spending period: <strong>{period}</strong>"),
      x        = "Scenario",
      y        = glue::glue("Amount ({period})"),
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
