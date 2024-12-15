figures <- list()

figures$`logo.png` <-
  base64enc::dataURI(
    file = system.file(
      "man", "figures", "logo.png", 
      package = "R4GoodPersonalFinances"
    ), 
    mime = "image/png"
  )

figures$`r4ga-logo.png` <-
  base64enc::dataURI(
    file = system.file(
      "man", "figures", "r4ga-logo.png", 
      package = "R4GoodPersonalFinances"
    ), 
    mime = "image/png"
  )

usethis::use_data(figures, overwrite = TRUE, internal = TRUE)
