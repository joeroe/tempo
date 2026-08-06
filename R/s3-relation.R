# s3-relation.R
# S3 infrastructure for temporal relations

# Relation class ---------------------------------------------------------------

#' @noRd
#' @keywords internal
new_relation <- function(...) {
  # Capture arguments using match.call
  call <- match.call(expand.dots = FALSE)
  args <- as.list(call$...)

  # Convert each argument to a list of predicate expressions
  arg_lists <- purrr::map(args, function(arg) {
    # Check if it's a list() call
    if (rlang::is_call(arg, "list")) {
      # Extract the elements from the list() call
      as.list(arg)[-1]  # Remove the first element (the function name)
    } else {
      # Single expression - wrap in list
      list(arg)
    }
  })

  # Recycle all lists to common length
  max_len <- max(purrr::map_int(arg_lists, length))
  if (max_len == 0) {
    # Empty relation
    return(
      new_list_of(
        list(new_predicate(list(), list(), list())),
        ptype = new_predicate(list(), list(), list()),
        class = "tempo_relation"
      )
    )
  }

  recycled <- purrr::map(arg_lists, function(arg_list) {
    if (length(arg_list) == max_len) {
      arg_list
    } else if (length(arg_list) == 1) {
      rep(arg_list, max_len)
    } else {
      abort(
        c(
          "Argument lengths must be 1 or equal to the maximum length.",
          x = sprintf("Got length %d with max length %d.", length(arg_list), max_len)
        ),
        class = "tempo_invalid_argument"
      )
    }
  })

  # Build predicates for each position
  relations <- purrr::map(seq_len(max_len), function(i) {
    # Collect non-NULL predicates at this position
    expressions <- purrr::map(recycled, i)
    expressions <- purrr::keep(expressions, Negate(is.null))

    if (length(expressions) == 0) {
      # Empty predicate vector for this relation
      new_predicate(list(), list(), list())
    } else {
      # Parse each expression and combine
      # Each expression is a comparison like end_of(x) == start_of(y)
      parsed <- purrr::map(expressions, parse_predicate)
      lhs_list <- purrr::list_c(purrr::map(parsed, "lhs"))
      op_list <- purrr::list_c(purrr::map(parsed, "op"))
      rhs_list <- purrr::list_c(purrr::map(parsed, "rhs"))
      new_predicate(lhs_list, op_list, rhs_list)
    }
  })

  # Create tempo_relation vector
  result <- new_list_of(
    relations,
    ptype = new_predicate(list(), list(), list()),
    class = "tempo_relation"
  )

  result
}

#' Get relation definitions by name
#'
#' `relation()` retrieves the declarative definitions of temporal relations by name.
#' This function returns the underlying predicate structures that define
#' each relation, which can be useful for programmatic inspection or
#' integration with other temporal reasoning systems.
#'
#' `relation_names()` lists all available relation names that can be used with
#' `relation()`.
#'
#' @param name Character vector of relation names (without the `_relation` suffix).
#'   Use `relation_names()` to see all available names.
#'
#' @return 
#' - `relation()` returns a named list of relation definitions. Each element is a list of
#'   predicates that define the relation.
#' - `relation_names()` returns a character vector of available relation names.
#'
#' @export
#' @rdname relation
#'
#' @examples
#' # List all available relations
#' relation_names()
#'
#' # Get a single relation definition
#' relation("meets")
#'
#' # Get multiple relations
#' relation(c("meets", "contemporary_with"))
#'
#' # Inspect the structure
#' meets_def <- relation("meets")
#' str(meets_def)
relation <- function(name) {
  if (!is.character(name)) {
    abort(
      "`name` must be a character vector.",
      class = "tempo_invalid_argument"
    )
  }

  # Look up relation definitions
  relation_fns <- paste0(name, "_relation")
  env <- rlang::current_env()

  # Check all names exist
  missing <- !purrr::map_lgl(relation_fns, exists, envir = env, inherits = TRUE)
  if (any(missing)) {
    abort(
      c(
        "Unknown relation name(s).",
        x = paste(name[missing], collapse = ", "),
        i = paste("Available relations:", paste(relation_names(), collapse = ", "))
      ),
      class = "tempo_invalid_argument"
    )
  }

  # Retrieve and combine
  relation_fns <- purrr::map(relation_fns, get, envir = env, inherits = TRUE)
  relations <- purrr::map(relation_fns, function(fn) fn())
  result <- vec_c(!!!relations)
  names(result) <- name
  result
}

#' @rdname relation
#' @export
relation_names <- function() {
  # Find all objects ending in "_relation" in the package namespace
  env <- asNamespace("tempo")
  all_objects <- ls(env, pattern = "_relation$")
  
  # Exclude infrastructure functions (new_relation, evaluate_relation, format.tempo_relation)
  infrastructure <- c("new_relation", "evaluate_relation", "format.tempo_relation")
  relation_objects <- setdiff(all_objects, infrastructure)
  
  # Strip the "_relation" suffix
  gsub("_relation$", "", relation_objects)
}

# Relation evaluation ----------------------------------------------------------

#' @noRd
#' @keywords internal
evaluate_relation <- function(relation, x, y, strict = FALSE) {
  # Evaluate each relation element
  # Each relation element is a conjunction of predicates
  # We need to evaluate all predicates and AND them together
  relation_data <- vec_data(relation)

  if (length(relation_data) == 0) {
    # Empty relation
    if (is.list(x)) {
      return(rep(TRUE, length(x)))
    } else {
      return(TRUE)
    }
  }

  # Evaluate each relation element (conjunction)
  results <- purrr::map(
    relation_data,
    evaluate_predicate,
    x = x,
    y = y,
    strict = strict
  )

  # If we have multiple relations, we need to handle them differently
  # For now, assume we're evaluating a single relation (length 1)
  if (length(results) == 1) {
    return(results[[1]])
  } else {
    # Multiple relations - this shouldn't happen in normal use
    # but handle it for completeness
    abort(
      "Cannot evaluate multiple relations at once.",
      class = "tempo_invalid_argument"
    )
  }
}

# Formatting -------------------------------------------------------------------

#' @noRd
#' @keywords internal
#' @exportS3Method format tempo_relation
format.tempo_relation <- function(x, ...) {
  relation_names <- names(x)
  if (!is.null(relation_names)) {
    return(relation_names)
  }

  purrr::map_chr(
    vec_data(x),
    function(predicate) {
      if (length(predicate) == 0) {
        return("")
      }
      paste(format(predicate), collapse = " & ")
    }
  )
}
