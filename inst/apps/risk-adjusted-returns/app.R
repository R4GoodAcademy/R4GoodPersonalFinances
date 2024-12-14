ui <- 
  bslib::page_sidebar(
    title = "Risk-adjusted Returns & Optimal Risky Asset Allocation",
    sidebar = bslib::sidebar(
      width = 300,
      shiny::sliderInput(
        inputId = "current_risky_asset_allocation",
        label = "Current\nrisky asset allocation",
        step = 1,
        animate = shiny::animationOptions(
          interval = 500,
          loop = FALSE,
          playButton = NULL,
          pauseButton = NULL
        ),
        post = "%",
        min = 0, 
        max = 100, 
        value = 50
      ),
      shiny::numericInput(
        inputId = "risky_asset_return_mean",
        label = "Risky asset return mean (%)",
        step = 0.1,
        value = 4
      ),
      shiny::numericInput(
        inputId = "risky_asset_return_sd",
        label = "Risky asset return SD (%)",
        step = 0.1,
        value = 15
      ),
      shiny::numericInput(
        inputId = "safe_asset_return",
        label = "Safe asset return (%)",
        step = 0.1,
        value = 2
      ),
      shiny::numericInput(
        inputId = "risk_aversion",
        label = "Risk aversion",
        step = 0.1,
        value = 2
      ),
      sidebar_footer()
    ),
    
    bslib::card(
      max_height = "650px",
      shiny::plotOutput("rar_plot")
    )
  )

server <- function(input, output, session) {

  add_sidebar_footer_resources()

  output$rar_plot <- shiny::renderPlot({
    
    plot_risk_adjusted_returns(
      current_risky_asset_allocation = 
        input$current_risky_asset_allocation / 100,
      safe_asset_return       = input$safe_asset_return / 100,
      risky_asset_return_mean = input$risky_asset_return_mean / 100,
      risky_asset_return_sd   = input$risky_asset_return_sd / 100,
      risk_aversion           = input$risk_aversion
    )
  })
}

shiny::shinyApp(ui, server)
