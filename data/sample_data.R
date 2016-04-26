# sample data
worm_data <- data.frame(c(rep("N2", 5), rep("CB1", 7)), c(rep('a', 2), rep('b', 3), rep('a', 4), rep('b',3)), sample(5:10, 12, replace = TRUE))
colnames(worm_data) <- c('strain', 'plate', 'measurement')
