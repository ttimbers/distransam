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
evenly_sampled_data <- distransam(test_data, "group", "plate", "id")

# calculate id counts for use in tests
# counts for expected data
data_counts_exp <- exp_data %>%
group_by(group) %>%
  count(plate, id) %>%
  group_by(group, plate) %>%
  summarise(count = n())
# counts for test data set generated via distransam
data_counts_evenly_sampled <- evenly_sampled_data %>%
  group_by(group) %>%
  count(plate, id) %>%
  group_by(group, plate) %>%
  summarise(count = n())

# calculate plate counts for use in tests
# test expected data set (generated manually)
plate_counts_exp <- data_counts_exp %>%
  group_by(group) %>%
  summarise(count = n())
# test data set generated via distransam
plate_counts_evenly_sampled <- data_counts_evenly_sampled %>%
  group_by(group) %>%
  summarise(count = n())


# run tests to ensure distransam function works correctly
test_that("randomly_sampled_dataframe is the same width and types as input data frame", {
  # test expected data set (generated manually)
  expect_equal(dim(test_data)[2], dim(exp_data)[2])

  # test data set generated via distransam
  expect_equal(dim(test_data)[2], dim(evenly_sampled_data)[2])
})

test_that("N (id's) for each plate should be equal in randomly_sampled_dataframe",{
  # test expected data set (generated manually)
  zero_range(data_counts_exp$count)

  # test data set generated via distransam
  zero_range(data_counts_evenly_sampled$count)
})

test_that("N for each Plate should be equal in randomly_sampled_dataframe", {
  # test expected data set (generated manually)
  zero_range(plate_counts_exp$count)

  # test data set generated via distransam
  zero_range(plate_counts_evenly_sampled$count)
})

test_that("N Plates per group must be equal to the minimum number of Plates in the smallest group", {
  # get min plate per group/strain
  min_plate_test_data <- test_data %>%
    group_by(group) %>%
    count(plate, id) %>%
    group_by(group, plate) %>%
    summarise(count = n()) %>%
    group_by(group) %>%
    summarise(count = n()) %>%
    select(count) %>%
    min()

  # test expected data set (generated manually)
  all(min_plate_test_data == plate_counts_exp$count)

  # test data set generated via distransam
  all(min_plate_test_data == plate_counts_evenly_sampled$count)
})

test_that("N for samples per Plate must be equal to the minimum number of samples in the smallest Plate", {
  # get min id per plate
  min_ids_test_data <- test_data %>%
    group_by(group) %>%
    count(plate, id) %>%
    group_by(group, plate) %>%
    summarise(count = n()) %>%
    ungroup() %>%
    select(count) %>%
    min()

  # test expected data set (generated manually)
  all(min_ids_test_data == data_counts_exp$count)

  # test data set generated via distransam
  all(min_ids_test_data == plate_counts_evenly_sampled$count)
})
