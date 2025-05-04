plot_expected_spending <- function(
  scenario, 
  period                          = c("yearly", "monthly"),
  discretionary_spending_position = c("top", "bottom")
) {
  
  stopifnot(
    length(unique(scenario$scenario_id)) == 1
  )

  type          <- c("discretionary", "non-discretionary")
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
    dplyr::filter(sample == 0) |> 
    dplyr::select(
      sample,
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
      median_spending = median(spending),
      max_spending    = max(spending),
      min_spending    = min(spending)
    )

  median_spending <- summarized_data$median_spending
  names(median_spending) <- 
    glue::glue( 
      "<span style='color: {type_colors[current_year$type]};'>**{current_year$type}**</span>"
    )
  
  max_spending <- summarized_data$max_spending
  names(max_spending) <- 
    glue::glue( 
      "<span style='color: {type_colors[current_year$type]};'>**{current_year$type}**</span>"
    )
  
  min_spending <- summarized_data$min_spending
  names(min_spending) <- 
    glue::glue( 
      "<span style='color: {type_colors[current_year$type]};'>**{current_year$type}**</span>"
    )
  
  data_to_plot |> 
    ggplot2::ggplot(
      ggplot2::aes(
        x    = index, 
        y    = spending
        
      )
    ) +
    ggplot2::geom_area(
      ggplot2::aes(fill = type)
    ) +
    ggplot2::guides(
      fill = ggplot2::guide_legend(title = "Spending type")
    ) +
    ggplot2::scale_fill_manual(
      values = c(
        "discretionary"     = colors[4], 
        "non-discretionary" = colors[5]
      )      
    ) +
    ggplot2::labs(
      title = glue::glue("Expected Spending"),
      subtitle = glue::glue(paste0(
        ifelse(
          "scenario" %in% names(scenario),
          glue::glue(
            "Scenario: <strong>'{unique(scenario$scenario)}'</strong><br>"
          ),
          ""
        ),
        "Current spending: ",
        paste0(
          "<strong>", 
          glue::glue(
            "<span style='color: {type_colors[current_year$type]};'>{print_currency(current_year_spending, accuracy = 1)}</span>"
          ),
          "</strong> ",
          collapse = " + "
        ),
        " = <strong>",
        print_currency(total_current_spending, accuracy = 1),
        "</strong>"
      )),
      caption = glue::glue(paste0(
        "Median spending: ",
        paste0(
          names(median_spending), 
          "= <strong>", 
          print_currency(median_spending, accuracy = 1), 
          "</strong>",
          collapse = " & "
        ),
        ".<br>",
        "Max spending: ",
        paste0(
          names(max_spending), 
          "= <strong>", 
          print_currency(max_spending, accuracy = 1), 
          "</strong>",
          collapse = " & "
        ),
        ".<br>",
        "Min spending: ",
        paste0(
          names(min_spending), 
          "= <strong>", 
          print_currency(min_spending, accuracy = 1), 
          "</strong>",
          collapse = " & "
        )
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
