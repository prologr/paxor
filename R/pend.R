#' Sets up pending Paxos-get operations.
#'
#' @param ... Keys to get.
#' @return Accumulated vector of keys for pending Paxos-get operations.
#' @export
pend.get <- local({
  keys <- NULL
  function(...) {
    keys <<- union(keys, c(...))
  }
})

#' Sets up pending Paxos-set operations.
#'
#' @param ... Pairs of names and values to set.
#' @return Accumulated list of names and values for pending Paxos-set
#'   operations.
#' @seealso [new.env()]
#' @export
pend.set <- local({
  pairs <- new.env()
  function(...) {
    x <- list(...)
    for (name in names(x)) {
      pairs[[name]] <- x[[name]]
    }
    as.list(pairs)
  }
})
