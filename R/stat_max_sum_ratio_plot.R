

StatMaxSum <-  ggproto("StatMaxSum", Stat,
        default_aes = aes(y = after_stat(ratio), x = after_stat(x),
                          group = after_stat(moments),
                          color = after_stat(moments)),

        required_aes = c("sample"),
        compute_group = function(data, scales, p = 4) {
          x=abs(data$sample)
          moments = list()
          for (i in 1:p) {
            y=x^i
            S=cumsum(y)
            M=cummax(y)
            R=M/S
            moments[[i]] = R
          }
          df <- data.frame(x = 1:length(x), do.call(cbind, moments))
          df.long <- reshape(df, direction = "long", varying = 2:ncol(df), v.names = "ratio", timevar = "moments")
          df.long$moments <- factor(df.long$moments)
          df.long[, 1:3]
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
#' @param p
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
stat_max_sum_ratio_plot <- function(mapping = NULL, data = NULL, geom = "step",
                             position = "identity", na.rm = FALSE, show.legend = NA,
                             inherit.aes = TRUE, p = 4, ...) {
  ggplot2::layer(
    stat = StatMaxSum, data = data, mapping = mapping, geom = geom,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(p = p, na.rm = na.rm, ...)
  )
}
