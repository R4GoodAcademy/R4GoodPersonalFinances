plot_optimal_portfolio <- function(
  portfolio
) {

  allocations <- portfolio$allocations
 
  allocations_long <- 
    allocations |> 
    tidyr::pivot_longer(
      cols      = -"name",
      names_to  = "portfolio",
      values_to = "accounts"
    ) |> 
    tidyr::unnest(cols = "accounts") |>
    tidyr::pivot_longer(
      cols      = - c("name", "portfolio"),
      names_to  = "account",
      values_to = "allocation"
    ) |> 
    dplyr::filter(account != "total") |>
    dplyr::mutate(
      portfolio = factor(portfolio, levels = c("optimal", "current"))
    )

  sums <- 
    allocations_long |>
    dplyr::group_by(name, portfolio) |>
    dplyr::summarise(total_allocation = sum(allocation), .groups = "drop")

  colors <- PrettyCols::prettycols("Bold")
  color_values <- c(
    "taxable"       = colors[3],
    "taxadvantaged" = colors[4]
  )

  ggplot2::ggplot(
    allocations_long,
    ggplot2::aes(
      x     = portfolio, 
      y     = allocation, 
      fill  = account
    )
  ) +
    ggplot2::scale_fill_manual(
      values = color_values
    ) +
    ggplot2::scale_y_continuous(labels = scales::percent_format()) +
    ggplot2::geom_col(
      position = ggplot2::position_stack(), 
      width = 0.9
    ) +
    ggplot2::coord_flip() +
    ggplot2::facet_wrap(~ name, ncol = 1, scales = "free_y") +
    ggplot2::theme(axis.text.y = ggplot2::element_text(size = 8)) + 
    ggplot2::geom_text(
      ggplot2::aes(
        label = ifelse(allocation < 0.001, "", print_percent(allocation))
      ),
      position = ggplot2::position_stack(vjust = 0.5),
      size = 3
    ) + 
    ggplot2::geom_label(
      data = sums,
      ggplot2::aes(
        x = portfolio,
        y = total_allocation,
        label = print_percent(total_allocation)
      ),
      inherit.aes = FALSE,
      hjust = 0.5,
      size = 3
    ) +
    ggplot2::theme_minimal() +
    ggplot2::labs(
      title = glue::glue("Current vs Optimal Portfolio Allocation"),
      x     = "Portfolio",
      y     = "Allocation",
    ) +
    ggplot2::theme(
      legend.position  = "bottom",
      panel.grid.minor = ggplot2::element_blank(),
      plot.caption = 
        ggtext::element_markdown(
          color = "grey60", 
          size  = 10
        ),
      plot.subtitle = ggtext::element_markdown(color = "grey60"),
      axis.text.y = ggtext::element_markdown(
        color = c(
          "optimal" = "black", 
          "current" = "grey60"
        )
      )
    )
}

