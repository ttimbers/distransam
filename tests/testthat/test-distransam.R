context("distransam")
library(dplyr)
library(purrr)

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
test_data

# create expected correct answer from test data
group <- c(rep('Strain1', 24), 
           rep('Strain2', 26))

plate <- c(rep('Plate1', 10), 
           rep('Plate2', 8), 
           rep('Plate3', 6), 
           rep('Plate4', 8), 
           #rep('Plate5', 12), 
           rep('Plate6', 10), 
           rep('Plate7', 8))

id <- c(rep(1, 5), rep(2, 5), 
        rep(1, 4), rep(2, 4), #rep(3, 4),
        rep(1, 3), rep(2, 3), 
        rep(1, 4), rep(2, 4), #rep(3, 4),
        #rep(1, 4), rep(2, 4), rep(3, 4), 
        rep(1, 5), rep(2, 5), 
        rep(1, 4), rep(2, 4)) #rep(3, 4))

time <- c(rep(seq(1:5), 2), 
          rep(seq(1:4), 2), 
          rep(seq(1:3), 2), 
          rep(seq(1:4), 2), 
          #rep(seq(1:4), 3), 
          rep(seq(1:5), 2), 
          rep(seq(1:4), 2))

measurement <- c(rnorm(24, mean = 5, sd = 0.5), 
                 rnorm(26, mean = 6.5, sd = 0.5))

exp_data <- data.frame(group, plate, id, time, measurement)
exp_data

# run distransam function on test data
evenly_sampled_data <- distransam(test_data)

# run tests to ensure distransam function works correctly
test_that("randomly_sampled_dataframe is the same width and types as input data frame", {
  # test expected data set (generated manually)
  expect_equal(dim(test_data)[2], dim(exp_data)[2])
  
  # test data set generated via distransam
  expect_equal(dim(test_data)[2], dim(evenly_sampled_data)[2])
})

test_that("N (id's) for each plate should be equal in randomly_sampled_dataframe",{
  # test expected data set (generated manually)
  data_counts_exp <- exp_data %>%
    group_by(group) %>%
    count(plate, id) %>% 
    group_by(group, plate) %>% 
    summarise(count = n())
    
  zero_range(data_counts_exp$count)
  
  # test data set generated via distransam
  data_counts_evenly_sampled <- evenly_sampled_data %>%
    group_by(group) %>%
    count(plate, id) %>%
    group_by(group, plate) %>%
    summarise(count = n())

  zero_range(data_counts_evenly_sampled$count)
})

test_that("N for each Plate should be equal in randomly_sampled_dataframe", {
  evenly_sampled_sample_counts <- unlist(evenly_sampled_data %>% split(.$Plate)  %>% map(~ length(unique(.$sample))))
  zero_range(evenly_sampled_sample_counts)
})

test_that("N Plates per group must be equal to the minimum number of Plates in the smallest group", {
  test_data_Plate_counts <- unlist(test_data %>%
                                     split(.$group) %>%
                                     map(~ length(unique(.$Plate))))

  evenly_sampled_Plate_counts <- unlist(evenly_sampled_data %>%
                                          split(.$group) %>%
                                          map(~ length(unique(.$Plate))))

  all(min(test_data_Plate_counts) == evenly_sampled_Plate_counts)
})

test_that("N for samples per Plate must be equal to the minimum number of samples in the smallest Plate", {
  test_data_sample_counts <- unlist(test_data %>% split(.$Plate)  %>%
                                      map(~ length(unique(.$sample))))

  evenly_sampled_sample_counts <- unlist(evenly_sampled_data %>%
                                           split(.$Plate)  %>%
                                           map(~ length(unique(.$sample))))

  all(min(test_data_sample_counts) == evenly_sampled_sample_counts)
})
