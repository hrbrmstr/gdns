## Test environments
* local OS X install, R 3.4.0
* ubuntu 12.04 (on travis-ci), R 3.4.0 & oldrel
* win-builder (devel and release) https://win-builder.r-project.org/8Ls4z6cqTVpg/00check.log

## R CMD check results

0 errors | 0 warnings | 1 note (maintainer & acronyms)

## Reverse dependencies

None

---

* This is an update release to fix CRAN checks due to the crazy way purrr does dplyr ops. This pkg now Imports the necessary dplyr functions.
* Mis-spelled words aren't mis-spelled. Too many necessary acronyms to use "'" pairs.
