
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![Travis-CI Build
Status](https://travis-ci.org/hrbrmstr/gdns.svg?branch=master)](https://travis-ci.org/hrbrmstr/gdns)

`gdns` : Tools to work with the Google DNS over HTTPS API

Traditional DNS queries and responses are sent over UDP or TCP without
encryption. This is vulnerable to eavesdropping and spoofing (including
DNS-based Internet filtering). Responses from recursive resolvers to
clients are the most vulnerable to undesired or malicious changes, while
communications between recursive resolvers and authoritative nameservers
often incorporate additional protection.

To address this problem, Google Public DNS offers DNS resolution over an
encrypted HTTPS connection. DNS-over-HTTPS greatly enhances privacy and
security between a client and a recursive resolver, and complements
DNSSEC to provide end-to-end authenticated DNS lookups.

More info at
<https://developers.google.com/speed/public-dns/docs/dns-over-https>.

The following functions are implemented:

  - `bulk_query`: Vectorized query, returning only answers in a data
    frame
  - `has_spf`: Test for whether a DNS TXT record is an SPF record
  - `is_hard_fail`: SPF “all” type test
  - `is_soft_fail`: SPF “all” type test
  - `passes_all`: SPF “all” type test
  - `query`: Perform DNS over HTTPS queries using Google
  - `spf_exists`: SPF field extraction functions
  - `spf_includes`: SPF field extraction functions
  - `spf_ipv4s`: SPF field extraction functions
  - `spf_ipv6s`: SPF field extraction functions
  - `spf_ptrs`: SPF field extraction functions
  - `split_spf`: Split out all SPF records in a domain’s TXT record

### Installation

``` r
devtools::install_github("hrbrmstr/gdns")
```

### Usage

``` r
library(gdns)

# current verison
packageVersion("gdns")
#> [1] '0.3.1'

str(query("rud.is"))
#> List of 10
#>  $ Status            : int 0
#>  $ TC                : logi FALSE
#>  $ RD                : logi TRUE
#>  $ RA                : logi TRUE
#>  $ AD                : logi FALSE
#>  $ CD                : logi FALSE
#>  $ Question          :'data.frame':  1 obs. of  2 variables:
#>   ..$ name: chr "rud.is."
#>   ..$ type: int 1
#>  $ Answer            :'data.frame':  1 obs. of  4 variables:
#>   ..$ name: chr "rud.is."
#>   ..$ type: int 1
#>   ..$ TTL : int 3536
#>   ..$ data: chr "104.236.112.222"
#>  $ Additional        : list()
#>  $ edns_client_subnet: chr "0.0.0.0/0"

str(query("example.com", "255")) # "ANY" query
#> List of 10
#>  $ Status            : int 0
#>  $ TC                : logi FALSE
#>  $ RD                : logi TRUE
#>  $ RA                : logi TRUE
#>  $ AD                : logi TRUE
#>  $ CD                : logi FALSE
#>  $ Question          :'data.frame':  1 obs. of  2 variables:
#>   ..$ name: chr "example.com."
#>   ..$ type: int 255
#>  $ Answer            :'data.frame':  20 obs. of  4 variables:
#>   ..$ name: chr [1:20] "example.com." "example.com." "example.com." "example.com." ...
#>   ..$ type: int [1:20] 6 46 47 46 2 2 46 28 46 1 ...
#>   ..$ TTL : int [1:20] 3566 3566 3566 21566 21566 21566 21566 21566 21566 21566 ...
#>   ..$ data: chr [1:20] "sns.dns.icann.org. noc.dns.icann.org. 2018080123 7200 3600 1209600 3600" "nsec 8 2 3600 1538855995 1537006806 63855 example.com. pFyGCdsJ2uw2FcRlszW1VuM6FRV1rHbBfeBmp/Jaecdth8njienGYt2k"| __truncated__ "www.example.com. A NS SOA TXT AAAA RRSIG NSEC DNSKEY" "ns 8 2 86400 1538826642 1537014006 63855 example.com. U7KJg6I3XylL5aT10B3tHw9MIV8QoHBlmzO3CwghRh4I00ZzF2IgjakMp"| __truncated__ ...
#>  $ Additional        : list()
#>  $ edns_client_subnet: chr "0.0.0.0/0"

str(query("microsoft.com", "MX"))
#> List of 10
#>  $ Status            : int 0
#>  $ TC                : logi FALSE
#>  $ RD                : logi TRUE
#>  $ RA                : logi TRUE
#>  $ AD                : logi FALSE
#>  $ CD                : logi FALSE
#>  $ Question          :'data.frame':  1 obs. of  2 variables:
#>   ..$ name: chr "microsoft.com."
#>   ..$ type: int 15
#>  $ Answer            :'data.frame':  1 obs. of  4 variables:
#>   ..$ name: chr "microsoft.com."
#>   ..$ type: int 15
#>   ..$ TTL : int 3507
#>   ..$ data: chr "10 microsoft-com.mail.protection.outlook.com."
#>  $ Additional        : list()
#>  $ edns_client_subnet: chr "0.0.0.0/0"

str(query("google-public-dns-a.google.com", "TXT"))
#> List of 10
#>  $ Status            : int 0
#>  $ TC                : logi FALSE
#>  $ RD                : logi TRUE
#>  $ RA                : logi TRUE
#>  $ AD                : logi FALSE
#>  $ CD                : logi FALSE
#>  $ Question          :'data.frame':  1 obs. of  2 variables:
#>   ..$ name: chr "google-public-dns-a.google.com."
#>   ..$ type: int 16
#>  $ Answer            :'data.frame':  1 obs. of  4 variables:
#>   ..$ name: chr "google-public-dns-a.google.com."
#>   ..$ type: int 16
#>   ..$ TTL : int 21537
#>   ..$ data: chr "\"http://xkcd.com/1361/\""
#>  $ Additional        : list()
#>  $ edns_client_subnet: chr "0.0.0.0/0"

str(query("apple.com"))
#> List of 10
#>  $ Status            : int 0
#>  $ TC                : logi FALSE
#>  $ RD                : logi TRUE
#>  $ RA                : logi TRUE
#>  $ AD                : logi FALSE
#>  $ CD                : logi FALSE
#>  $ Question          :'data.frame':  1 obs. of  2 variables:
#>   ..$ name: chr "apple.com."
#>   ..$ type: int 1
#>  $ Answer            :'data.frame':  3 obs. of  4 variables:
#>   ..$ name: chr [1:3] "apple.com." "apple.com." "apple.com."
#>   ..$ type: int [1:3] 1 1 1
#>   ..$ TTL : int [1:3] 3557 3557 3557
#>   ..$ data: chr [1:3] "17.172.224.47" "17.178.96.59" "17.142.160.59"
#>  $ Additional        : list()
#>  $ edns_client_subnet: chr "0.0.0.0/0"

str(query("17.142.160.59", "PTR"))
#> List of 10
#>  $ Status            : int 0
#>  $ TC                : logi FALSE
#>  $ RD                : logi TRUE
#>  $ RA                : logi TRUE
#>  $ AD                : logi FALSE
#>  $ CD                : logi FALSE
#>  $ Question          :'data.frame':  1 obs. of  2 variables:
#>   ..$ name: chr "59.160.142.17.in-addr.arpa."
#>   ..$ type: int 12
#>  $ Answer            :'data.frame':  5 obs. of  4 variables:
#>   ..$ name: chr [1:5] "59.160.142.17.in-addr.arpa." "59.160.142.17.in-addr.arpa." "59.160.142.17.in-addr.arpa." "59.160.142.17.in-addr.arpa." ...
#>   ..$ type: int [1:5] 12 12 12 12 12
#>   ..$ TTL : int [1:5] 2733 2733 2733 2733 2733
#>   ..$ data: chr [1:5] "apple.by." "apple.com." "pv-apple-com.apple.com." "ipad.host." ...
#>  $ Additional        : list()
#>  $ edns_client_subnet: chr "0.0.0.0/0"

hosts <- c("rud.is", "dds.ec", "r-project.org", "rstudio.com", "apple.com")

gdns::bulk_query(hosts)
#>             name type  TTL            data        entity
#> 1        rud.is.    1  806 104.236.112.222        rud.is
#> 2        dds.ec.    1  507    185.53.178.9        dds.ec
#> 3 r-project.org.    1 7199   137.208.57.37 r-project.org
#> 4   rstudio.com.    1 3536   104.196.200.5   rstudio.com
#> 5     apple.com.    1 3082   17.172.224.47     apple.com
#> 6     apple.com.    1 3082    17.178.96.59     apple.com
#> 7     apple.com.    1 3082   17.142.160.59     apple.com
```

### Test Results

``` r
library(gdns)
library(testthat)

date()
#> [1] "Sat Sep 15 14:29:20 2018"

test_dir("tests/")
#> ✔ | OK F W S | Context
#> ══ testthat results  ═════════════════════════════════════════════════════════════════════════════════════════
#> OK: 2 SKIPPED: 0 FAILED: 0
#> 
#> ══ Results ═══════════════════════════════════════════════════════════════════════════════════════════════════
#> Duration: 0.4 s
#> 
#> OK:       0
#> Failed:   0
#> Warnings: 0
#> Skipped:  0
```

### Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](CONDUCT.md). By participating in this project you agree to
abide by its terms.
