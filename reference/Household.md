# Household class

The `Household` class aggregates information about a household and its
members.

## Value

An object of class `Household`.

## Active bindings

- `expected_income`:

  Set of rules that are used to generate streams of expected income

- `expected_spending`:

  Set of rules that are used to generate streams of expected spending

- `risk_tolerance`:

  Risk tolerance of the household

- `consumption_impatience_preference`:

  Consumption impatience preference of the household - subjective
  discount rate (rho). Higher values indicate a stronger preference for
  consumption today versus in the future.

- `smooth_consumption_preference`:

  Smooth consumption preference of the household - Elasticity of
  Intertemporal Substitution (EOIS) (eta). Higher values indicate more
  flexibility and a lower preference for smooth consumption.

## Methods

### Public methods

- [`Household$print()`](#method-Household-print)

- [`Household$get_members()`](#method-Household-get_members)

- [`Household$add_member()`](#method-Household-add_member)

- [`Household$set_member()`](#method-Household-set_member)

- [`Household$set_lifespan()`](#method-Household-set_lifespan)

- [`Household$get_lifespan()`](#method-Household-get_lifespan)

- [`Household$calc_survival()`](#method-Household-calc_survival)

- [`Household$get_min_age()`](#method-Household-get_min_age)

- [`Household$clone()`](#method-Household-clone)

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Printing the household object

#### Usage

    Household$print(current_date = get_current_date())

#### Arguments

- `current_date`:

  A date in the format "YYYY-MM-DD".

------------------------------------------------------------------------

### Method `get_members()`

Getting members of the household

#### Usage

    Household$get_members()

------------------------------------------------------------------------

### Method `add_member()`

Adding a member to the household It will fail if a member with the same
name already exists.

#### Usage

    Household$add_member(household_member)

#### Arguments

- `household_member`:

  A `HouseholdMember` object.

------------------------------------------------------------------------

### Method `set_member()`

Setting a member of the household If a member already exists, it will be
overwritten.

#### Usage

    Household$set_member(member)

#### Arguments

- `member`:

  A `HouseholdMember` object.

------------------------------------------------------------------------

### Method `set_lifespan()`

Setting an arbitrary lifespan of the household

#### Usage

    Household$set_lifespan(value)

#### Arguments

- `value`:

  A number of years.

------------------------------------------------------------------------

### Method `get_lifespan()`

Getting a lifespan of the household If not set, it will be calculated
based on the members' lifespans.

#### Usage

    Household$get_lifespan(current_date = get_current_date())

#### Arguments

- `current_date`:

  A date in the format "YYYY-MM-DD".

------------------------------------------------------------------------

### Method `calc_survival()`

Calculating a survival rate of the household based on its members'
parameters of the Gompertz model.

#### Usage

    Household$calc_survival(current_date = get_current_date())

#### Arguments

- `current_date`:

  A date in the format "YYYY-MM-DD".

------------------------------------------------------------------------

### Method `get_min_age()`

Calculating a minimum age of the household members.

#### Usage

    Household$get_min_age(current_date = get_current_date())

#### Arguments

- `current_date`:

  A date in the format "YYYY-MM-DD".

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Household$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
household <- Household$new()
household$risk_tolerance
#> [1] 0.5
household$consumption_impatience_preference
#> [1] 0.04
household$smooth_consumption_preference
#> [1] 1
```
