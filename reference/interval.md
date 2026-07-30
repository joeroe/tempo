# Vectors of temporal intervals

The `interval` class represents the interval between two points in time.

## Usage

``` r
interval(start, end = start, ...)

# S3 method for class 'numeric'
interval(start, end = start, era = NULL, ...)

# Default S3 method
interval(start, end = start, ...)

# S3 method for class 'era_yr'
interval(start, end = start, era = NULL, ...)

is_interval(x)
```

## Arguments

- start, end:

  Vectors specifying the earliest and latest points in each interval,
  respectively. Can be numeric or
  [`era::yr()`](https://era.joeroe.io/reference/yr.html) vectors.
  Unequal length vectors are recycled to their common length (if
  possible) using the rules described in
  [`vctrs::vec_recycle_common()`](https://vctrs.r-lib.org/reference/vec_recycle.html).

- ...:

  Arguments passed to methods.

- era:

  Optional era label or
  [`era::era()`](https://era.joeroe.io/reference/era.html) object
  specifying the era of the interval. If this differs from `start` or
  `end`, they are harmonised using
  [`era::yr_transform()`](https://era.joeroe.io/reference/yr_transform.html),
  if possible.

- x:

  Object to test.

## Value

`interval()` returns an object with S3 class `"tempo_interval"`,
representing a vector of temporal intervals.

`is_interval()` returns a logical value.

## Examples

``` r
# Numeric intervals
interval(c(10, 20, 30), c(20, 30, 40))
#> <interval[3]>
#> [1] 10–20 20–30 30–40

# Intervals with calendar era
interval(era::yr(c(100, 200), "BP"), era::yr(c(50, 100), "BP"))
#> <interval[2]>
#> [1] 100–50 BP  200–100 BP

# Shorthand: numeric inputs with era
interval(1000, 1500, "CE")
#> <interval[1]>
#> [1] 1000–1500 CE
```
