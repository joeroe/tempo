#' Set operations for temporal intervals
#'
#' Calculate the union, intersection or difference of vectors of temporal 
#' intervals.
#' 
#' @param ... Vectors of temporal intervals.
#'
#' @return
#' [interval] vector representing the union, intersection or difference of all 
#' the intervals passed to `...`. `intv_union()` and `intv_intersection()`
#' always return a vector of length 1. `intv_difference()` can return more
#' elements, representing a disjoint interval.
#'
#' @name intv_sets
NULL

#' @rdname intv_sets
#' @export
intv_union <- function(...) {
  # TODO: maybe follow base's x, y signature instead?
  new_interval(min(intv_start(c(...))), max(intv_end(c(...))))
}

#' @rdname intv_sets
#' @export
intv_intersection <- function(...) {
  set <- c(...)
  new_interval(max(intv_start(set)), min(intv_end(set)))
}

#' @rdname intv_sets
#' @export
intv_difference <- function(...) {
  # TODO: calculate, but what to do about disjoints?
  abort("`intv_difference()` is not yet implemented!")
}
