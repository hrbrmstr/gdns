<!-- README.md is generated from README.Rmd. Please edit that file -->
`gdns` : Tools to work with the Google DNS over HTTPS API

Traditional DNS queries and responses are sent over UDP or TCP without encryption. This is vulnerable to eavesdropping and spoofing (including DNS-based Internet filtering). Responses from recursive resolvers to clients are the most vulnerable to undesired or malicious changes, while communications between recursive resolvers and authoritative nameservers often incorporate additional protection.

To address this problem, Google Public DNS offers DNS resolution over an encrypted HTTPS connection. DNS-over-HTTPS greatly enhances privacy and security between a client and a recursive resolver, and complements DNSSEC to provide end-to-end authenticated DNS lookups.

More info at <https://developers.google.com/speed/public-dns/docs/dns-over-https>.

The following functions are implemented:

-   `query` : perform Google DNS query for a single host (retreives metadata & answer)
-   `bulk_query` : perform bulk host queries, returning a of only answers (no metadata)

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
#> [1] "Sat Apr  9 20:19:06 2016"

test_dir("tests/")
#> testthat results ========================================================================================================
#> OK: 2 SKIPPED: 0 FAILED: 0

hosts <- c("rud.is", "dds.ec", "r-project.org", "rstudio.com", "apple.com")

gdns::bulk_query(hosts)
#> Source: local data frame [7 x 4]
#> 
#>             name  type   TTL            data
#>            (chr) (int) (int)           (chr)
#> 1        rud.is.     1  3599 104.236.112.222
#> 2        dds.ec.     1   284   162.243.111.4
#> 3 r-project.org.     1  7146   137.208.57.37
#> 4   rstudio.com.     1  3599    45.79.156.36
#> 5     apple.com.     1  3172   17.172.224.47
#> 6     apple.com.     1  3172    17.178.96.59
#> 7     apple.com.     1  3172   17.142.160.59
```

### Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
