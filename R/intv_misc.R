# intv_misc.R
# Miscellaneous interval methods

#' Interval durations
#'
#' `intv_duration()` calculates the duration of each temporal interval.
#' `intv_seq()` generates sequences of values within each temporal interval.
#'
#' @param x A temporal interval vector (see [interval()]).
#' @param ... Passed to [seq()].
#'
#' @return
#' `intv_duration()` returns a numeric vector of durations (even for
#' [era::yr()]-backed intervals, since durations are not expressed relative to
#' an epoch).
#' `intv_seq()` returns a list of numeric vectors (or [era::yr()] vectors for
#' yr-backed intervals), one per interval.
#'
#' @name intv_duration
#' @examples
#' x <- interval(c(10, 20), c(30, 40))
#' intv_duration(x)
#' intv_seq(x, by = 5)
NULL

#' @rdname intv_duration
#' @export
intv_duration <- function(x) {
  UseMethod("intv_duration")
}

#' @rdname intv_duration
#' @export
intv_duration.tempo_interval_numeric <- function(x) {
  intv_end(x) - intv_start(x)
}

#' @rdname intv_duration
#' @export
intv_duration.tempo_interval_era_yr <- function(x) {
  yr_difference(intv_end(x), intv_start(x))
}

#' @rdname intv_duration
#' @export
intv_seq <- function(x, ...) {
  purrr::map(x, seq, ...)
}

#' @rdname intv_duration
#' @export
seq.tempo_interval <- function(x, ...) {
  if (vec_size(x) > 1) {
    abort(
      c(
        "no method `seq` for interval vectors with length > 1",
        i = "Use `intv_seq()` instead"
      ),
      class = "tempo_no_method"
    )
  }

  # TODO: yr class is dropped when it shouldn't be
  seq(from = intv_start(x), to = intv_end(x), ...)
}
