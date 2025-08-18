# intv_misc.R
# Miscellaneous interval methods

#' @export
intv_duration <- function(x) {
  # TODO: yr class should be dropped but isn't
  intv_end(x) - intv_start(x)
}

#' @export
intv_seq <- function(x, ...) {
  purrr::map(x, seq, ...)
}

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
