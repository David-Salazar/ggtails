

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
#'
#' @examples
stat_mean_excess <- function(mapping = NULL, data = NULL, geom = "point",
                             position = "identity", na.rm = FALSE, show.legend = NA,
                             inherit.aes = TRUE, ...) {
  ggplot2::layer(
    stat = StatMeanExcess, data = data, mapping = mapping, geom = geom,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}



StatMeanExcess <- ggplot2::ggproto("StatMeanExcess", ggplot2::Stat,
                                   default_aes = ggplot2::aes(y = ggplot2::after_stat(mean_excess),
                                                              x = ggplot2::after_stat(threshold)),

                                   required_aes = c("sample"),
                                   compute_group = function(data, scales, omit = 3) {
                                     data <- as.numeric(data$sample)
                                     n <- length(data)
                                     myrank <- function(x, na.last = TRUE) {
                                       ranks <- sort.list(sort.list(x, na.last = na.last))
                                       if (is.na(na.last))
                                         x <- x[!is.na(x)]
                                       for (i in unique(x[duplicated(x)])) {
                                         which <- x == i & !is.na(x)
                                         ranks[which] <- max(ranks[which])
                                       }
                                       ranks
                                     }
                                     data <- sort(data)
                                     n.excess <- unique(floor(length(data) - myrank(data)))
                                     points <- unique(data)
                                     nl <- length(points)
                                     n.excess <- n.excess[-nl]
                                     points <- points[-nl]
                                     excess <- cumsum(rev(data))[n.excess] - n.excess * points
                                     y <- excess/n.excess
                                     xx <- points[1:(nl - omit)]
                                     yy <- y[1:(nl - omit)]
                                     data.frame(threshold = xx, mean_excess = yy)
                                   }
)
