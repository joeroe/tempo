# s3-relations.R
# S3 infrastructure for declarative temporal relations

#' @noRd
#' @keywords internal
rel_boundary <- function(operand, boundary) {
  structure(
    list(operand = operand, boundary = boundary),
    class = "tempo_rel_boundary"
  )
}

#' @noRd
#' @keywords internal
start <- function(operand) {
  operand_expr <- rlang::enexpr(operand)
  rel_boundary(operand_expr, "start")
}

#' @noRd
#' @keywords internal
end <- function(operand) {
  operand_expr <- rlang::enexpr(operand)
  rel_boundary(operand_expr, "end")
}

#' @noRd
#' @keywords internal
new_rel_predicate <- function(lhs, op, strict_op, rhs) {
  new_rcrd(
    fields = list(
      lhs = list(lhs),
      op = list(op),
      strict_op = list(strict_op),
      rhs = list(rhs)
    ),
    class = "tempo_rel_predicate"
  )
}

#' @export
`<=.tempo_rel_boundary` <- function(e1, e2) {
  new_rel_predicate(e1, `<=`, `<`, e2)
}

#' @export
`==.tempo_rel_boundary` <- function(e1, e2) {
  new_rel_predicate(e1, `==`, `==`, e2)
}

#' @export
`>=.tempo_rel_boundary` <- function(e1, e2) {
  new_rel_predicate(e1, `>=`, `>`, e2)
}

#' @noRd
#' @keywords internal
rel_evaluate <- function(definition, x, y, strict = FALSE) {
  UseMethod("rel_evaluate")
}

#' @noRd
#' @keywords internal
#' @exportS3Method rel_evaluate tempo_rel_predicate
rel_evaluate.tempo_rel_predicate <- function(definition, x, y,
                                             strict = FALSE) {
  results <- purrr::map(
    definition,
    evaluate_predicate,
    x = x,
    y = y,
    strict = strict
  )
  Reduce(`&`, results)
}

#' @noRd
#' @keywords internal
evaluate_boundary <- function(boundary, x, y) {
  operand <- boundary$operand
  bound <- boundary$boundary

  if (identical(operand, quote(x))) {
    if (bound == "start") start_of(x) else end_of(x)
  } else if (identical(operand, quote(y))) {
    if (bound == "start") start_of(y) else end_of(y)
  } else {
    abort(
      "Invalid operand in relation boundary.",
      class = "tempo_invalid_argument"
    )
  }
}

#' @noRd
#' @keywords internal
evaluate_predicate <- function(predicate, x, y, strict) {
  lhs_val <- evaluate_boundary(
    rel_left_hand_side(predicate)[[1]],
    x,
    y
  )
  rhs_val <- evaluate_boundary(
    rel_right_hand_side(predicate)[[1]],
    x,
    y
  )
  op <- if (isTRUE(strict)) {
    rel_strict_operator(predicate)[[1]]
  } else {
    rel_operator(predicate)[[1]]
  }
  op(lhs_val, rhs_val)
}

#' @noRd
#' @keywords internal
rel_left_hand_side <- function(predicate) {
  field(predicate, "lhs")
}

#' @noRd
#' @keywords internal
rel_right_hand_side <- function(predicate) {
  field(predicate, "rhs")
}

#' @noRd
#' @keywords internal
rel_operator <- function(predicate) {
  field(predicate, "op")
}

#' @noRd
#' @keywords internal
rel_strict_operator <- function(predicate) {
  field(predicate, "strict_op")
}
