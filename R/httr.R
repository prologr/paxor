#' @export
GET <- function(key) {
  response <- httr::GET(url = url(key))
  httr::stop_for_status(response)
  httr::content(response)
}

#' @export
SET <- function(key, data) {
  body <- jsonlite::toJSON(data, auto_unbox = TRUE, digits = NA)
  response <- httr::POST(url = url(key), body = body, encode = "raw", content_type_json())
  httr::stop_for_status(response)
  httr::content(response)
}

url <- function(key) paste0("http://localhost:8080/paxor/", key)
