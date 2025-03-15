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

    calc_max_lifespan = function() {}

  ),

  active = list(

  ),

  private = list(

    .household_members = list()

  )
)
