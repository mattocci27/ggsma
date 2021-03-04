#' Smoothed conditional means for SMA
#'
#' Aids the eye in seeing patterns in the presence of overplotting.
#' `geom_smooth()` and `stat_smooth()` are effectively aliases: they
#' both use the same arguments. Use `stat_smooth()` if you want to
#' display the results with a non-standard geom.
#'
#' Calculation is performed by the (currently undocumented)
#' `predictdf.sma()`. Confidence intervals are estimated by using Bootstrapping.
#'
#' @param mapping Set of aesthetic mappings created by [aes()] or
#'   [aes_()]. If specified and `inherit.aes = TRUE` (the
#'   default), it is combined with the default mapping at the top level of the
#'   plot. You must supply `mapping` if there is no plot mapping.
#' @param data The data to be displayed in this layer. There are three
#'    options:
#'
#'    If `NULL`, the default, the data is inherited from the plot
#'    data as specified in the call to [ggplot()].
#'
#'    A `data.frame`, or other object, will override the plot
#'    data. All objects will be fortified to produce a data frame. See
#'    [fortify()] for which variables will be created.
#'
#'    A `function` will be called with a single argument,
#'    the plot data. The return value must be a `data.frame`, and
#'    will be used as the layer data. A `function` can be created
#'    from a `formula` (e.g. `~ head(.x, 10)`).
#' @param method Smoothing method (function) to use, accepts either
#'   `NULL` or a character "sma". Both NULL` and "sma" use SMA regression.
#' @param position Position adjustment, either as a string, or the result of
#'  a call to a position adjustment function.
#' @param formula Formula to use in smoothing function, eg. `y ~ x`,
#'   `y ~ poly(x, 2)`, `y ~ log(x)`. `NULL` by default, in which case
#'   `method = NULL` implies `formula = y ~ x` when there are fewer than 1,000
#'   observations and `formula = y ~ s(x, bs = "cs")` otherwise.
#' @param se Display bootstrap confidence interval around smooth? (`TRUE` by default, see
#'   `level` to control.)
#' @param fullrange Should the fit span the full range of the plot, or just
#'   the data?
#' @param level Level of confidence interval to use (0.95 by default).
#' @param n Number of points at which to evaluate smoother.
#' @param nboot Number of bootstraps.
#' @param na.rm If `FALSE`, the default, missing values are removed with
#'   a warning. If `TRUE`, missing values are silently removed.
#' @param show.legend logical. Should this layer be included in the legends?
#'   `NA`, the default, includes if any aesthetics are mapped.
#'   `FALSE` never includes, and `TRUE` always includes.
#'   It can also be a named logical vector to finely select the aesthetics to
#'   display.
#' @param inherit.aes If `FALSE`, overrides the default aesthetics,
#'   rather than combining with them. This is most useful for helper functions
#'   that define both data and aesthetics and shouldn't inherit behaviour from
#'   the default plot specification, e.g. [borders()].
#' @param ... Other arguments passed on to [layer()]. These are
#'   often aesthetics, used to set an aesthetic to a fixed value, like
#'   `colour = "red"` or `size = 3`. They may also be parameters
#'   to the paired geom/stat.
#' @param orientation projection orientation, which defaults to
#'   `c(90, 0, mean(range(x)))`.  This is not optimal for many
#'   projections, so you will have to supply your own. See
#'   [mapproj::mapproject()] for more information.
#' @export
#' @examples
#' ggplot(mpg, aes(displ, hwy)) +
#'   geom_point() +
#'   geom_sma()
geom_sma <- function(mapping = NULL, data = NULL,
                        #stat = "sma",
                        position = "identity",
                        ...,
                        method = "sma",
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
    method = method,
    formula = formula,
    ...
  )
#  if (identical(stat, "sma")) {
    #params$method <- method
    #params$formula <- formula
#  }

  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = StatSMA,
  # stat = stat,
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

