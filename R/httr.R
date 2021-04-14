#' @export
PROPERTIES <- function() {
  content_for_response(httr::GET(url = url()))
}

#' @export
#' @examples
#' > c("a", "b", "c") %>% paxor::GET()
#' a b c
#' 1 2 3
#'
GET <- function(...) {
  mapply(function(key)
    content_for_response(httr::GET(url = url(key))),
    unlist(list(...)))
}

#' @export
#' @examples
#' > list(a = 1, b = 2, c = 3) %>% paxor::SET()
#' a    b    c
#' NULL NULL NULL
#'
SET <- function(...) {
  dots <- unlist(list(...))
  mapply(function(name, value) {
    body <- jsonlite::toJSON(value, auto_unbox = TRUE, digits = NA)
    content_for_response(httr::POST(url = url(name),
                                    body = body,
                                    encode = "raw",
                                    httr::content_type_json()))
  }, names(dots), dots)
}
