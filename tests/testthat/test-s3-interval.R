test_that("interval() constructs from scalar inputs", {
  intv <- interval(10, 20)
  expect_s3_class(intv, "tempo_interval")
  expect_equal(intv_start(intv), 10)
  expect_equal(intv_end(intv), 20)
})

test_that("interval() constructs from vector inputs", {
  intv <- interval(c(10, 20, 30), c(20, 30, 40))
  expect_s3_class(intv, "tempo_interval")
  expect_equal(intv_start(intv), c(10, 20, 30))
  expect_equal(intv_end(intv), c(20, 30, 40))
})

test_that("interval() recycles unequal-length inputs", {
  intv <- interval(10, c(20, 30))
  expect_equal(intv_start(intv), c(10, 10))
  expect_equal(intv_end(intv), c(20, 30))
})

test_that("interval() errors when recycling is impossible", {
  expect_error(interval(c(1, 2, 3), c(1, 2)))
})

test_that("interval() errors when start > end", {
  expect_error(interval(20, 10), class = "tempo_invalid_interval")
})

test_that("interval() allows matching NA values", {
  intv <- interval(c(10, NA), c(20, NA))
  expect_s3_class(intv, "tempo_interval")
  expect_equal(intv_start(intv), c(10, NA))
  expect_equal(intv_end(intv), c(20, NA))
})

test_that("interval() errors when NA in start is not matched by NA in end", {
  expect_error(interval(c(10, NA), c(20, 30)), class = "tempo_invalid_interval")
  expect_error(interval(c(10, 20), c(NA, 30)), class = "tempo_invalid_interval")
})

test_that("interval() returns empty interval for no arguments", {
  intv <- interval()
  expect_s3_class(intv, "tempo_interval")
  expect_equal(vec_size(intv), 0L)
})

test_that("is_interval() returns TRUE for intervals", {
  expect_true(is_interval(interval(10, 20)))
})

test_that("is_interval() returns FALSE for non-intervals", {
  expect_false(is_interval(c(10, 20)))
  expect_false(is_interval("interval"))
  expect_false(is_interval(NULL))
})

test_that("format.tempo_interval() formats correctly", {
  intv <- interval(c(10, 20), c(30, 40))
  expect_equal(format(intv), c("10\u201330", "20\u201340"))
})

test_that("format.tempo_interval() handles NA", {
  intv <- interval(c(10, NA), c(30, NA))
  expect_equal(format(intv), c("10\u201330", NA))
})

test_that("vec_ptype_abbr.tempo_interval() returns 'intv'", {
  expect_equal(vec_ptype_abbr(interval(10, 20)), "intv")
})

test_that("vec_ptype_full.tempo_interval() returns 'interval'", {
  expect_equal(vec_ptype_full(interval(10, 20)), "interval")
})

test_that("intv_start() extracts start values", {
  intv <- interval(c(10, 20), c(30, 40))
  expect_equal(intv_start(intv), c(10, 20))
})

test_that("intv_end() extracts end values", {
  intv <- interval(c(10, 20), c(30, 40))
  expect_equal(intv_end(intv), c(30, 40))
})

test_that("intv_start() and intv_end() work for empty intervals", {
  intv <- interval()
  expect_equal(intv_start(intv), numeric())
  expect_equal(intv_end(intv), numeric())
})

test_that("new_interval() errors on mismatched lengths", {
  expect_error(new_interval(1:3, 1:2))
})
