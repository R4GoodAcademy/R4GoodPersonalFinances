plot_expected_spending <- function(
  scenario, 
  period                          = c("yearly", "monthly"),
  type                            = c("discretionary", "non-discretionary"),
  discretionary_spending_position = c("top", "bottom")
) {

  type          <- rlang::arg_match(type, multiple = TRUE)
  period        <- rlang::arg_match(period)
  period_factor <- if (period == "yearly") 1 else 12

  discretionary_spending_position <- 
    rlang::arg_match(discretionary_spending_position)
  
  if (discretionary_spending_position == "bottom") {
    type_levels <- c(
      "non-discretionary",
      "discretionary"
    )
  } else {
    type_levels <- c(
      "discretionary",
      "non-discretionary"
    )
  }

  colors <- PrettyCols::prettycols("Bold")
  
  data_to_plot <- 
    scenario |>
    dplyr::select(
      index, 
      discretionary_spending, 
      nondiscretionary_spending
    ) |>
    tidyr::pivot_longer(
      cols = c(
        discretionary_spending, 
        nondiscretionary_spending
      ),
      names_to  = "type",
      values_to = "spending"
    ) |>
    dplyr::mutate(spending = spending / period_factor) |>
    dplyr::mutate(
      type = stringr::str_replace_all(type, "_spending", ""),
      type = dplyr::case_when(
        type == "discretionary"    ~ "discretionary", 
        type == "nondiscretionary" ~ "non-discretionary"
      ),
      type = factor(
        type, 
        levels = type_levels
      )
    ) |> 
    dplyr::filter(type %in% !!type)

  data_to_plot |> 
    ggplot2::ggplot(
      ggplot2::aes(
        x    = index, 
        y    = spending, 
        fill = type
      )
    ) +
    ggplot2::geom_area() +
    ggplot2::guides(fill = ggplot2::guide_legend(title = "Spending type")) +
    ggplot2::scale_fill_manual(
      values = c(
        "discretionary"     = colors[4], 
        "non-discretionary" = colors[5]
      )      
    ) +
      ggplot2::labs(
        title = "Expected Spending",
        x     = "Year index",
        y     = glue::glue("Spending {period}"),
      ) +
      ggplot2::scale_y_continuous(
        labels = print_currency
      ) +
      ggplot2::theme_minimal() +
      ggplot2::theme(
        panel.grid.minor = ggplot2::element_blank(),
        plot.caption = 
          ggtext::element_markdown(
            color = "grey60", 
            size  = 10
          ),
        plot.subtitle = ggtext::element_markdown(color = "grey60")
      )
}
