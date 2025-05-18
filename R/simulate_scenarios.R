#' @export
simulate_scenarios <- function(
  scenarios_parameters,
  household,
  portfolio,
  current_date        = get_current_date(),
  monte_carlo_samples = NULL,
  auto_parallel       = FALSE,
  use_cache           = FALSE,
  debug               = FALSE,
  ...
) {

  scenario_id <- index <- NULL

  current_date <- lubridate::as_date(current_date)

  if (!is.null(monte_carlo_samples)) {
    seeds <- stats::runif(monte_carlo_samples, min = 0, max = 1e6)
  }

  scenarios_ids <- unique(scenarios_parameters$scenario_id)

  cli::cli_h1(glue::glue(
    "Simulating {length(scenarios_ids)} scenarios"
  ))

  cli::cli_alert_info("Cache directory: {.file {(.pkg_env$cache_directory)}}")

  if (auto_parallel) {

    if (!is.null(monte_carlo_samples)) {

      n_workers <- future::availableCores()

      old_plan <- future::plan(future::multisession, workers = n_workers)

      cli::cli_alert_info(
        "Auto-parallelization enabled with {.field {n_workers}} workers."
      )
      
      on.exit(future::plan(old_plan))
    } 
  }

  scenarios_ids |> 
    purrr::map(function(scenario_id) {

      cli::cli_h2(paste0(
        "Scenario ", 
        "{which(scenario_id == scenarios_ids)}/{length(scenarios_ids)} ",
        "({format_percent(which(scenario_id == scenarios_ids) / 
          length(scenarios_ids), 1)})"
      ))
      
      scenario_params <- 
        scenarios_parameters |> 
        dplyr::filter(scenario_id == !!scenario_id)
        
      scenario_events   <- scenario_params$events[[1]]

      temp_file <- tempfile(fileext = ".rds")
      saveRDS(household, temp_file)
      household_cloned <- readRDS(temp_file)

      for (i in NROW(scenario_events)) {
        household_cloned$get_members()[[scenario_events[i, ]$member]]$set_event(
          event     = scenario_events[i, ]$event,  
          start_age = scenario_events[i, ]$start_age, 
          end_age   = scenario_events[i, ]$end_age,
          years     = scenario_events[i, ]$years)
      }
        
      simulate_scenario(
        household           = household_cloned,
        portfolio           = portfolio,
        current_date        = current_date,
        scenario_id         = scenario_id,
        monte_carlo_samples = monte_carlo_samples,
        seeds               = seeds,
        use_cache           = use_cache,
        debug               = debug,
        ...
      ) 

    }) |> 
    purrr::list_rbind() |> 
    dplyr::select(
      scenario_id, 
      index, 
      dplyr::everything()
    )
}
