

StatZipf <- ggproto("StatZipf", Stat,
                    default_aes = aes(y = after_stat(survival), x = after_stat(x)),

                    required_aes = c("sample"),
                    compute_group = function(data, scales) {
                      x <- sort(as.numeric(data$sample))
                      survival <- 1 - ppoints(data$sample)
                      data.frame(x, survival)
                    }
)

#' Title
#'
#' @param mapping
#' @param data
#' @param geom
#' @param position
#' @param na.rm
#' @param show.legend
#' @param inherit.aes
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
stat_zipf <- function(mapping = NULL, data = NULL, geom = "point",
                      position = "identity", na.rm = FALSE, show.legend = NA,
                      inherit.aes = TRUE, ...) {
  layer(
    stat = StatZipf, data = data, mapping = mapping, geom = geom,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}

