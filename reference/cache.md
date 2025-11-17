# Working with cache

Get information about the cache

Reset the cache

Set the cache directory

## Usage

``` r
get_cache_info()

reset_cache()

set_cache(path = file.path(getwd(), ".cache"))
```

## Arguments

- path:

  The path to the cache directory. Defaults to the '.cache' folder in
  the current working directory.

## Value

Invisibly returns the path to the cache directory or a list containing:

- path:

  The path to the cache directory.

- files:

  The number of files in the cache.

## Examples

``` r
if (FALSE) { # interactive()
get_cache_info()
}
if (FALSE) { # interactive()
reset_cache()
}
if (FALSE) { # interactive()
set_cache()
}
```
