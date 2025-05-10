#' @export
HouseholdMember <- R6::R6Class(
  classname = "HouseholdMember",

  public = list(

    initialize = function(
      name,
      birth_date,
      mode       = NULL,
      dispersion = NULL
    ) {
      private$.name       <- name
      private$.birth_date <- lubridate::as_date(birth_date)
      private$.mode       <- mode
      private$.dispersion <- dispersion
    },

    get_name = function() {
      private$.name
    },

    get_birth_date = function() {
      private$.birth_date
    },

    calc_age = function(current_date = get_current_date()) {

      current_date <- lubridate::as_date(current_date)
      max_age      <- private$.max_age
      
      age <- current_date - private$.birth_date
      age <- lubridate::time_length(age, unit = "years")
      
      age[floor(age) > max_age] <- NA
      age
    },
    
    get_lifespan = function(current_date = get_current_date()) {
      
      current_date <- lubridate::as_date(current_date)
      max_years_left <- self$max_age - self$calc_age(current_date)
      max_years_left[max_years_left < 0] <- 0
      max_years_left
    },

    calc_life_expectancy = function(current_date = get_current_date()) {
      
      current_date <- lubridate::as_date(current_date)
      calc_life_expectancy(
        current_age = self$calc_age(current_date),
        mode        = self$mode,
        dispersion  = self$dispersion
      )
    },

    calc_survival_probability = function(
      target_age, 
      current_date = get_current_date()
    ) {
      
      current_date <- lubridate::as_date(current_date)
      age          <- self$calc_age(current_date = current_date)
      mode         <- self$mode
      dispersion   <- self$dispersion
      
      calc_gompertz_survival_probability(
        current_age = age,
        target_age  = target_age,
        mode        = mode,
        dispersion  = dispersion
      )
    },

    get_events = function() {
      private$.events
    },

    set_event = function(
      event, 
      start_age, 
      end_age = Inf,
      years   = Inf
    ) {

      if (!is.infinite(years)) {
        end_age <- start_age + years - 1
      }

      private$.events[[event]] <- list(
        start_age = start_age,
        end_age   = end_age
      )
    }

  ),

  active = list(

    max_age = function(value) {
      if (missing(value)) {
        private$.max_age
      } else {
        private$.max_age <- value
      }
    },

    mode = function(value) {
      if (missing(value)) {
        private$.mode
      } else {
        private$.mode <- value
      }
    },

    dispersion = function(value) {
      if (missing(value)) {
        private$.dispersion
      } else {
        private$.dispersion <- value
      }
    }
  ),

  private = list(

    .max_age    = 100,
    .name       = NULL,
    .birth_date = NULL,
    .mode       = NULL,
    .dispersion = NULL,
    .events      = list()

  )
)
