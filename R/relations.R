# relations.R
# Logical functions for temporal relations between periods (Levy's typology)

#' Temporal relations
#' 
#' These functions test for the logical relation between two periods according
#' to Levy's typology (Levy et al. 2021 <https://doi.org/10.1016/j.jas.2020.105225>;
#' Levy in press).
#'
#' @param x,y Pair(s) of periods to test the relation between, each specified as 
#'   a two-element numeric vector with start and end times. Use lists to give
#'   multiple periods.
#' @param strict By default, comparison is inclusive (i.e. using `<=` and `>=`).
#'   Use `strict = FALSE` for strict comparison (i.e. using `<` and `>`).
#'
#' @return
#' Logical vector the same length as `x` and `y`.
#'
#' @name relations
#'
#' @examples
#' period1 <- c(1500, 1900)
#' period2 <- c(1800, 1950)
#' period3 <- c(1900, 1950)
#' 
#' contemporary_with(period1, period2)
#' 
#' # Inclusive relations (the default)
#' contemporary_with(period1, period3)
#' 
#' # Strict relations
#' contemporary_with(period1, period3, strict = TRUE)
NULL

#' @rdname relations
#' @export
starts_before_end_of <- function(x, y, strict = FALSE) {
  lt(start_of(x), end_of(y), strict)
}

#' @rdname relations
#' @export
ends_after_start_of <- function(x, y, strict = FALSE) {
  gt(start_of(x), end_of(y), strict)
}

#' @rdname relations
#' @export
starts_before_start_of <- function(x, y, strict = FALSE) {
  lt(start_of(x), start_of(y), strict)
}

#' @rdname relations
#' @export
starts_after_start_of <- function(x, y, strict = FALSE) {
  gt(start_of(x), start_of(y), strict)
}

#' @rdname relations
#' @export
ends_before_end_of <- function(x, y, strict = FALSE) { 
  lt(end_of(x), end_of(y), strict)
}

#' @rdname relations
#' @export
ends_after_end_of <- function(x, y, strict = FALSE) { 
  gt(end_of(x), end_of(y), strict)
}

#' @rdname relations
#' @export
ends_before_start_of <- function(x, y, strict = FALSE) {
  lt(end_of(x), start_of(y), strict)
}

#' @rdname relations
#' @export
starts_after_end_of <- function(x, y, strict = FALSE) { 
  gt(start_of(x), end_of(y), strict)
}

#' @rdname relations
#' @export
meets <- function(x, y, strict = FALSE) {
  end_of(x) == start_of(y)
}

#' @rdname relations
#' @export
met_by <- function(x, y, strict = FALSE) {
  start_of(x) == end_of(y)
}

#' @rdname relations
#' @export
contemporary_with <- function(x, y, strict = FALSE) {
  gt(end_of(x), start_of(y), strict) & 
    lt(start_of(x), end_of(y), strict)
}

#' @rdname relations
#' @export
starts_during <- function(x, y, strict = FALSE) {
  lt(start_of(y), start_of(x), strict) &
    lt(start_of(x), end_of(y), strict)
}

#' @rdname relations
#' @export
includes_start_of <- function(x, y, strict = FALSE) { 
  lt(start_of(x), start_of(y), strict) &
    lt(start_of(y), end_of(x), strict)
}

#' @rdname relations
#' @export
starts_with <- function(x, y, strict = FALSE) { 
  start_of(x) == start_of(y)
}

#' @rdname relations
#' @export
ends_with <- function(x, y, strict = FALSE) {
  end_of(x) == end_of(y)
}

#' @rdname relations
#' @export
overlaps_before <- function(x, y, strict = FALSE) { 
  lt(start_of(x), start_of(y), strict) &
    lt(start_of(y), end_of(x), strict) &
    lt(end_of(x), end_of(y), strict)
}

#' @rdname relations
#' @export
overlaps_after <- function(x, y, strict = FALSE) { 
  lt(start_of(y), start_of(x), strict) &
    lt(start_of(x), end_of(y), strict) &
    lt(end_of(y), end_of(x), strict)
}

#' @rdname relations
#' @export
includes <- function(x, y, strict = FALSE) { 
  lt(start_of(x), start_of(y), strict) &
    gt(end_of(x), end_of(y), strict)
}

#' @rdname relations
#' @export
included_in <- function(x, y, strict = FALSE) { 
  gt(start_of(x), start_of(y), strict) &
    lt(end_of(x), end_of(y), strict)
}

#' @rdname relations
#' @export
begins <- function(x, y, strict = FALSE) { 
  (start_of(x) == start_of(y)) &
    lt(end_of(x), end_of(y), strict)
}

#' @rdname relations
#' @export
begun_by <- function(x, y, strict = FALSE) { 
  (start_of(x) == start_of(y)) &
    gt(end_of(x), end_of(y), strict)
}

#' @rdname relations
#' @export
ends <- function(x, y, strict = FALSE) { 
  (end_of(x) == end_of(y)) &
    gt(start_of(x), start_of(y))
}

#' @rdname relations
#' @export
ended_by <- function(x, y, strict = FALSE) { 
  (end_of(x) == end_of(y)) &
    lt(start_of(x), start_of(y))
}

#' @rdname relations
#' @export
#  N.B. `equal_to` not `equals` to avoid conflict with `magrittr::equals`
equal_to <- function(x, y, strict = FALSE) { 
  (start_of(x) == start_of(y)) &
    (end_of(x) == end_of(y))
}


# Helper functions --------------------------------------------------------

#' @noRd
#' @keywords internal
lt <- function(x, y, strict = FALSE) {
  if (isTRUE(strict)) x < y
  else x <= y
}

#' @noRd
#' @keywords internal
gt <- function(x, y, strict = FALSE) {
  if (isTRUE(strict)) x > y
  else x >= y
}

