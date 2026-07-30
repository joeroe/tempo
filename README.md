
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tempo

<!-- badges: start -->

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![CRAN
status](https://www.r-pkg.org/badges/version/tempo)](https://CRAN.R-project.org/package=tempo)
[![R-CMD-check](https://github.com/joeroe/tempo/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/joeroe/tempo/actions/workflows/R-CMD-check.yaml)
[![Test
coverage](https://codecov.io/gh/joeroe/tempo/graph/badge.svg)](https://app.codecov.io/gh/joeroe/tempo)
<!-- badges: end -->

**tempo** provides a formal representation of intervals between two
points in time (periods) and the potential logical relations between
them in R.

## Installation

You can install the development version of tempo from GitHub with the
[pak](https://pak.r-lib.org/) package:

``` r
pak::pak("joeroe/tempo")
```

## Usage

Create intervals from numeric start and end dates:

``` r
library("tempo")
#> Loading required package: era
#> Loading required package: rlang
#> Loading required package: vctrs
#> Loading required package: zeallot

intv1 <- interval(1500, 1900)
intv2 <- interval(1800, 1950)
```

Or from numeric dates with an era label:

``` r
interval(1200, 800, "BCE")
#> <interval[1]>
#> [1] 1200–800 BCE
```

Test whether two intervals are contemporary with each other:

``` r
contemporary_with(intv1, intv2)
#> [1] TRUE
```

tempo supports fifteen types of temporal relations following Levy’s
typology (Levy et al. 2021; Levy 2025). See `?relations` for a list.

By default, comparison of start and end points is inclusive (i.e. using
`>=` and `<=`). `strict = TRUE` enables the ‘strict’ variants of each
relation (i.e. using `>` and `<`):

``` r
intv3 <- interval(1900, 1950)

contemporary_with(intv1, intv3)
#> [1] TRUE

contemporary_with(intv1, intv3, strict = TRUE)
#> [1] FALSE
```

## References

<div id="refs" class="references csl-bib-body hanging-indent"
entry-spacing="0">

<div id="ref-Levy2025" class="csl-entry">

Levy, E. 2025. “Temporal Relations in Archaeology: A Survey and a New
Typology.” *Archaeometry* 67 (S1): 178–99.
<https://doi.org/10.1111/arcm.13080>.

</div>

<div id="ref-LevyEtAl2021" class="csl-entry">

Levy, E., G. Geeraerts, F. Pluquet, E. Piasetzky, and A. Fantalkin.
2021. “Chronological Networks in Archaeology: A Formalised Scheme.”
*Journal of Archaeological Science* 127: 105225.
<https://doi.org/10.1016/j.jas.2020.105225>.

</div>

</div>
