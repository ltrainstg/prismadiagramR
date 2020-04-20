
<!-- README.md is generated from README.Rmd. Please edit that file -->

# prismadiagramR

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/ltrainstg/prismadiagramR.svg?branch=master)](https://travis-ci.org/ltrainstg/prismadiagramR)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/ltrainstg/prismadiagramR?branch=master&svg=true)](https://ci.appveyor.com/project/ltrainstg/prismadiagramR)
[![CRAN
status](https://www.r-pkg.org/badges/version/prismadiagramR)](https://CRAN.R-project.org/package=prismadiagramR)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Codecov test
coverage](https://codecov.io/gh/ltrainstg/prismadiagramR/branch/master/graph/badge.svg)](https://codecov.io/gh/ltrainstg/prismadiagramR?branch=master)
<!-- badges: end -->

The goal of prismadiagramR is to create a custom prismadiagram in R.

## Installation

You can install the released version of prismadiagramR from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("prismadiagramR")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ltrainstg/prismadiagramR")
```

## Example

This example shows how to create a simple automated PRISMA from a
publication tracker.

``` r

set.seed(25)
N <- 100
studyStatus <- data.frame(Pub.ID = seq(1:N), 
                          Source = sample(1:3, N, replace = TRUE),
                          Filter = sample(1:5, N, replace = TRUE))
studyStatus$Filter[studyStatus$Filter==5] <- NA  
getPrisma(studyStatus) %>% DiagrammeR::grViz(.)
#> Warning in getPrisma(studyStatus): prismaFormat is null so attempting to
#> make automatic one from studyStatus
#> Warning in getFormatNode(prismaFormat): fontSize param not passed in
#> prismaFormat
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

## Other PRISMA resources

A few other R packages exist that also make PRISMA diagram that might be
better for your needs.

1.  [prismaStatement](https://CRAN.R-project.org/package=PRISMAstatement)
    This also uses DiagrammeR, but the template is fixed.
2.  [metagear](https://rdrr.io/cran/metagear/man/plot_PRISMA.html) This
    does not use DiagrammeR and is highly customizable, but is buried
    with many other functions and a little hard to get working.

## Package Development Resources

This package was developed following these guides:

  - John Muschelli’s r package development 1
    [HERE](https://www.youtube.com/watch?v=79s3z0gIuFU)
  - <https://sahirbhatnagar.com/rpkg/#tests>
