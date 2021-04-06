test_that("pend get works", {
  expect_equal(paxor::pend.get(), c())
  expect_equal(paxor::pend.get("xyz"), c("xyz"))
  expect_equal(paxor::pend.get("abc"), c("xyz", "abc"))
})

test_that("pend set works", {
  expect_equal(paxor::pend.set(), list())
  expect_equal(paxor::pend.set(a = 1, b = 2, c = 3), list(a = 1, b = 2, c = 3))
  expect_equal(paxor::pend.set(a = 123), list(a = 123, b = 2, c = 3))
})
