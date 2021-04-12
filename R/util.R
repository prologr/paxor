`%||%` <- function(lhs, rhs) if (is.null(lhs)) rhs else lhs

isNamed <- function(x) all(hasNames(x))

hasNames <- function(x) {
  y <- names(x)
  if (is.null(y)) rep(FALSE, length(x))
  else !(is.na(y) | y == "")
}

url <- function(...) {
  PAXOR_URL <- utils::URLencode(Sys.getenv("PAXOR_URL"))
  url <- PAXOR_URL %||% "http://localhost:8080/paxor"
  paste(url, ..., sep = "/")
}
