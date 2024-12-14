sidebar_footer <- function(hex_size = "110px") {

  shiny::div(
    style = 
      "text-align: center; display: flex; justify-content: center; gap: 10px;",
    shiny::tags$a(
      shiny::tags$img(
        src = "figures/r4ga-logo.png",
        height = hex_size,
        width = hex_size,
        alt = "R4Good.Academy",
        style = "display: block; margin: 0; border: none;"
      ),
      href = "https://r4good.academy/",
      target = "_blank"
    ),
    shiny::tags$a(
      shiny::tags$img(
        src = "figures/logo.png",
        height = hex_size,
        width = hex_size,
        alt = "R4GoodPersonalFinances",
        style = "display: block; margin: 0; border: none;"
      ),
      href = "https://r4goodacademy.github.io/R4GoodPersonalFinances",
      target = "_blank"
    )
  )
}

add_sidebar_footer_resources <- function() {

  shiny::addResourcePath(
    "figures", 
    system.file("man", "figures", package = "R4GoodPersonalFinances")
  )
}

