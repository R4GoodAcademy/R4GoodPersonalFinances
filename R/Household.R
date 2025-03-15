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
          "x" = "There is already a member named {.val {household_member$get_name()}}"
        ))
      }

      new_household_member <- list(household_member)
      names(new_household_member) <- household_member$get_name()

      private$.household_members <-
        append(
          private$.household_members,
          new_household_member
        )
    },

    calc_max_lifespan = function(current_date) {
      
      current_date <- lubridate::as_date(current_date)

      if (length(private$.household_members) == 0) {
        cli::cli_abort(c(
          "No members in the household:",
          "x" = "There are no members added to the household!"
        ))
      }

      private$.household_members |> 
        purrr::map_dbl(function(household_member) {
          household_member$calc_max_lifespan(current_date = current_date)
        }) |> 
        max() |> 
        ceiling()
    }
  ),

  active = list(

  ),

  private = list(

    .household_members = list()

  )
)
