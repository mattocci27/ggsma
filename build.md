
roxygen2::roxygenise()
devtools::check(".", manual = TRUE)



devtools::build_vignettes()
devtools::build_manual(".")
devtools::build(".")


devtools::install_deps()
devtools::test()
devtools::test_coverage()
devtools::run_examples()
devtools::document()

devtools::check(".", manual = TRUE)


library(smatr)
library(tictoc)
library(tidyverse)
library(grid)

set.seed(123)
N <- 100
xx <- rnorm(N) + rnorm(N, 0, 0.05)
yy <- rnorm(N, xx)

lm(yy ~ xx)

tic()
for (i in 1:1000) model2 <- sma(yy ~ xx)
toc()

tic()
for (i in 1:1000) model <- lm(yy ~ xx)
toc()

tic()
for ( i in 1:1000) {
b1 <- sd(yy) / sd(xx)
b0 <- mean(yy) - b1 * mean(xx)
}
toc()

source("./R/predictdf.R")
source("./R/geom_smooth2.R")
source("./R/stat-sma.R")
#source("./R/stat-smooth-methods.R")
hoge <- tibble(y = yy, x = xx) %>% sma_fun

tibble(yy, xx) %>%
  ggplot(., aes(x = xx, y = yy)) +
  geom_point() +
  stat_sma(se=TRUE) +
  geom_smooth2(method = "lm", se=TRUE, col = "red")

tibble(yy, xx) %>%
  ggplot(., aes(x = xx, y = yy)) +
  geom_point() +
  geom_smooth2(method = "sma", se=TRUE) +
  geom_smooth2(method = "lm", se=TRUE, col = "red")
