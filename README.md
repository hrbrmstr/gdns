
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
#> [1] "Response from dns.mwebdns.net.(84.246.124.75)"

query("example.com", "255") # "ANY" query
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
#> [1] TRUE
#> 
#> $CD
#> [1] FALSE
#> 
#> $Question
#>           name type
#> 1 example.com.  255
#> 
#> $Answer
#>            name type   TTL
#> 1  example.com.    6  3599
#> 2  example.com.   46 21599
#> 3  example.com.   46 21599
#> 4  example.com.   46  3599
#> 5  example.com.   46    59
#> 6  example.com.   46 21599
#> 7  example.com.   46  3599
#> 8  example.com.   46  3599
#> 9  example.com.   46  3599
#> 10 example.com.   47  3599
#> 11 example.com.    2 21599
#> 12 example.com.    2 21599
#> 13 example.com.   28 21599
#> 14 example.com.    1 21599
#> 15 example.com.   16    59
#> 16 example.com.   16    59
#> 17 example.com.   48  3599
#> 18 example.com.   48  3599
#> 19 example.com.   48  3599
#>                                                                                                                                                                                                                                                                                                                                                                                                                 data
#> 1                                                                                                                                                                                                                                                                                                                                            sns.dns.icann.org. noc.dns.icann.org. 2015082662 7200 3600 1209600 3600
#> 2                                                                                                                                                                               a 8 2 86400 1476095331 1474297785 1704 example.com. OnhJa3/aHkvePBvBME3nlZrkU/rdenyaquFgSYI/wKPq2/ZJVZGhv0TVBMJ5l6GZujqnyBfq9cvvb88//koi17oNjR5JEv2cv4rLT5pud3VhQdVrHD7fU8BV/YnCpP3ikXJMgjf6sAhgL7FZKLtpv7cFXnqznfRCTZ3HKkpBtAB0ZZw=
#> 3                                                                                                                                                                              ns 8 2 86400 1476218628 1474362585 1704 example.com. dxPw4KtqLRMR/P1MB7umTClO/Tgf5X2ukJApKd133OMPhsy7c2N3QIxW4TLxZnCezUewDE1D86HBnGi1kGw4pN4W83lI37L6pTjIkDUtrc1acISOwg9Q9JM74On9/qKTGpTi7aSGVA5t4biLKqPm00a1Yu/VNPOxeLQPyYNjUYspNZ8=
#> 4                                                                                                                                                                              soa 8 2 3600 1476508736 1474722585 1704 example.com. rHojLwiWn5xVU8noy1se7gRjiNI6GJdDcxwO1GU1qUs3Un4y7LyENjrK8qOv2z6EhblBOhPnrgnNMzEPPH3w+5azpU6xAH+jJHO4tExj4Pc3zzQ1sfFx1k8xWPfJjiWnUtUsk19y8vVqHvLXltvVItXlCClzljA0XyNUi1fvYjHbQxI=
#> 5                                                                                                                                                                                txt 8 2 60 1476051975 1474218584 1704 example.com. FBZiE56Ux4VY5AMVtgitLIBWi+UteNSFh4BWwJksVRRt/7OoH7iD6h4UDqP8rNbk9qvXmRo4Ce2vROCbNkdTy/IDEoKo+Urfm69TuI2UTbl/nnQ2UtfMIEC83yywYRWdra5BPkt67SQhHSc4N7QHblABFbm2jPuu2+uOqaRCpfeoWYo=
#> 6                                                                                                                                                                            aaaa 8 2 86400 1475967038 1474146584 1704 example.com. ZQgPaEBxSxHCPhOES76xksqOVYSRtNIieIwTwIo4Oceq0NGzjOyI+8wrgs79QHqs4e5SRe67hVX2rSaJ9Q167+TuQz57ZtyqeOZ+x+cgULyT1Q+8N0ZJlHpZS4i2VfR1xT+quG+0m9wtye8wA3Hl2mWPyTjtsH7mjoS7/U/ZQMJwi44=
#> 7                                                                                                                                                                             nsec 8 2 3600 1475694918 1473887384 1704 example.com. XTCfotH8+cSDgNrFnCNWt4lx64yTnVzwOMZsFgynNSGS5LzY0VfRl7UvTH2WDVzdsIHgKpPBOUwv/DvjNhAMzUgHFlaK/A+U1aFa16/YQkqkIqqfnCA4EgBdhIK4FM3dSIVcpaj3PhGFKvMG4RBvoMAWLRXE3gKf3306CJzX1sfKdsA=
#> 8  dnskey 8 2 3600 1476561735 1474722585 31406 example.com. Oup7snCR/5iUmTuGyHfCfFCisTeqaJ8RHD6aE9wZQR2CCkKZHXO9dzfUL1gA6T35p4T0XeM+TMlv1uZhX157RnanPwyZluancmm5cNz5ub0vG7G/O4DxnSoLmATYoBJ7Ub9Ul4iWFUE7nvyJ23X2MhX6XTiplXYPnztiem6rJLV84JiemoKtvapWchRhFi4w4Y+BdjHfY7IRERjQYNhVuaus5+EeppIoot9srsj2suXePGC7dE0R8z9K/BTYvQi76kBlJzzF9fNNy5JvyZPEUpXATuRD7KfxBsWHaFajOnYOb1eDAL/C0H3hhjVBov2Pexp7YDIsJzIa2g8850LruQ==
#> 9  dnskey 8 2 3600 1476561735 1474722585 45620 example.com. f+aO6V+QKA4XgTC0Vqow59jBP/NlX6f7EEbaoXts0lp7Vaj/DBrhnS/sT4BbJb3VK1MvuPmNre5t0eyOeNCjbjrwIM2uf41GFuBI0AFxQx7o2PIdf1vrXsDnUGsZrMkYMv4gr802S7MXsvMdMN5cM0AA5Zol888sLP1yrHIcfNxG8hoUn3dS0L6nd/OxkL70+NjHBTjBQLqkLsK92ryJ0CWrzcJElszBRqfQfYGV/sJ84Ko4tjnBqRuki/rmTW5KQYdE7NI+MvERtGnep7RHb02Luk7BFPPD3uh353EYSAOVHrMH4fte6mJGcj3vxErfSWakRUXQpovLNcqYZNxoGQ==
#> 10                                                                                                                                                                                                                                                                                                                                                              www.example.com. A NS SOA TXT AAAA RRSIG NSEC DNSKEY
#> 11                                                                                                                                                                                                                                                                                                                                                                                               a.iana-servers.net.
#> 12                                                                                                                                                                                                                                                                                                                                                                                               b.iana-servers.net.
#> 13                                                                                                                                                                                                                                                                                                                                                                                2606:2800:220:1:248:1893:25c8:1946
#> 14                                                                                                                                                                                                                                                                                                                                                                                                     93.184.216.34
#> 15                                                                                                                                                                                                                                                                                                                                                                                                     "v=spf1 -all"
#> 16                                                                                                                                                                                                                                                                                                                                                             "$Id: example.com 4415 2015-08-24 20:12:23Z davids $"
#> 17                                                                                                                                                                                                                      256 3 8 AwEAAa3d68DfyIs03nGYpi3a9YX+f/wln3g6dhWWzjUUqp6CGXuaOdEHfS8zI/5JdGKi8Xoc4YmjPGfiCJIkCiQnMKn/QFygpZs41ANLdPp2jJlJhFA6IHE/xxTCxJfNhsdEAOGlMORN9Zu1XLUBo/IuCDUvUzZPgalivd/m9L+Jr4kxbg3v
#> 18                                              257 3 8 AwEAAZ0aqu1rJ6orJynrRfNpPmayJZoAx9Ic2/Rl9VQWLMHyjxxem3VUSoNUIFXERQbj0A9Ogp0zDM9YIccKLRd6LmWiDCt7UJQxVdD+heb5Ec4qlqGmyX9MDabkvX2NvMwsUecbYBq8oXeTT9LRmCUt9KUt/WOi6DKECxoG/bWTykrXyBR8elD+SQY43OAVjlWrVltHxgp4/rhBCvRbmdflunaPIgu27eE2U4myDSLT8a4A0rB5uHG4PkOa9dIRs9y00M2mWf4lyPee7vi5few2dbayHXmieGcaAHrx76NGAABeY393xjlmDNcUkF1gpNWUla4fWZbbaYQzA93mLdrng+M=
#> 19                                              257 3 8 AwEAAbOFAxl+Lkt0UMglZizKEC1AxUu8zlj65KYatR5wBWMrh18TYzK/ig6Y1t5YTWCO68bynorpNu9fqNFALX7bVl9/gybA0v0EhF+dgXmoUfRX7ksMGgBvtfa2/Y9a3klXNLqkTszIQ4PEMVCjtryl19Be9/PkFeC9ITjgMRQsQhmB39eyMYnal+f3bUxKk4fq7cuEU0dbRpue4H/N6jPucXWOwiMAkTJhghqgy+o9FfIp+tR/emKao94/wpVXDcPf5B18j7xz2SvTTxiuqCzCMtsxnikZHcoh1j4g+Y1B8zIMIvrEM+pZGhh/Yuf4RwCBgaYCi9hpiMWVvS4WBzx0/lU=
#> 
#> $Additional
#> list()
#> 
#> $edns_client_subnet
#> [1] "0.0.0.0/0"
#> 
#> $Comment
#> [1] "Response from 199.43.135.53"

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
#> 1 microsoft.com.   15 1509 10 microsoft-com.mail.protection.outlook.com.
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
#> [1] "Response from 216.239.36.10"

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
#> 1 apple.com.    1 3413 17.172.224.47
#> 2 apple.com.    1 3413  17.178.96.59
#> 3 apple.com.    1 3413 17.142.160.59
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
#> 1  59.160.142.17.in-addr.arpa.   12 3025                 apples-msk.ru.
#> 2  59.160.142.17.in-addr.arpa.   12 3025                     icloud.se.
#> 3  59.160.142.17.in-addr.arpa.   12 3025                     icloud.es.
#> 4  59.160.142.17.in-addr.arpa.   12 3025                     icloud.om.
#> 5  59.160.142.17.in-addr.arpa.   12 3025                   icloudo.com.
#> 6  59.160.142.17.in-addr.arpa.   12 3025                     icloud.ch.
#> 7  59.160.142.17.in-addr.arpa.   12 3025                     icloud.fr.
#> 8  59.160.142.17.in-addr.arpa.   12 3025                   icloude.com.
#> 9  59.160.142.17.in-addr.arpa.   12 3025          camelspaceeffect.com.
#> 10 59.160.142.17.in-addr.arpa.   12 3025                 camelphat.com.
#> 11 59.160.142.17.in-addr.arpa.   12 3025              alchemysynth.com.
#> 12 59.160.142.17.in-addr.arpa.   12 3025                    openni.org.
#> 13 59.160.142.17.in-addr.arpa.   12 3025                      swell.am.
#> 14 59.160.142.17.in-addr.arpa.   12 3025                  appleweb.net.
#> 15 59.160.142.17.in-addr.arpa.   12 3025                     apple.com.
#> 16 59.160.142.17.in-addr.arpa.   12 3025        pv-apple-com.apple.com.
#> 17 59.160.142.17.in-addr.arpa.   12 3025                ripmixburn.com.
#> 18 59.160.142.17.in-addr.arpa.   12 3025                   yessql.info.
#> 19 59.160.142.17.in-addr.arpa.   12 3025               webobjects.info.
#> 20 59.160.142.17.in-addr.arpa.   12 3025                     ubnw.info.
#> 21 59.160.142.17.in-addr.arpa.   12 3025                 skyvines.info.
#> 22 59.160.142.17.in-addr.arpa.   12 3025            shopdifferent.info.
#> 23 59.160.142.17.in-addr.arpa.   12 3025                 sherlock.info.
#> 24 59.160.142.17.in-addr.arpa.   12 3025              quicktimetv.info.
#> 25 59.160.142.17.in-addr.arpa.   12 3025            quicktimelive.info.
#> 26 59.160.142.17.in-addr.arpa.   12 3025                 powermac.info.
#> 27 59.160.142.17.in-addr.arpa.   12 3025                powerbook.info.
#> 28 59.160.142.17.in-addr.arpa.   12 3025                   macosx.info.
#> 29 59.160.142.17.in-addr.arpa.   12 3025               appleshare.info.
#> 30 59.160.142.17.in-addr.arpa.   12 3025              applescript.info.
#> 31 59.160.142.17.in-addr.arpa.   12 3025         applepaysupplies.info.
#> 32 59.160.142.17.in-addr.arpa.   12 3025 applepaymerchantsupplies.info.
#> 33 59.160.142.17.in-addr.arpa.   12 3025                 applepay.info.
#> 34 59.160.142.17.in-addr.arpa.   12 3025             applemasters.info.
#> 35 59.160.142.17.in-addr.arpa.   12 3025                appleexpo.info.
#> 36 59.160.142.17.in-addr.arpa.   12 3025         applecomputerinc.info.
#> 37 59.160.142.17.in-addr.arpa.   12 3025              applecentre.info.
#> 38 59.160.142.17.in-addr.arpa.   12 3025                 airtunes.info.
#> 39 59.160.142.17.in-addr.arpa.   12 3025                      apple.by.
#> 
#> $Additional
#> list()
#> 
#> $edns_client_subnet
#> [1] "0.0.0.0/0"

hosts <- c("rud.is", "dds.ec", "r-project.org", "rstudio.com", "apple.com")
gdns::bulk_query(hosts)
#>             name type  TTL            data
#> 1        rud.is.    1 3598 104.236.112.222
#> 2        dds.ec.    1  299   162.243.111.4
#> 3 r-project.org.    1 3072   137.208.57.37
#> 4   rstudio.com.    1 3599    45.79.156.36
#> 5     apple.com.    1 3415   17.172.224.47
#> 6     apple.com.    1 3415    17.178.96.59
#> 7     apple.com.    1 3415   17.142.160.59
```

### Test Results

``` r
library(gdns)
library(testthat)

date()
#> [1] "Thu Sep 29 09:44:11 2016"

test_dir("tests/")
#> testthat results ========================================================================================================
#> OK: 2 SKIPPED: 0 FAILED: 0
#> 
#> DONE ===================================================================================================================
```

### Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
