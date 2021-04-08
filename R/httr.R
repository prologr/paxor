#' @export
GET <- function(key) {
  response <- httr::GET(url = url(key))
  httr::stop_for_status(response)
  httr::content(response)$data
}

#' @export
SET <- function(key, data) {
  response <- httr::POST(url = url(key), body = list(data = data), encode = "json")
  httr::stop_for_status(response)
  httr::content(response)
}

url <- function(key) paste0("http://localhost:8080/paxor/", key)
