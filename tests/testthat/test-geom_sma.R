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

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_sma(method = "hoge")

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  stat_sma()

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_sma()

fit1 <- sma(hwy ~ displ, mpg)

fit2 <- mpg %>%
  rename(x = displ, y = hwy) %>%
  sma_fun

# intercept and slope
test_that("Estimated coefficients",{
            expect_equal(fit1$coef[[1]][1,1], unlist(fit2)[[1]])
            expect_equal(fit1$coef[[1]][2,1], unlist(fit2)[[2]])
})

# bad model
set.seed(123)
x1 <- rnorm(50)
y1 <- rnorm(50)
x2 <- rnorm(50)
y2 <- rnorm(50, x2)
dat <- tibble(x = c(x1, x2), y = c(y1, y2), gr = rep(c("gr1", "gr2"), each = 50))

ggplot(dat, aes(x = x, y = y, col = gr)) +
  geom_point() +
  geom_sma()

ggplot(dat, aes(x = x, y = y, col = gr)) +
  geom_point() +
  geom_sma(show.sig.only = TRUE)

ggplot(dat, aes(x = x, y = y, col = gr)) +
  geom_point() +
  geom_sma(show.sig.only = c(0.9, 0.2))

ggplot(dat, aes(x = x, y = y, col = gr)) +
  geom_point() +
  geom_sma(show.sig.only = 0.9)

ggplot(dat, aes(x = x, y = y, col = gr)) +
  geom_point() +
  geom_sma(show.sig.only = "hoge")
