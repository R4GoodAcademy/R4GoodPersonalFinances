plot_structure <- function(
  scenario,
  period       = c("yearly", "monthly"),
  structure_of = c("spending", "income"),
  y_limit      = c(NA, NA)
) {

  period        <- rlang::arg_match(period)
  period_factor <- if (period == "yearly") 1 else 12

  structure_of <- rlang::arg_match(structure_of)

  data_to_plot <-
    scenario |> 
    dplyr::filter(sample == 0) |> 
    dplyr::select(index, !!rlang::sym(structure_of)) |>
    tidyr::unnest_wider(!!rlang::sym(structure_of)) |>
    tidyr::pivot_longer(
      -index,
      names_to  = "category",
      values_to = "amount"
    ) |>
    dplyr::group_by(index, category) |>
    dplyr::summarise(amount = sum(amount / 12)) |>
    dplyr::ungroup() |>
    dplyr::group_by(category) |>
    dplyr::mutate(presence_count = sum(amount > 0)) |>
    dplyr::ungroup() |>
    dplyr::mutate(category = factor(category, levels = unique(category[order(presence_count)])))

  scale_fill <- 
    switch(
      structure_of,
      "spending" = "Summer",
      "income"   = "Autumn"
    )
  scale_direction <- 1

  data_to_plot |>
    ggplot2::ggplot(
      ggplot2::aes(x = index, y = amount, fill = category)
    ) +
    ggplot2::geom_col(position = "stack", color = NA, alpha = 0.8, width = 1) +
    PrettyCols::scale_fill_pretty_d(
      palette   = scale_fill,
      direction = scale_direction,
      name      = structure_of
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      plot.caption  = ggtext::element_markdown(color = "grey60"),
      plot.subtitle = ggtext::element_markdown(color = "grey60")
    ) +
    ggplot2::labs(
      title    = glue::glue("Structure of {structure_of}"),
      subtitle = paste_scenario_id(scenario),
      x = paste_year_index_axis_label(),
      y = glue::glue("Amount ({period})")
    ) +
    ggplot2::scale_x_continuous(
      breaks = seq(0, max(scenario$index), by = 10),
      labels = function(breaks) paste_labels(breaks, scenario = scenario)
    ) +
    ggplot2::scale_y_continuous(
      labels = format_currency,
      breaks = 
        seq(
          from = 0, 
          to   = ceiling(max(
            data_to_plot |> 
              dplyr::group_by(category) |>
              dplyr::summarise(amount = sum(amount)) |>
              dplyr::pull(amount)
          ) / 1000) * 1000, 
          by   = 1000
        )
    ) +
    ggplot2::coord_cartesian(ylim = c(y_limit[1], y_limit[2]))
 
}
