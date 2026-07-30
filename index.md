# tempo

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
typology (Levy et al. 2021; Levy 2025). See
[`?relations`](https://tempo.joeroe.io/reference/relations.md) for a
list.

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

Levy, E. 2025. “Temporal Relations in Archaeology: A Survey and a New
Typology.” *Archaeometry* 67 (S1): 178–99.
<https://doi.org/10.1111/arcm.13080>.

Levy, E., G. Geeraerts, F. Pluquet, E. Piasetzky, and A. Fantalkin.
2021. “Chronological Networks in Archaeology: A Formalised Scheme.”
*Journal of Archaeological Science* 127: 105225.
<https://doi.org/10.1016/j.jas.2020.105225>.
