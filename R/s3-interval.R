# s3-interval.R
# S3 record class representing intervals between two points in time

#' Vectors of temporal intervals
#'
#' @description
#' The `interval` class represents the interval between two points in time.
#'
#' @param start,end Vectors specifying the earliest and latest points in each
#'   interval, respectively. Can be numeric or [era::yr()] vectors. Unequal
#'   length vectors are recycled to their common length (if possible) using the
#'   rules described in [vctrs::vec_recycle_common()].
#'
#' @param era Optional era label or [era::era()] object specifying the era of
#'   the interval. If this differs from `start` or `end`, they are harmonised
#'   using [era::yr_transform()], if possible.
#' @param ... Arguments passed to methods.
#'
#' @return
#' `interval()` returns an object with S3 class `"tempo_interval"`, representing
#' a vector of temporal intervals.
#'
#' @export
#'
#' @examples
#' # Numeric intervals
#' interval(c(10, 20, 30), c(20, 30, 40))
#'
#' # Intervals with calendar era
#' interval(era::yr(c(100, 200), "BP"), era::yr(c(50, 100), "BP"))
#'
#' # Shorthand: numeric inputs with era
#' interval(1000, 1500, "CE")
interval <- function(start, end = start, ...) {
  UseMethod("interval")
}

#' @rdname interval
#' @export
interval.numeric <- function(start, end = start, era = NULL, ...) {
  if (is.null(era)) {
    c(start, end) %<-% vec_recycle_common(start, end)
    intv <- new_interval(start, end, subclass = "tempo_interval_numeric")
    validate_interval(intv)
  } else {
    interval.era_yr(yr(start, era), yr(end, era), era)
  }
}

#' @rdname interval
#' @export
interval.default <- function(start, end = start, ...) {
  if (missing(start) || (is.null(start) && length(start) == 0)) {
    return(interval.numeric(numeric(), numeric()))
  }
  abort(
    c(
      "No method for `interval()` with this type of input.",
      i = "Supported types: numeric, era::yr."
    ),
    class = "tempo_invalid_argument"
  )
}

#' @rdname interval
#' @export
interval.era_yr <- function(start, end = start, era = NULL, ...) {
  c(start, end) %<-% vec_recycle_common(start, end)
  if (!is.null(era)) {
    c(start, end) %<-% lapply(list(start, end), yr_transform, era = era)
  }
  end <- yr_transform(end, yr_era(start))
  intv <- new_interval(start, end, subclass = "tempo_interval_era_yr")
  validate_interval(intv)
}

#' Low-level constructor for intervals
#'
#' @noRd
#' @keywords internal
new_interval <- function(start = numeric(), end = numeric(),
                         subclass = character()) {
  # TODO: type/class checks
  stopifnot(length(start) == length(end))

  new_rcrd(
    fields = list(
      start = start,
      end = end
    ),
    class = c(subclass, "tempo_interval")
  )
}

#' @noRd
#' @keywords internal
validate_interval <- function(x) {
  UseMethod("validate_interval")
}

#' @noRd
#' @keywords internal
#' @exportS3Method validate_interval tempo_interval_numeric
validate_interval.tempo_interval_numeric <- function(x) {
  validate_na_pairing(x)
  if (!all(intv_start(x) <= intv_end(x), na.rm = TRUE)) {
    abort(
      "`start` must be less than or equal to `end`.",
      class = "tempo_invalid_interval"
    )
  }
  x
}

#' @noRd
#' @keywords internal
#' @exportS3Method validate_interval tempo_interval_era_yr
validate_interval.tempo_interval_era_yr <- function(x) {
  validate_na_pairing(x)
  if (any(yr_later_than(intv_start(x), intv_end(x)), na.rm = TRUE)) {
    abort(
      "`start` must be chronologically before or equal to `end`.",
      class = "tempo_invalid_interval"
    )
  }
  x
}

#' @noRd
#' @keywords internal
validate_na_pairing <- function(x) {
  if (!all(are_na(intv_start(x)) == are_na(intv_end(x)))) {
    abort(
      c(
        "NA values in `start` must be matched by NA values in `end`",
        "and vice versa."
      ),
      class = "tempo_invalid_interval"
    )
  }
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

  out <- paste0(starts, "\u2013", ends)
  out[is.na(starts) | is.na(ends)] <- NA

  out
}

#' @export
format.tempo_interval_era_yr <- function(x, ...) {
  starts <- field(x, "start")
  ends <- field(x, "end")

  # Extract numeric values
  start_nums <- vec_data(starts)
  end_nums <- vec_data(ends)

  # Format as "start–end"
  out <- paste0(start_nums, "\u2013", end_nums)

  # Append era label once
  era_lbl <- era_label(yr_era(starts))
  out <- paste0(out, " ", era_lbl)

  # Handle NA values
  out[is.na(starts) | is.na(ends)] <- NA

  out
}

#' @export
vec_ptype_abbr.tempo_interval <- function(x, ...) "intv"

#' @export
vec_ptype_abbr.tempo_interval_numeric <- function(x, ...) "intv"

#' @export
vec_ptype_abbr.tempo_interval_era_yr <- function(x, ...) "intv"

#' @export
vec_ptype_full.tempo_interval <- function(x, ...) "interval"

#' @export
vec_ptype_full.tempo_interval_numeric <- function(x, ...) "interval"

#' @export
vec_ptype_full.tempo_interval_era_yr <- function(x, ...) "interval"


#
# Accessors
#

#' Temporal interval bounds
#'
#' `intv_start()` and `intv_end()` extract the bounds of a temporal interval
#' vector. The *start* is the chronologically earliest point of each interval;
#' the *end* is the chronologically latest point.
#'
#' @param x A temporal interval vector (see [interval()]).
#'
#' @return A vector the same length as `x`, of the same type as the bounds
#'   (numeric or [era::yr()]).
#'
#' @name intv_bounds
#' @examples
#' x <- interval(c(10, 20), c(30, 40))
#' intv_start(x)
#' intv_end(x)
NULL

#' @rdname intv_bounds
#' @export
intv_start <- function(x) field(x, "start")

#' @rdname intv_bounds
#' @export
intv_end <- function(x) field(x, "end")
