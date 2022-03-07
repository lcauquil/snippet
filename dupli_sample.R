dupli_sample <- function(data, val)
{
  ifelse(class(data) == "phyloseq",
         tmp <- as.vector(data.frame(sample_data(data))[, val]),
         ifelse(class(data) == "data.frame",
                tmp <- as.vector(data[, val]),
                stop("Please enter an object of class phyloseq or data.frame", call. = FALSE)))
  
  tmp_rle <- rle(sort(tmp))
  df_rle <- data.frame(len = tmp_rle$lengths,
                       val = tmp_rle$values)
  df_rle |> 
    arrange(desc(len)) |> 
    filter(len > 1)
}
