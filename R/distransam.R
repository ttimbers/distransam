#' Randomly samples groups to get equal N's
#' 
#' Takes a data frame, and returns one with equal N's for each group. For unequal sample sizes, it finds the minimum sample size from the smallest group, and randomly selects that number of samples from each group. A single sub-groups can be specified, as can a maximum N value. The returned object is a dataframe, with all the same original columns as the original data frame.
#'
#' @param x dataframe
#' @param grouping_var string
#' @param sample_var string (optional)
#' @param max_N integer (not yet implemented)
#'
#' @return dataframe
#' @export
#'
#' @examples
#' library(gapminder)
#' distransam(gapminder[gapminder$year == 1992,], 'continent')
distransam <- function(x, grouping_var, sample_var = NULL, max_N = NULL){
  
  # case where we want to randomly sample only across groups (no plates/sites to worry about)
  if (is.null(sample_var)) {
  # grab N random sample from unique factors in grouping_var column
    
    # get the minimum sample size of each group
    x_counts <- dplyr::group_by_(x, grouping_var) %>% dplyr::summarise(n())
    min_sample <- min(x_counts$`n()`)
    
    # sample the minimum number of samples from each group
    randomly_sampled_dataframe <- data.frame(dplyr::group_by_(x, grouping_var) %>% dplyr::sample_n(size = min_sample))
                   
  # case where we want to randomly sample only across groups, and we want to spread these
  # equally across the sample variable (e.g., plates)
  } else{
  # grab N random sample from unique combinations of factors in grouping_var & sample_var column
    
    # get the minimum sample size of each group
    x_counts <- x %>% dplyr::group_by_(grouping_var, sample_var) %>% dplyr::summarise(n())
    min_sample <- min(x_counts$`n()`)
    
    # sample the minimum number of samples from each group
    randomly_sampled_dataframe <- data.frame(x %>% dplyr::group_by_(grouping_var, sample_var) %>% dplyr::sample_n(size = min_sample))
    
  }
  
  return(randomly_sampled_dataframe)
}
  
  