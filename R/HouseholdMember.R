HouseholdMember <- R6::R6Class(
  classname = "HouseholdMember",

  public = list(

    initialize = function(
      name,
      birth_date
    ) {
      private$.name       <- name
      private$.birth_date <- lubridate::as_date(birth_date)
    },

    get_name = function() {
      private$.name
    },

    get_birth_date = function() {
      private$.birth_date
    },

    calc_age = function(current_date) {

      current_date <- lubridate::as_date(current_date)
      max_age      <- private$.max_age
      
      age <- current_date - private$.birth_date
      age <- lubridate::time_length(age, unit = "years")
      
      age[floor(age) > max_age] <- NA
      age
    },
    
    calc_max_lifespan = function(current_date) {
      
      current_date <- lubridate::as_date(current_date)
      max_years_left <- self$max_age - self$calc_age(current_date)
      max_years_left[max_years_left < 0] <- 0
      max_years_left
    }

  ),

  active = list(

    max_age = function(value) {
      if (missing(value)) {
        private$.max_age
      } else {
        private$.max_age <- value
      }
    }
  ),

  private = list(

    .name       = NULL,
    .birth_date = NULL,
    .max_age    = 100

  )
)
