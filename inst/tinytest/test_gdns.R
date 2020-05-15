library(gdns)

if (at_home()) {

  expect_true(length(gdns::query("example.com")) > 0)

  doms <- c("example.com", "example.org", "example.net")

  qry <- gdns::bulk_query(doms)

  expect_true(nrow(qry) > 0)

}

expect_true(is_soft_fail("v=spf1 include:_spf.apple.com include:_spf-txn.apple.com ~all"))
expect_false(is_hard_fail("v=spf1 include:_spf.apple.com include:_spf-txn.apple.com ~all"))
expect_false(passes_all("v=spf1 include:_spf.apple.com include:_spf-txn.apple.com ~all"))

