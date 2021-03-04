#' SMA lines
#'
#' Functions for obtaining the density, random deviates and maximum likelihood
#' estimates of the zero-truncated Poisson lognormal distributions and their
#' mixtures.
#'
#' @author Masatoshi Katabuchi <mattocci27@gmail.com> 
#'
#' @references Bulmer, M. G. 1974. On Fitting the Poisson Lognormal Distribution to Species-Abundance Data. Biometrics 30:101-110.
#'
#' @keywords internal
"_PACKAGE"

#' @import ggplot2
#' @import dplyr
#' @importFrom modelr bootstrap
#' @importFrom purrr map_dfc
#' @importFrom stats fitted quantile sd cor
#' @importFrom utils globalVariables
#' @importFrom magrittr %>%
#' @export
magrittr::`%>%`
NULL


