#' distransam: randomly samples groups to get equal N's
#'
#'Takes a data frame, and returns one with equal N's for each group. For unequal sample sizes, it finds the minimum sample size from the smallest group, and randomly selects that number of samples from each group. A single sub-groups can be specified, as can a maximum N value. The returned object is a dataframe, with all the same original columns as the original data frame.
#'
#' @name distransam
#' @docType package
NULL
