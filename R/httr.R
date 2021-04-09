#' @export
PROPERTIES <- function() {
  response <- httr::GET(url = url())
  httr::stop_for_status(response)
  httr::content(response)
}

#' @export
GET <- function(key) {
  response <- httr::GET(url = url(key))
  httr::stop_for_status(response)
  httr::content(response)
}

#' @export
SET <- function(...) {
  keyed.data <- list(...)
  stopifnot(isNamed(keyed.data), length(keyed.data) == 1)
  body <- jsonlite::toJSON(keyed.data[[1]], auto_unbox = TRUE, digits = NA)
  response <- httr::POST(url = url(names(keyed.data)),
                         body = body,
                         encode = "raw",
                         httr::content_type_json())
  httr::stop_for_status(response)
  httr::content(response)
}
