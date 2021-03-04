#' SMA lines
#'
#' Functions for obtaining the density, random deviates and maximum likelihood
#' estimates of the zero-truncated Poisson lognormal distributions and their
#' mixtures.
#'
#' @author Masatoshi Katabuchi <mattocci27@gmail.com> 
#'
#' @references Warton, David I., Ian J. Wright, Daniel S. Falster, and Mark Westoby. 2006. Bivariate Line-Fitting Methods for Allometry. Biological Reviews 81: 259–91.
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

