# relations-levy.R
# Levy's typology of temporal relations

# Suppress R CMD check NOTE about undefined global variables
utils::globalVariables(c("x", "y"))

#' Temporal relations
#'
#' These functions test for the logical relation between two periods according
#' to Levy's typology \insertCite{LevyEtAl2021,Levy2025}{tempo}.
#'
#' @param x,y Pair(s) of periods to test the relation between. Can be
#'   [interval()] objects, two-element numeric vectors, or lists of two-element
#'   numeric vectors.
#' @param strict By default, comparison is inclusive (i.e. using `<=` and `>=`).
#'   Use `strict = TRUE` for strict comparison (i.e. using `<` and `>`).
#'
#' @return
#' Logical vector the same length as `x` and `y`.
#'
#' @references
#'   \insertAllCited{}
#'
#' @name relations
#'
#' @importFrom Rdpack reprompt
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

# Relation definitions ---------------------------------------------------------
# All definitions follow Levy's inclusive core definitions (Levy 2025, Table 5).
# Strict variants are derived by interpreting the same definition with the
# `strict` argument set to TRUE.

#' @noRd
#' @keywords internal
starts_before_end_of_relation <- function() new_relation(start_of(x) <= end_of(y))

#' @noRd
#' @keywords internal
ends_after_start_of_relation <- function() new_relation(end_of(x) >= start_of(y))

#' @noRd
#' @keywords internal
# nolint next: object_length_linter.
starts_before_start_of_relation <- function() new_relation(start_of(x) <= start_of(y))

#' @noRd
#' @keywords internal
starts_after_start_of_relation <- function() new_relation(start_of(x) >= start_of(y))

#' @noRd
#' @keywords internal
ends_before_end_of_relation <- function() new_relation(end_of(x) <= end_of(y))

#' @noRd
#' @keywords internal
ends_after_end_of_relation <- function() new_relation(end_of(x) >= end_of(y))

#' @noRd
#' @keywords internal
ends_before_start_of_relation <- function() new_relation(end_of(x) <= start_of(y))

#' @noRd
#' @keywords internal
starts_after_end_of_relation <- function() new_relation(start_of(x) >= end_of(y))

#' @noRd
#' @keywords internal
meets_relation <- function() new_relation(end_of(x) == start_of(y))

#' @noRd
#' @keywords internal
met_by_relation <- function() new_relation(start_of(x) == end_of(y))

# Levy 6: end(A) >= beg(B) AND beg(A) <= end(B)
#' @noRd
#' @keywords internal
contemporary_with_relation <- function() new_relation(
  end_of(x) >= start_of(y),
  start_of(x) <= end_of(y)
)

# Levy 7a: beg(B) <= beg(A) <= end(B)
#' @noRd
#' @keywords internal
starts_during_relation <- function() new_relation(
  start_of(y) <= start_of(x),
  start_of(x) <= end_of(y)
)

# Levy 7b: beg(A) <= beg(B) <= end(A)
#' @noRd
#' @keywords internal
includes_start_of_relation <- function() new_relation(
  start_of(x) <= start_of(y),
  start_of(y) <= end_of(x)
)

# Levy 8a: beg(B) <= end(A) <= end(B)
#' @noRd
#' @keywords internal
ends_during_relation <- function() new_relation(
  start_of(y) <= end_of(x),
  end_of(x) <= end_of(y)
)

# Levy 8b: beg(A) <= end(B) <= end(A)
#' @noRd
#' @keywords internal
includes_end_of_relation <- function() new_relation(
  start_of(x) <= end_of(y),
  end_of(y) <= end_of(x)
)

#' @noRd
#' @keywords internal
starts_with_relation <- function() new_relation(start_of(x) == start_of(y))

#' @noRd
#' @keywords internal
ends_with_relation <- function() new_relation(end_of(x) == end_of(y))

# Levy 11a: beg(A) <= beg(B) <= end(A) <= end(B)
#' @noRd
#' @keywords internal
overlaps_before_relation <- function() new_relation(
  start_of(x) <= start_of(y),
  start_of(y) <= end_of(x),
  end_of(x) <= end_of(y)
)

# Levy 11b: beg(B) <= beg(A) <= end(B) <= end(A)
#' @noRd
#' @keywords internal
overlaps_after_relation <- function() new_relation(
  start_of(y) <= start_of(x),
  start_of(x) <= end_of(y),
  end_of(y) <= end_of(x)
)

# Levy 12a: beg(A) <= beg(B) AND end(A) >= end(B)
#' @noRd
#' @keywords internal
includes_relation <- function() new_relation(
  start_of(x) <= start_of(y),
  end_of(x) >= end_of(y)
)

# Levy 12b: beg(A) >= beg(B) AND end(A) <= end(B)
#' @noRd
#' @keywords internal
included_in_relation <- function() new_relation(
  start_of(x) >= start_of(y),
  end_of(x) <= end_of(y)
)

# Levy 13a: beg(A) = beg(B) AND end(A) <= end(B)
#' @noRd
#' @keywords internal
begins_relation <- function() new_relation(
  start_of(x) == start_of(y),
  end_of(x) <= end_of(y)
)

# Levy 13b: beg(A) = beg(B) AND end(A) >= end(B)
#' @noRd
#' @keywords internal
begun_by_relation <- function() new_relation(
  start_of(x) == start_of(y),
  end_of(x) >= end_of(y)
)

# Levy 14a: end(A) = end(B) AND beg(A) >= beg(B)
#' @noRd
#' @keywords internal
ends_relation <- function() new_relation(
  end_of(x) == end_of(y),
  start_of(x) >= start_of(y)
)

# Levy 14b: end(A) = end(B) AND beg(A) <= beg(B)
#' @noRd
#' @keywords internal
ended_by_relation <- function() new_relation(
  end_of(x) == end_of(y),
  start_of(x) <= start_of(y)
)

# Levy 15: beg(A) = beg(B) AND end(A) = end(B)
#' @noRd
#' @keywords internal
equal_to_relation <- function() new_relation(
  start_of(x) == start_of(y),
  end_of(x) == end_of(y)
)

# Exported relation functions --------------------------------------------------

#' @rdname relations
#' @export
starts_before_end_of <- function(x, y, strict = FALSE) {
  evaluate_relation(starts_before_end_of_relation(), x, y, strict)
}

#' @rdname relations
#' @export
ends_after_start_of <- function(x, y, strict = FALSE) {
  evaluate_relation(ends_after_start_of_relation(), x, y, strict)
}

#' @rdname relations
#' @export
starts_before_start_of <- function(x, y, strict = FALSE) {
  evaluate_relation(starts_before_start_of_relation(), x, y, strict)
}

#' @rdname relations
#' @export
starts_after_start_of <- function(x, y, strict = FALSE) {
  evaluate_relation(starts_after_start_of_relation(), x, y, strict)
}

#' @rdname relations
#' @export
ends_before_end_of <- function(x, y, strict = FALSE) {
  evaluate_relation(ends_before_end_of_relation(), x, y, strict)
}

#' @rdname relations
#' @export
ends_after_end_of <- function(x, y, strict = FALSE) {
  evaluate_relation(ends_after_end_of_relation(), x, y, strict)
}

#' @rdname relations
#' @export
ends_before_start_of <- function(x, y, strict = FALSE) {
  evaluate_relation(ends_before_start_of_relation(), x, y, strict)
}

#' @rdname relations
#' @export
starts_after_end_of <- function(x, y, strict = FALSE) {
  evaluate_relation(starts_after_end_of_relation(), x, y, strict)
}

#' @rdname relations
#' @export
meets <- function(x, y, strict = FALSE) {
  evaluate_relation(meets_relation(), x, y, strict)
}

#' @rdname relations
#' @export
met_by <- function(x, y, strict = FALSE) {
  evaluate_relation(met_by_relation(), x, y, strict)
}

#' @rdname relations
#' @export
contemporary_with <- function(x, y, strict = FALSE) {
  evaluate_relation(contemporary_with_relation(), x, y, strict)
}

#' @rdname relations
#' @export
starts_during <- function(x, y, strict = FALSE) {
  evaluate_relation(starts_during_relation(), x, y, strict)
}

#' @rdname relations
#' @export
includes_start_of <- function(x, y, strict = FALSE) {
  evaluate_relation(includes_start_of_relation(), x, y, strict)
}

#' @rdname relations
#' @export
ends_during <- function(x, y, strict = FALSE) {
  evaluate_relation(ends_during_relation(), x, y, strict)
}

#' @rdname relations
#' @export
includes_end_of <- function(x, y, strict = FALSE) {
  evaluate_relation(includes_end_of_relation(), x, y, strict)
}

#' @rdname relations
#' @export
starts_with <- function(x, y, strict = FALSE) {
  evaluate_relation(starts_with_relation(), x, y, strict)
}

#' @rdname relations
#' @export
ends_with <- function(x, y, strict = FALSE) {
  evaluate_relation(ends_with_relation(), x, y, strict)
}

#' @rdname relations
#' @export
overlaps_before <- function(x, y, strict = FALSE) {
  evaluate_relation(overlaps_before_relation(), x, y, strict)
}

#' @rdname relations
#' @export
overlaps_after <- function(x, y, strict = FALSE) {
  evaluate_relation(overlaps_after_relation(), x, y, strict)
}

#' @rdname relations
#' @export
includes <- function(x, y, strict = FALSE) {
  evaluate_relation(includes_relation(), x, y, strict)
}

#' @rdname relations
#' @export
included_in <- function(x, y, strict = FALSE) {
  evaluate_relation(included_in_relation(), x, y, strict)
}

#' @rdname relations
#' @export
begins <- function(x, y, strict = FALSE) {
  evaluate_relation(begins_relation(), x, y, strict)
}

#' @rdname relations
#' @export
begun_by <- function(x, y, strict = FALSE) {
  evaluate_relation(begun_by_relation(), x, y, strict)
}

#' @rdname relations
#' @export
ends <- function(x, y, strict = FALSE) {
  evaluate_relation(ends_relation(), x, y, strict)
}

#' @rdname relations
#' @export
ended_by <- function(x, y, strict = FALSE) {
  evaluate_relation(ended_by_relation(), x, y, strict)
}

#' @rdname relations
#' @export
#  N.B. `equal_to` not `equals` to avoid conflict with `magrittr::equals`
equal_to <- function(x, y, strict = FALSE) {
  evaluate_relation(equal_to_relation(), x, y, strict)
}
