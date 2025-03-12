# R4GoodPersonalFinances 0.2.0

This release provides functions for calculating probability of retirement ruin and functions for calibrating the underlying Gompertz model with the use of the mortality rates.

## Major changes

* Added `calc_retirement_ruin()` and `plot_retirement_ruin()` to calculate and visualize the probability of retirement ruin.
* Added `retirement-ruin` option to `run_app()` function for
running package new interactive app.
* Added `calc_gompertz_survival_probability()` to calculate the probability of survival using the Gompertz model. 
* Added `calc_gompertz_parameters()` to calculate the parameters of the Gompertz model based on mortality rates and `calc_gompertz_joint_parameters()` to calculate the parameters of the joint Gompertz model.
* Added `plot_gompertz_calibration()` for visually checking the calibration of the Gompertz model and `plot_joint_survival()` for plotting the survival probabilities for two individuals and their joint survival probability.
* Added `read_hmd_life_tables()` for reading the 'Human Mortality Database' (HMD) life tables files.

# R4GoodPersonalFinances 0.1.1

## Bugfixes

* Fixed apps errors while executing locally.

# R4GoodPersonalFinances 0.1.0

Initial release of the package includes functions designed to 
support the optimal allocation of your investment portfolio
with the use of the 'Merton Share' formula.

* Added `calc_purchasing_power()` and `plot_purchasing_power()` to calculate and visualize the effect of real interest rates—whether positive (compounding) or negative (inflation)—on the purchasing power of savings.  
* Added `calc_optimal_risky_asset_allocation()` for calculating optimal allocation using the 'Merton Share' formula.  
* Added `calc_risk_adjusted_return()` and `plot_risk_adjusted_returns()` to calculate and visualize the effect of allocation to risky assets on the risk-adjusted return.
* Added `run_app()` function that runs package interactive apps:
`risk-adjusted-returns` and `purchasing-power`.
