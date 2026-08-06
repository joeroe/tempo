# Get relation definitions by name

`relation()` retrieves the declarative definitions of temporal relations
by name. This function returns the underlying predicate structures that
define each relation, which can be useful for programmatic inspection or
integration with other temporal reasoning systems.

## Usage

``` r
relation(name)

relation_names()
```

## Arguments

- name:

  Character vector of relation names (without the `_relation` suffix).
  Use `relation_names()` to see all available names.

## Value

- `relation()` returns a named list of relation definitions. Each
  element is a list of predicates that define the relation.

- `relation_names()` returns a character vector of available relation
  names.

## Details

`relation_names()` lists all available relation names that can be used
with `relation()`.

## Examples

``` r
# List all available relations
relation_names()
#>  [1] "begins"                 "begun_by"               "contemporary_with"     
#>  [4] "ended_by"               "ends_after_end_of"      "ends_after_start_of"   
#>  [7] "ends_before_end_of"     "ends_before_start_of"   "ends_during"           
#> [10] "ends"                   "ends_with"              "equal_to"              
#> [13] "included_in"            "includes_end_of"        "includes"              
#> [16] "includes_start_of"      "meets"                  "met_by"                
#> [19] "overlaps_after"         "overlaps_before"        "starts_after_end_of"   
#> [22] "starts_after_start_of"  "starts_before_end_of"   "starts_before_start_of"
#> [25] "starts_during"          "starts_with"           

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
