# Prediction data frame
# Get predictions with standard errors into data frame

utils::globalVariables(c(".", "boot_num", "strap"))

predictdf.sma <- function(data, xseq, se, level, nboot) {
#  data <- data$data
  coef <- sma_fun(data)
  pred <- coef[[1]] + coef[[2]] * xseq
  pval <- cor.test(data$x, data$y)$p.value
  if (se) {
    # use data instead of model
    boot_fit <- modelr::bootstrap(data, n = nboot, id = 'boot_num') %>% 
      group_by(boot_num) %>%
      mutate(map_dfc(strap, sma_fun)) %>%
      do(data.frame(fitted = .$intercept + .$slope * xseq, xseq)) %>%
      ungroup %>%
      group_by(xseq) %>%
      dplyr::summarise(., conf_low = quantile(fitted, 0.5 - level / 2),
                       conf_high = quantile(fitted, level / 2 + 0.5))
    base::data.frame(
      x = xseq,
      y = pred,
      ymin = boot_fit$conf_low,
      ymax = boot_fit$conf_high,
      se = 10,
      pval = pval)
  } else {
    base::data.frame(x = xseq, y = as.vector(pred), pval = pval)
  }
}


sma_fun <- function(data) {
  data <- as_tibble(data)
  sign <- ifelse(cor(data$y, data$x) >= 0, 1, -1)
  slope <- sign * sd(data$y) / sd(data$x)
  intercept <- mean(data$y) - slope * mean(data$x)
  tibble(intercept, slope)
}
