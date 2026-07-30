# Temporal relations

These functions test for the logical relation between two periods
according to Levy's typology (Levy et al. 2021; Levy 2025) .

## Usage

``` r
starts_before_end_of(x, y, strict = FALSE)

ends_after_start_of(x, y, strict = FALSE)

starts_before_start_of(x, y, strict = FALSE)

starts_after_start_of(x, y, strict = FALSE)

ends_before_end_of(x, y, strict = FALSE)

ends_after_end_of(x, y, strict = FALSE)

ends_before_start_of(x, y, strict = FALSE)

starts_after_end_of(x, y, strict = FALSE)

meets(x, y, strict = FALSE)

met_by(x, y, strict = FALSE)

contemporary_with(x, y, strict = FALSE)

starts_during(x, y, strict = FALSE)

includes_start_of(x, y, strict = FALSE)

ends_during(x, y, strict = FALSE)

includes_end_of(x, y, strict = FALSE)

starts_with(x, y, strict = FALSE)

ends_with(x, y, strict = FALSE)

overlaps_before(x, y, strict = FALSE)

overlaps_after(x, y, strict = FALSE)

includes(x, y, strict = FALSE)

included_in(x, y, strict = FALSE)

begins(x, y, strict = FALSE)

begun_by(x, y, strict = FALSE)

ends(x, y, strict = FALSE)

ended_by(x, y, strict = FALSE)

equal_to(x, y, strict = FALSE)
```

## Arguments

- x, y:

  Pair(s) of periods to test the relation between. Can be
  [`interval()`](https://tempo.joeroe.io/reference/interval.md) objects,
  two-element numeric vectors, or lists of two-element numeric vectors.

- strict:

  By default, comparison is inclusive (i.e. using `<=` and `>=`). Use
  `strict = FALSE` for strict comparison (i.e. using `<` and `>`).

## Value

Logical vector the same length as `x` and `y`.

## References

Levy E (2025). “Temporal relations in archaeology: a survey and a new
typology.” *Archaeometry*, **67**(S1), 178–199.
[doi:10.1111/arcm.13080](https://doi.org/10.1111/arcm.13080) .  
  
Levy E, Geeraerts G, Pluquet F, Piasetzky E, Fantalkin A (2021).
“Chronological networks in archaeology: A formalised scheme.” *Journal
of Archaeological Science*, **127**, 105225.
[doi:10.1016/j.jas.2020.105225](https://doi.org/10.1016/j.jas.2020.105225)
.

## Examples

``` r
period1 <- c(1500, 1900)
period2 <- c(1800, 1950)
period3 <- c(1900, 1950)

contemporary_with(period1, period2)
#> [1] TRUE

# Inclusive relations (the default)
contemporary_with(period1, period3)
#> [1] TRUE

# Strict relations
contemporary_with(period1, period3, strict = TRUE)
#> [1] FALSE
```
