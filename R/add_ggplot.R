#' Create an HTML fragment for an embedded ggplot image
#'
#' Add an ggplot plot inside the body of the email with this helper function.
#' @param plot_object The `ggplot2` plot object.
#' @param height The height of the output plot in inches.
#' @param width The width of the output plot in inches.
#' @param alt Text description of image passed to the `alt` attribute inside of the image (`<img>`) tag
#'     for use when image loading is disabled and on screen readers. Defaults to the `ggplot2` plot object's
#'     title, if exists. Override by passing a custom character string or `""` for no text.
#' @return A character object with an HTML fragment that can be placed inside
#'   the message body wherever the plot image should appear.
#' @examples
#' library(ggplot2)
#'
#' # Create a ggplot plot
#' plot <-
#'   ggplot(
#'     data = mtcars,
#'     aes(x = disp, y = hp,
#'         color = wt, size = mpg)) +
#'   geom_point()
#'
#' # Create an HTML fragment that
#' # contains an the ggplot as an
#' # embedded plot
#' plot_html <-
#'   add_ggplot(
#'     plot_object = plot)
#'
#' # Include the plot in the email
#' # message body by simply referencing
#' # the `plot_html` object
#' email <-
#'   compose_email(
#'   body = "
#'   Hello!
#'
#'   Here is a very important plot \\
#'   that will change the way you \\
#'   look at cars forever.
#'
#'   {plot_html}
#'
#'   Thanks.
#'   ")
#' @export
add_ggplot <- function(plot_object,
                       width = 5,
                       height = 5,
                       alt = NULL) {

  # nocov start

  # If the `ggplot2` package is available, then
  # use the `ggplot2::ggsave()` function
  if (requireNamespace("ggplot2", quietly = TRUE)) {

    ggplot2::ggsave(
      device = "png",
      plot = plot_object,
      filename = "temp_ggplot.png",
      dpi = 100,
      width = width,
      height = height)

  } else {
    stop("Please ensure that the `ggplot2` package is installed before using `add_ggplot()`.",
         call. = FALSE)
  }

  Sys.sleep(2)

  # Determine alt text
  alt_text <-
    if (is.null(alt)) {
      plot_object$labels$title
    } else {
      alt
    }

  image_html <-
    add_image(file = "temp_ggplot.png", alt = alt_text)

  file.remove("temp_ggplot.png")

  image_html

  # nocov end
}
