# Prediction data frame
# Get predictions with standard errors into data frame

utils::globalVariables(c(".", "boot_num", "strap"))

predictdf.sma <- function(data, xseq, se, level) {
  data <- data$data
  coef <- sma_fun(data)
  pred <- coef[[1]] + coef[[2]] * xseq
  if (se) {
    # use data instead of model
    boot_fit <- modelr::bootstrap(data, n = 1000, id = 'boot_num') %>% 
      group_by(boot_num) %>%
      mutate(map_dfc(strap, sma_fun)) %>%
      do(data.frame(fitted = .$intercept + .$slope * xseq, xseq)) %>%
      ungroup %>%
      group_by(xseq) %>%
      dplyr::summarise(., conf_low = quantile(fitted, 0.025),
                       conf_high = quantile(fitted, 0.975))
    base::data.frame(
      x = xseq,
      y = pred,
      ymin = boot_fit$conf_low,
      ymax = boot_fit$conf_high,
      se = 10)
  } else {
    base::data.frame(x = xseq, y = as.vector(pred))
  }
}

#predict_sma <- function(model, xseq, se, level, nboot = 1000) {
#  pred <- coefficients(model)[1] + coefficients(model)[2] * xseq
#  if (se) {
#    model <- smatr::sma(model$formula, model$data)
#    boot_fit <- modelr::bootstrap(model$data, n = nboot, id = 'boot_num') %>% 
#      group_by(boot_num) %>%
#        mutate(fit = map(strap, ~ smatr::sma(model$formula, data = ., method = "SMA"))) %>% 
#    ungroup() %>%
#      mutate(., intercept = map_dbl(fit, ~coef(.x)[1]),
#             slope = map_dbl(fit, ~coef(.x)[2])) %>%
#      select(., -fit) %>%
#      group_by(boot_num) %>%
#      do(data.frame(fitted = .$intercept + .$slope * xseq, xseq)) %>%
#      ungroup %>%
#      group_by(xseq) %>%
#      dplyr::summarise(., conf_low = quantile(fitted, 0.025),
#                       conf_high = quantile(fitted, 0.975))
#
#    base::data.frame(
#      x = xseq,
#      y = pred,
#      ymin = boot_fit$conf_low,
#      ymax = boot_fit$conf_high)
#      #se = 10)
#  } else {
#    base::data.frame(x = xseq, y = as.vector(pred))
#  }
#}
#
#
