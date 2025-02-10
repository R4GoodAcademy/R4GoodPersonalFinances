# See: Milevsky, M.A. (2020). Retirement Income Recipes in R: From Ruin Probabilities to Intelligent Drawdowns. Use R! Series. https://doi.org/10.1007/978-3-030-51434-1
#' @export
calc_retirement_ruin <- function(
  portfolio_return_mean,
  portfolio_return_sd,
  age,
  gompertz_mode,
  gompertz_dispersion,
  portfolio_value,
  monthly_spendings,
  yearly_spendings = 12 * monthly_spendings,
  spending_rate    = yearly_spendings / portfolio_value
) {

  nu    <- portfolio_return_mean
  sigma <- portfolio_return_sd
  x     <- age
  m     <- gompertz_mode
  b     <- gompertz_dispersion

  mu <- nu + (0.5) * sigma^2 
  M1 <- calc_a(mu - sigma^2, x, m, b)
  M2 <- (M1 - calc_a(2 * mu - 3 * sigma^2, x, m, b)) / (mu / 2 - sigma^2)
  
  alpha <- (2 * M2 - M1^2) / (M2 - M1^2)
  beta  <- (M2 - M1^2) / (M2 * M1)

  pgamma(
    q          = spending_rate,
    shape      = alpha,
    scale      = beta,
    lower.tail = TRUE
  )
}

calc_a <- function(v, x, m, b) {
  
  b * exp(exp((x - m) / b) + (x - m) * v) * 
    calc_incomplete_gamma(-b * v, exp((x - m) / b))
}

calc_incomplete_gamma <- function(a, c) {

  integrand <- function(t) {
    t^(a - 1) * exp(-t)
  }

  integrate(integrand, c, Inf)$value
}



#' @export
plot_retirement_ruin <- function(
  portfolio_return_mean,
  portfolio_return_sd,
  age,
  gompertz_mode,
  gompertz_dispersion,
  portfolio_value,
  monthly_spendings = NULL
) {
  
annotate_monthly_spendings <- FALSE
if (length(monthly_spendings) == 1) {
  annotate_monthly_spendings <- TRUE
  monthly_spendings_to_annotate <- monthly_spendings
}
  
if (is.null(monthly_spendings)) {
  monthly_spendings <- round(portfolio_value * 0.04 / 12 / 1000,  0) * 1000
}

if (length(monthly_spendings) == 1) {

  if (monthly_spendings >= 1000) scale <- 1000 else scale <- 100
  
  monthly_spendings <- 
    seq(
      from = round(monthly_spendings * 0.20 / scale,  0) * scale,
      to   = round(monthly_spendings * 2.50 / scale,  0) * scale,
      by   = scale / 2
    )
}

yearly_spendings <- 12 * monthly_spendings
spending_rate    <- yearly_spendings / portfolio_value

retirement_ruin <- 
  calc_retirement_ruin(
  yearly_spendings      = yearly_spendings,
  portfolio_value       = portfolio_value,
  portfolio_return_mean = portfolio_return_mean,
  portfolio_return_sd   = portfolio_return_sd,
  age                   = age,
  gompertz_mode         = gompertz_mode,
  gompertz_dispersion   = gompertz_dispersion
) 
  
value_colour <- "grey60"
  
the_plot <- 
  dplyr::tibble(
    monthly_spendings = monthly_spendings,
    retirement_ruin = retirement_ruin
  ) |>
  ggplot2::ggplot(
    ggplot2::aes(
      x = monthly_spendings, 
      y = retirement_ruin,
      color = retirement_ruin
    )
  ) +
  ggplot2::geom_line(linewidth = 1) +
  ggplot2::scale_x_continuous(
    breaks = scales::breaks_extended(n = 10),
    labels = function(x) {
      paste0(
        print_currency(x / 1000, suffix = "k"),
        "<br><span style='color: grey60;'>",
        print_percent(x * 12 / portfolio_value),
        "</span>"
      )
    }
  ) + 
  ggplot2::scale_y_continuous(
    breaks = seq(0, 1, by = 0.1),
    labels = scales::percent,
    expand = c(0.005, 0.005)
  ) +
  ggplot2::theme_minimal() +
  ggplot2::guides(color = "none") +
  ggplot2::theme(
    axis.text.x = ggtext::element_markdown(),
    plot.caption = 
      ggtext::element_markdown(
        color = "grey60", 
        size  = 10
      ),
    plot.subtitle = ggtext::element_markdown(color = "grey60")
  ) +
  ggplot2::scale_color_gradientn(
    colors = c(
      PrettyCols::prettycols("Bold")[4], 
      rep(PrettyCols::prettycols("Bold")[5], 10)
    )
  ) + 
  ggplot2::labs(
    title = "Probability of Retirement Ruin",
    x = "Monthly spendings (in thousands) / Initial year withdrawal rate",
    y = "Probability of Retirement Ruin",
    caption = glue::glue(paste(
      "*Mean of portfolio returns*: <span style='color: {value_colour};'>**{print_percent(portfolio_return_mean)}**</span>;",
      "*Standard deviation of portfolio returns*: <span style='color: {value_colour};'>**{print_percent(portfolio_return_sd)}**</span>.",
      "<br>",
      "*Gompertz mode*: <span style='color: {value_colour};'>**{gompertz_mode}**</span>;",
      "*Gompertz dispersion*: <span style='color: {value_colour};'>**{gompertz_dispersion}**</span>."
    )),
    subtitle = glue::glue(paste0(
      "*Current age*: <span style='color: {value_colour};'>**{age}**</span>;",
      " *Initial portfolio value*: <span style='color: {value_colour};'>**{print_currency(portfolio_value)}**</span>."
    ))
  ) 
      
  if (annotate_monthly_spendings) {

    retirement_ruin_to_annotate <- 
      calc_retirement_ruin(
        monthly_spendings     = monthly_spendings_to_annotate,
        portfolio_value       = portfolio_value,
        portfolio_return_mean = portfolio_return_mean,
        portfolio_return_sd   = portfolio_return_sd,
        age                   = age,
        gompertz_mode         = gompertz_mode,
        gompertz_dispersion   = gompertz_dispersion
      )

    the_plot <- 
      the_plot +
      ggplot2::geom_vline(
        xintercept = monthly_spendings_to_annotate,
        color      = PrettyCols::prettycols("Bold")[1],
        linetype   = "dashed"
      ) + 
      ggplot2::geom_hline(
        yintercept = retirement_ruin_to_annotate,
        color      = PrettyCols::prettycols("Bold")[1],
        linetype   = "dashed"
      ) +
      ggplot2::annotate(
        geom = "label",
        x = monthly_spendings_to_annotate,
        y = max(retirement_ruin) * 0.95,
        label = paste0(
          print_currency(monthly_spendings_to_annotate, accuracy = 1),
          " (", 
          print_percent(monthly_spendings_to_annotate * 12 / portfolio_value), 
          ")"
        ),
        color = PrettyCols::prettycols("Bold")[1]
      ) +
      ggplot2::annotate(
        geom = "label",
        x = min(monthly_spendings),
        y = retirement_ruin_to_annotate,
        label = print_percent(retirement_ruin_to_annotate),
        color = PrettyCols::prettycols("Bold")[1]
      )
  }

  the_plot
}
