#' Smoothed conditional means
#'
#' Aids the eye in seeing patterns in the presence of overplotting.
#' `geom_smooth()` and `stat_smooth()` are effectively aliases: they
#' both use the same arguments. Use `stat_smooth()` if you want to
#' display the results with a non-standard geom.
#'
#' Calculation is performed by the (currently undocumented)
#' `predictdf()` generic and its methods.  For most methods the standard
#' error bounds are computed using the [predict()] method -- the
#' exceptions are `loess()`, which uses a t-based approximation, and
#' `glm()`, where the normal confidence interval is constructed on the link
#' scale and then back-transformed to the response scale.
#'
#'
#' @param geom,stat Use to override the default connection between
#'   `geom_smooth()` and `stat_smooth()`.
#' @seealso See individual modelling functions for more details:
#'   [lm()] for linear smooths,
#'   [glm()] for generalised linear smooths, and
#'   [loess()] for local smooths.
#' @export
#' @examples
#' ggplot(mpg, aes(displ, hwy)) +
#'   geom_point() +
#'   geom_sma()
geom_sma <- function(mapping = NULL, data = NULL,
                        stat = "sma",
                        position = "identity",
                        ...,
                        method = NULL,
                        formula = NULL,
                        se = TRUE,
                        na.rm = FALSE,
                        orientation = NA,
                        show.legend = NA,
                        inherit.aes = TRUE) {

  params <- list(
    na.rm = na.rm,
    orientation = orientation,
    se = se,
    ...
  )
  if (identical(stat, "sma")) {
    params$method <- method
    params$formula <- formula
  }

  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = StatSMA,
    geom = GeomSMA,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = params
  )
}

GeomSMA <- ggplot2::ggproto("GeomSMA", Geom,
  setup_params = function(data, params) {
    params$flipped_aes <- has_flipped_aes(data, params, range_is_orthogonal = TRUE, ambiguous = TRUE)
    params
  },

  extra_params = c("na.rm", "orientation"),

  setup_data = function(data, params) {
    ggplot2::GeomLine$setup_data(data, params)
  },

  draw_group = function(data, panel_params, coord, se = FALSE, flipped_aes = FALSE) {
    ribbon <- transform(data, colour = NA)
    path <- transform(data, alpha = NA)

    ymin = flipped_names(flipped_aes)$ymin
    ymax = flipped_names(flipped_aes)$ymax
    has_ribbon <- se && !is.null(data[[ymax]]) && !is.null(data[[ymin]])

    grid::gList(
      if (has_ribbon) ggplot2::GeomRibbon$draw_group(ribbon, panel_params, coord, flipped_aes = flipped_aes),
      ggplot2::GeomLine$draw_panel(path, panel_params, coord)
    )
  },

  draw_key = ggplot2::draw_key_smooth,

  required_aes = c("x", "y"),
  optional_aes = c("ymin", "ymax"),

  default_aes = aes(colour = "#3366FF", fill = "grey60", size = 1,
    linetype = 1, weight = 1, alpha = 0.4)
)

