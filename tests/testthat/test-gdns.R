context("basic functionality")
test_that("we can do something", {

  expect_that(length(gdns::query("example.com")), equals(10))

  doms <- c("example.com", "example.org", "example.net")
  qry <- gdns::bulk_query(doms)

  expect_that(dim(qry), equals(c(3, 7)))

})
