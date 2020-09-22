#' Run Megadepth commands
#'
#' Wrapper functions to run Megadepth commands via
#' \code{\link{system2}('megadepth', ...)}.
#'
#' @param ... Arguments to be passed to \code{system2('megadepth', ...)}, e.g.
#' \code{annotation(path)} is basically
#' \code{megadepth_cmd(c('--annotation', path))}
#' (i.e. run the command \command{megadepth --annotation path}).
#' @export
#' @describeIn megadepth_cmd Run an arbitrary Megadepth command.
#'
#' @references
#' This function is based on blogdown::hugo_cmd() which is available from
#' <https://github.com/rstudio/blogdown/blob/master/R/hugo.R>.
#'
#' @examples
#'
#' ## Install if necessary
#' install_megadepth()
#'
#' ## Find version
#' megadepth_cmd("--version", stdout = TRUE)
megadepth_cmd <- function(...) {
    system2(find_megadepth(), ...)
}
