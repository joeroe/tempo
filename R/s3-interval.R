# s3-interval.R
# S3 record class representing intervals between two points in time

#' Vectors of temporal intervals
#'
#' The `interval` class represents the interval between two points in time.
#'
#' @param start,end Numeric vectors specifying the earliest and latest points
#'   in each interval, respectively. Unequal length vectors are recycled to
#'   their common length (if possible) using the rules described in 
#'   [vctrs::vec_recycle_common()].
#'
#' @return 
#' `interval()` returns an object with the S3 class `"tempo_interval"`,
#' representing a vector of temporal intervals.
#'
#' @export
#' 
#' @examples
#' interval(c(10, 20, 30), c(20, 30, 40))
interval <- function(start = numeric(), end = numeric()) {
  c(start, end) %<-% vec_recycle_common(start, end)
  intv <- new_interval(start, end)
  validate_interval(intv)
}

#' Low-level constructor for intervals
#'
#' @noRd
#' @keywords internal
new_interval <- function(start = numeric(), end = numeric()) {
  # TODO: type/class checks
  stopifnot(length(start) == length(end))

  new_rcrd(
    fields = list(
      start = start,
      end = end
    ),
    class = "tempo_interval"
  )
}

#' @noRd
#' @keywords internal
validate_interval <- function(x) {
  if (!all(are_na(intv_start(x)) == are_na(intv_end(x)))) {
    abort(
      "NA values in `start` must be matched by NA values in `end` and vice versa.",
      class = "tempo_invalid_interval"
    )
  }

  if (!all(intv_start(x) <= intv_end(x), na.rm = TRUE)) {
    abort(
      "Numeric values of `start` must be less than or equal to corresponding values of `end`.",
      class = "tempo_invalid_interval"
    )
  }

  x
}

#' @param x Object to test.
#' @return `is_interval()` returns a logical value.
#' @export
#' @rdname interval
is_interval <- function(x) {
  inherits(x, "tempo_interval")
}


#
# Printing
#

#' @export
format.tempo_interval <- function(x, ...) {
  starts <- field(x, "start")
  ends <- field(x, "end")

  # TODO: better printing for yrs

  out <- paste0(starts, "\u2013", ends)
  out[is.na(starts) | is.na(ends)] <- NA

  out
}

#' @export
vec_ptype_abbr.tempo_interval <- function(x, ...) "intv"

#' @export
vec_ptype_full.tempo_interval <- function(x, ...) "interval"


#
# Accessors
#

#' @export
intv_start <- function(x) field(x, "start")

#' @export
intv_end <- function(x) field(x, "end")
