<!-- README.md is generated from README.Rmd. Please edit that file -->
code is a work in process - which is not yet working correctly
--------------------------------------------------------------

[![Build Status](https://travis-ci.org/ttimbers/distransam.svg?branch=master)](https://travis-ci.org/ttimbers/distransam)

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
#> Loading required package: dplyr
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(dplyr)
distransam(gap92, 'continent')
#>             country continent year lifeExp       pop  gdpPercap
#> 1              Mali    Africa 1992  48.388   8416215   739.0144
#> 2            Rwanda    Africa 1992  23.599   7290203   737.0686
#> 3            Mexico  Americas 1992  71.455  88111030  9472.3843
#> 4     United States  Americas 1992  76.090 256894189 32003.9322
#> 5          Malaysia      Asia 1992  70.693  18319502  7277.9128
#> 6  Hong Kong, China      Asia 1992  77.601   5829696 24757.6030
#> 7           Belgium    Europe 1992  76.460  10045622 25575.5707
#> 8           Germany    Europe 1992  76.070  80597764 26505.3032
#> 9       New Zealand   Oceania 1992  76.330   3437674 18363.3249
#> 10        Australia   Oceania 1992  77.560  17481977 23424.7668
```

Another example of where this could be used, is if you had two groupings that you wanted equal random samples from, for example, if you want random samples of equal size from each plate for each strain

``` r
# make a data frame with worm strain, Petri plate ID, and a measurement
worm_data <- data.frame(c(rep("N2", 5), rep("CB1", 7)), c(rep('a', 2), rep('b', 3), rep('a', 4), rep('b',3)), sample(5:10, 12, replace = TRUE))
colnames(worm_data) <- c('strain', 'plate', 'measurement')

#view data frame
worm_data
#>    strain plate measurement
#> 1      N2     a          10
#> 2      N2     a           8
#> 3      N2     b          10
#> 4      N2     b           8
#> 5      N2     b          10
#> 6     CB1     a           8
#> 7     CB1     a           9
#> 8     CB1     a           7
#> 9     CB1     a           9
#> 10    CB1     b           8
#> 11    CB1     b           7
#> 12    CB1     b          10
```

Use distransam to get a new, randomly sampled dataframe where N's are equal for each plate, and strain:

``` r
distransam(worm_data, 'strain', 'plate')
#>   strain plate measurement
#> 1    CB1     a           9
#> 2    CB1     a           8
#> 3    CB1     b           7
#> 4    CB1     b           8
#> 5     N2     a           8
#> 6     N2     a          10
#> 7     N2     b          10
#> 8     N2     b          10
```
