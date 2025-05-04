simulate_scenarios <- function(
  scenarios_parameters,
  household,
  portfolio,
  current_date = get_current_date(),
  monte_carlo_samples = NULL
) {

  if (!is.null(monte_carlo_samples)) {
    seeds <- runif(monte_carlo_samples, min = 0, max = 1e6)
  }

  scenarios_ids <- unique(scenarios_parameters$scenario_id)

  cli::cli_h1(glue::glue(
    "Simulating {length(scenarios_ids)} scenarios"
  ))

  scenarios_ids |> 
    purrr::map(function(scenario_id) {

      cli::cli_h2(paste0(
        "Scenario ", 
        "{which(scenario_id == scenarios_ids)}/{length(scenarios_ids)} ",
        "({print_percent(which(scenario_id == scenarios_ids) / 
          length(scenarios_ids), 1)})"
      ))
      
      scenario_params <- 
        scenarios_parameters |> 
        dplyr::filter(scenario_id == !!scenario_id)
        
      scenario_events   <- scenario_params$events[[1]]
      household_cloned <- household$clone(deep = TRUE)

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
        seeds               = seeds
      ) 

    }) |> 
    purrr::list_rbind() |> 
    dplyr::select(
      scenario_id, 
      index, 
      dplyr::everything()
    )
}
