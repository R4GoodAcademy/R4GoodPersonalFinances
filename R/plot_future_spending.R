#' @export
plot_future_spending <- function(
  scenario,
  period                          = c("yearly", "monthly"),
  type                            = c("discretionary", "non-discretionary"),
  discretionary_spending_position = c("bottom", "top"),
  y_limit                         = c(NA, NA)
) {
  
  period <- rlang::arg_match(period)
  type   <- rlang::arg_match(type, multiple = TRUE)

  discretionary_spending_position <- 
    rlang::arg_match(discretionary_spending_position)

  if (length(type) == 2) {
    return(
      plot_expected_spending(
        scenario, 
        period = period,
        discretionary_spending_position = discretionary_spending_position
      )
    )
  } 

  if (type == "discretionary") {
    return(
      plot_simulated_spending(
        scenario, 
        period = period
      )
    )
  } 

  if (type == "non-discretionary") {

    return(
      plot_structure(
        scenario, 
        structure_of = "spending",
        period = period
      )
    )
  }
}

plot_simulated_spending <- function(
  scenario,
  period  = c("yearly", "monthly"),
  y_limit = c(NA, NA)
) {
  
  min_alpha     <- 0.15
  period        <- rlang::arg_match(period)
  period_factor <- if (period == "yearly") 1 else 12

  
  if (length(unique(scenario$sample)) <= 1) {
    cli::cli_abort(
      call = NULL,
      "Plotting Monte Carlo samples requires more than one sample."
    )
  }

  quantile_min <- 
    scenario |>
    dplyr::filter(sample != 0) |>
    dplyr::group_by(index) |>
    dplyr::summarize(
      min_quantiles = list(
        quantile(
          discretionary_spending, 
          probs = seq(0, 0.9, 0.1)
        ) |>
          setNames(1:10)
      )
    ) |>
    tidyr::unnest_longer(
      min_quantiles,
      indices_to = "quantile_group",
      values_to  = "min"
    ) |> 
    dplyr::mutate(min = min / period_factor)
    
  quantile_max <- 
    scenario |>
    dplyr::filter(sample != 0) |>
    dplyr::group_by(index) |>
    dplyr::summarize(
      max_quantiles = list(
        quantile(
          discretionary_spending, 
          probs = seq(0.1, 1, 0.1)
        ) |>
          setNames(1:10)
      )
    ) |>
    tidyr::unnest_longer(
      max_quantiles,
      indices_to = "quantile_group",
      values_to  = "max"
    ) |> 
    dplyr::mutate(max = max / period_factor)

  quantile_data <- 
    dplyr::left_join(
      quantile_min, 
      quantile_max,
      by = c("index", "quantile_group")
    )  |> dplyr::filter(
      !quantile_group %in% c(1, 2, 9, 10)
    )   

  group_names <- sort(unique(quantile_data$quantile_group))
  n_groups    <- length(group_names)
  colors      <- PrettyCols::prettycols("Teals")

  plot <- 
    quantile_data |>
    ggplot2::ggplot(
      ggplot2::aes(x = index)
    ) +
    ggplot2::geom_ribbon(
      ggplot2::aes(
        ymin  = min, 
        ymax  = max, 
        group = quantile_group, 
        alpha = quantile_group
      ),
      fill = colors[3],
      show.legend = FALSE
    ) +
    ggplot2::scale_alpha_manual(
      values = c(
        seq(min_alpha, 1, length.out = n_groups/2) |> 
          setNames(group_names[1:(n_groups/2)]),
        seq(1, min_alpha, length.out = n_groups/2) |> 
          setNames(group_names[(n_groups/2 + 1):n_groups])
      )
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      panel.grid.minor.y = ggplot2::element_blank(),
      plot.caption       = ggtext::element_markdown(color = "grey60"),
      plot.subtitle      = ggtext::element_markdown(color = "grey60")
    ) +
    ggplot2::geom_line(
      data = dplyr::filter(scenario, sample == 0),
      ggplot2::aes(
        y = discretionary_spending / period_factor
      ),
      color     = PrettyCols::prettycols("Bold")[3],
      linetype  = "dashed",
      linewidth = 1
    ) +
    ggplot2::geom_line(
      data = 
        scenario |>
          dplyr::filter(sample != 0) |> 
          dplyr::group_by(index) |>
          dplyr::summarize(
            discretionary_spending = median(discretionary_spending) 
          ),
      ggplot2::aes(
        y = discretionary_spending / period_factor,
      ),
      color     = colors[1],
      linewidth = 1
    ) + 
    ggplot2::geom_hline(
      yintercept = 0,
      linetype = "dotted"
    ) +
    ggplot2::labs(
      title = "Future Simulated Discretionary Spending",
      subtitle = glue::glue(paste0(
        paste_scenario_id(scenario),
        "Based on {max(scenario$sample)} Monte Carlo samples."
      )),
      caption = "Yellow dashed line shows discretionary spending based on portfolio expected returns.<br>Solid teal line shows median of discretionary spending in Monte Carlo samples.<br>Teal bands show middle six decile groups of spending without top 2 and bottom 2 deciles.",
      x = "Year Index",
      y = glue::glue("Amount ({period})"),
    ) +
    ggplot2::scale_x_continuous(
      breaks = seq(0, max(scenario$index), by = 10),
      labels = function(breaks) paste_labels(breaks, scenario = scenario)
    ) +
    ggplot2::scale_y_continuous(
      labels = format_currency,
      breaks = seq(
        round(min(quantile_data$min) / 1000) * 1000, 
        round(max(quantile_data$max) / 1000) * 1000, 
        by = 1000
      ),
      expand = c(0, NA)
    ) + 
    ggplot2::coord_cartesian(ylim = c(y_limit[1], y_limit[2])) 

  plot
}
