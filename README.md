
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build Status](https://travis-ci.org/hrbrmstr/gdns.svg?branch=master)](https://travis-ci.org/hrbrmstr/gdns)

`gdns` : Tools to work with the Google DNS over HTTPS API

Traditional DNS queries and responses are sent over UDP or TCP without encryption. This is vulnerable to eavesdropping and spoofing (including DNS-based Internet filtering). Responses from recursive resolvers to clients are the most vulnerable to undesired or malicious changes, while communications between recursive resolvers and authoritative nameservers often incorporate additional protection.

To address this problem, Google Public DNS offers DNS resolution over an encrypted HTTPS connection. DNS-over-HTTPS greatly enhances privacy and security between a client and a recursive resolver, and complements DNSSEC to provide end-to-end authenticated DNS lookups.

More info at <https://developers.google.com/speed/public-dns/docs/dns-over-https>.

The following functions are implemented:

-   `bulk_query`: Vectorized query, returning only answers in a data frame
-   `has_spf`: Test for whether a DNS TXT record is an SPF record
-   `is_hard_fail`: SPF "all" type test
-   `is_soft_fail`: SPF "all" type test
-   `passes_all`: SPF "all" type test
-   `query`: Perform DNS over HTTPS queries using Google
-   `spf_exists`: SPF field extraction functions
-   `spf_includes`: SPF field extraction functions
-   `spf_ipv4s`: SPF field extraction functions
-   `spf_ipv6s`: SPF field extraction functions
-   `spf_ptrs`: SPF field extraction functions
-   `split_spf`: Split out all SPF records in a domain's TXT record

### News

-   Version 0.2.0.9000 SPF stuff
-   Version 0.1.0.9000 released

### Installation

``` r
devtools::install_github("hrbrmstr/gdns")
```

### Usage

``` r
library(gdns)

# current verison
packageVersion("gdns")
#> [1] '0.2.0.9000'
```

### Test Results

``` r
library(gdns)
library(testthat)

date()
#> [1] "Sun Apr 10 14:51:46 2016"

test_dir("tests/")
#> testthat results ========================================================================================================
#> OK: 2 SKIPPED: 0 FAILED: 0

query("rud.is")
#> $Status
#> [1] 0
#> 
#> $TC
#> [1] FALSE
#> 
#> $RD
#> [1] TRUE
#> 
#> $RA
#> [1] TRUE
#> 
#> $AD
#> [1] FALSE
#> 
#> $CD
#> [1] FALSE
#> 
#> $Question
#>      name type
#> 1 rud.is.    1
#> 
#> $Answer
#>      name type  TTL            data
#> 1 rud.is.    1 3599 104.236.112.222
#> 
#> $Additional
#> list()
#> 
#> $edns_client_subnet
#> [1] "0.0.0.0/0"
#> 
#> $Comment
#> [1] "Response from dns.mwebdns.net.(84.246.121.10)"

query("microsoft.com", "MX")
#> $Status
#> [1] 0
#> 
#> $TC
#> [1] FALSE
#> 
#> $RD
#> [1] TRUE
#> 
#> $RA
#> [1] TRUE
#> 
#> $AD
#> [1] FALSE
#> 
#> $CD
#> [1] FALSE
#> 
#> $Question
#>             name type
#> 1 microsoft.com.   15
#> 
#> $Answer
#>             name type  TTL                                          data
#> 1 microsoft.com.   15 2054 10 microsoft-com.mail.protection.outlook.com.
#> 
#> $Additional
#> list()
#> 
#> $edns_client_subnet
#> [1] "0.0.0.0/0"

query("google-public-dns-a.google.com", "TXT")
#> $Status
#> [1] 0
#> 
#> $TC
#> [1] FALSE
#> 
#> $RD
#> [1] TRUE
#> 
#> $RA
#> [1] TRUE
#> 
#> $AD
#> [1] FALSE
#> 
#> $CD
#> [1] FALSE
#> 
#> $Question
#>                              name type
#> 1 google-public-dns-a.google.com.   16
#> 
#> $Answer
#>                              name type   TTL                    data
#> 1 google-public-dns-a.google.com.   16 21599 "http://xkcd.com/1361/"
#> 
#> $Additional
#> list()
#> 
#> $edns_client_subnet
#> [1] "0.0.0.0/0"
#> 
#> $Comment
#> [1] "Response from 216.239.38.10"

query("apple.com")
#> $Status
#> [1] 0
#> 
#> $TC
#> [1] FALSE
#> 
#> $RD
#> [1] TRUE
#> 
#> $RA
#> [1] TRUE
#> 
#> $AD
#> [1] FALSE
#> 
#> $CD
#> [1] FALSE
#> 
#> $Question
#>         name type
#> 1 apple.com.    1
#> 
#> $Answer
#>         name type  TTL          data
#> 1 apple.com.    1 1119 17.172.224.47
#> 2 apple.com.    1 1119  17.178.96.59
#> 3 apple.com.    1 1119 17.142.160.59
#> 
#> $Additional
#> list()
#> 
#> $edns_client_subnet
#> [1] "0.0.0.0/0"

query("17.142.160.59", "PTR")
#> $Status
#> [1] 0
#> 
#> $TC
#> [1] FALSE
#> 
#> $RD
#> [1] TRUE
#> 
#> $RA
#> [1] TRUE
#> 
#> $AD
#> [1] FALSE
#> 
#> $CD
#> [1] FALSE
#> 
#> $Question
#>                          name type
#> 1 59.160.142.17.in-addr.arpa.   12
#> 
#> $Answer
#>                           name type  TTL                           data
#> 1  59.160.142.17.in-addr.arpa.   12 1134              alchemysynth.com.
#> 2  59.160.142.17.in-addr.arpa.   12 1134                    openni.org.
#> 3  59.160.142.17.in-addr.arpa.   12 1134                      swell.am.
#> 4  59.160.142.17.in-addr.arpa.   12 1134                  appleweb.net.
#> 5  59.160.142.17.in-addr.arpa.   12 1134                     apple.com.
#> 6  59.160.142.17.in-addr.arpa.   12 1134        pv-apple-com.apple.com.
#> 7  59.160.142.17.in-addr.arpa.   12 1134                      apple.by.
#> 8  59.160.142.17.in-addr.arpa.   12 1134                 airtunes.info.
#> 9  59.160.142.17.in-addr.arpa.   12 1134              applecentre.info.
#> 10 59.160.142.17.in-addr.arpa.   12 1134         applecomputerinc.info.
#> 11 59.160.142.17.in-addr.arpa.   12 1134                appleexpo.info.
#> 12 59.160.142.17.in-addr.arpa.   12 1134             applemasters.info.
#> 13 59.160.142.17.in-addr.arpa.   12 1134                 applepay.info.
#> 14 59.160.142.17.in-addr.arpa.   12 1134 applepaymerchantsupplies.info.
#> 15 59.160.142.17.in-addr.arpa.   12 1134         applepaysupplies.info.
#> 16 59.160.142.17.in-addr.arpa.   12 1134              applescript.info.
#> 17 59.160.142.17.in-addr.arpa.   12 1134               appleshare.info.
#> 18 59.160.142.17.in-addr.arpa.   12 1134                   macosx.info.
#> 19 59.160.142.17.in-addr.arpa.   12 1134                powerbook.info.
#> 20 59.160.142.17.in-addr.arpa.   12 1134                 powermac.info.
#> 21 59.160.142.17.in-addr.arpa.   12 1134            quicktimelive.info.
#> 22 59.160.142.17.in-addr.arpa.   12 1134              quicktimetv.info.
#> 23 59.160.142.17.in-addr.arpa.   12 1134                 sherlock.info.
#> 24 59.160.142.17.in-addr.arpa.   12 1134            shopdifferent.info.
#> 25 59.160.142.17.in-addr.arpa.   12 1134                 skyvines.info.
#> 26 59.160.142.17.in-addr.arpa.   12 1134                     ubnw.info.
#> 27 59.160.142.17.in-addr.arpa.   12 1134               webobjects.info.
#> 28 59.160.142.17.in-addr.arpa.   12 1134                   yessql.info.
#> 29 59.160.142.17.in-addr.arpa.   12 1134                ripmixburn.com.
#> 30 59.160.142.17.in-addr.arpa.   12 1134                 apples-msk.ru.
#> 31 59.160.142.17.in-addr.arpa.   12 1134                     icloud.se.
#> 32 59.160.142.17.in-addr.arpa.   12 1134                     icloud.es.
#> 33 59.160.142.17.in-addr.arpa.   12 1134                     icloud.om.
#> 34 59.160.142.17.in-addr.arpa.   12 1134                   icloudo.com.
#> 35 59.160.142.17.in-addr.arpa.   12 1134                     icloud.ch.
#> 36 59.160.142.17.in-addr.arpa.   12 1134                     icloud.fr.
#> 37 59.160.142.17.in-addr.arpa.   12 1134                   icloude.com.
#> 38 59.160.142.17.in-addr.arpa.   12 1134          camelspaceeffect.com.
#> 39 59.160.142.17.in-addr.arpa.   12 1134                 camelphat.com.
#> 
#> $Additional
#> list()
#> 
#> $edns_client_subnet
#> [1] "0.0.0.0/0"

hosts <- c("rud.is", "dds.ec", "r-project.org", "rstudio.com", "apple.com")
gdns::bulk_query(hosts)
#> Source: local data frame [7 x 4]
#> 
#>             name  type   TTL            data
#>            (chr) (int) (int)           (chr)
#> 1        rud.is.     1  3598 104.236.112.222
#> 2        dds.ec.     1   299   162.243.111.4
#> 3 r-project.org.     1  7177   137.208.57.37
#> 4   rstudio.com.     1  3599    45.79.156.36
#> 5     apple.com.     1  1102   17.172.224.47
#> 6     apple.com.     1  1102    17.178.96.59
#> 7     apple.com.     1  1102   17.142.160.59
```

### Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
