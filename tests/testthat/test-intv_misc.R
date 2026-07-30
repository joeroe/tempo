test_that("intv_duration() returns end minus start", {
  intv <- interval(c(10, 20), c(30, 50))
  expect_equal(intv_duration(intv), c(20, 30))
})

test_that("intv_duration() returns zero for point intervals", {
  intv <- interval(10, 10)
  expect_equal(intv_duration(intv), 0)
})

test_that("intv_duration() handles NA", {
  intv <- interval(c(10, NA), c(30, NA))
  expect_equal(intv_duration(intv), c(20, NA))
})

test_that("intv_duration() works for empty intervals", {
  expect_equal(intv_duration(interval()), numeric())
})

test_that("intv_seq() generates sequences within intervals", {
  intv <- interval(c(0, 10), c(10, 20))
  result <- intv_seq(intv, by = 5)
  expect_type(result, "list")
  expect_length(result, 2)
  expect_equal(result[[1]], seq(0, 10, by = 5))
  expect_equal(result[[2]], seq(10, 20, by = 5))
})

test_that("intv_seq() returns list of correct length for empty intervals", {
  result <- intv_seq(interval())
  expect_type(result, "list")
  expect_length(result, 0)
})

test_that("seq.tempo_interval() works for length-1 intervals", {
  intv <- interval(0, 10)
  expect_equal(seq(intv, by = 5), seq(0, 10, by = 5))
})

test_that("seq.tempo_interval() errors for length > 1", {
  intv <- interval(c(0, 10), c(10, 20))
  expect_error(seq(intv), class = "tempo_no_method")
})
