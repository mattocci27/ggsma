
# Smooth lines for Standard Major Axis Regression

![R-CMD-check](https://github.com/mattocci27/ggsma/workflows/R-CMD-check/badge.svg?branch=master)

``` r
devtools::install_github("mattocci27/ggsma")
```

``` r
library(ggsma)
library(smatr)

data(leaflife)
leaf_low <- leaflife %>%
  filter(soilp == "low")

ggplot(leaflife, aes(lma, longev)) +
  geom_point() +
  geom_sma() +
  geom_smooth(method = "lm", col = "red") 
```

    ## `stat_sma()` using method = 'sma' and formula 'y ~ x'

    ## `geom_smooth()` using formula 'y ~ x'

![](README_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->
