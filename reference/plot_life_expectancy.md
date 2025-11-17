# Plot life expectancy of household members

Probability of dying at a given age is plotted for each member of a
household. Also for each member the life expectancy is shown as dashed
vertical line.

## Usage

``` r
plot_life_expectancy(household)
```

## Arguments

- household:

  An R6 object of class `Household`.

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
household <- Household$new()
household$add_member(hm1)
household$add_member(hm2)

plot_life_expectancy(household = household)
```
