# Temporal intervals and relations

**tempo** provides a formal representation of intervals between two
points in time (periods) and the logical relations between them.

Intervals are a foundational concept in chronological modelling across
archaeology and other fields. Although R has several ways to represent
spans of time (e.g. `Date` and `POSIXct`), these are based on the
Gregorian calendar and are unsuited to non-Gregorian or deep-time
applications. tempo instead represents intervals as vectors of start and
end points on arbitrary time scales. It is based on
[vctrs](https://vctrs.r-lib.org), so the resulting S3 class is stable in
data frames and tibbles, prints in a readable format, and behaves
predictably in tidyverse workflows. Optionally, the calendar era of
year-based time scales can be explicitly specified via the [*era*
package](https://era.joeroe.io), providing calendar-aware chronological
operations.

Logical relations between temporal intervals were first studied by Allen
(1983), with later archaeological adaptations by Holst (2001), Holst
(2004), and the CIDOC-CRM standard (ISO 21127 2014). They include
relations like “x is before y”, “x meets y”, or “x overlaps y”. The
package implements the typology developed by Levy et al. (2021) and Levy
(2025), which is a superset of these previous typologies.

This vignette introduces the main features of the package: constructing
and inspecting temporal intervals, performing set operations on them,
and testing the logical relations between them.

``` r

library("tempo")
```

## Temporal intervals

The [`interval()`](https://tempo.joeroe.io/reference/interval.md)
function creates vectors of temporal intervals from numeric start
(earliest) and end (latest) points:

``` r

interval(c(10, 20, 30), c(20, 30, 40))
#> <interval[3]>
#> [1] 10–20 20–30 30–40
```

To specify the calendar eras, pass an era label via the `era` argument:

``` r

interval(1200, 800, "BCE")
#> <interval[1]>
#> [1] 1200–800 BCE
```

Or use [`era::yr()`](https://era.joeroe.io/reference/yr.html) vectors
directly:

``` r

interval(era::yr(c(100, 200), "BP"), era::yr(c(50, 100), "BP"))
#> <interval[2]>
#> [1] 100–50 BP  200–100 BP
```

See the [era package vignette](https://era.joeroe.io/articles/era.html)
for details on working with calendar eras.

Making the era explicitly is especially useful for backwards counted
like BC(E) or Before Present, allowing for chronologically-aware
arithmetic. For example,
[`intv_duration()`](https://tempo.joeroe.io/reference/intv_duration.md)
takes into account the counting direction when calculating the length of
each interval:

``` r

x <- interval(1200, 800, "BCE")
intv_duration(x)
#> [1] 400
```

### Set operations

Two or more intervals can be combined using set operations.

[`intv_union()`](https://tempo.joeroe.io/reference/intv_sets.md) returns
the bounding interval across all inputs:

``` r

a <- interval(10, 30)
b <- interval(20, 40)
intv_union(a, b)
#> <interval[1]>
#> [1] 10–40
```

[`intv_intersection()`](https://tempo.joeroe.io/reference/intv_sets.md)
returns the overlapping region:

``` r

intv_intersection(a, b)
#> <interval[1]>
#> [1] 20–30
```

## Temporal relations

A temporal relation is a mathematical object describing the relationship
between two temporal intervals, defined as a formal function of the
intervals’ four endpoints (the start and end of each). They avoid the
ambiguities of natural language descriptions — for example, statements
about whether two phases were “contemporary” can be read in several
different ways, whereas a formal relation has a single, precise meaning.
In chronological modelling they serve as an exact vocabulary, enabling
computational analysis and consistent comparison of chronological claims
across studies. The remainder of this section introduces the typology of
such relations implemented in tempo Levy et al. (2021); Levy (2025).

All relation functions share the signature `fn(x, y, strict = FALSE)`
and accept `interval` objects, two-element numeric vectors, or lists of
two-element numeric vectors.

By default, comparisons are **inclusive** (using `>=` and `<=`). Setting
`strict = TRUE` uses **strict** comparisons (using `>` and `<`), which
affects relations that involve equality of endpoints. For example, two
intervals sharing an endpoint are
[`contemporary_with()`](https://tempo.joeroe.io/reference/relations.md)
each other by default, but not under strict comparison:

``` r

intv1 <- interval(1500, 1900)
intv2 <- interval(1800, 1950)
intv3 <- interval(1900, 1950)

contemporary_with(intv1, intv2)
#> [1] TRUE

# Inclusive (default): intervals sharing an endpoint are contemporary
contemporary_with(intv1, intv3)
#> [1] TRUE

# Strict: intervals must overlap in their interiors
contemporary_with(intv1, intv3, strict = TRUE)
#> [1] FALSE
```

The package provides 24 functions for testing temporal relations, listed
in the table below in the order of Levy’s typology.

| Type | Relation | tempo function | Definition |
|----|----|----|----|
| Start–end order | Starts before or at end of | [`starts_before_end_of()`](https://tempo.joeroe.io/reference/relations.md) | beg(x) ≤ end(y) |
| Start–end order | Ends after or at start of | [`ends_after_start_of()`](https://tempo.joeroe.io/reference/relations.md) | end(x) ≥ beg(y) |
| Start order | Starts before or at start of | [`starts_before_start_of()`](https://tempo.joeroe.io/reference/relations.md) | beg(x) ≤ beg(y) |
| Start order | Starts after or at start of | [`starts_after_start_of()`](https://tempo.joeroe.io/reference/relations.md) | beg(x) ≥ beg(y) |
| End order | Ends before or at end of | [`ends_before_end_of()`](https://tempo.joeroe.io/reference/relations.md) | end(x) ≤ end(y) |
| End order | Ends after or at end of | [`ends_after_end_of()`](https://tempo.joeroe.io/reference/relations.md) | end(x) ≥ end(y) |
| Disjunction | Ends before or at start of | [`ends_before_start_of()`](https://tempo.joeroe.io/reference/relations.md) | end(x) ≤ beg(y) |
| Disjunction | Starts after or at end of | [`starts_after_end_of()`](https://tempo.joeroe.io/reference/relations.md) | beg(x) ≥ end(y) |
| Sequence | Meets | [`meets()`](https://tempo.joeroe.io/reference/relations.md) | end(x) = beg(y) |
| Sequence | Met by | [`met_by()`](https://tempo.joeroe.io/reference/relations.md) | beg(x) = end(y) |
| Contemporaneity | Contemporary with | [`contemporary_with()`](https://tempo.joeroe.io/reference/relations.md) | end(x) ≥ beg(y) AND beg(x) ≤ end(y) |
| Start inclusion | Starts during | [`starts_during()`](https://tempo.joeroe.io/reference/relations.md) | beg(y) ≤ beg(x) ≤ end(y) |
| Start inclusion | Includes start of | [`includes_start_of()`](https://tempo.joeroe.io/reference/relations.md) | beg(x) ≤ beg(y) ≤ end(x) |
| End inclusion | Ends during | [`ends_during()`](https://tempo.joeroe.io/reference/relations.md) | beg(y) ≤ end(x) ≤ end(y) |
| End inclusion | Includes end of | [`includes_end_of()`](https://tempo.joeroe.io/reference/relations.md) | beg(x) ≤ end(y) ≤ end(x) |
| Equal start | Starts with | [`starts_with()`](https://tempo.joeroe.io/reference/relations.md) | beg(x) = beg(y) |
| Equal end | Ends with | [`ends_with()`](https://tempo.joeroe.io/reference/relations.md) | end(x) = end(y) |
| Overlap | Overlaps before | [`overlaps_before()`](https://tempo.joeroe.io/reference/relations.md) | beg(x) ≤ beg(y) ≤ end(x) ≤ end(y) |
| Overlap | Overlaps after | [`overlaps_after()`](https://tempo.joeroe.io/reference/relations.md) | beg(y) ≤ beg(x) ≤ end(y) ≤ end(x) |
| Inclusion | Includes | [`includes()`](https://tempo.joeroe.io/reference/relations.md) | beg(x) ≤ beg(y) AND end(x) ≥ end(y) |
| Inclusion | Included in | [`included_in()`](https://tempo.joeroe.io/reference/relations.md) | beg(x) ≥ beg(y) AND end(x) ≤ end(y) |
| Beginning | Begins | [`begins()`](https://tempo.joeroe.io/reference/relations.md) | beg(x) = beg(y) AND end(x) ≤ end(y) |
| Beginning | Begun by | [`begun_by()`](https://tempo.joeroe.io/reference/relations.md) | beg(x) = beg(y) AND end(x) ≥ end(y) |
| Ending | Ends | [`ends()`](https://tempo.joeroe.io/reference/relations.md) | end(x) = end(y) AND beg(x) ≥ beg(y) |
| Ending | Ended by | [`ended_by()`](https://tempo.joeroe.io/reference/relations.md) | end(x) = end(y) AND beg(x) ≤ beg(y) |
| Equality | Equals | [`equal_to()`](https://tempo.joeroe.io/reference/relations.md) | beg(x) = beg(y) AND end(x) = end(y) |

Adapted from (2025, Table 5). The definitions above are for the
inclusive variants; set `strict = TRUE` for the exclusive variants.

## References

Allen, J. F. 1983. “Maintaining Knowledge about Temporal Intervals.”
*Communications of the ACM* 26 (11): 832–43.
<https://doi.org/10.1145/182.358434>.

Holst, M. K. 2001. “Formalizing Fact and Fiction in Four Dimensions: A
Relational Description of Temporal Structures in Settlements.” In
*Computing Archaeology for Understanding the Past*.

Holst, M. K. 2004. “Complicated Relations and Blind Dating: Formal
Analysis of Relative Chronological Structures.” In *Tools for
Constructing Chronologies*, edited by C. E. Buck and A. R. Millard.
Springer. <https://doi.org/10.1007/978-1-4471-0231-1_6>.

ISO 21127:2014 – Information and Documentation – a Reference Ontology
for the Interchange of Cultural Heritage Information (2014).

Levy, E. 2025. “Temporal Relations in Archaeology: A Survey and a New
Typology.” *Archaeometry* 67 (S1): 178–99.
<https://doi.org/10.1111/arcm.13080>.

Levy, E., G. Geeraerts, F. Pluquet, E. Piasetzky, and A. Fantalkin.
2021. “Chronological Networks in Archaeology: A Formalised Scheme.”
*Journal of Archaeological Science* 127: 105225.
<https://doi.org/10.1016/j.jas.2020.105225>.
