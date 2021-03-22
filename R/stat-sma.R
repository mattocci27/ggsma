## #' @inheritParams geom_sma
#' @rdname geom_sma
#' @export
stat_sma <- function(mapping = NULL, data = NULL,
                        position = "identity",
                        ...,
                        method = "sma",
                      #  geom = "sma",
                        formula = NULL,
                        se = TRUE,
                        n = 80,
                        nboot = 1000,
                        fullrange = FALSE,
                        level = 0.95,
                        #method.args = list(),
                        na.rm = FALSE,
                        show.sig.only = FALSE,
                        orientation = NA,
                        show.legend = NA,
                        inherit.aes = TRUE) {

  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = StatSMA,
    geom = GeomSMA,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      method = method,
      formula = formula,
      se = se,
      n = n,
      show.sig.only = show.sig.only,
      nboot = nboot,
      fullrange = fullrange,
      level = level,
      na.rm = na.rm,
      orientation = orientation,
    #  method.args = method.args,
      ...
    )
  )
}


StatSMA <- ggplot2::ggproto("StatSMA", Stat,
  setup_params = function(data, params) {
    params$flipped_aes <- has_flipped_aes(data, params, ambiguous = TRUE)
    msg <- character()
    #if (is.null(params$method) || identical(params$method, "auto")) {
    #  # Use loess for small datasets, gam with a cubic regression basis for
    #  # larger. Based on size of the _largest_ group to avoid bad memory
    #  # behaviour of loess
    #  max_group <- max(table(interaction(data$group, data$PANEL, drop = TRUE)))

    #if (identical(stat, StatSMA)) {
    ##if (identical(stat, "sma")) {
    #  message("helllo")
    #  params$method <- "sma"
    #}

      #msg <- c(msg, paste0("method = '", params$method, "'"))
      msg <- "method = 'sma'"
        #c(msg, paste0("method = '", params$method, "'"))
    #}

    if (is.null(params$formula)) {
        params$formula <- y ~ x
        msg <- c(msg, paste0("formula '", deparse(params$formula), "'"))
    }
    if (params$method != "sma") {
      message("`stat_sma()` only uses sma (Standardized Major Axis)
              ")
      message("please use `ggplot2::stat_smooth()` or `ggplot2::geom_smooth()` for other models")
      params$method <- "sma"
    }

    if (length(msg) > 0) {
      message("`stat_sma()` using ", paste0(msg, collapse = " and "))
    }

    params
  },

  extra_params = c("na.rm", "orientation"),

  compute_group = function(data, scales, method = NULL, formula = NULL,
                           se = TRUE, n = 80, nboot = 1000, fullrange = FALSE,
                           xseq = NULL, level = 0.95, show.sig.only = show.sig.only, show.sig.pval = 0.05, method.args = list(),
                           na.rm = FALSE, flipped_aes = NA) {
    data <- flip_data(data, flipped_aes)
    if (length(unique(data$x)) < 2) {
      # Not enough data to perform fit
      return(new_data_frame())
    }

    if (is.null(data$weight)) data$weight <- 1

    if (is.null(xseq)) {
      if (is.integer(data$x)) {
        if (fullrange) {
          xseq <- scales$x$dimension()
        } else {
          xseq <- sort(unique(data$x))
        }
      } else {
        if (fullrange) {
          range <- scales$x$dimension()
        } else {
          range <- range(data$x, na.rm = TRUE)
        }
        xseq <- seq(range[1], range[2], length.out = n)
      }
    }

     # method <- smatr::sma
     # method.args$method <- "SMA"

     # base.args <- list(quote(formula), data = quote(data), weights = quote(weight))
     # model <- do.call(method, c(base.args, method.args))

     # sma_fun(data) %>% print

      prediction <- predictdf.sma(data, xseq, se, show.sig.only, show.sig.pval, level, nboot)
      prediction$flipped_aes <- flipped_aes
      flip_data(prediction, flipped_aes)
  },

  required_aes = c("x", "y")
)

