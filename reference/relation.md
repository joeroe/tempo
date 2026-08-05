# Temporal relation definitions

Retrieve the declarative definitions of temporal relations by name. This
function returns the underlying predicate structures that define each
relation, which can be useful for programmatic inspection or integration
with other temporal reasoning systems.

## Usage

``` r
relation(name)
```

## Arguments

- name:

  Character vector of relation names (without the `_relation` suffix).
  Valid names include: "starts_before_end_of", "ends_after_start_of",
  "starts_before_start_of", "starts_after_start_of",
  "ends_before_end_of", "ends_after_end_of", "ends_before_start_of",
  "starts_after_end_of", "meets", "met_by", "contemporary_with",
  "starts_during", "includes_start_of", "ends_during",
  "includes_end_of", "starts_with", "ends_with", "overlaps_before",
  "overlaps_after", "includes", "included_in", "begins", "begun_by",
  "ends", "ended_by", "equal_to".

## Value

A named list of relation definitions. Each element is a list of
predicates that define the relation.

## Examples

``` r
# Get a single relation definition
relation("meets")
#> <tempo_relation[1]>
#> $meets
#> <tempo_predicate[1]>
#> [1] end_of(x) == start_of(y)
#> 

# Get multiple relations
relation(c("meets", "contemporary_with"))
#> <tempo_relation[2]>
#> $meets
#> <tempo_predicate[1]>
#> [1] end_of(x) == start_of(y)
#> 
#> $contemporary_with
#> <tempo_predicate[2]>
#> [1] end_of(x) >= start_of(y) start_of(x) <= end_of(y)
#> 

# Inspect the structure
meets_def <- relation("meets")
str(meets_def)
#> tmp_rltn [1:1] 
#> $ meets: tmp_prdc [1:1] end_of(x) == start_of(y)
#> @ ptype: tmp_prdc [1:0] 
```
