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
  intervals <- c(...)
  UseMethod("intv_union", intervals)
}

#' @rdname intv_sets
#' @export
intv_union.tempo_interval_numeric <- function(...) {
  intervals <- c(...)
  new_interval(
    min(intv_start(intervals)),
    max(intv_end(intervals)),
    subclass = "tempo_interval_numeric"
  )
}

#' @rdname intv_sets
#' @export
intv_union.tempo_interval_era_yr <- function(...) {
  intervals <- c(...)
  new_interval(
    yr_earliest(intv_start(intervals)),
    yr_latest(intv_end(intervals)),
    subclass = "tempo_interval_era_yr"
  )
}

#' @rdname intv_sets
#' @export
intv_intersection <- function(...) {
  intervals <- c(...)
  UseMethod("intv_intersection", intervals)
}

#' @rdname intv_sets
#' @export
intv_intersection.tempo_interval_numeric <- function(...) {
  intervals <- c(...)
  new_interval(
    max(intv_start(intervals)),
    min(intv_end(intervals)),
    subclass = "tempo_interval_numeric"
  )
}

#' @rdname intv_sets
#' @export
intv_intersection.tempo_interval_era_yr <- function(...) {
  intervals <- c(...)
  new_interval(
    yr_latest(intv_start(intervals)),
    yr_earliest(intv_end(intervals)),
    subclass = "tempo_interval_era_yr"
  )
}

#' @rdname intv_sets
#' @export
intv_difference <- function(...) {
  intervals <- c(...)
  UseMethod("intv_difference", intervals)
}

#' @rdname intv_sets
#' @export
intv_difference.tempo_interval_numeric <- function(...) {
  abort("`intv_difference()` is not yet implemented!")
}

#' @rdname intv_sets
#' @export
intv_difference.tempo_interval_era_yr <- function(...) {
  abort("`intv_difference()` is not yet implemented!")
}
