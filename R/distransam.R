#' Randomly samples groups to get equal N's for both sites and samples from each group
#'
#' Takes a data frame, and returns one with equal N's for both sites and samples from each group. For
#' unequal site numbers, it finds the minimum site number from the smallest group, and randomly
#' selects that number of sites from each group. For unequal sample sizes between sites, it finds the
#' minimum sample size from the smallest site, and randomly selects that number of samples from each
#' group. The returned object is a dataframe, with all the same original columns as the original data
#' frame. This function also works for time series data (where you have mutliple measurements from
#' different time points for each sample).
#'
#' @param x dataframe
#' @param grouping_var string
#' @param site_var string
#' @param sample_var string
#'
#' @return dataframe
#' @export
#'
#' @examples
#' work in progress
distransam <- function(x, grouping_var, sample_var = NULL, max_N = NULL){



  return(randomly_sampled_dataframe)
}



