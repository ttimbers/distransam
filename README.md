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

Create some data:

``` r
# create test data
group <- c(rep('Strain1', 28),
           rep('Strain2', 46))

plate <- c(rep('Plate1', 10),
           rep('Plate2', 12),
           rep('Plate3', 6),
           rep('Plate4', 12),
           rep('Plate5', 12),
           rep('Plate6', 10),
           rep('Plate7', 12))

id <- c(rep(1, 5), rep(2, 5),
        rep(1, 4), rep(2, 4), rep(3, 4),
        rep(1, 3), rep(2, 3),
        rep(1, 4), rep(2, 4), rep(3, 4),
        rep(1, 4), rep(2, 4), rep(3, 4),
        rep(1, 5), rep(2, 5),
        rep(1, 4), rep(2, 4), rep(3, 4))

time <- c(rep(seq(1:5), 2),
          rep(seq(1:4), 3),
          rep(seq(1:3), 2),
          rep(seq(1:4), 3),
          rep(seq(1:4), 3),
          rep(seq(1:5), 2),
          rep(seq(1:4), 3))

measurement <- c(rnorm(28, mean = 5, sd = 0.5),
                 rnorm(46, mean = 6.5, sd = 0.5))

test_data <- data.frame(group, plate, id, time, measurement)
head(test_data)
#>     group  plate id time measurement
#> 1 Strain1 Plate1  1    1    4.752098
#> 2 Strain1 Plate1  1    2    5.123247
#> 3 Strain1 Plate1  1    3    5.094555
#> 4 Strain1 Plate1  1    4    4.868570
#> 5 Strain1 Plate1  1    5    5.737470
#> 6 Strain1 Plate1  2    1    4.946963
```

Use distransam to get a new, randomly sampled dataframe where N's are equal for each plate, and strain:

``` r
library(dplyr)
library(purrr)
library(tidyr)
library(distransam)

sampled_test_data <- distransam(worm_data, 'group', 'plate', 'id')
```

Compare `test_data` to `sampled_test_data`:

``` r
str(test_data)
```

``` r
str(sampled_test_data)
```
