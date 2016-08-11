context("distransam")
library(dplyr)
library(purrr)

# Determine if range of vector is FP 0. (borrowed from Hadley Wickam - http://stackoverflow.com/questions/4752275/test-for-equality-among-all-elements-of-a-single-vector)
zero_range <- function(x, tol = .Machine$double.eps ^ 0.5) {
  if (length(x) == 1) return(TRUE)
  x <- range(x) / mean(x)
  isTRUE(all.equal(x[1], x[2], tolerance = tol))
}

# create test data
group <- c(rep('Drug1', 28), rep('Drug2', 46))
site <- c(rep('Site1', 10), rep('Site2', 12), rep('Site3', 6), rep('Site4', 12), rep('Site5', 12), rep('Site6', 10), rep('Site7', 12))
sample <- c(rep(seq(1:5), 2), rep(seq(1:4), 3), rep(seq(1:3), 2), rep(seq(1:4), 3), rep(seq(1:4), 3), rep(seq(1:5), 2), rep(seq(1:4), 3))
measurement <- c(rnorm(28, mean = 5, sd = 0.5), rnorm(46, mean = 6.5, sd = 0.5))
test_data <- data.frame(group, site, sample, measurement)

# run distransam function on test data
evenly_sampled_data <- distransam(test_data)

# run tests to ensure distransam function works correctly
test_that("randomly_sampled_dataframe is the same width and types as input data frame", {
  expect_equal(dim(test_data)[2], dim(evenly_sampled_data)[2])
})

test_that("N for each group should be equal in randomly_sampled_dataframe",{
  data_counts_evenly_sampled <- evenly_sampled_data %>% group_by(group) %>% map(plyr::count)
  zero_range(data_counts_evenly_sampled$group$freq)
})

test_that("N for each site should be equal in randomly_sampled_dataframe", {
  evenly_sampled_sample_counts <- unlist(evenly_sampled_data %>% split(.$site)  %>% map(~ length(unique(.$sample))))
  zero_range(evenly_sampled_sample_counts)
})

test_that("N sites per group must be equal to the minimum number of sites in the smallest group", {
  test_data_site_counts <- unlist(test_data %>% split(.$group) %>% map(~ length(unique(.$site))))
  evenly_sampled_site_counts <- unlist(evenly_sampled_data %>% split(.$group) %>% map(~ length(unique(.$site))))
  all(min(test_data_site_counts) == evenly_sampled_site_counts)
})

test_that("N for samples per site must be equal to the minimum number of samples in the smallest site", {
  test_data_sample_counts <- unlist(test_data %>% split(.$site)  %>% map(~ length(unique(.$sample))))
  evenly_sampled_sample_counts <- unlist(evenly_sampled_data %>% split(.$site)  %>% map(~ length(unique(.$sample))))
  all(min(test_data_sample_counts) == evenly_sampled_sample_counts)
})
