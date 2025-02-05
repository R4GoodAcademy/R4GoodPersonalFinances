#' @export
#' 
calc_gompertz_survival_probability <- function(
  current_age, 
  target_age, 
  mode, 
  dispersion,
  max_age = NULL
) {

  if (is.null(max_age)) {
    return(calc_gompertz_surv_prob(
      current_age = current_age,
      target_age  = target_age,
      mode        = mode,
      dispersion  = dispersion
    ))
  }
  
  probabilities <- 
    (
      calc_gompertz_survival_probability(
        current_age = current_age, 
        target_age  = target_age, 
        mode        = mode, 
        dispersion  = dispersion
      ) - 
      calc_gompertz_survival_probability(
        current_age = current_age, 
        target_age  = max_age, 
        mode        = mode, 
        dispersion  = dispersion
      ) 
    ) / (
      1 - 
        calc_gompertz_survival_probability(
          current_age = current_age, 
          target_age  = max_age, 
          mode        = mode, 
          dispersion  = dispersion
        )
    )

  probabilities[target_age > max_age] <- 0
  
  probabilities
}

calc_gompertz_surv_prob <- function(
  current_age, 
  target_age, 
  mode, 
  dispersion
) {

  exp(
    exp((current_age - mode) / dispersion) * 
    (1 - exp((target_age - current_age) / dispersion))
  )
}

#' @export
calc_gomperts_paramaters <- function(
  mortality_rates,
  current_age, 
  max_age = NULL
) {
  
  mortality_rates <- 
    mortality_rates |>
    dplyr::filter(age >= !!current_age) |> 
    dplyr::mutate(
      survival_rate = cumprod(c(1, 1 - mortality_rate[-1]))
    ) |> 
    dplyr::mutate(
      probability_of_death = 
        dplyr::lag(survival_rate, default = 1) - survival_rate
  )

  mode <- 
    mortality_rates |> 
    dplyr::filter(probability_of_death == max(probability_of_death)) |> 
    dplyr::pull(age)

  
  objective_fun <- function(x) {
    sum(
      (
        calc_gompertz_survival_probability(
          current_age = current_age, 
          target_age  = mortality_rates$age, 
          max_age     = max_age,
          mode        = mode, 
          dispersion  = x
        ) - mortality_rates$survival_rate
      ) ^ 2
    )
  }

  dispersion = optimize(
    objective_fun, 
    interval = c(0, 100),
    maximum = FALSE
  )$minimum

  list(
    mortality_rates = mortality_rates,
    mode            = mode,
    dispersion      = dispersion
  )
}
