
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
install("gdns", repos = "https://cinc.rud.is")
devtools::install_git("https://git.rud.is/hrbrmstr/gdns")
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

    ## [1] '0.4.0'

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
    ##  $ Comment           : chr "Response from 84.246.124.75."
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

    ## List of 10
    ##  $ Status            : int 0
    ##  $ TC                : logi FALSE
    ##  $ RD                : logi TRUE
    ##  $ RA                : logi TRUE
    ##  $ AD                : logi TRUE
    ##  $ CD                : logi FALSE
    ##  $ Question          :'data.frame':  1 obs. of  2 variables:
    ##   ..$ name: chr "example.com."
    ##   ..$ type: int 255
    ##  $ Answer            :'data.frame':  18 obs. of  4 variables:
    ##   ..$ name: chr [1:18] "example.com." "example.com." "example.com." "example.com." ...
    ##   ..$ type: int [1:18] 6 46 46 46 46 46 46 46 46 47 ...
    ##   ..$ TTL : int [1:18] 1533 19533 19533 1533 19533 19533 1533 1533 1533 1533 ...
    ##   ..$ data: chr [1:18] "sns.dns.icann.org. noc.dns.icann.org. 2019041044 7200 3600 1209600 3600" "a 8 2 86400 1562528621 1560723663 23689 example.com. fdyvf2c+HYL8Qt9UXB+KLdnvuWyeE9U2i7pR9vnb59L6E7eBCxeGGZAVBf"| __truncated__ "ns 8 2 86400 1562498297 1560694863 23689 example.com. c2wn0Bz2Yb6T545v7f3O7XH8/gwRqPDlho6jtVNC9f7qL8lidsfTTpOPl"| __truncated__ "soa 8 2 3600 1562561021 1560759663 23689 example.com. icHLconr6/MiDdoLcVEFXErYXJ6XgZK+r/Q25Xu4sKKaKQhIgkDzeX+Fn"| __truncated__ ...
    ##  $ Additional        : list()
    ##  $ edns_client_subnet: chr "0.0.0.0/0"
    ##  - attr(*, "class")= chr [1:2] "gdns_response" "list"

``` r
query("microsoft.com", "MX") %>% 
  as.data.frame()
```

    ## # A tibble: 1 x 6
    ##   query          qtype name            type   ttl data                                         
    ## * <chr>          <int> <chr>          <int> <int> <chr>                                        
    ## 1 microsoft.com.    15 microsoft.com.    15  2904 10 microsoft-com.mail.protection.outlook.com.

``` r
as.data.frame(query("apple.com"))
```

    ## # A tibble: 3 x 6
    ##   query      qtype name        type   ttl data         
    ## * <chr>      <int> <chr>      <int> <int> <chr>        
    ## 1 apple.com.     1 apple.com.     1  3274 17.172.224.47
    ## 2 apple.com.     1 apple.com.     1  3274 17.178.96.59 
    ## 3 apple.com.     1 apple.com.     1  3274 17.142.160.59

``` r
as.data.frame(dig("17.142.160.59", "PTR"))
```

    ## # A tibble: 5 x 6
    ##   query                       qtype name                         type   ttl data                   
    ## * <chr>                       <int> <chr>                       <int> <int> <chr>                  
    ## 1 59.160.142.17.in-addr.arpa.    12 59.160.142.17.in-addr.arpa.    12   102 appleid.org.           
    ## 2 59.160.142.17.in-addr.arpa.    12 59.160.142.17.in-addr.arpa.    12   102 apple.by.              
    ## 3 59.160.142.17.in-addr.arpa.    12 59.160.142.17.in-addr.arpa.    12   102 apple.com.             
    ## 4 59.160.142.17.in-addr.arpa.    12 59.160.142.17.in-addr.arpa.    12   102 ipad.host.             
    ## 5 59.160.142.17.in-addr.arpa.    12 59.160.142.17.in-addr.arpa.    12   102 pv-apple-com.apple.com.

``` r
hosts <- c("rud.is", "dds.ec", "r-project.org", "rstudio.com", "apple.com")

gdns::bulk_query(hosts)
```

    ## # A tibble: 7 x 7
    ##   query          qtype name            type   ttl data          entity       
    ##   <chr>          <int> <chr>          <int> <int> <chr>         <chr>        
    ## 1 rud.is.            1 rud.is.            1  3598 172.93.49.183 rud.is       
    ## 2 dds.ec.            1 dds.ec.            1   599 185.53.178.9  dds.ec       
    ## 3 r-project.org.     1 r-project.org.     1  4469 137.208.57.37 r-project.org
    ## 4 rstudio.com.       1 rstudio.com.       1  3599 104.196.200.5 rstudio.com  
    ## 5 apple.com.         1 apple.com.         1  2137 17.172.224.47 apple.com    
    ## 6 apple.com.         1 apple.com.         1  2137 17.178.96.59  apple.com    
    ## 7 apple.com.         1 apple.com.         1  2137 17.142.160.59 apple.com

## gdns Metrics

| Lang | \# Files |  (%) | LoC |  (%) | Blank lines |  (%) | \# Lines |  (%) |
| :--- | -------: | ---: | --: | ---: | ----------: | ---: | -------: | ---: |
| R    |       14 | 0.93 | 384 | 0.94 |         118 | 0.77 |      314 | 0.85 |
| Rmd  |        1 | 0.07 |  26 | 0.06 |          35 | 0.23 |       54 | 0.15 |

## Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](CONDUCT.md). By participating in this project you agree to
abide by its terms.
