ui <- 
  bslib::page_sidebar(
    title = "Purchasing Power Over Time",
    sidebar = bslib::sidebar(
      width = 250,
      shiny::numericInput(
        inputId = "x",
        label = "Initial capital",
        step = 1,
        value = 10
      ),
      shiny::sliderInput(
        inputId = "real_interest_rate",
        label = "Real interest rate",
        step = 0.5,
        post = "%",
        min = -10, 
        max = 10, 
        value = -5
      ),
      shiny::sliderInput(
        inputId = "years",
        label = "Number of years",
        animate = shiny::animationOptions(
          interval = 700,
          loop = FALSE,
          playButton = NULL,
          pauseButton = NULL
        ),
        step = 5,
        min = 1, 
        max = 100, 
        value = 1
      ),
      sidebar_footer()
    ),
    
    bslib::card(
      max_height = "650px",
      full_screen = TRUE,
      shiny::plotOutput("purchasing_power_plot"),
      bslib::card_footer(
        bslib::popover(
          bsicons::bs_icon("gear"),
          shiny::numericInput(
            inputId = "res", 
            value = getOption("R4GPF.plot_res", default = 120), 
            label = "Plot resolution"
          ),
          title = "Settings"
        )
      )
    )
  )
