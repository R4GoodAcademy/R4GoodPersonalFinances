# HouseholdMember class

The `HouseholdMember` class aggregates information about a single member
of a household.

## Value

An object of class `HouseholdMember`.

## Active bindings

- `max_age`:

  The maximum age of the household member

- `mode`:

  The Gompertz mode parameter

- `dispersion`:

  The Gompertz dispersion parameter

## Methods

### Public methods

- [`HouseholdMember$new()`](#method-HouseholdMember-new)

- [`HouseholdMember$print()`](#method-HouseholdMember-print)

- [`HouseholdMember$get_name()`](#method-HouseholdMember-get_name)

- [`HouseholdMember$get_birth_date()`](#method-HouseholdMember-get_birth_date)

- [`HouseholdMember$calc_age()`](#method-HouseholdMember-calc_age)

- [`HouseholdMember$get_lifespan()`](#method-HouseholdMember-get_lifespan)

- [`HouseholdMember$calc_life_expectancy()`](#method-HouseholdMember-calc_life_expectancy)

- [`HouseholdMember$calc_survival_probability()`](#method-HouseholdMember-calc_survival_probability)

- [`HouseholdMember$get_events()`](#method-HouseholdMember-get_events)

- [`HouseholdMember$set_event()`](#method-HouseholdMember-set_event)

- [`HouseholdMember$clone()`](#method-HouseholdMember-clone)

------------------------------------------------------------------------

### Method `new()`

Creating a new object of class `HouseholdMember`

#### Usage

    HouseholdMember$new(name, birth_date, mode = NULL, dispersion = NULL)

#### Arguments

- `name`:

  The name of the member.

- `birth_date`:

  The birth date of the household member in the format `YYYY-MM-DD`.

- `mode`:

  The Gompertz mode parameter.

- `dispersion`:

  The Gompertz dispersion parameter.

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Printing the household member object

#### Usage

    HouseholdMember$print(current_date = get_current_date())

#### Arguments

- `current_date`:

  A date in the format "YYYY-MM-DD".

------------------------------------------------------------------------

### Method `get_name()`

Getting the name of the household member

#### Usage

    HouseholdMember$get_name()

------------------------------------------------------------------------

### Method `get_birth_date()`

Getting the birth date of the household member

#### Usage

    HouseholdMember$get_birth_date()

------------------------------------------------------------------------

### Method `calc_age()`

Calculating the age of the household member

#### Usage

    HouseholdMember$calc_age(current_date = get_current_date())

#### Arguments

- `current_date`:

  A date in the format "YYYY-MM-DD".

------------------------------------------------------------------------

### Method `get_lifespan()`

Calculating a lifespan of the household member

#### Usage

    HouseholdMember$get_lifespan(current_date = get_current_date())

#### Arguments

- `current_date`:

  A date in the format "YYYY-MM-DD".

------------------------------------------------------------------------

### Method [`calc_life_expectancy()`](https://r4goodacademy.github.io/R4GoodPersonalFinances/reference/calc_life_expectancy.md)

Calculating a life expectancy of the household member

#### Usage

    HouseholdMember$calc_life_expectancy(current_date = get_current_date())

#### Arguments

- `current_date`:

  A date in the format "YYYY-MM-DD".

------------------------------------------------------------------------

### Method `calc_survival_probability()`

Calculating a survival probability of the household member

#### Usage

    HouseholdMember$calc_survival_probability(
      target_age,
      current_date = get_current_date()
    )

#### Arguments

- `target_age`:

  Target age (numeric, in years).

- `current_date`:

  A date in the format "YYYY-MM-DD".

------------------------------------------------------------------------

### Method `get_events()`

Getting the events related to the household member

#### Usage

    HouseholdMember$get_events()

------------------------------------------------------------------------

### Method `set_event()`

Setting an event related to the household member

#### Usage

    HouseholdMember$set_event(event, start_age, end_age = Inf, years = Inf)

#### Arguments

- `event`:

  The name of the event.

- `start_age`:

  The age of the household member when the event starts.

- `end_age`:

  The age of the household member when the event ends.

- `years`:

  The number of years the event lasts.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    HouseholdMember$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
member <- HouseholdMember$new(
  name       = "Isabela",
  birth_date = "1980-07-15",
  mode       = 91,
  dispersion = 8.88
)
member$calc_age()
#> [1] 45.34155
member$calc_life_expectancy()
#> [1] 86.16425
```
