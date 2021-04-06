#' @export
pend.get <- local({
  keys <- NULL
  function(...) {
    keys <<- union(keys, c(...))
    return(keys)
  }
})

#' @seealso [new.env()]
#' @export
pend.set <- local({
  pairs <- new.env()
  function(...) {
    x <- list(...)
    for (name in names(x)) {
      pairs[[name]] <- x[[name]]
    }
    return(as.list(pairs))
  }
})
