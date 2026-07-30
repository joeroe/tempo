# Interval durations

`intv_duration()` calculates the duration of each temporal interval.
`intv_seq()` generates sequences of values within each temporal
interval.

## Usage

``` r
intv_duration(x)

# S3 method for class 'tempo_interval_numeric'
intv_duration(x)

# S3 method for class 'tempo_interval_era_yr'
intv_duration(x)

intv_seq(x, ...)

# S3 method for class 'tempo_interval'
seq(x, ...)
```

## Arguments

- x:

  A temporal interval vector (see
  [`interval()`](https://tempo.joeroe.io/reference/interval.md)).

- ...:

  Passed to [`seq()`](https://rdrr.io/r/base/seq.html).

## Value

`intv_duration()` returns a numeric vector of durations (even for
[`era::yr()`](https://era.joeroe.io/reference/yr.html)-backed intervals,
since durations are not expressed relative to an epoch). `intv_seq()`
returns a list of numeric vectors (or
[`era::yr()`](https://era.joeroe.io/reference/yr.html) vectors for
yr-backed intervals), one per interval.

## Examples

``` r
x <- interval(c(10, 20), c(30, 40))
intv_duration(x)
#> [1] 20 20
intv_seq(x, by = 5)
#> [[1]]
#> [1] 10 15 20 25 30
#> 
#> [[2]]
#> [1] 20 25 30 35 40
#> 
```
