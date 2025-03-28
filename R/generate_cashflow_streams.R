generate_cashflow_streams <- function(
  timeline, 
  triggers
) {
  
  purrr::map(triggers, function(triggers) {
  
    triggers <- c(triggers, "TRUE ~ 0")
    formulas <- purrr::map(triggers, rlang::parse_expr)

    timeline |>
      dplyr::transmute(stream = dplyr::case_when(!!!formulas)) |>
      dplyr::pull(stream)

  }) |>
  tibble::as_tibble()
}
