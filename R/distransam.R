distransam ->  function(dataframe, grouping_var, sample_var = NULL, N){
  
  # case where we want to randomly sample only across groups (no plates/sites to worry about)
  if (is.null(sample_var) {
    # grab N random sample from unique factors in grouping_var column
    
    # case where we want to randomly sample only across groups, and we want to spread these
    # equally across the sample variable (e.g., plates)
  } else {
    # grab N random sample from unique combinations of factors in grouping_var & sample_var column
  }
  
  return(randomly_sampled_dataframe)
}