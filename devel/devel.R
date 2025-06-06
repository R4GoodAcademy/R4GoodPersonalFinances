custom_function <- 
function (name, old_path, new_path) {
  
  inform <- print
    stopifnot(length(name) == length(old_path), length(old_path) == 
        length(new_path))
    n <- length(name)
    case_index <- stats::setNames(seq_along(name), name)
    handled <- rep(FALSE, n)
    ui <- shiny::fluidPage(style = "margin: 0.5em", shiny::fluidRow(style = "display: flex", 
        shiny::div(style = "flex: 1 1", shiny::selectInput("cases", 
            NULL, case_index, width = "100%")), shiny::div(class = "btn-group", 
            style = "margin-left: 1em; flex: 0 0 auto", shiny::actionButton("skip", 
                "Skip"), shiny::actionButton("accept", "Accept", 
                class = "btn-success"), )), shiny::fluidRow(diffviewer::visual_diff_output("diff")))
    server <- function(input, output, session) {
        i <- shiny::reactive(as.numeric(input$cases))
        output$diff <- diffviewer::visual_diff_render({
            diffviewer::visual_diff(old_path[[i()]], new_path[[i()]])
        })
        shiny::observeEvent(input$reject, {
            inform(paste0("Rejecting snapshot: '", new_path[[i()]], 
                "'"))
            unlink(new_path[[i()]])
            update_cases()
        })
        shiny::observeEvent(input$accept, {
            inform(paste0("Accepting snapshot: '", old_path[[i()]], 
                "'"))
            file.rename(new_path[[i()]], old_path[[i()]])
            update_cases()
        })
        shiny::observeEvent(input$skip, {
            i <- next_case()
            shiny::updateSelectInput(session, "cases", selected = i)
        })
        update_cases <- function() {
            handled[[i()]] <<- TRUE
            i <- next_case()
            shiny::updateSelectInput(session, "cases", choices = case_index[!handled], 
                selected = i)
        }
        next_case <- function() {
            if (all(handled)) {
                inform("Review complete")
                shiny::stopApp()
                return()
            }
            remaining <- case_index[!handled]
            next_cases <- which(remaining > i())
            if (length(next_cases) == 0) 
                remaining[[1]]
            else remaining[[next_cases[[1]]]]
        }
    }
    inform(c("Starting Shiny app for snapshot review", i = "Use Ctrl + C to quit"))
    shiny::runApp(shiny::shinyApp(ui, server), 
    # quiet = TRUE, 
    quiet = FALSE, 
        launch.browser = shiny::paneViewer())
    invisible()
}

unlockBinding("review_app", asNamespace("testthat"))
assign("review_app", custom_function, envir = asNamespace("testthat"))
lockBinding("review_app", asNamespace("testthat"))

usethis::use_version(which = "dev")

{devtools::load_all("../../CoeditorAI/CoeditorAI-RStudio/"); coedit_text();}
