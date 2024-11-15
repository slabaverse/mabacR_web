
baa_calc <- function(mabac_df){
  maxmin_df <- mabac_df[, -c(1, 2, 3)]
  max_values <- apply(maxmin_df, 1, max)
  min_values <- apply(maxmin_df, 1, min)
  differences <- max_values - min_values
  negative_differences <- -differences

  original_values_t <- mabac_df[, -c(1, 2)]
  original_values <- original_values_t[, -c(1)]
  normalized_value <- original_values

  for (row in 1:nrow(original_values)) {
    for (col in 1:ncol(original_values)) {
      if (original_values_t[row, 1] == 1) {
        current_min <- min_values[row]
        current_difference <- differences[row]
        normalized_value[row, col] <- (original_values[row, col] - current_min) / current_difference
      } else if (original_values_t[row, 1] == -1) {
        current_max <- max_values[row]
        current_neg_difference <- negative_differences[row]
        normalized_value[row, col] <- (original_values[row, col] - current_max) / current_neg_difference
      }
    }
  }

  normalized_weight <- normalized_value

  for (row in 1:nrow(normalized_value)) {
    for (col in 1:ncol(normalized_value)) {
      current_value <- normalized_value[row, col]
      current_weight <- mabac_df[row, 2]
      normalized_weight[row, col] <- current_weight * (current_value + 1)
    }
  }

  baa <- exp(rowMeans(log(normalized_weight)))
  return(as.data.frame(baa))
}

