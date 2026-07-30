# Temporal interval bounds

`intv_start()` and `intv_end()` extract the bounds of a temporal
interval vector. The *start* is the chronologically earliest point of
each interval; the *end* is the chronologically latest point.

## Usage

``` r
intv_start(x)

intv_end(x)
```

## Arguments

- x:

  A temporal interval vector (see
  [`interval()`](https://tempo.joeroe.io/reference/interval.md)).

## Value

A vector the same length as `x`, of the same type as the bounds (numeric
or [`era::yr()`](https://era.joeroe.io/reference/yr.html)).

## Examples

``` r
x <- interval(c(10, 20), c(30, 40))
intv_start(x)
#> [1] 10 20
intv_end(x)
#> [1] 30 40
```
