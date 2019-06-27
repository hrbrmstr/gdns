#' Vectorized query, returning only answers in a data frame
#'
#' @param entities character vector of entities to query
#' @param type RR type can be represented as a number in [1, 65535] or canonical
#'        string (A, aaaa, etc). More information on RR types can be
#'        found \href{http://www.iana.org/assignments/dns-parameters/dns-parameters.xhtml#dns-parameters-4}{here}.
#' @param cd (Checking Disabled) flag. Use `TRUE` to disable DNSSEC validation;
#'        Default: `FALSE`.
#' @param do (DNSSEC OK) flag. Use `TRUE` include DNSSEC records (RRSIG, NSEC, NSEC3);
#'        Default: `FALSE`.
#' @param edns_client_subnet The edns0-client-subnet option. Format is an IP
#'        address with a subnet mask. Examples: \code{1.2.3.4/24},
#'        \code{2001:700:300::/48}.\cr
#'        If you are using DNS-over-HTTPS because of privacy concerns, and do
#'        not want any part of your IP address to be sent to authoritative
#'        nameservers for geographic location accuracy, use
#'        \code{edns_client_subnet=0.0.0.0/0}. Google Public DNS normally sends
#'        approximate network information (usually replacing the last part of
#'        your IPv4 address with zeroes). \code{0.0.0.0/0} is the default.
#' @return \code{data.frame} of only answers (use \code{query()} for detailed responses)
#' @references \url{https://developers.google.com/speed/public-dns/docs/dns-over-https}
#' @export
#' @note this is a fairly naive function. It expects \code{Answer} to be one of the
#'       return value list slots. The intent for it was to make it easier
#'       to do bulk forward queries. It will get smarter in future versions.
#' @examples
#' hosts <- c("rud.is", "r-project.org", "rstudio.com", "apple.com")
#' gdns::bulk_query(hosts)
bulk_query <- function(entities, type = 1, cd = FALSE, do = FALSE,
                       edns_client_subnet = "0.0.0.0/0") {

  lapply(
    entities,
    query, type = type, cd = cd,
    edns_client_subnet = edns_client_subnet
  ) -> results

  lapply(seq_along(results), function(idx) {
    res <- as.data.frame(results[[idx]])
    res$entity <-  entities[[idx]]
    res
  }) -> xlst

  xdf <- do.call(rbind.data.frame, xlst)
  class(xdf) <- c("tbl_df", "tbl", "data.frame")
  xdf

}
