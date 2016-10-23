#' Randomly samples a time series groups and plates/sites to get equal N's for both
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
#' @param x dataframe
#' @param grouping_var string
#' @param plate_var string
#' @param sample_var string
#'
#' @return dataframe
#' @export
#'
#' @examples
#'
#' # distransam(data_frame, "strain", "plate", "id")
#'
distransam <- function(x, grouping_var, plate_var, sample_var){

  # make table with counts from dataset (strain_n, min_n_id_per_plate,  min_n_plates_per_strain)
  # id counts
  id_counts <- x %>%
    dplyr::group_by_(grouping_var) %>%
    dplyr::count_(c(plate_var, sample_var)) %>%
    dplyr::group_by_(grouping_var, plate_var) %>%
    dplyr::summarise(count = n())

  # number of strains
  strain_n <- id_counts %>%
    dplyr::select_(grouping_var)
  strain_n <- nrow(unique(strain_n))

  # minimum number of samples per plate
  min_n_id_per_plate <- id_counts %>%
    dplyr::ungroup() %>%
    dplyr::select(count) %>%
    min()

  # minimum number of plates per strain
  min_n_plates_per_strain <- id_counts %>%
    dplyr::group_by_(grouping_var) %>%
    dplyr::summarise(count = n()) %>%
    dplyr::select(count) %>%
    min()

  count_summary <- data.frame(stat = c("Number of Strains",
               "Min N of samples per plate",
               "Min N of plates per strain"),
             value = c(strain_n, min_n_id_per_plate, min_n_plates_per_strain))
  print(count_summary)

  # randomly select min_n_plates from each strain
  randomly_sampled_dataframe <- x %>%
    dplyr::group_by_(grouping_var, plate_var, sample_var) %>%
    tidyr::nest(.key = id_data) %>%
    dplyr::ungroup() %>%
    dplyr::group_by_(grouping_var, plate_var) %>%
    tidyr::nest(.key = plate_data) %>%
    dplyr::ungroup() %>%
    dplyr::group_by_(grouping_var) %>%
    tidyr::nest(.key = strain_data) %>%
    dplyr::mutate(samp = map2(strain_data, min_n_plates_per_strain, sample_n)) %>%
    dplyr::select_(grouping_var, "samp") %>%
    tidyr::unnest() %>%
    # randomly select min_n_id_per_plate from each plate
    dplyr::mutate(samp = map2(plate_data, min_n_id_per_plate, sample_n)) %>%
    dplyr::select_(grouping_var, plate_var, "samp") %>%
    tidyr::unnest() %>%
    tidyr::unnest()

  # return data frame
  return(randomly_sampled_dataframe)
}
