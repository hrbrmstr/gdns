
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![Travis-CI Build
Status](https://travis-ci.org/hrbrmstr/gdns.svg?branch=master)](https://travis-ci.org/hrbrmstr/gdns)

# gdns

Tools to work with the Google DNS over HTTPS (DoH) API

## Description

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

More info at <https://developers.google.com/speed/public-dns/docs/doh/>.

The following functions are implemented:

Core:

  - `query` / `dig`: Perform DNS over HTTPS queries using Google
  - `bulk_query`: Vectorized query, returning only answers in a data
    frame
  - `as.data.frame`: Coerce a gdns query response answer to a data frame

Helpers:

  - `has_spf`: Test for whether a DNS TXT record is an SPF record
  - `is_hard_fail`: SPF “all” type test
  - `is_soft_fail`: SPF “all” type test
  - `passes_all`: SPF “all” type test
  - `spf_exists`: SPF field extraction functions
  - `spf_includes`: SPF field extraction functions
  - `spf_ipv4s`: SPF field extraction functions
  - `spf_ipv6s`: SPF field extraction functions
  - `spf_ptrs`: SPF field extraction functions
  - `split_spf`: Split out all SPF records in a domain’s TXT record

IANA Datasets:

  - `dns_classes`: DNS CLASSes (dataset)
  - `dns_glob_names`: Underscored and Globally Scoped DNS Node Names
    (dataset)
  - `dns_opcodes`: DNS OpCodes (dataset)
  - `dns_rcodes`: DNS RCODEs (dataset)
  - `edns0_option_codes`: DNS EDNS0 Option Codes (OPT) (dataset)
  - `rrtypes`: Resource Record (RR) TYPEs (dataset)

### Installation

Any of the following:

``` r
install.packages("gdns", repos = "https://cinc.rud.is")
devtools::install_git("https://git.rud.is/hrbrmstr/gdns")
devtools::install_git("https://git.sr.ht/~rbrmstr/gdns")
devtools::install_bitbucket("hrbrmstr/gdns")
devtools::install_gitlab("hrbrmstr/gdns")
devtools::install_github("hrbrmstr/gdns")
```

### Usage

``` r
library(gdns)
library(tibble) # for printing

# current verison
packageVersion("gdns")
```

    ## [1] '0.5.0'

``` r
str(query("rud.is"))
```

    ## List of 11
    ##  $ Status            : int 0
    ##  $ TC                : logi FALSE
    ##  $ RD                : logi TRUE
    ##  $ RA                : logi TRUE
    ##  $ AD                : logi FALSE
    ##  $ CD                : logi FALSE
    ##  $ Question          :'data.frame':  1 obs. of  2 variables:
    ##   ..$ name: chr "rud.is."
    ##   ..$ type: int 1
    ##  $ Answer            :'data.frame':  1 obs. of  4 variables:
    ##   ..$ name: chr "rud.is."
    ##   ..$ type: int 1
    ##   ..$ TTL : int 3599
    ##   ..$ data: chr "172.93.49.183"
    ##  $ Additional        : list()
    ##  $ edns_client_subnet: chr "0.0.0.0/0"
    ##  $ Comment           : chr "Response from 84.246.121.10."
    ##  - attr(*, "class")= chr [1:2] "gdns_response" "list"

``` r
query("rud.is") %>% 
  as.data.frame()
```

    ## # A tibble: 1 x 6
    ##   query   qtype name     type   ttl data         
    ## * <chr>   <int> <chr>   <int> <int> <chr>        
    ## 1 rud.is.     1 rud.is.     1  3599 172.93.49.183

``` r
str(dig("example.com", "255")) # "ANY" query
```

    ## List of 11
    ##  $ Status            : int 0
    ##  $ TC                : logi FALSE
    ##  $ RD                : logi TRUE
    ##  $ RA                : logi TRUE
    ##  $ AD                : logi TRUE
    ##  $ CD                : logi FALSE
    ##  $ Question          :'data.frame':  1 obs. of  2 variables:
    ##   ..$ name: chr "example.com."
    ##   ..$ type: int 255
    ##  $ Answer            :'data.frame':  2 obs. of  4 variables:
    ##   ..$ name: chr [1:2] "example.com." "example.com."
    ##   ..$ type: int [1:2] 47 46
    ##   ..$ TTL : int [1:2] 3599 3599
    ##   ..$ data: chr [1:2] "www.example.com. A NS SOA MX TXT AAAA RRSIG NSEC DNSKEY" "nsec 8 2 3600 1591086291 1589272385 21738 example.com. S9HOliGkjh8YEAU68DDrEtYmo2f1E8zeFKMqLMLrG8FzG9PSw1kG19Lk"| __truncated__
    ##  $ Additional        : list()
    ##  $ edns_client_subnet: chr "0.0.0.0/0"
    ##  $ Comment           : chr "Response from 2001:500:8d::53."
    ##  - attr(*, "class")= chr [1:2] "gdns_response" "list"

``` r
query("microsoft.com", "MX") %>% 
  as.data.frame()
```

    ## # A tibble: 1 x 6
    ##   query          qtype name            type   ttl data                                         
    ## * <chr>          <int> <chr>          <int> <int> <chr>                                        
    ## 1 microsoft.com.    15 microsoft.com.    15  3599 10 microsoft-com.mail.protection.outlook.com.

``` r
as.data.frame(query("apple.com"))
```

    ## # A tibble: 3 x 6
    ##   query      qtype name        type   ttl data         
    ## * <chr>      <int> <chr>      <int> <int> <chr>        
    ## 1 apple.com.     1 apple.com.     1  3441 17.172.224.47
    ## 2 apple.com.     1 apple.com.     1  3441 17.178.96.59 
    ## 3 apple.com.     1 apple.com.     1  3441 17.142.160.59

``` r
as.data.frame(dig("17.142.160.59", "PTR"))
```

    ## # A tibble: 5 x 6
    ##   query                       qtype name                         type   ttl data                   
    ## * <chr>                       <int> <chr>                       <int> <int> <chr>                  
    ## 1 59.160.142.17.in-addr.arpa.    12 59.160.142.17.in-addr.arpa.    12  3599 ipad.host.             
    ## 2 59.160.142.17.in-addr.arpa.    12 59.160.142.17.in-addr.arpa.    12  3599 apple.by.              
    ## 3 59.160.142.17.in-addr.arpa.    12 59.160.142.17.in-addr.arpa.    12  3599 apple.com.             
    ## 4 59.160.142.17.in-addr.arpa.    12 59.160.142.17.in-addr.arpa.    12  3599 appleid.org.           
    ## 5 59.160.142.17.in-addr.arpa.    12 59.160.142.17.in-addr.arpa.    12  3599 pv-apple-com.apple.com.

``` r
hosts <- c("rud.is", "dds.ec", "r-project.org", "rstudio.com", "apple.com")

gdns::bulk_query(hosts)
```

    ## # A tibble: 7 x 7
    ##   query          qtype name            type   ttl data          entity       
    ##   <chr>          <int> <chr>          <int> <int> <chr>         <chr>        
    ## 1 rud.is.            1 rud.is.            1  3599 172.93.49.183 rud.is       
    ## 2 dds.ec.            1 dds.ec.            1   599 104.247.81.52 dds.ec       
    ## 3 r-project.org.     1 r-project.org.     1  7199 137.208.57.37 r-project.org
    ## 4 rstudio.com.       1 rstudio.com.       1    59 104.198.14.52 rstudio.com  
    ## 5 apple.com.         1 apple.com.         1  3082 17.142.160.59 apple.com    
    ## 6 apple.com.         1 apple.com.         1  3082 17.172.224.47 apple.com    
    ## 7 apple.com.         1 apple.com.         1  3082 17.178.96.59  apple.com

## gdns Metrics

| Lang | \# Files |  (%) | LoC |  (%) | Blank lines |  (%) | \# Lines |  (%) |
| :--- | -------: | ---: | --: | ---: | ----------: | ---: | -------: | ---: |
| R    |       13 | 0.93 | 389 | 0.94 |         129 | 0.79 |      339 | 0.86 |
| Rmd  |        1 | 0.07 |  27 | 0.06 |          35 | 0.21 |       53 | 0.14 |

## Code of Conduct

Please note that this project is released with a Contributor Code of
Conduct. By participating in this project you agree to abide by its
terms.
