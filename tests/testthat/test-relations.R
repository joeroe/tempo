test_that("can get start_of() and end_of() a two-element numeric vector", {
  expect_equal(start_of(c(0,1)), 0)
  expect_equal(end_of(c(0,1)), 1)
})

test_that("can get start_of() and end_of() a list of vectors", {
  periods <- list(c(0,1), c(2, 3), c(4, 5))
  expect_equal(start_of(periods), c(0, 2, 4))
  expect_equal(end_of(periods), c(1, 3, 5))
})

# Levy (2025) ordering relations (Table 5, relations 1-4) --------------------

test_that("starts_before_end_of() implements Levy 1a (beg(x) <= end(y))", {
  expect_true(starts_before_end_of(c(0, 2), c(1, 3)))
  expect_false(starts_before_end_of(c(5, 6), c(0, 1)))
  x <- c(1, 2)
  y <- c(0, 1)
  expect_true(starts_before_end_of(x, y))
  expect_false(starts_before_end_of(x, y, strict = TRUE))
})

test_that("ends_after_start_of() implements Levy 1b (end(x) >= beg(y))", {
  expect_true(ends_after_start_of(c(0, 2), c(1, 3)))
  expect_false(ends_after_start_of(c(0, 1), c(5, 6)))
  x <- c(0, 1)
  y <- c(1, 2)
  expect_true(ends_after_start_of(x, y))
  expect_false(ends_after_start_of(x, y, strict = TRUE))
})

test_that("starts_before_start_of() implements Levy 2a (beg(x) <= beg(y))", {
  expect_true(starts_before_start_of(c(0, 1), c(2, 3)))
  expect_false(starts_before_start_of(c(5, 6), c(0, 1)))
  x <- c(1, 2)
  y <- c(1, 3)
  expect_true(starts_before_start_of(x, y))
  expect_false(starts_before_start_of(x, y, strict = TRUE))
})

test_that("starts_after_start_of() implements Levy 2b (beg(x) >= beg(y))", {
  expect_true(starts_after_start_of(c(2, 3), c(0, 1)))
  expect_false(starts_after_start_of(c(0, 1), c(5, 6)))
  x <- c(1, 2)
  y <- c(1, 3)
  expect_true(starts_after_start_of(x, y))
  expect_false(starts_after_start_of(x, y, strict = TRUE))
})

test_that("ends_before_end_of() implements Levy 3a (end(x) <= end(y))", {
  expect_true(ends_before_end_of(c(0, 1), c(2, 3)))
  expect_false(ends_before_end_of(c(5, 6), c(0, 1)))
  x <- c(0, 1)
  y <- c(0, 1)
  expect_true(ends_before_end_of(x, y))
  expect_false(ends_before_end_of(x, y, strict = TRUE))
})

test_that("ends_after_end_of() implements Levy 3b (end(x) >= end(y))", {
  expect_true(ends_after_end_of(c(2, 3), c(0, 1)))
  expect_false(ends_after_end_of(c(0, 1), c(5, 6)))
  x <- c(0, 1)
  y <- c(0, 1)
  expect_true(ends_after_end_of(x, y))
  expect_false(ends_after_end_of(x, y, strict = TRUE))
})

test_that("ends_before_start_of() implements Levy 4a (end(x) <= beg(y))", {
  expect_true(ends_before_start_of(c(0, 1), c(2, 3)))
  expect_false(ends_before_start_of(c(2, 3), c(0, 1)))
  x <- c(0, 1)
  y <- c(1, 2)
  expect_true(ends_before_start_of(x, y))
  expect_false(ends_before_start_of(x, y, strict = TRUE))
})

test_that("starts_after_end_of() implements Levy 4b (beg(x) >= end(y))", {
  expect_true(starts_after_end_of(c(2, 3), c(0, 1)))
  expect_false(starts_after_end_of(c(0, 1), c(2, 3)))
  x <- c(1, 2)
  y <- c(0, 1)
  expect_true(starts_after_end_of(x, y))
  expect_false(starts_after_end_of(x, y, strict = TRUE))
})

# Levy (2025) sequence and contemporaneity (Table 5, relations 5-6) ---------

test_that("meets() returns TRUE when end of x equals start of y", {
  expect_true(meets(c(0, 1), c(1, 2)))
  expect_false(meets(c(0, 1), c(2, 3)))
})

test_that("met_by() returns TRUE when start of x equals end of y", {
  expect_true(met_by(c(1, 2), c(0, 1)))
  expect_false(met_by(c(2, 3), c(0, 1)))
})

test_that("contemporary_with() returns TRUE for intervals sharing any time", {
  expect_true(contemporary_with(c(0, 2), c(1, 3)))
  expect_true(contemporary_with(c(0, 3), c(1, 2)))
  expect_false(contemporary_with(c(0, 1), c(2, 3)))
  expect_false(contemporary_with(c(2, 3), c(0, 1)))
  expect_true(contemporary_with(c(0, 1), c(1, 2)))
  expect_false(contemporary_with(c(0, 1), c(1, 2), strict = TRUE))
})

# Levy (2025) start and end inclusion (Table 5, relations 7-8) --------------

test_that("starts_during() returns TRUE when x's start falls within y", {
  expect_true(starts_during(c(1, 3), c(0, 2)))
  expect_false(starts_during(c(0, 2), c(1, 3)))
  expect_true(starts_during(c(2, 3), c(0, 2)))
  expect_false(starts_during(c(2, 3), c(0, 2), strict = TRUE))
})

test_that("includes_start_of() returns TRUE when y's start falls within x", {
  expect_true(includes_start_of(c(0, 2), c(1, 3)))
  expect_false(includes_start_of(c(1, 3), c(0, 2)))
  expect_true(includes_start_of(c(0, 1), c(1, 3)))
  expect_false(includes_start_of(c(0, 1), c(1, 3), strict = TRUE))
})

test_that("ends_during() returns TRUE when x's end falls within y (Levy 8a)", {
  expect_true(ends_during(c(0, 3), c(1, 5)))
  expect_true(ends_during(c(0, 2), c(0, 4)))
  expect_false(ends_during(c(0, 1), c(2, 3)))
  expect_false(ends_during(c(0, 5), c(2, 3)))
  expect_false(ends_during(c(2, 5), c(0, 3)))
  expect_true(ends_during(c(0, 3), c(0, 3)))
  expect_true(ends_during(c(0, 3), c(0, 5)))
  expect_true(ends_during(c(0, 5), c(0, 5)))
  expect_false(ends_during(c(0, 3), c(0, 3), strict = TRUE))
  expect_false(ends_during(c(0, 3), c(0, 3), strict = TRUE))
  expect_false(ends_during(c(0, 5), c(0, 5), strict = TRUE))
  expect_true(ends_during(c(0, 3), c(1, 5)))
  expect_true(contemporary_with(c(0, 3), c(1, 5)))
})

test_that("includes_end_of() returns TRUE when y's end falls within x (Levy 8b)", {
  expect_true(includes_end_of(c(0, 5), c(1, 3)))
  expect_true(includes_end_of(c(0, 4), c(0, 2)))
  expect_false(includes_end_of(c(0, 2), c(3, 5)))
  expect_false(includes_end_of(c(0, 2), c(0, 5)))
  expect_false(includes_end_of(c(2, 3), c(3, 4)))
  expect_false(includes_end_of(c(0, 2), c(0, 3)))
  expect_true(includes_end_of(c(0, 3), c(0, 3)))
  expect_true(includes_end_of(c(0, 5), c(0, 3)))
  expect_true(includes_end_of(c(0, 5), c(0, 5)))
  expect_false(includes_end_of(c(0, 3), c(0, 3), strict = TRUE))
  expect_false(includes_end_of(c(0, 3), c(0, 3), strict = TRUE))
  expect_false(includes_end_of(c(0, 5), c(0, 5), strict = TRUE))
  expect_true(includes_end_of(c(0, 5), c(1, 3)))
  expect_true(contemporary_with(c(0, 5), c(1, 3)))
})

# Levy (2025) equal start/end and overlap (Table 5, relations 9-11) ---------

test_that("starts_with() returns TRUE when x and y share start", {
  expect_true(starts_with(c(0, 1), c(0, 2)))
  expect_false(starts_with(c(0, 2), c(1, 2)))
})

test_that("ends_with() returns TRUE when x and y share end", {
  expect_true(ends_with(c(0, 2), c(1, 2)))
  expect_false(ends_with(c(0, 1), c(0, 2)))
})

test_that("overlaps_before() returns TRUE when x starts first and y ends last", {
  expect_true(overlaps_before(c(0, 2), c(1, 3)))
  expect_false(overlaps_before(c(0, 3), c(1, 2)))
  expect_true(overlaps_before(c(0, 2), c(0, 3)))
  expect_false(overlaps_before(c(0, 2), c(0, 3), strict = TRUE))
})

test_that("overlaps_after() returns TRUE when y starts first and x ends last", {
  expect_true(overlaps_after(c(1, 3), c(0, 2)))
  expect_false(overlaps_after(c(1, 2), c(0, 3)))
  expect_true(overlaps_after(c(0, 2), c(0, 1)))
  expect_false(overlaps_after(c(0, 2), c(0, 1), strict = TRUE))
})

# Levy (2025) inclusion (Table 5, relation 12) -------------------------------

test_that("includes() returns TRUE when x fully contains y", {
  expect_true(includes(c(0, 3), c(1, 2)))
  expect_false(includes(c(0, 2), c(1, 3)))
  expect_true(includes(c(0, 3), c(0, 2)))
  expect_false(includes(c(0, 3), c(0, 2), strict = TRUE))
})

test_that("included_in() returns TRUE when x is fully contained within y", {
  expect_true(included_in(c(1, 2), c(0, 3)))
  expect_false(included_in(c(1, 3), c(0, 2)))
  expect_true(included_in(c(0, 2), c(0, 3)))
  expect_false(included_in(c(0, 2), c(0, 3), strict = TRUE))
})

# Levy (2025) beginning, ending, equality (Table 5, relations 13-15) ---------

test_that("begins() works", {
  expect_true(begins(c(0, 1), c(0, 2)))
  expect_false(begins(c(1, 2), c(0, 2)))
  expect_true(begins(c(0, 1), c(0, 1)))
  expect_false(begins(c(0, 1), c(0, 1), strict = TRUE))
})

test_that("begun_by() works", {
  expect_true(begun_by(c(0, 2), c(0, 1)))
  expect_false(begun_by(c(1, 2), c(0, 1)))
  expect_true(begun_by(c(0, 1), c(0, 1)))
  expect_false(begun_by(c(0, 1), c(0, 1), strict = TRUE))
})

test_that("ends() works", {
  expect_true(ends(c(1, 2), c(0, 2)))
  expect_false(ends(c(1, 2), c(0, 3)))
  expect_true(ends(c(1, 2), c(1, 2)))
  expect_false(ends(c(1, 2), c(1, 2), strict = TRUE))
})

test_that("ended_by() works", {
  expect_true(ended_by(c(0, 2), c(1, 2)))
  expect_false(ended_by(c(0, 3), c(1, 2)))
  expect_true(ended_by(c(1, 2), c(1, 2)))
  expect_false(ended_by(c(1, 2), c(1, 2), strict = TRUE))
})

test_that("equal_to() works", {
  expect_true(equal_to(c(0, 2), c(0, 2)))
  expect_false(equal_to(c(0, 2), c(1, 2)))
  expect_false(equal_to(c(0, 2), c(0, 3)))
  expect_false(equal_to(c(0, 2), c(1, 3)))
})

# Vectorisation --------------------------------------------------------------

test_that("temporal relations functions are vectorised", {
  x <- list(c(0, 2), c(1, 3), c(5, 6))
  y <- list(c(1, 3), c(2, 4), c(7, 8))

  result <- contemporary_with(x, y)
  expect_length(result, 3)
  expect_true(result[1])
  expect_true(result[2])
  expect_false(result[3])

  result <- starts_before_start_of(x, y)
  expect_length(result, 3)
  expect_true(result[1])
  expect_true(result[2])
  expect_true(result[3])

  result <- equal_to(x, y)
  expect_length(result, 3)
  expect_false(result[1])
  expect_false(result[2])
  expect_false(result[3])
  expect_true(equal_to(list(c(0, 1)), list(c(0, 1))))
})
