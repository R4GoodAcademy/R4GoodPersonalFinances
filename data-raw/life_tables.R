  # HMD. Human Mortality Database. Max Planck Institute for Demographic Research (Germany), University of California, Berkeley (USA), and French Institute for Demographic Studies (France). Available at www.mortality.org (data downloaded on 2025-02-05).




# ## code to prepare `DATASET` dataset goes here

# # Table 1: "Annuity 2000 Basic Table" in 
# # Johansen, Robert J. 1998. “Annuity 2000 Mortality Tables.” Transactions, Society of Actuaries, pp.  264-290. http://www.soa.org/library/research/transactions-reports-of-mortality-moribidity-and-experience/1990-99/1995/january/TSR9510.pdf.


read_hmd_life_tables <- function(
  path  = getwd(),
  files = c("mltper_1x1.txt", "fltper_1x1.txt", "bltper_1x1.txt")
) {
  
  purrr::map(files, function(file) {
    readr::read_table(
      file.path(path, file), 
      skip = 2,
      col_types = readr::cols(
        Year = readr::col_integer(),
        Age  = readr::col_character(),
        mx   = readr::col_double(),
        qx   = readr::col_double(),
        ax   = readr::col_double(),
        lx   = readr::col_double(),
        dx   = readr::col_double(),
        Lx   = readr::col_double(),
        Tx   = readr::col_double(),
        ex   = readr::col_double()
      )
    )  
  }) |> 
    purrr::set_names(files) |> 
    dplyr::bind_rows(.id = "file") |> 
    dplyr::transmute(
      sex = dplyr::case_when(
        file == "mltper_1x1.txt" ~ "male",
        file == "fltper_1x1.txt" ~ "female",
        file == "bltper_1x1.txt" ~ "both"
      ),
      year            = Year,
      age             = Age,
      mortality_rate  = qx,
      life_expectancy = ex
    ) |> 
    dplyr::mutate(
      age = stringr::str_replace(age, stringr::fixed("+"), "")
    ) |> 
    dplyr::mutate( age = as.integer(age)) 
}

countries <- c("Poland", "USA")

life_tables <- 
  purrr::map_dfr(countries, function(country) {
    read_hmd_life_tables(path = file.path("data-raw", tolower(country))) |> 
    dplyr::mutate(country = !!country) |> 
    dplyr::select(country, dplyr::everything())
  })  

life_tables |> 
  dplyr::count(country)

usethis::use_data(
  life_tables, 
  overwrite = TRUE,
  internal  = FALSE
)
