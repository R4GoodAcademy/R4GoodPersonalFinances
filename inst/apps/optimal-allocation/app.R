ui <- 
  bslib::page_sidebar(
    title = "Optimal Risky Asset Allocation",
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
      shiny::div(style = "text-align: center;",
      shiny::tags$a(
        shiny::tags$img(
          src = "figures/r4ga-logo.png",
          height = "110px",
          width = "110px",
          alt = "R4Good.Academy"
        ),
        href = "https://r4good.academy/", 
        target = "_blank"
      ),
      shiny::tags$a(
        shiny::tags$img(
          src = "figures/logo.png",
          height = "110px",
          width = "110px",
          alt = "R4GoodPersonalFinances"
        ),
        href = "https://r4goodacademy.github.io/R4GoodPersonalFinances", 
        target = "_blank"
      )
      )
    ),
    
    bslib::card(
      max_height = "650px",
      shiny::plotOutput("rar_plot")
    )
  )

server <- function(input, output, session) {

  shiny::addResourcePath("figures", system.file("man", "figures", package = "R4GoodPersonalFinances"))

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
