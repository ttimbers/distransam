library(dplyr)

distransam <- function(x, grouping_var, sample_var = NULL, max_N = NULL){
  
  # case where we want to randomly sample only across groups (no plates/sites to worry about)
  if (is.null(sample_var)) {
  # grab N random sample from unique factors in grouping_var column
    
    # get the minimum sample size of each group
    x_counts <- group_by_(x, grouping_var) %>% summarise(n())
    min_sample <- min(x_counts$`n()`)
    
    # sample the minimum number of samples from each group
    randomly_sampled_dataframe <- data.frame(group_by_(x, grouping_var) %>% sample_n(size = min_sample))
                   
  # case where we want to randomly sample only across groups, and we want to spread these
  # equally across the sample variable (e.g., plates)
  } else{
  # grab N random sample from unique combinations of factors in grouping_var & sample_var column
    
    # get the minimum sample size of each group
    x_counts <- x %>% group_by_(grouping_var, sample_var) %>% summarise(n())
    min_sample <- min(x_counts$`n()`)
    
    # sample the minimum number of samples from each group
    randomly_sampled_dataframe <- data.frame(x %>% group_by_(grouping_var, sample_var) %>% sample_n(size = min_sample))
    
  }
  
  return(randomly_sampled_dataframe)
}
  
  