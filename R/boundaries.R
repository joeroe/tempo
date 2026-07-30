# boundaries.R
# Methods for accessing the start of and end of intervals

#' @noRd
#' @keywords internal
start_of <- function(x) {
  UseMethod("start_of")
}

#' @noRd
#' @keywords internal
#' @exportS3Method start_of tempo_interval
start_of.tempo_interval <- function(x) {
  intv_start(x)
}

#' @noRd
#' @keywords internal
#' @exportS3Method start_of numeric
start_of.numeric <- function(x) {
  x[1]
}

#' @noRd
#' @keywords internal
#' @exportS3Method start_of list
start_of.list <- function(x) {
  purrr::map_vec(x, 1)
}

#' @noRd
#' @keywords internal
#' @exportS3Method start_of default
start_of.default <- function(x) {
  abort(
    c(
      "`start_of()` is not defined for this type of input.",
      i = "Supported types: tempo_interval, numeric, list."
    ),
    class = "tempo_invalid_argument"
  )
}

#' @noRd
#' @keywords internal
end_of <- function(x) {
  UseMethod("end_of")
}

#' @noRd
#' @keywords internal
#' @exportS3Method end_of tempo_interval
end_of.tempo_interval <- function(x) {
  intv_end(x)
}

#' @noRd
#' @keywords internal
#' @exportS3Method end_of numeric
end_of.numeric <- function(x) {
  x[2]
}

#' @noRd
#' @keywords internal
#' @exportS3Method end_of list
end_of.list <- function(x) {
  purrr::map_vec(x, 2)
}

#' @noRd
#' @keywords internal
#' @exportS3Method end_of default
end_of.default <- function(x) {
  abort(
    c(
      "`end_of()` is not defined for this type of input.",
      i = "Supported types: tempo_interval, numeric, list."
    ),
    class = "tempo_invalid_argument"
  )
}
