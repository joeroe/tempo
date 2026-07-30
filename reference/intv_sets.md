# Set operations for temporal intervals

Calculate the union, intersection or difference of vectors of temporal
intervals.

## Usage

``` r
intv_union(...)

# S3 method for class 'tempo_interval_numeric'
intv_union(...)

# S3 method for class 'tempo_interval_era_yr'
intv_union(...)

intv_intersection(...)

# S3 method for class 'tempo_interval_numeric'
intv_intersection(...)

# S3 method for class 'tempo_interval_era_yr'
intv_intersection(...)

intv_difference(...)

# S3 method for class 'tempo_interval_numeric'
intv_difference(...)

# S3 method for class 'tempo_interval_era_yr'
intv_difference(...)
```

## Arguments

- ...:

  Vectors of temporal intervals.

## Value

[interval](https://tempo.joeroe.io/reference/interval.md) vector
representing the union, intersection or difference of all the intervals
passed to `...`. `intv_union()` and `intv_intersection()` always return
a vector of length 1. `intv_difference()` can return more elements,
representing a disjoint interval.
