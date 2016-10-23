#' distransam.
#'
#'#' Randomly samples a time series groups and plates/sites to get equal N's for both
#' plates/sites and samples from each group
#'
#' Takes a data frame containing a time series, a column name for the grouping variable,
#' a column name for the plates/sites variable, and a column name for the sample id's.
#' Returns one with equal N's for both plates/sites and samples from each group.
#'
#' For unequal site numbers, it finds the minimum site number from the smallest group,
#' and randomly selects that number of sites from each group. For unequal sample sizes
#' between sites, it finds the minimum sample size from the smallest site, and randomly
#' selects that number of samples from each group. The returned object is a dataframe,
#' with all the same columns as the original data frame.
#'
#' @name distransam
#' @docType package
NULL
