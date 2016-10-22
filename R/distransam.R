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
distransam <- function(x, grouping_var, site_var, sample_var){

  # make table with counts from dataset (strain_n, min_n_id_per_plate,  min_n_plates_per_strain)
  # id counts
  id_counts <- x %>%
    group_by(group) %>%
    count(plate, id) %>% 
    group_by(group, plate) %>% 
    summarise(count = n())
  
  # number of strains
  strain_n <- id_counts %>% 
    select(group) 
  strain_n <- nrow(unique(strain_n))
  
  # minimum number of samples per plate
  min_n_id_per_plate <- id_counts %>% 
    ungroup() %>% 
    select(count) %>% 
    min()
  
  # minimum number of plates per strain
  min_n_plates_per_strain <- id_counts %>% 
    group_by(group) %>%
    summarise(count = n()) %>% 
    select(count) %>% 
    min()
  
  count_summary <- data.frame(stat = c("Number of Strains", 
               "Min N of samples per plate", 
               "Min N of plates per strain"), 
             value = c(strain_n, min_n_id_per_plate, min_n_plates_per_strain))
  
  # randomly select min_n_plates from each strain
  randomly_sampled_dataframe <- x %>% 
    group_by(group, plate, id) %>% 
    nest(.key = id_data) %>% 
    ungroup() %>% 
    group_by(group, plate) %>% 
    nest(.key = plate_data) %>% 
    ungroup() %>% 
    group_by(group) %>% 
    nest(.key = strain_data) %>%  
    mutate(samp = map2(strain_data, min_n_plates_per_strain, sample_n)) %>% 
    select(group, samp) %>% 
    unnest() %>% 
    # randomly select min_n_id_per_plate from each plate
    mutate(samp = map2(plate_data, min_n_id_per_plate, sample_n)) %>% 
    select(group, plate, samp) %>% 
    unnest() %>% 
    unnest()
    
  # return data frame
  return(randomly_sampled_dataframe)
}



