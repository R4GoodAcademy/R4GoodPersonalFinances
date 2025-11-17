# Plot survival of household members

Plot survival probabilities for each household members and for the
entire household when at least one member is alive. The household joint
survival probability is also approximated by a Gompertz model.

## Usage

``` r
plot_survival(household, current_date = get_current_date())
```

## Arguments

- household:

  An R6 object of class `Household`.

- current_date:

  A character. Current date in the format `YYYY-MM-DD`. By default, it
  is the output of
  [`get_current_date()`](https://r4goodacademy.github.io/R4GoodPersonalFinances/reference/get_current_date.md).

## Value

A `ggplot` object.

## Examples

``` r
hm1 <- 
 HouseholdMember$new(
   name       = "member1",
   birth_date = "1955-01-01",
   mode       = 88,
   dispersion = 10.65
 )
hm2 <- 
 HouseholdMember$new(
   name       = "member2",
   birth_date = "1965-01-01",
   mode       = 91,
   dispersion = 8.88
 )
hm3 <- 
 HouseholdMember$new(
   name       = "member3",
   birth_date = "1975-01-01",
   mode       = 88,
   dispersion = 7.77
 )
household <- Household$new()
household$add_member(hm1)
household$add_member(hm2)
household$add_member(hm3) 

plot_survival(
 household    = household, 
 current_date = "2020-01-01"
)
```
