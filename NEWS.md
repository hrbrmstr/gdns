# gdns 0.5.0

* Addressed CRAN check issues
* Switched to tinytest
* Added support for 'dns-message' new content type

# gdns 0.4.0

* Updated the JSON API endpoint per Google notification
* Added `dig()` alias for `query()`
* Added an `as.data.frame()` coercer for query results
* Added IANA DNS-related datasets

# gdns 0.3.1

* fixed bug in `bulk_query()`

# gdns 0.3.0

* removed purrr, dplyr and tibble dependencies
* `bulk_query()` now returns the original query string in a `query` column
* added `resource_record_tbl` data frame of DNS RR metadata

# gdns 0.2.1

* Fix CRAN checks due to purrr insanity

# gdns 0.2.0

* CRAN release
* Added a `NEWS.md` file to track changes to the package.
