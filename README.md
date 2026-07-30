
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tempo

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/tempo)](https://CRAN.R-project.org/package=tempo)
[![R-CMD-check](https://github.com/joeroe/tempo/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/joeroe/tempo/actions/workflows/R-CMD-check.yaml)
[![Test
coverage](https://codecov.io/gh/joeroe/tempo/graph/badge.svg)](https://app.codecov.io/gh/joeroe/tempo)
<!-- badges: end -->

***tempo*** is an R package that provides a formal representation of
intervals between two points in time (periods) and the potential logical
relations between them.

## Installation

You can install the development version of tempo from GitHub with the
[remotes](https://remotes.r-lib.org/) package:

``` r
remotes::install_github("joeroe/tempo")
```

## Example

Test whether two periods, specified as numeric vectors of start and end
dates, are contemporary with each other:

``` r
library("tempo")
#> Loading required package: era
#> Loading required package: rlang
#> Loading required package: vctrs
#> Loading required package: zeallot

period1 <- c(1500, 1900)
period2 <- c(1800, 1950)

contemporary_with(period1, period2)
#> [1] TRUE
```

tempo supports fifteen types of temporal relations following Levy’s
typology (Levy et al. 2021 <https://doi.org/10.1016/j.jas.2020.105225>;
Levy 2025 <https://doi.org/10.1111/arcm.13080>). See `?relations` for a
list.

By default, comparison of start and end points is inclusive (i.e. using
`>=` and `<=`). `strict = TRUE` enables the ‘strict’ variants of each
relation (i.e. using `>` and `<`):

``` r
period3 <- c(1900, 1950)

contemporary_with(period1, period3)
#> [1] TRUE

contemporary_with(period1, period3, strict = TRUE)
#> [1] FALSE
```
