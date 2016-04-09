<!-- README.md is generated from README.Rmd. Please edit that file -->
`gdns` : Tools to work with the Google DNS over HTTPS API

Traditional DNS queries and responses are sent over UDP or TCP without encryption. This is vulnerable to eavesdropping and spoofing (including DNS-based Internet filtering). Responses from recursive resolvers to clients are the most vulnerable to undesired or malicious changes, while communications between recursive resolvers and authoritative nameservers often incorporate additional protection.

To address this problem, Google Public DNS offers DNS resolution over an encrypted HTTPS connection. DNS-over-HTTPS greatly enhances privacy and security between a client and a recursive resolver, and complements DNSSEC to provide end-to-end authenticated DNS lookups.

The following functions are implemented:

-   `query` : perform the DNS query

### News

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
#> [1] '0.1.0.9000'
```

### Test Results

``` r
library(gdns)
library(testthat)

date()
#> [1] "Sat Apr  9 17:16:13 2016"

test_dir("tests/")
#> testthat results ========================================================================================================
#> OK: 0 SKIPPED: 0 FAILED: 0

library(purrr)
#> 
#> Attaching package: 'purrr'
#> The following object is masked from 'package:testthat':
#> 
#>     is_null

hosts <- c("rud.is", "dds.ec", "r-project.org", "rstudio.com")
results <- map(hosts, gdns::query)
map_df(results, "Answer")
#> Source: local data frame [4 x 4]
#> 
#>             name  type   TTL            data
#>            (chr) (int) (int)           (chr)
#> 1        rud.is.     1   823 104.236.112.222
#> 2        dds.ec.     1   204   162.243.111.4
#> 3 r-project.org.     1   927   137.208.57.37
#> 4   rstudio.com.     1  3386    45.79.156.36
```

### Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
