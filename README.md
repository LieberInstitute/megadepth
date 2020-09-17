
<!-- README.md is generated from README.Rmd. Please edit that file -->

# megadepth

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![BioC
status](http://www.bioconductor.org/shields/build/release/bioc/megadepth.svg)](https://bioconductor.org/checkResults/release/bioc-LATEST/megadepth)
[![R build
status](https://github.com/LieberInstitute/megadepth/workflows/R-CMD-check-bioc/badge.svg)](https://github.com/LieberInstitute/megadepth/actions)
[![Codecov test
coverage](https://codecov.io/gh/LieberInstitute/megadepth/branch/master/graph/badge.svg)](https://codecov.io/gh/LieberInstitute/megadepth?branch=master)
<!-- badges: end -->

The goal of `megadepth` is to provide an R interface to the command line
tool [megadepth](https://github.com/ChristopherWilks/megadepth) for
BigWig and BAM related utilities created by [Christopher
Wilks](https://twitter.com/chrisnwilks). This R package enables fast
processing of bigWig files on downstream packages such as
[dasper](https://bioconductor.org/packages/dasper) and
[recount3](https://bioconductor.org/packages/recount3).

## Installation instructions

Get the latest stable `R` release from
[CRAN](http://cran.r-project.org/). Then install `megadepth` using from
[Bioconductor](http://bioconductor.org/) the following code:

``` r
if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager")
}

BiocManager::install("megadepth")
```

And the development version from [GitHub](https://github.com/) with:

``` r
BiocManager::install("LieberInstitute/megadepth")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library("megadepth")
## basic example code
```

## Citation

Below is the citation output from using `citation('megadepth')` in R.
Please run this yourself to check for any updates on how to cite
**megadepth**.

``` r
print(citation('megadepth'), bibtex = TRUE)
#> 
#> LieberInstitute (2020). _megadepth: BigWig and BAM related utilities_.
#> doi: 10.18129/B9.bioc.megadepth (URL:
#> https://doi.org/10.18129/B9.bioc.megadepth),
#> https://github.com/LieberInstitute/megadepth - R package version
#> 0.99.0, <URL: http://www.bioconductor.org/packages/megadepth>.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {megadepth: BigWig and BAM related utilities},
#>     author = {{LieberInstitute}},
#>     year = {2020},
#>     url = {http://www.bioconductor.org/packages/megadepth},
#>     note = {https://github.com/LieberInstitute/megadepth - R package version 0.99.0},
#>     doi = {10.18129/B9.bioc.megadepth},
#>   }
#> 
#> Zhang D, Wilks C, Langmead B, Collado-Torres L (2020). "megadepth:
#> BigWig and BAM related utilities." _bioRxiv_. doi: 10.1101/TODO (URL:
#> https://doi.org/10.1101/TODO), <URL:
#> https://www.biorxiv.org/content/10.1101/TODO>.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Article{,
#>     title = {megadepth: BigWig and BAM related utilities},
#>     author = {David Zhang and Christopher Wilks and Ben Langmead and Leonardo Collado-Torres},
#>     year = {2020},
#>     journal = {bioRxiv},
#>     doi = {10.1101/TODO},
#>     url = {https://www.biorxiv.org/content/10.1101/TODO},
#>   }
```

Please note that the `megadepth` was only made possible thanks to many
other R and bioinformatics software authors, which are cited either in
the vignettes and/or the paper(s) describing this package.

## Code of Conduct

Please note that the `megadepth` project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

## Development tools

  - Continuous code testing is possible thanks to [GitHub
    actions](https://www.tidyverse.org/blog/2020/04/usethis-1-6-0/)
    through *[usethis](https://CRAN.R-project.org/package=usethis)*,
    *[remotes](https://CRAN.R-project.org/package=remotes)*,
    *[sysreqs](https://github.com/r-hub/sysreqs)* and
    *[rcmdcheck](https://CRAN.R-project.org/package=rcmdcheck)*
    customized to use [Bioconductor’s docker
    containers](https://www.bioconductor.org/help/docker/) and
    *[BiocCheck](https://bioconductor.org/packages/3.12/BiocCheck)*.
  - Code coverage assessment is possible thanks to
    [codecov](https://codecov.io/gh) and
    *[covr](https://CRAN.R-project.org/package=covr)*.
  - The [documentation
    website](http://LieberInstitute.github.io/megadepth) is
    automatically updated thanks to
    *[pkgdown](https://CRAN.R-project.org/package=pkgdown)*.
  - The code is styled automatically thanks to
    *[styler](https://CRAN.R-project.org/package=styler)*.
  - The documentation is formatted thanks to
    *[devtools](https://CRAN.R-project.org/package=devtools)* and
    *[roxygen2](https://CRAN.R-project.org/package=roxygen2)*.

For more details, check the `dev` directory.

This package was developed using
*[biocthis](https://github.com/lcolladotor/biocthis)*.
