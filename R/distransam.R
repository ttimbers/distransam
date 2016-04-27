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



#' Randomly samples groups that have series data to get equal N's
#'
#' @param x
#' @param grouping_var
#' @param series_var
#'
#' @return dataframe
#' @export
#'
#' @examples
#' distransam_series(gapminder, 'continent', 'country', 'year')
distransam_series <- function(x, grouping_var, subgroup_var = NULL, series_var){

  # case where we want to randomly sample only across groups (no plates/sites to worry about)
  if (is.null(subgroup_var)) {

    # get the minimum sample size of each group
    x_counts <- x %>% dplyr::group_by_(grouping_var, series_var) %>% dplyr::summarise(n())
    min_sample <- min(x_counts$`n()`)

    # sample the minimum number of samples from each group, but get all the series
    # data for that sample

    # decide which series to sample
    samples <- data.frame(x_counts%>% dplyr::group_by_(grouping_var) %>% dplyr::sample_n(size = min_sample))

    # get the randomly sample dataframe for that series
    randomly_sampled_dataframe <- x[x$ID %in% samples$ID,]

    # grab N random sample from unique combinations of factors in grouping_var & sample_var column
  } else {

    # get the minimum sample size of each group
    x_counts <- x %>% dplyr::group_by_(grouping_var, subgroup_var) %>% dplyr::summarise(n())
    x_counts_counts <- x_counts %>% dplyr::group_by_(grouping_var) %>% dplyr::summarise(n())
    min_sample <- min(x_counts_counts$`n()`)

    # sample the minimum number of samples from each group, but get all the series
    # data for that sample

    # decide which series to sample
    samples <- x %>% dplyr::group_by_(grouping_var) %>% dplyr::group_by_(subgroup_var) %>%  dplyr::slice(1)

    random_samples <- samples %>% dplyr::group_by_(grouping_var) %>% dplyr::sample_n(size = min_sample)

    # get the randomly sample dataframe for that series
    #randomly_sampled_dataframe <- x[x$country %in% samples$country,]
    randomly_sampled_dataframe <- x[x[[subgroup_var]] %in% random_samples[[subgroup_var]],]
  }

  return(randomly_sampled_dataframe)
}
