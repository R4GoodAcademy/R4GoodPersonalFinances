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

#' See Blanchet, David M., and Paul D. Kaplan. 2013. "Alpha, Beta, and Now... Gamma." Journal of Retirement 1 (2): 29-45. doi:10.3905/jor.2013.1.2.029.
#' @export
calc_gompertz_paramaters <- function(
  mortality_rates,
  current_age
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
  
  gompertz_objective_fun <- function(x) {
    dispersion <- x[1]
    max_age    <- x[2]

    sum((
      calc_gompertz_survival_probability(
        current_age = current_age, 
        target_age  = mortality_rates$age, 
        max_age     = max_age,
        mode        = mode, 
        dispersion  = dispersion
      ) - mortality_rates$survival_rate
    ) ^ 2)
  }

  results <- optim(
    par = c(10, 100),
    fn = gompertz_objective_fun
  )

  dispersion <- results$par[1]
  max_age    <- results$par[2]

  list(
    data        = mortality_rates,
    mode        = mode,
    dispersion  = dispersion,
    current_age = current_age,
    max_age     = max_age
  )
}

#' @export
plot_gompertz_callibration <- function(
  params,
  mode,
  dispersion,
  max_age
) {

  if (missing(max_age))    max_age    <- params$max_age
  if (missing(mode))       mode       <- params$mode
  if (missing(dispersion)) dispersion <- params$dispersion

  data_to_plot <- 
    params$data |> 
    dplyr::mutate(
      survival_rate_gompertz = 
        calc_gompertz_survival_probability(
          target_age  = age, 
          current_age = params$current_age, 
          max_age     = max_age,
          mode        = mode, 
          dispersion  = dispersion
        )
    ) 
  
  colours                    <-  PrettyCols::prettycols("Bold")
  real_survival_rate_col     <- colours[4]
  gompertz_survival_rate_col <- colours[5]
  value_colour               <- "grey40"
  
  data_to_plot |> 
     print(n = 1) |> 
    ggplot2::ggplot(
      ggplot2::aes(x = age)
    ) + 
    ggplot2::geom_point(
      ggplot2::aes(y = survival_rate), 
      color = real_survival_rate_col,
      size = 2.5,
    ) + 
    ggplot2::geom_line(
      ggplot2::aes(y = survival_rate_gompertz),
      color = gompertz_survival_rate_col,
      linewidth = 1
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      legend.position  = "bottom",
      panel.grid.minor = ggplot2::element_line(color = "grey90"),
      plot.caption = 
        ggtext::element_markdown(
          color = "grey60", 
          size  = 10
        ),
      plot.subtitle = ggtext::element_markdown(color = "grey60")
    ) +
    ggplot2::labs(
      title    = "Gompertz Model Callibration",
      subtitle = glue::glue("<span style='color: {real_survival_rate_col};'>**Life tables**</span> vs <span style='color: {gompertz_survival_rate_col};'>**Gompertz**</span> survival rates for 
      {unique(params$data$sex)} in {unique(params$data$country)} as of 
      {unique(params$data$year)}

      "),
      y        = "Survival rate", 
      x        = "Age",
      caption = glue::glue(paste(
        "*Current age*: <span style='color: {value_colour};'>**{params$current_age}**</span>;",
        "*Max age*: <span style='color: {value_colour};'>**{ifelse(is.null(max_age), 'NULL', round(max_age,1))}**</span>;",
        "*Mode*: <span style='color: {value_colour};'>**{mode}**</span>;",
        "*Dispersion*: <span style='color: {value_colour};'>**{round(dispersion,2)}**</span>.",
        ""
      ))
    )
}
