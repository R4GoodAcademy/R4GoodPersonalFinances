generate_household_timeline <- function(
  household, 
  current_date
) {

  current_date <- lubridate::as_date(current_date)
  max_lifespan <- household$get_lifespan(current_date = current_date)

  timeline <-
    tibble::tibble(
      index         = seq_len(max_lifespan + 1) - 1,
      years_left    = max_lifespan - index,
      date          = current_date + lubridate::years(index),
      year          = lubridate::year(date),
      survival_prob = 
        household$calc_survival(current_date = current_date)$data$gompertz
    )
  
  members <- 
    household$get_members() |> 
    purrr::map(function(member) {
      
      member_specific <- 
        tibble::tibble(
          age = member$calc_age(current_date = timeline$date) |>  round(0)
        ) 
      
      events <- member$get_events()
      if (length(events) > 0) {
        
        events <- 
          names(events) |> 
          purrr::map(function(event_name) {
            member_specific$age >= events[[event_name]]$start_age &
            member_specific$age <= events[[event_name]]$end_age
          }) |> 
          purrr::set_names(names(events)) |> 
          tibble::as_tibble()
          
        member_specific <- 
          member_specific |>
          dplyr::mutate(events = events)
      }

      member_specific
    }) |> 
    tibble::as_tibble()

  timeline |> 
    dplyr::mutate(hm = members)
}
