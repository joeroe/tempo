test_that("intv_union() spans earliest start to latest end", {
  result <- intv_union(interval(10, 30), interval(20, 50))
  expect_s3_class(result, "tempo_interval_numeric")
  expect_equal(intv_start(result), 10)
  expect_equal(intv_end(result), 50)
})

test_that("intv_union() works with more than two intervals", {
  result <- intv_union(interval(10, 20), interval(5, 15), interval(25, 50))
  expect_equal(intv_start(result), 5)
  expect_equal(intv_end(result), 50)
})

test_that("intv_intersection() returns latest start to earliest end", {
  result <- intv_intersection(interval(10, 30), interval(20, 50))
  expect_s3_class(result, "tempo_interval_numeric")
  expect_equal(intv_start(result), 20)
  expect_equal(intv_end(result), 30)
})

test_that("intv_intersection() works with more than two intervals", {
  result <- intv_intersection(
    interval(0, 30), interval(10, 40), interval(15, 50)
  )
  expect_equal(intv_start(result), 15)
  expect_equal(intv_end(result), 30)
})

test_that("intv_difference() is not yet implemented", {
  expect_error(intv_difference(interval(0, 10), interval(5, 15)))
})

# yr-backed intervals ---------------------------------------------------

test_that("intv_union() preserves yr subclass", {
  result <- intv_union(
    interval(yr(100, "BP"), yr(50, "BP")),
    interval(yr(75, "BP"), yr(25, "BP"))
  )
  expect_s3_class(result, "tempo_interval_era_yr")
  expect_equal(intv_start(result), yr(100, "BP"))
  expect_equal(intv_end(result), yr(25, "BP"))
})

test_that("intv_intersection() preserves yr subclass", {
  result <- intv_intersection(
    interval(yr(100, "BP"), yr(50, "BP")),
    interval(yr(75, "BP"), yr(25, "BP"))
  )
  expect_s3_class(result, "tempo_interval_era_yr")
  expect_equal(intv_start(result), yr(75, "BP"))
  expect_equal(intv_end(result), yr(50, "BP"))
})

test_that("intv_difference() errors for yr-backed intervals", {
  expect_error(intv_difference(
    interval(yr(100, "BP"), yr(50, "BP")),
    interval(yr(75, "BP"), yr(25, "BP"))
  ))
})
