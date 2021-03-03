library(ggsma)
library(smatr)

data(leaflife)
leaf_low <- leaflife %>%
  filter(soilp == "low")

ggplot(leaflife, aes(lma, longev)) +
  geom_point() +
  stat_sma()

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_sma(method = "sma")

fit1 <- sma(hwy ~ displ, mpg)

fit2 <- mpg %>%
  rename(x = displ, y = hwy) %>%
  sma_fun

# intercept and slope
test_that("Estimated coefficients",{
            expect_equal(fit1$coef[[1]][1,1], unlist(fit2)[[1]])
            expect_equal(fit1$coef[[1]][2,1], unlist(fit2)[[2]])
})

