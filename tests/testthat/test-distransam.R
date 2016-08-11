context("distransam")
library(dply)
library(purrr)

# Determine if range of vector is FP 0. (borrowed from Hadley Wickam - http://stackoverflow.com/questions/4752275/test-for-equality-among-all-elements-of-a-single-vector)
zero_range <- function(x, tol = .Machine$double.eps ^ 0.5) {
  if (length(x) == 1) return(TRUE)
  x <- range(x) / mean(x)
  isTRUE(all.equal(x[1], x[2], tolerance = tol))
}

# create test data
group <- c(rep('Drug1', 12), rep('Drug2', 17))
site <- c(rep('Site1', 5), rep('Site2', 4), rep('Site3', 3), rep('Site4', 4), rep('Site5', 4), rep('Site6', 5), rep('Site7', 4))
sample <- c(seq(1:5), seq(1:4), seq(1:3), seq(1:4), seq(1:4), seq(1:5), seq(1:4))
measurement <- c(rnorm(12, mean = 5, sd = 0.5), rnorm(17, mean = 6.5, sd = 0.5))
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
  zero_range(data_counts_evenly_sampled$site$freq)
})

test_that("N sites per group must be equal to the minimum number of sites in the smallest group", {
  test_data_site_counts <- unlist(test_data %>% split(.$group) %>% map(~ length(unique(.$site))))
  evenly_sampled_site_counts <- unlist(evenly_sampled_data %>% split(.$group) %>% map(~ length(unique(.$site))))
  all(min(test_data_site_counts) == evenly_sampled_site_counts)
})

test_that("N for samples per site must be equal to the minimum number of samples in the smallest site", {
  test_counts <- test_data %>% group_by(group) %>% map(plyr::count)
  all(min(test_counts$site$freq) ==  data_counts_evenly_sampled$site$freq)
})
