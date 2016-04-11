#' Split out all SPF records in a domain's TXT record
#'
#' Given a vector of TXT records, this function will return a list of vectors
#' of all the SPF records for each. If the given TXT record is not an SPF
#' record, \code{NULL} is returned (which makes it easy to skip with \code{purrr}
#' functions).
#'
#' @param spf_rec a character vector of DNS TXT records
#' @export
split_spf <- function(spf_rec) {
  purrr::map(spf_rec, .split_spf)
}

.split_spf <- function(spf_rec) {

  if (has_spf(spf_rec)) {
    spf_rec <- stringi::stri_trim(stringi::stri_replace_all_regex(spf_rec, '"', ""))
    recs <- stri_trim(unlist(stringi::stri_split_regex(spf_rec, "\ +")))
    grep("v=spf1", recs, invert=TRUE, value=TRUE)
  } else {
    NA_character_
  }

}

#' Test for whether a DNS TXT record is an SPF record
#'
#' @param spf_rec a character vector of DNS TXT records
#' @export
has_spf <- function(spf_rec) {
  grepl("v=spf1", spf_rec)
}

#' SPF "all" type test
#'
#' @param spf_rec a character vector of DNS TXT records
#' @export
is_soft_fail <- function(spf_rec) {
  ret <- vector("logical", length(spf_rec))
  spf_rec <- stringi::stri_trim(stringi::stri_replace_all_regex(spf_rec, '"', ""))
  SPF <- which(has_spf(spf_rec))
  ret[SPF] <- grepl("~all$", stringi::stri_trim(spf_rec[SPF]))
  ret[!SPF] <- NA
  ret
}

#' @rdname is_soft_fail
#' @export
is_hard_fail <- function(spf_rec) {
  ret <- vector("logical", length(spf_rec))
  spf_rec <- stringi::stri_trim(stringi::stri_replace_all_regex(spf_rec, '"', ""))
  SPF <- which(has_spf(spf_rec))
  ret[SPF] <- grepl("\\-all$", stringi::stri_trim(spf_rec[SPF]))
  ret[!SPF] <- NA
  ret
}

#' @rdname is_soft_fail
#' @export
passes_all <- function(spf_rec) {
  ret <- vector("logical", length(spf_rec))
  spf_rec <- stringi::stri_trim(stringi::stri_replace_all_regex(spf_rec, '"', ""))
  SPF <- which(has_spf(spf_rec))
  ret[SPF] <- grepl("[\\+ ]all$", stringi::stri_trim(spf_rec[SPF]))
  ret[!SPF] <- NA
  ret
}

#' SPF field extraction functions
#'
#' Various helper functions to extract SPF record components.
#'
#' @param spf_rec a character vector of DNS TXT records
#' @export
spf_ipv4s <- function(spf_rec) {
  purrr::map(split_spf(spf_rec), function(x) {
    stringi::stri_replace_all_regex(grep("ip4", x, value=TRUE), "^ip4:", "")
  })
}

#' @rdname spf_ipv4s
#' @export
spf_ipv6s <- function(spf_rec) {
  purrr::map(split_spf(spf_rec), function(x) {
    stringi::stri_replace_all_regex(grep("ip6", x, value=TRUE), "^ip6:", "")
  })
}

#' @rdname spf_ipv4s
#' @export
spf_includes <- function(spf_rec) {
  purrr::map(split_spf(spf_rec), function(x) {
    stringi::stri_replace_all_regex(grep("include", x, value=TRUE), "^include:", "")
  })
}

#' @rdname spf_ipv4s
#' @export
spf_ptrs <- function(spf_rec) {
  purrr::map(split_spf(spf_rec), function(x) {
    stringi::stri_replace_all_regex(grep("ptr", x, value=TRUE), "^ptr[:]", "")
  })
}

#' @rdname spf_ipv4s
#' @export
spf_exists <- function(spf_rec) {
  purrr::map(split_spf(spf_rec), function(x) {
    stringi::stri_replace_all_regex(grep("exists", x, value=TRUE), "^exists:", "")
  })
}
