#' Tools to Work with Google DNS Over https API
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
#' to provide end-to-end authenticated DNS lookups.\cr
#' \cr
#' Support for reverse lookups is also provided.
#'
#' @name gdns
#' @docType package
#' @author Bob Rudis (@@hrbrmstr)
#' @import httr
#' @importFrom stringi stri_split_fixed stri_split_regex stri_trim
#'                     stri_replace_all_regex stri_enc_toutf8
#' @importFrom jsonlite fromJSON
#' @importFrom purrr safely map map_df %||%
NULL
