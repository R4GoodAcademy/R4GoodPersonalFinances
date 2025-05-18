#' HouseholdMember class
#' 
#' @description
#' The `HouseholdMember` class aggregates information about
#' a single member of a household.
#' 
#' @returns An object of class `HouseholdMember`.
#' @examples
#' member <- HouseholdMember$new(
#'   name       = "Isabela",
#'   birth_date = "1980-07-15",
#'   mode       = 91,
#'   dispersion = 8.88
#' )
#' member$calc_age()
#' member$calc_life_expectancy()
#' @export
HouseholdMember <- R6::R6Class(
  classname = "HouseholdMember",
  public = list(

    #' @description 
    #' Creating a new object of class `HouseholdMember`
    #' @param name The name of the member.
    #' @param birth_date The birth date of the household member 
    #' in the format `YYYY-MM-DD`.
    #' @param mode The Gompertz mode parameter.
    #' @param dispersion The Gompertz dispersion parameter.
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

    #' @description 
    #' Getting the name of the household member
    get_name = function() {
      private$.name
    },

    #' @description 
    #' Getting the birth date of the household member
    get_birth_date = function() {
      private$.birth_date
    },

    #' @description 
    #' Calculating the age of the household member
    #' @param current_date A date in the format "YYYY-MM-DD".
    calc_age = function(current_date = get_current_date()) {

      current_date <- lubridate::as_date(current_date)
      max_age      <- private$.max_age
      
      age <- current_date - private$.birth_date
      age <- lubridate::time_length(age, unit = "years")
      
      age[floor(age) > max_age] <- NA
      age
    },
    
    #' @description 
    #' Calculating a lifespan of the household member
    #' @param current_date A date in the format "YYYY-MM-DD".
    get_lifespan = function(current_date = get_current_date()) {
      
      current_date <- lubridate::as_date(current_date)
      max_years_left <- self$max_age - self$calc_age(current_date)
      max_years_left[max_years_left < 0] <- 0
      max_years_left
    },

    #' @description 
    #' Calculating a life expectancy of the household member
    #' @param current_date A date in the format "YYYY-MM-DD".
    calc_life_expectancy = function(current_date = get_current_date()) {
      
      current_date <- lubridate::as_date(current_date)
      calc_life_expectancy(
        current_age = self$calc_age(current_date),
        mode        = self$mode,
        dispersion  = self$dispersion
      )
    },

    #' @description 
    #' Calculating a survival probability of the household member
    #' @param target_age A target age in the format "YYYY-MM-DD".
    #' @param current_date A date in the format "YYYY-MM-DD".
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

    #' @description 
    #' Getting the events related to the household member
    get_events = function() {
      private$.events
    },

    #' @description 
    #' Setting an event related to the household member
    #' @param event The name of the event.
    #' @param start_age The age of the household member when the event starts.
    #' @param end_age The age of the household member when the event ends.
    #' @param years The number of years the event lasts.
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

    #' @field max_age The maximum age of the household member
    max_age = function(value) {
      if (missing(value)) {
        private$.max_age
      } else {
        private$.max_age <- value
      }
    },

    #' @field mode The Gompertz mode parameter
    mode = function(value) {
      if (missing(value)) {
        private$.mode
      } else {
        private$.mode <- value
      }
    },

    #' @field dispersion The Gompertz dispersion parameter
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
