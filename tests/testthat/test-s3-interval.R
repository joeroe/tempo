test_that("interval() constructs from scalar inputs", {
  intv <- interval(10, 20)
  expect_s3_class(intv, "tempo_interval_numeric")
  expect_s3_class(intv, "tempo_interval")
  expect_equal(intv_start(intv), 10)
  expect_equal(intv_end(intv), 20)
})

test_that("interval() constructs from vector inputs", {
  intv <- interval(c(10, 20, 30), c(20, 30, 40))
  expect_s3_class(intv, "tempo_interval_numeric")
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
  expect_s3_class(intv, "tempo_interval_numeric")
  expect_equal(intv_start(intv), c(10, NA))
  expect_equal(intv_end(intv), c(20, NA))
})

test_that("interval() errors when NA in start is not matched by NA in end", {
  expect_error(interval(c(10, NA), c(20, 30)), class = "tempo_invalid_interval")
  expect_error(interval(c(10, 20), c(NA, 30)), class = "tempo_invalid_interval")
})

test_that("interval() returns empty interval for no arguments", {
  intv <- interval()
  expect_s3_class(intv, "tempo_interval_numeric")
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

# yr-backed intervals ---------------------------------------------------

test_that("interval() constructs from yr inputs", {
  intv <- interval(yr(100, "BP"), yr(50, "BP"))
  expect_s3_class(intv, "tempo_interval_era_yr")
  expect_s3_class(intv, "tempo_interval")
  expect_s3_class(intv_start(intv), "era_yr")
  expect_s3_class(intv_end(intv), "era_yr")
})

test_that("interval() constructs from yr vector inputs", {
  intv <- interval(yr(c(100, 200, 300), "BP"), yr(c(50, 100, 200), "BP"))
  expect_s3_class(intv, "tempo_interval_era_yr")
  expect_equal(intv_start(intv), yr(c(100, 200, 300), "BP"))
  expect_equal(intv_end(intv), yr(c(50, 100, 200), "BP"))
})

test_that("interval() recycles unequal-length yr inputs", {
  intv <- interval(yr(100, "BP"), yr(c(50, 30), "BP"))
  expect_equal(intv_start(intv), yr(c(100, 100), "BP"))
  expect_equal(intv_end(intv), yr(c(50, 30), "BP"))
})

test_that("interval() transforms end to start's era for yr inputs", {
  intv <- interval(yr(100, "BP"), yr(1900, "CE"))
  expect_equal(yr_era(intv_start(intv)), yr_era(intv_end(intv)))
})

test_that("interval() errors when yr start is chronologically after end", {
  expect_error(
    interval(yr(50, "BP"), yr(100, "BP")),
    class = "tempo_invalid_interval"
  )
})

test_that("interval() allows matching NA values for yr inputs", {
  intv <- interval(yr(c(100, NA), "BP"), yr(c(50, NA), "BP"))
  expect_s3_class(intv, "tempo_interval_era_yr")
  expect_equal(intv_start(intv), yr(c(100, NA), "BP"))
  expect_equal(intv_end(intv), yr(c(50, NA), "BP"))
})

test_that("interval() returns empty yr interval for empty yr inputs", {
  intv <- interval(yr(numeric(), "BP"), yr(numeric(), "BP"))
  expect_s3_class(intv, "tempo_interval_era_yr")
  expect_equal(vec_size(intv), 0L)
})

test_that("interval() constructs from numeric inputs with era argument", {
  intv <- interval(1000, 1500, "CE")
  expect_s3_class(intv, "tempo_interval_era_yr")
  expect_equal(intv_start(intv), yr(1000, "CE"))
  expect_equal(intv_end(intv), yr(1500, "CE"))
})

test_that("interval() constructs from numeric vectors with era argument", {
  intv <- interval(c(1500, 2500), c(1000, 2000), "BP")
  expect_s3_class(intv, "tempo_interval_era_yr")
  expect_equal(intv_start(intv), yr(c(1500, 2500), "BP"))
  expect_equal(intv_end(intv), yr(c(1000, 2000), "BP"))
})

test_that("interval() transforms yr inputs to specified era", {
  intv <- interval(yr(1000, "CE"), yr(1500, "CE"), "BP")
  expect_s3_class(intv, "tempo_interval_era_yr")
  expect_equal(yr_era(intv_start(intv)), era("BP"))
  expect_equal(yr_era(intv_end(intv)), era("BP"))
})

test_that("format.tempo_interval_era_yr() formats correctly", {
  intv <- interval(yr(c(100, 200), "BP"), yr(c(50, 100), "BP"))
  expect_equal(format(intv), c("100\u201350 BP", "200\u2013100 BP"))
})

test_that("format.tempo_interval_era_yr() handles NA", {
  intv <- interval(yr(c(100, NA), "BP"), yr(c(50, NA), "BP"))
  expect_equal(format(intv), c("100\u201350 BP", NA))
})
