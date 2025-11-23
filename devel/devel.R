
usethis::use_version(which = "dev")

{devtools::load_all("../../CoeditorAI/CoeditorAI-RStudio/"); coedit_text();}


withr::with_envvar(
  c(
    NOT_CRAN = "true",   # prevents skip_on_cran()
    CI = "false"         # prevents skip_on_ci()
  ),
  covr::package_coverage(quiet = FALSE, type = "tests")
)


testthat::snapshot_review("plot_life_expectancy/")
testthat::snapshot_review("plot_purchasing_power/")
testthat::snapshot_review("plot_life_expectancy/")
testthat::snapshot_review("plot_future_spending/")
testthat::snapshot_review("plot_future_saving_rates/")
testthat::snapshot_review("plot_future_income/")
testthat::snapshot_review("plot_expected_capital/")
testthat::snapshot_review("plot_expected_allocation/")
testthat::snapshot_review("plot_risk_adjusted_returns/")
testthat::snapshot_review("plot_scenarios/")
testthat::snapshot_review("plot_survival/")
testthat::snapshot_review("simulate_scenario/")
testthat::snapshot_review("plot_optimal_portfolio/")
