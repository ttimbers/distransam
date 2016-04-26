<!-- README.md is generated from README.Rmd. Please edit that file -->
### distransam

Randomly samples groups to get equal N's. Takes a data frame, and returns one with equal N's for each group. For unequal sample sizes, it finds the minimum sample size from the smallest group, and randomly selects that number of samples from each group. A single sub-groups can be specified, as can a maximum N value. The returned object is a dataframe, with all the same original columns as the original data frame.

note - that because this package uses dplyr & `%>%` both distransam & dplyr libraries must be loaded

### Installation

``` r
devtools::install_github("ttimbers/distransam")
```

### Quick demo

Using a subset of the gapminder dataset

``` r
library(gapminder)
gap92 <- gapminder[gapminder$year == 1992,]
```

Lets randomly sample the gap92 dataframe for countries from each continent, but in doing so, ensure that we get an equal sample size for each continent.

``` r
library(distransam)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
distransam(gap92, 'continent')
#>           country continent year lifeExp      pop gdpPercap
#> 1            Togo    Africa 1992  58.061  3747553  1034.299
#> 2          Angola    Africa 1992  40.647  8735988  2627.846
#> 3         Jamaica  Americas 1992  71.766  2378618  7404.924
#> 4       Venezuela  Americas 1992  71.150 20265563 10733.926
#> 5         Bahrain      Asia 1992  72.601   529491 19035.579
#> 6     Yemen, Rep.      Asia 1992  55.599 13367997  1879.497
#> 7     Netherlands    Europe 1992  77.420 15174244 26790.950
#> 8  Czech Republic    Europe 1992  72.400 10315702 14297.021
#> 9       Australia   Oceania 1992  77.560 17481977 23424.767
#> 10    New Zealand   Oceania 1992  76.330  3437674 18363.325
```
