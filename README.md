
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
#> [1] '0.2.1'

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
#>      name type TTL            data
#> 1 rud.is.    1 277 104.236.112.222
#> 
#> $Additional
#> list()
#> 
#> $edns_client_subnet
#> [1] "0.0.0.0/0"

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
#> 1  example.com.   46 21548
#> 2  example.com.   46 21548
#> 3  example.com.   46  3548
#> 4  example.com.   46     8
#> 5  example.com.   46 21548
#> 6  example.com.   46  3548
#> 7  example.com.   46  3548
#> 8  example.com.   46  3548
#> 9  example.com.   47  3548
#> 10 example.com.    2 21548
#> 11 example.com.    2 21548
#> 12 example.com.   28 21548
#> 13 example.com.    1 21548
#> 14 example.com.   16     8
#> 15 example.com.   16     8
#> 16 example.com.   48  3548
#> 17 example.com.   48  3548
#> 18 example.com.   48  3548
#> 19 example.com.   48  3548
#> 20 example.com.    6  3548
#>                                                                                                                                                                                                                                                                                                                                                                                                                 data
#> 1                                                                                                                                                                                   a 8 2 86400 1530064725 1528271786 4354 example.com. gpgx3XIhF4XZg5Nw0eo7TmCD1zfKX9YtMq9PuSh3eAc4fJrvyS/VWy2bz/KYhgiXQe6PvtOLZbgTT2O9knkHIlAsmnznEowSrgWYaCkkkNnoC8Ii1Ikg87PCZ7FffTposk/4HRG6yXZlo9+++YZAfAC0cc9FFYpQXqxVLf9/aDQ=
#> 2                                                                                                                                                                                  ns 8 2 86400 1530070167 1528286186 4354 example.com. tVZnWX3VxO+XqrDS76S6RpLYvGluZIQkai0aWx3pzjjhqi+qKO7WtjcIYmOgehBB2t3TVC9cv1rhb21SDBZPNtgtpWAR/W3hPK1FA4AhDW3tDwk0vZ8VnxRS6YZRdubY5xx8f+88auYUZNauK3SsAcKj4k9IaeMLinzpie0ydKk=
#> 3                                                                                                                                                                                  soa 8 2 3600 1530144931 1528300586 4354 example.com. oDz3EMYugQZ5zJV2Wwr76heKzbOB8cDgol+HD0DTPPNkBHkU33thZI3kwtD/KE7YFbwlD86is5Qgy4sVOToEcxs6Th2+bxkwkSDbnNCfpqXg9FP2nknfsYdN8UHIOcsbjo8pAEQrwbOBnRhkfgh+B2jXCeR8wcYIDtlfyjIG5dw=
#> 4                                                                                                                                                                                    txt 8 2 60 1530100194 1528250186 4354 example.com. PRVGxCX8Sghw9xQv+ITTpIHbpku543BNEVSA0LZVIZ2p5r3kPb4vlID/jSzFTOhgLhdkB0OAMG3dvWxNXT3fOBiv8c/UZHdwjJdneLeoHILiAa4Y3HSC+t4kcs+9qRFzj4EQgXwr0zWLDoZTa9bkhoVdaC8q+oL+TyjiwgG6RXs=
#> 5                                                                                                                                                                                aaaa 8 2 86400 1528834805 1526975786 4354 example.com. lRAUeTu/Wr7mobPHuh29z66cqqnCQXvUcSWYNsrdJvWIUaaGNUtz800bQQuZah3tZbJeSbDV+LivN8pFYrTPR9AVyTi1uD7x8qH+3MckgKezJ199e1twfbpl0O44zSFlrI7SxEaWhTnUGM2xafyH0HZUr1Eg/5nxDFlmaVfxet8=
#> 6                                                                                                                                                                                 nsec 8 2 3600 1530145868 1528300586 4354 example.com. NV0BbCZT7yXFnrJhEV1atS0QBbkDmojtUw9PIxDOUJzEZtWql5qJ5iMJl2z8ghmRwurnRAskBOZaT1jstyf/X8wBS8T05uc6KgfiFdoeseIWfTd9+9y6E9ESHmsSLDyHlbex6k3XAb5c4GWSyZ058JpSUyQbpnTC0fxEONxiFT4=
#> 7  dnskey 8 2 3600 1530072436 1528278986 31406 example.com. exstuS89vtBrpvN+6XK49NWMrQmUoHJAAMzLMCi5w3xUczvo9hQWi3yfDVk7Rdtv61IFEFRTIVVCoM0kpWmgp1NwOPKNSUxg3OVO5++PGoCE7hI8fhW/xdiOUC1dHHk/zuWRoriERykgNvo6yzegBmXbOyf7WCh1csoGuk+RmIWykngZw9wCX+qjdO1G8y8DMmwzEzDc3fBN9v2at3lo+VK/uhR4Tu6rr4rxkYqqgz02TIkHr14GsCa4hlf8/s2UhaWKil5ja51HgFsR2fLHRwZ1x1toejaxMekJvVcarhNYodU83q8qZ0Yoa8GIKpdS70chj4ZrLiUkBhV2KEtytg==
#> 8  dnskey 8 2 3600 1530072436 1528278986 45620 example.com. Kd2iq2xmcg5GJmNOQiHjZKDKHH+MyDagSjXuTJKiJFXSpgMzZUl9Gnr+LsDTiLaddotsBo3OXQODZDlIB5jlI7/hkt/kYOb8d1ns+hd5jmTyFowhOiQAxpWUlZkvXvVQ5gAnefxGCx78/4JtFnTMGADiAYEIMXZm+qtjn9/YJKtkgmgutxcVjTDAl7zVdvN+uyR5g/f2Rm5x1aWLIfmAtg0Nv5xFKZTduPse8PrKsGHC3uezWRshbOYugOxp/Ui6Ru6PNBaeUBGuKwQw2XcB9H65PE4wj14mcCcQk5wTL8VfeaW6WQ6y+dgtwMGoUCnF2Eaj/5Gnv2mW+1VMv0jIqg==
#> 9                                                                                                                                                                                                                                                                                                                                                               www.example.com. A NS SOA TXT AAAA RRSIG NSEC DNSKEY
#> 10                                                                                                                                                                                                                                                                                                                                                                                               a.iana-servers.net.
#> 11                                                                                                                                                                                                                                                                                                                                                                                               b.iana-servers.net.
#> 12                                                                                                                                                                                                                                                                                                                                                                                2606:2800:220:1:248:1893:25c8:1946
#> 13                                                                                                                                                                                                                                                                                                                                                                                                     93.184.216.34
#> 14                                                                                                                                                                                                                                                                                                                                                                                                     "v=spf1 -all"
#> 15                                                                                                                                                                                                                                                                                                                                                             "$Id: example.com 4415 2015-08-24 20:12:23Z davids $"
#> 16                                                                                                                                                                                                                          256 3 8 AwEAAa1e3aHzKml+EtBvA6ZVztOV+AByi8/9akkbL9COtasbKc1VBbHS6w8uHGqHaEMXzriWtXAwlSzHMgIxJ1y0fXcB/h4Yg8qNnJvgSU1JAKvYLJMkdAk+P5XbdGtpUNCh4d9NEZkY/lFClYo8iyIAVeifDeaeaEQIRKbPZLLwtgr1
#> 17                                                                                                                                                                                                                          256 3 8 AwEAAbpTkuNZuxDDAwDW46cAroMR10zm9MsdVnXT+m/4HtbGstC4LIt8WU3CRayoXZyO6zDwxAytkuKxuEWVCAVA7ligFPR8Ta/BoR91H66dj8OPExAq6ugqKsQDKP906j5cF9Rsr9k0rEjvh2MptStkzCSaBB3FulTj14pBX1MZ8x9n
#> 18                                              257 3 8 AwEAAZ0aqu1rJ6orJynrRfNpPmayJZoAx9Ic2/Rl9VQWLMHyjxxem3VUSoNUIFXERQbj0A9Ogp0zDM9YIccKLRd6LmWiDCt7UJQxVdD+heb5Ec4qlqGmyX9MDabkvX2NvMwsUecbYBq8oXeTT9LRmCUt9KUt/WOi6DKECxoG/bWTykrXyBR8elD+SQY43OAVjlWrVltHxgp4/rhBCvRbmdflunaPIgu27eE2U4myDSLT8a4A0rB5uHG4PkOa9dIRs9y00M2mWf4lyPee7vi5few2dbayHXmieGcaAHrx76NGAABeY393xjlmDNcUkF1gpNWUla4fWZbbaYQzA93mLdrng+M=
#> 19                                              257 3 8 AwEAAbOFAxl+Lkt0UMglZizKEC1AxUu8zlj65KYatR5wBWMrh18TYzK/ig6Y1t5YTWCO68bynorpNu9fqNFALX7bVl9/gybA0v0EhF+dgXmoUfRX7ksMGgBvtfa2/Y9a3klXNLqkTszIQ4PEMVCjtryl19Be9/PkFeC9ITjgMRQsQhmB39eyMYnal+f3bUxKk4fq7cuEU0dbRpue4H/N6jPucXWOwiMAkTJhghqgy+o9FfIp+tR/emKao94/wpVXDcPf5B18j7xz2SvTTxiuqCzCMtsxnikZHcoh1j4g+Y1B8zIMIvrEM+pZGhh/Yuf4RwCBgaYCi9hpiMWVvS4WBzx0/lU=
#> 20                                                                                                                                                                                                                                                                                                                                           sns.dns.icann.org. noc.dns.icann.org. 2018050812 7200 3600 1209600 3600
#> 
#> $Additional
#> list()
#> 
#> $edns_client_subnet
#> [1] "0.0.0.0/0"

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
#> 1 microsoft.com.   15 3599 10 microsoft-com.mail.protection.outlook.com.
#> 
#> $Additional
#> list()
#> 
#> $edns_client_subnet
#> [1] "0.0.0.0/0"
#> 
#> $Comment
#> [1] "Response from 193.221.113.53."

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
#> [1] "Response from 216.239.32.10."

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
#> 1 apple.com.    1 3592 17.172.224.47
#> 2 apple.com.    1 3592  17.178.96.59
#> 3 apple.com.    1 3592 17.142.160.59
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
#>                           name type TTL                           data
#> 1  59.160.142.17.in-addr.arpa.   12 907                      imac.one.
#> 2  59.160.142.17.in-addr.arpa.   12 907                       mac.one.
#> 3  59.160.142.17.in-addr.arpa.   12 907                  itunes.earth.
#> 4  59.160.142.17.in-addr.arpa.   12 907                     chomp.com.
#> 5  59.160.142.17.in-addr.arpa.   12 907                   iphone.host.
#> 6  59.160.142.17.in-addr.arpa.   12 907                ripmixburn.com.
#> 7  59.160.142.17.in-addr.arpa.   12 907                   yessql.info.
#> 8  59.160.142.17.in-addr.arpa.   12 907               webobjects.info.
#> 9  59.160.142.17.in-addr.arpa.   12 907                     ubnw.info.
#> 10 59.160.142.17.in-addr.arpa.   12 907                 skyvines.info.
#> 11 59.160.142.17.in-addr.arpa.   12 907            shopdifferent.info.
#> 12 59.160.142.17.in-addr.arpa.   12 907                 sherlock.info.
#> 13 59.160.142.17.in-addr.arpa.   12 907              quicktimetv.info.
#> 14 59.160.142.17.in-addr.arpa.   12 907            quicktimelive.info.
#> 15 59.160.142.17.in-addr.arpa.   12 907                 powermac.info.
#> 16 59.160.142.17.in-addr.arpa.   12 907                powerbook.info.
#> 17 59.160.142.17.in-addr.arpa.   12 907                   macosx.info.
#> 18 59.160.142.17.in-addr.arpa.   12 907               appleshare.info.
#> 19 59.160.142.17.in-addr.arpa.   12 907              applescript.info.
#> 20 59.160.142.17.in-addr.arpa.   12 907         applepaysupplies.info.
#> 21 59.160.142.17.in-addr.arpa.   12 907 applepaymerchantsupplies.info.
#> 22 59.160.142.17.in-addr.arpa.   12 907                 applepay.info.
#> 23 59.160.142.17.in-addr.arpa.   12 907             applemasters.info.
#> 24 59.160.142.17.in-addr.arpa.   12 907                appleexpo.info.
#> 25 59.160.142.17.in-addr.arpa.   12 907         applecomputerinc.info.
#> 26 59.160.142.17.in-addr.arpa.   12 907              applecentre.info.
#> 27 59.160.142.17.in-addr.arpa.   12 907                 airtunes.info.
#> 28 59.160.142.17.in-addr.arpa.   12 907                      apple.by.
#> 29 59.160.142.17.in-addr.arpa.   12 907                 apples-msk.ru.
#> 30 59.160.142.17.in-addr.arpa.   12 907                     icloud.se.
#> 31 59.160.142.17.in-addr.arpa.   12 907                     icloud.es.
#> 32 59.160.142.17.in-addr.arpa.   12 907                     icloud.om.
#> 33 59.160.142.17.in-addr.arpa.   12 907                   icloudo.com.
#> 34 59.160.142.17.in-addr.arpa.   12 907                     icloud.ch.
#> 35 59.160.142.17.in-addr.arpa.   12 907                     icloud.fr.
#> 36 59.160.142.17.in-addr.arpa.   12 907                   icloude.com.
#> 37 59.160.142.17.in-addr.arpa.   12 907          camelspaceeffect.com.
#> 38 59.160.142.17.in-addr.arpa.   12 907                 camelphat.com.
#> 39 59.160.142.17.in-addr.arpa.   12 907              alchemysynth.com.
#> 40 59.160.142.17.in-addr.arpa.   12 907                    openni.org.
#> 41 59.160.142.17.in-addr.arpa.   12 907                      swell.am.
#> 42 59.160.142.17.in-addr.arpa.   12 907                  appleweb.net.
#> 43 59.160.142.17.in-addr.arpa.   12 907                     apple.com.
#> 44 59.160.142.17.in-addr.arpa.   12 907        pv-apple-com.apple.com.
#> 45 59.160.142.17.in-addr.arpa.   12 907                     ipad.host.
#> 46 59.160.142.17.in-addr.arpa.   12 907                   appleid.org.
#> 47 59.160.142.17.in-addr.arpa.   12 907                     apple.xyz.
#> 48 59.160.142.17.in-addr.arpa.   12 907           searchads-apple.com.
#> 49 59.160.142.17.in-addr.arpa.   12 907              airport.brussels.
#> 50 59.160.142.17.in-addr.arpa.   12 907                  ipadpro.buzz.
#> 
#> $Additional
#> list()
#> 
#> $edns_client_subnet
#> [1] "0.0.0.0/0"

hosts <- c("rud.is", "dds.ec", "r-project.org", "rstudio.com", "apple.com")
gdns::bulk_query(hosts)
#>             name type  TTL            data
#> 1        rud.is.    1  276 104.236.112.222
#> 2        dds.ec.    1  599    185.53.178.9
#> 3 r-project.org.    1 4806   137.208.57.37
#> 4   rstudio.com.    1 3599   104.196.200.5
#> 5     apple.com.    1 3585   17.172.224.47
#> 6     apple.com.    1 3585    17.178.96.59
#> 7     apple.com.    1 3585   17.142.160.59
```

### Test Results

``` r
library(gdns)
library(testthat)

date()
#> [1] "Wed Jun  6 15:28:43 2018"

test_dir("tests/")
#> ✔ | OK F W S | Context
#> ══ testthat results  ════════════════════════════════════════════════════════════
#> OK: 2 SKIPPED: 0 FAILED: 0
#> 
#> ══ Results ══════════════════════════════════════════════════════════════════════
#> Duration: 0.3 s
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
