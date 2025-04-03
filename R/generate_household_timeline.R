generate_household_timeline <- function(household, current_date) {

  current_date <- lubridate::as_date(current_date)
  max_lifespan <- household$get_lifespan(current_date = current_date)


  timeline <-
    tibble::tibble(
      index      = seq_len(max_lifespan + 1) - 1,
      years_left = max_lifespan - index,
      date       = current_date + lubridate::years(index),
      year       = lubridate::year(date)
    )

  members <- 
    household$get_members() |> 
    purrr::map(function(member) {
      
      tibble::tibble(
        age = 
          member$calc_age(current_date = timeline$date) |> 
            round(0)
      )
    }) |> 
    tibble::as_tibble()
  
  timeline |> 
    dplyr::mutate(hm = members)
}
