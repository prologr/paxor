test_that("pend get works", {
  expect_equal(paxor::get(), c())
  expect_equal(paxor::get("xyz"), c("xyz"))
  expect_equal(paxor::get("abc"), c("xyz", "abc"))
})

test_that("pend set works", {
  expect_equal(paxor::set(), list())
  expect_equal(paxor::set(a = 1, b = 2, c = 3), list(a = 1, b = 2, c = 3))
  expect_equal(paxor::set(a = 123), list(a = 123, b = 2, c = 3))
})
