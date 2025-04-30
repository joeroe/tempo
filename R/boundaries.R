# boundaries.R
# Methods for accessing the start of and end of intervals

#' @noRd
#' @keywords internal
start_of <- function(x) {
  if (is_list(x)) purrr::map_vec(x, 1)
  else x[1]
}

#' @noRd
#' @keywords internal
end_of <- function(x) {
  if (is_list(x)) purrr::map_vec(x, 2)
  else x[2]
}
