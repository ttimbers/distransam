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
#>             country continent year lifeExp      pop gdpPercap
#> 1            Malawi    Africa 1992  49.420 10014249   563.200
#> 2         Mauritius    Africa 1992  69.745  1096202  6058.254
#> 3            Panama  Americas 1992  72.462  2484997  6618.743
#> 4          Honduras  Americas 1992  66.399  5077347  3081.695
#> 5         Sri Lanka      Asia 1992  70.379 17587060  2153.739
#> 6  Hong Kong, China      Asia 1992  77.601  5829696 24757.603
#> 7           Albania    Europe 1992  71.581  3326498  2497.438
#> 8       Switzerland    Europe 1992  78.030  6995447 31871.530
#> 9       New Zealand   Oceania 1992  76.330  3437674 18363.325
#> 10        Australia   Oceania 1992  77.560 17481977 23424.767
```

Another example of where this could be used, is if you had two groupings that you wanted equal random samples from, for example, if you want random samples of equal size from each plate for each strain

``` r
# make a data frame with worm strain, Petri plate ID, and a measurement
worm_data <- data.frame(c(rep("N2", 5), rep("CB1", 7)), c(rep('a', 2), rep('b', 3), rep('a', 4), rep('b',3)), sample(5:10, 12, replace = TRUE))
colnames(worm_data) <- c('strain', 'plate', 'measurement')

#view data frame
worm_data
#>    strain plate measurement
#> 1      N2     a           7
#> 2      N2     a          10
#> 3      N2     b           7
#> 4      N2     b           9
#> 5      N2     b          10
#> 6     CB1     a           8
#> 7     CB1     a           8
#> 8     CB1     a          10
#> 9     CB1     a           7
#> 10    CB1     b           9
#> 11    CB1     b           5
#> 12    CB1     b           6
```

Use distransam to get a new, randomly sampled dataframe where N's are equal for each plate, and strain:

``` r
distransam(worm_data, 'strain', 'plate')
#>   strain plate measurement
#> 1    CB1     a           8
#> 2    CB1     a           7
#> 3    CB1     b           5
#> 4    CB1     b           9
#> 5     N2     a           7
#> 6     N2     a          10
#> 7     N2     b           7
#> 8     N2     b          10
```
