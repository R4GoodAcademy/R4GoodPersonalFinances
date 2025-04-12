simulate_scenarios <- function(
  scenarios_parameters,
  household,
  portfolio,
  current_date
) {

  unique(scenarios_parameters$scenario) |> 
    purrr::map(function(scenario_id) {

      cli::cli_h1("Simulating scenario: {.value {scenario_id}}")
      
      scenario_params <- 
        scenarios_parameters |> 
        dplyr::filter(scenario == scenario_id)
        
      scenario_flags   <- scenario_params$flags[[1]]
      cloned_household <- household$clone(deep = TRUE)

      for (i in NROW(scenario_flags)) {
        cloned_household$get_members()[[scenario_flags[i, ]$member]]$set_flag(
          flag      = scenario_flags[i, ]$flag,  
          start_age = scenario_flags[i, ]$start_age, 
          end_age   = scenario_flags[i, ]$end_age,
          years     = scenario_flags[i, ]$years)
      }
        
      simulate_scenario(
        household    = cloned_household,
        portfolio    = portfolio,
        current_date = current_date
      ) |> 
        dplyr::mutate(scenario = scenario_id)

    }) |> 
    purrr::list_rbind() |> 
    dplyr::select(
      scenario, index, dplyr::everything()
    )
}
