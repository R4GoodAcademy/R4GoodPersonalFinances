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
    ) 
  
  total_current_spending <- 
    data_to_plot |>
      dplyr::filter(index == min(index)) |> 
      dplyr::pull(spending) |> 
      sum()
  
  data_to_plot <-
    data_to_plot|> 
    dplyr::filter(type %in% !!type)

  current_year <- 
    data_to_plot |> 
    dplyr::filter(index == min(index)) 

  type_colors <- c(
    "discretionary"     = colors[4], 
    "non-discretionary" = colors[5]
  )

  current_year_spending <- current_year$spending
  names(current_year_spending) <- 
    glue::glue( 
      "<span style='color: {type_colors[current_year$type]};'>**{current_year$type}**</span> "
    )
    
  summarized_data <-
    data_to_plot |> 
    dplyr::group_by(type) |>
    dplyr::summarise(
      median_spending = median(spending)
    )
  
  median_spending <- summarized_data$median_spending
  names(median_spending) <- 
    glue::glue( 
      "<span style='color: {type_colors[current_year$type]};'>**{current_year$type}**</span>"
    )
    
  data_to_plot |> 
    ggplot2::ggplot(
      ggplot2::aes(
        x    = index, 
        y    = spending, 
        fill = type
      )
    ) +
    ggplot2::geom_area() +
    ggplot2::annotate(
      "text", 
      x = 0, 
      y = total_current_spending, 
      label = glue::glue("{print_currency(total_current_spending / 1000, accuracy = 0.1, suffix = 'k')}"),
      vjust = -1

    ) +
    ggplot2::guides(fill = ggplot2::guide_legend(title = "Spending type")) +
    ggplot2::scale_fill_manual(
      values = c(
        "discretionary"     = colors[4], 
        "non-discretionary" = colors[5]
      )      
    ) +
    ggplot2::labs(
      title = glue::glue("Expected Spending"),
      subtitle =  ifelse(
        "scenario" %in% names(scenario),
        glue::glue(
          "Scenario: <strong>'{unique(scenario$scenario)}'</strong>"
        ),
        ""
      ),
      caption = glue::glue(paste0(
        "Total current spending: ",
        "<strong>",
        print_currency(total_current_spending, accuracy = 1),
        "</strong>",
        ".<br>",
        "Current spending: ",
        paste0(
          names(current_year_spending), 
          "= <strong>", 
          print_currency(current_year_spending, accuracy = 1), 
          "</strong>",
          collapse = " & "
        ),
        ".<br>",
        "Median spending: ",
        paste0(
          names(median_spending), 
          "= <strong>", 
          print_currency(median_spending, accuracy = 1), 
          "</strong>",
          collapse = " & "
        ),
        ".<br>"
      )),
      x     = "Year index",
      y     = glue::glue("Spending {period}"),
    ) +
    ggplot2::scale_y_continuous(
      labels = print_currency
    ) +
    ggplot2::scale_x_continuous() +
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
