#' @export
simulate_scenario <- function(
  household,
  portfolio,
  scenario_id         = "default",
  current_date        = get_current_date(),
  monte_carlo_samples = NULL,
  seeds               = NULL,
  use_cache           = FALSE,
  debug               = FALSE,
  ...
) {
  
  index <- NULL

  if (
    capabilities("tcltk") && requireNamespace("tcltk1", quietly = TRUE) &&
    (!identical(.Platform$OS.type, "unix") || nzchar(Sys.getenv("DISPLAY")))
  ) {
    progress_handler <- progressr::handler_tkprogressbar()
  } else {
    progress_handler <- progressr::handler_cli()
  }


  cli::cli_h3("Simulating scenario: {.field {scenario_id}}")
  cli::cli_alert_info("Current date: {.field {current_date}}")

  if (use_cache) {

    cli::cli_alert_info("Caching is enabled!")

    memoised_functions       <- .pkg_env$memoised
    simulate_single_scenario <- memoised_functions$simulate_single_scenario
    
  } else {

    cli::cli_alert_warning(cli::col_yellow("Caching is NOT enabled."))

  }


  cli::cli_progress_step(
    "Simulating a scenario based on expected returns (sample_id=={.field {0}})",
    class = ".alert"
  )
  
  scenario <- 
    simulate_single_scenario(
      household      = household,
      portfolio      = portfolio,
      scenario_id    = scenario_id,
      current_date   = current_date,
      random_returns = FALSE,
      seed           = NULL,
      debug          = debug,
      ...
    ) |> 
      dplyr::mutate(sample = 0) |> 
      dplyr::select(
        scenario_id, 
        sample, 
        index,
        dplyr::everything()
      )

  if (is.null(monte_carlo_samples)) {
    return(scenario)
  } 

  n_samples <- monte_carlo_samples

  cli::cli_progress_step(
    "Simulating {.field {n_samples}} Monte Carlo samples",
    class = ".alert"
  )

  progressr::with_progress(
    handlers = progress_handler,
    expr     = {

      progress_bar <- progressr::progressor(steps = n_samples)
      
      monte_carlo_samples <- 
        furrr::future_map(seq_len(n_samples), function(sample_id) {
          
          progress_bar(
            message = glue::glue(
              "Sample {sample_id} out of {n_samples}"
            )
          )
        
          simulate_single_scenario(
            household      = household,
            portfolio      = portfolio,
            scenario_id    = scenario_id,
            current_date   = current_date,
            random_returns = TRUE,
            seed           = seeds[sample_id],
            debug          = debug,
            ...
          ) |> 
            dplyr::mutate(sample = sample_id)
        }, 
        .options = furrr::furrr_options(seed = NULL)
      ) |> 
          dplyr::bind_rows() 
  })
  
  scenario |> 
    dplyr::bind_rows(monte_carlo_samples) |> 
    dplyr::select(
      scenario_id, 
      sample, 
      dplyr::everything()
    )
}
