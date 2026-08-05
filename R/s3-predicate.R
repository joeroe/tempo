# s3-predicate.R
# S3 infrastructure for temporal predicates

# Predicate class --------------------------------------------------------------

#' @noRd
#' @keywords internal
new_predicate <- function(lhs, op, rhs) {
  new_rcrd(
    fields = list(lhs = lhs, op = op, rhs = rhs),
    class = "tempo_predicate"
  )
}

#' @noRd
#' @keywords internal
parse_predicate <- function(expr) {
  # Extract operator
  op <- expr[[1]]
  if (!rlang::is_call(expr) || length(expr) != 3) {
    abort(
      "Predicate must be a comparison expression.",
      class = "tempo_invalid_argument"
    )
  }

  # Extract lhs and rhs
  lhs <- expr[[2]]
  rhs <- expr[[3]]

  # Validate they are boundary calls
  validate_boundary_call(lhs)
  validate_boundary_call(rhs)

  # Return as language objects in lists
  list(lhs = list(lhs), op = list(op), rhs = list(rhs))
}

#' @noRd
#' @keywords internal
validate_boundary_call <- function(expr) {
  if (!rlang::is_call(expr)) {
    abort(
      c(
        "Boundary must be a call to start_of() or end_of().",
        x = sprintf("Got %s.", deparse(expr))
      ),
      class = "tempo_invalid_argument"
    )
  }

  fn_name <- rlang::call_name(expr)
  if (!fn_name %in% c("start_of", "end_of")) {
    abort(
      c(
        "Boundary must be a call to start_of() or end_of().",
        x = sprintf("Got %s().", fn_name)
      ),
      class = "tempo_invalid_argument"
    )
  }

  # Check operand is a symbol
  operand <- expr[[2]]
  if (!rlang::is_symbol(operand)) {
    abort(
      c(
        "Boundary operand must be a symbol (x or y).",
        x = sprintf("Got %s.", deparse(operand))
      ),
      class = "tempo_invalid_argument"
    )
  }
}

# Predicate evaluation ---------------------------------------------------------

#' @noRd
#' @keywords internal
evaluate_boundary <- function(boundary_call, x, y) {
  fn_name <- rlang::call_name(boundary_call)
  operand <- boundary_call[[2]]

  # Get the actual interval
  interval <- if (identical(operand, quote(x))) x else y

  # Call the appropriate function
  if (fn_name == "start_of") {
    start_of(interval)
  } else {
    end_of(interval)
  }
}

#' @noRd
#' @keywords internal
evaluate_predicate <- function(predicate, x, y, strict = FALSE) {
  if (length(predicate) == 0) {
    # Empty predicate is always TRUE
    # Need to return a vector of TRUE with correct length
    if (is.list(x)) {
      return(rep(TRUE, length(x)))
    } else {
      return(TRUE)
    }
  }

  # Get fields
  lhs_calls <- field(predicate, "lhs")
  ops <- field(predicate, "op")
  rhs_calls <- field(predicate, "rhs")

  # Evaluate each predicate element and collect results
  all_results <- purrr::map(seq_along(predicate), function(i) {
    lhs_val <- evaluate_boundary(lhs_calls[[i]], x, y)
    rhs_val <- evaluate_boundary(rhs_calls[[i]], x, y)

    # Get operator symbol and evaluate to function
    op_symbol <- ops[[i]]
    if (isTRUE(strict)) {
      # Rewrite to strict version
      op_symbol <- rewrite_to_strict(op_symbol)
    }
    op <- eval(op_symbol)

    # Apply operator - returns vector of logical values
    op(lhs_val, rhs_val)
  })

  # AND all predicates together element-wise
  Reduce(`&`, all_results)
}

#' @noRd
#' @keywords internal
rewrite_to_strict <- function(op) {
  if (identical(op, quote(`<=`))) {
    return(quote(`<`))
  } else if (identical(op, quote(`>=`))) {
    return(quote(`>`))
  }
  op
}

# Formatting -------------------------------------------------------------------

#' @noRd
#' @keywords internal
#' @exportS3Method format tempo_predicate
format.tempo_predicate <- function(x, ...) {
  if (length(x) == 0) {
    return(character())
  }

  lhs_calls <- field(x, "lhs")
  ops <- field(x, "op")
  rhs_calls <- field(x, "rhs")

  purrr::map_chr(seq_along(x), function(i) {
    paste(
      deparse(lhs_calls[[i]]),
      deparse(ops[[i]]),
      deparse(rhs_calls[[i]])
    )
  })
}
