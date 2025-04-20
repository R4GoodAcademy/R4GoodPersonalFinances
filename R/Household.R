Household <- R6::R6Class(
  classname = "Household",

  public = list(

    initialize = function() {},

    get_members = function() {
      private$.household_members
    },

    add_member = function(household_member) {

      if (household_member$get_name() %in% 
          names(private$.household_members)) {
        
        cli::cli_abort(c(
          "Household member already exists:",
          "x" = "There is already a member named {.value {household_member$get_name()}}"
        ))
      }

      self$set_member(member = household_member)
    },

    set_member = function(member) {

      private$.household_members[[member$get_name()]] <- member
    },

    set_lifespan = function(value) {
      private$.lifespan <- value
    },

    get_lifespan = function(current_date = get_current_date()) {
      
      current_date <- lubridate::as_date(current_date)

      if (!is.null(private$.lifespan)) {
        return(private$.lifespan)
      }

      if (length(private$.household_members) == 0) {
        cli::cli_abort(c(
          "No members in the household:",
          "x" = "There are no members added to the household!"
        ))
      }

      private$.household_members |> 
        purrr::map_dbl(function(household_member) {
          household_member$get_lifespan(current_date = current_date)
        }) |> 
        max() |> 
        ceiling()
    },

    calc_survival = function(current_date = get_current_date()) {

      current_date       <- lubridate::as_date(current_date)
      household_lifespan <- self$get_lifespan(current_date = current_date)
      members            <- self$get_members()
      members_params <- purrr::map(members, function(member) {
        list(
          name       = member$get_name(),
          age        = member$calc_age(current_date = current_date) |> round(0),
          mode       = member$mode,
          dispersion = member$dispersion,
          max_age    = member$max_age
        )
        
      })

      survival_rates <- 
        dplyr::tibble(
          year = 0:(household_lifespan)
        ) 
      
      members_ages <- 
        members_params |> 
        purrr::map_dbl(function(x) x$age) |> 
        unname() 

      min_age <- min(members_ages)

      for (member in members_params) {

        survival_rates <- 
          survival_rates |>
          dplyr::mutate(
            !!member$name := 
              calc_gompertz_survival_probability(
                current_age = member$age, 
                target_age  = member$age + year, 
                mode        = member$mode, 
                dispersion  = member$dispersion,
                max_age     = member$max_age
              )
          )
      }

      survival_rates <- 
        survival_rates |>
        dplyr::mutate(
          joint = 
            1 - purrr::pmap_dbl(
              .l = dplyr::select(survival_rates, dplyr::all_of(names(members_params))),
              .f = function(...) {
                prod(1 - c(...))
              }
            )
        )

      objective_fun <- function(params) {

        mode       <- params[1]
        dispersion <- params[2]
        
        approx_surv <- 
          calc_gompertz_survival_probability(
            current_age = min_age, 
            target_age  = min_age + survival_rates$year,
            mode        = mode, 
            dispersion  = dispersion
          )
        
        actual_surv <- survival_rates$joint
        sum((approx_surv - actual_surv) ^ 2)
      }

      members_modes <- 
        purrr::map_dbl(members_params, function(x) x$mode)
      members_dispersions <- 
        purrr::map_dbl(members_params, function(x) x$dispersion)
      
      init_params <- c(
        mode       = mean(members_modes), 
        dispersion = mean(members_dispersions)
      )
      
      params <- stats::optim(
        par = init_params, 
        fn  = objective_fun
      )

      mode       <- params$par[["mode"]]
      dispersion <- params$par[["dispersion"]]

      survival_rates <- 
        survival_rates |> 
        dplyr::mutate(
          gompertz = calc_gompertz_survival_probability(
            current_age = min_age,
            target_age  = min_age + year,
            mode        = mode,
            dispersion  = dispersion
          )
        )
        
      list(
        data        = survival_rates,
        mode        = mode,
        dispersion  = dispersion,
        current_age = min_age
      )
    },

    get_min_age = function(current_date = get_current_date()) {

      current_date <- lubridate::as_date(current_date)
      
      min_age <- 
        private$.household_members |>
        purrr::map_dbl(function(x) x$calc_age(current_date = current_date)) |>
        min()
      min_age
    }
  ),

  active = list(

    expected_income = function(value) {
      if (missing(value)) {
        return(private$.expected_income)
      } 
      private$.expected_income <- value
    },

    expected_spending = function(value) {
      if (missing(value)) {
        return(private$.expected_spending)
      } 
      private$.expected_spending <- value
    },

    risk_tolerance = function(value) {
      if (missing(value)) {
        return(private$.risk_tolerance)
      } 
      private$.risk_tolerance <- value
    },

    consumption_impatience_preference = function(value) {
      if (missing(value)) {
        return(private$.consumption_impatience_preference)
      }
      private$.consumption_impatience_preference <- value
    },

    smooth_consumption_preference = function(value) {
      if (missing(value)) {
        return(private$.smooth_consumption_preference)
      }
      private$.smooth_consumption_preference <- value
    }

  ),

  private = list(

    .household_members                 = list(),
    .expected_income                   = list(),
    .expected_spending                 = list(),
    .lifespan                          = NULL,
    .risk_tolerance                    = 0.5,
    .consumption_impatience_preference = 0.04,
    .smooth_consumption_preference     = 1,
    
    deep_clone = function(name, value) {

      if (name != ".household_members") return(value)
        
      purrr::map(value, function(item) {
        item$clone(deep = TRUE)
      })
    }

  )
)

