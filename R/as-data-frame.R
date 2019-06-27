#' Coerce a gdns query response answer to a data frame
#'
#' Helper function to get to the `Answer` quickly
#' @param x a `gdns_response` object
#' @param ... unused
#' @export
as.data.frame.gdns_response <- function(x, ...) {

  if (length(x[["Answer"]]) == 0) {
    data.frame(
      name = NA_character_,
      type = NA_character_,
      ttl = NA_character_,
      data = NA_character_,
      stringsAsFactors = FALSE
    ) -> out
  } else {
    out <- x[["Answer"]]
  }

  if (length(x[["Question"]][["name"]])) {
    out[["query"]] <- x[["Question"]][["name"]][[1]]
    out[["qtype"]] <- x[["Question"]][["type"]][[1]]
  } else {
    out[["query"]] <- NA_character_
    out[["qtype"]] <- NA_character_
  }

  colnames(out) <- tolower(colnames(out))
  out <- out[,c("query", "qtype", "name", "type", "ttl", "data")]

  class(out) <- c("tbl_df", "tbl", "data.frame")
  out

}
