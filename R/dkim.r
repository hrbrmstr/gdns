#' #' Split out all SPF records in a domain's TXT record
#' #'
#' #' Given a vector of TXT records, this function will return a list of vectors
#' #' of all the SPF records for each. If the given TXT record is not an SPF
#' #' record, \code{NA} is returned (which makes it easy to skip with \code{purrr}
#' #' functions).
#' #'
#' #' @param dkim_rec a character vector of DNS TXT records
#' #' @export
#' parse_dkim <- function(dkim_rec) {
#'   purrr::map_df(dkim_rec, .parse_dkim)
#' }
#'
#' .parse_dkim <- function(dkim_rec) {
#'
#'   if (has_dkim(dkim_rec)) {
#'     spf_rec <- stringi::stri_trim(stringi::stri_replace_all_regex(dkim_rec, '"', ""))
#'     recs <- stri_trim(unlist(stringi::stri_split_regex(dkim_rec, ";")))
#'     recs <- grep("v=DKIM1", recs, invert=TRUE, value=TRUE)
#'     purrr::keep(recs, stringi::stri_detect_fixed, "=") %>%
#'       purrr::map_df(~{
#'         x <- stringi::stri_match_all_regex(.x, "(.*)=(.*)")[[1]]
#'         data_frame(key=x[,2], value=x[,3])
#'       })
#'   } else {
#'     NULL
#'   }
#'
#' }
#'
#' #' Test for whether a DNS TXT record is a DKIM record
#' #'
#' #' @param spf_rec a character vector of DNS TXT records
#' #' @export
#' has_dkim <- function(dkim_rec) {
#'   grepl("v=DKIM1", dkim_rec)
#' }
