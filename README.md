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
#>        country continent year lifeExp      pop  gdpPercap
#> 1       Malawi    Africa 1992  49.420 10014249   563.2000
#> 2     Ethiopia    Africa 1992  48.091 52088559   421.3535
#> 3    Argentina  Americas 1992  71.868 33958947  9308.4187
#> 4    Venezuela  Americas 1992  71.150 20265563 10733.9263
#> 5    Singapore      Asia 1992  75.788  3235865 24769.8912
#> 6     Mongolia      Asia 1992  61.271  2312802  1785.4020
#> 7      Romania    Europe 1992  69.360 22797027  6598.4099
#> 8  Netherlands    Europe 1992  77.420 15174244 26790.9496
#> 9  New Zealand   Oceania 1992  76.330  3437674 18363.3249
#> 10   Australia   Oceania 1992  77.560 17481977 23424.7668
```

Another example of where this could be used, is if you had two groupings that you wanted equal random samples from, for example, if you want random samples of equal size from each plate for each strain

``` r
# make a data frame with worm strain, Petri plate ID, and a measurement
worm_data <- data.frame(c(rep("N2", 5), rep("CB1", 7)), c(rep('a', 2), rep('b', 3), rep('a', 4), rep('b',3)), sample(5:10, 12, replace = TRUE))
colnames(worm_data) <- c('strain', 'plate', 'measurement')

#view data frame
worm_data
#>    strain plate measurement
#> 1      N2     a           9
#> 2      N2     a           9
#> 3      N2     b           9
#> 4      N2     b          10
#> 5      N2     b           5
#> 6     CB1     a           8
#> 7     CB1     a           8
#> 8     CB1     a           5
#> 9     CB1     a           9
#> 10    CB1     b           8
#> 11    CB1     b           8
#> 12    CB1     b           8
```

Use distransam to get a new, randomly sampled dataframe where N's are equal:

``` r
distransam(worm_data, 'strain', 'plate')
#>   strain plate measurement
#> 1    CB1     a           9
#> 2    CB1     a           8
#> 3    CB1     b           8
#> 4    CB1     b           8
#> 5     N2     a           9
#> 6     N2     a           9
#> 7     N2     b           9
#> 8     N2     b           5
```
