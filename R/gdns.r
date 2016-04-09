S_GET <- purrr::safely(GET)

#' Perform DNS over HTTPS queries using Google
#'
#' Traditional DNS queries and responses are sent over UDP or TCP without
#' encryption. This is vulnerable to eavesdropping and spoofing (including
#' DNS-based Internet filtering). Responses from recursive resolvers to clients
#' are the most vulnerable to undesired or malicious changes, while
#' communications between recursive resolvers and authoritative nameservers
#' often incorporate additional protection.\cr
#' \cr
#' To address this problem, Google Public DNS offers DNS resolution over an
#' encrypted HTTPS connection. DNS-over-HTTPS greatly enhances privacy and
#' security between a client and a recursive resolver, and complements DNSSEC
#' to provide end-to-end authenticated DNS lookups.
#'
#' @param name item to lookup. Valid characters are numbers, letters, hyphen, and dot. Length
#'        must be between 1 and 255. Names with escaped or non-ASCII characters
#'        are not supported. Internationalized domain names must use the
#'        punycode format (e.g. "\code{xn--qxam}" rather than "\code{ελ}")
#' @param type RR type can be represented as a number in [1, 65535] or canonical
#'        string (A, aaaa, etc.)
#' @param edns_client_subnet The edns0-client-subnet option. Format is an IP
#'        address with a subnet mask. Examples: \code{1.2.3.4/24},
#'        \code{2001:700:300::/48}.\cr
#'        If you are using DNS-over-HTTPS because of privacy concerns, and do
#'        not want any part of your IP address to be sent to authoritative
#'        nameservers for geographic location accuracy, use
#'        \code{edns_client_subnet=0.0.0.0/0}. Google Public DNS normally sends
#'        approximate network information (usually replacing the last part of
#'        your IPv4 address with zeroes).
#' @return a \code{list} with the query result or \code{NULL} if an error occurred
#' @export
#' @examples
#' query("rud.is")
query <- function(name, type="1", cd=FALSE, edns_client_subnet=NULL) {

  res <- S_GET("https://dns.google.com/resolve",
               query=list(name=name,
                          type=type,
                          edns_client_subnet=edns_client_subnet))

  if (!is.null(res$result)) {
    stop_for_status(res$result)
    jsonlite::fromJSON(httr::content(res$result, as="text"))
  } else {
    NULL
  }

}
