context("distransam")

test_random_sample_across_samples ->  function (){
  # 1. randomly_sampled_dataframe should be =< dimensions of original dataframe
  
  # 2. if sample_var = NULL, N for each group should be equal in randomly_sampled_dataframe
  
  # 3. if sample_var = !NULL, N for each samples should be equal in randomly_sampled_dataframe
  
  # 4. if sample_var = NULL, then N must be > minimum # individuals in smallest group
  
  # 5. if sample_var = !NULL, then N/# of samples must be > minimum # individuals in 
  # smallest sample within all groups
}