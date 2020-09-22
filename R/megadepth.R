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
#' This function is based on blogdown::hugo_cmd() which is available at
#' <https://github.com/rstudio/blogdown/blob/master/R/hugo.R>.
megadepth_cmd <- function(...) {
    system2(find_megadepth(), ...)
}

#' @param input A `character(1)` with the path to the input BAM, BigWig or
#' text file for Megadepth.
#' @export
#' @describeIn megadepth_cmd Run an arbitrary Megadepth command.
#'
#' @references
#' This function is based on the shell_ls() example from cmdfun which is
#' available at <https://snystrom.github.io/cmdfun/index.html>.
#'
#' @importFrom cmdfun cmd_args_dots cmd_list_interp cmd_list_to_flags
#' @examples
#'
#' ## Install if necessary
#' install_megadepth()
#'
#' ## Find version
#' ## megadepth_shell() provides an interface more familiar to R users
#' megadepth_shell(version = TRUE)
#' ## megadepth_cmd requires using directly the command line syntax for
#' ## Megadepth
#' megadepth_cmd("--version", stdout = TRUE)
megadepth_shell <- function(input = ".", ...) {
    # grab arguments passed to "..." in a list
    # prepare list for conversion to vector
    # Convert the list to a flag vector
    flags <- cmdfun::cmd_list_to_flags(cmdfun::cmd_list_interp(cmdfun::cmd_args_dots()),
        prefix = "--"
    )

    # Run ls shell command
    # system2(find_megadepth(), c(input, flags), stdout = TRUE)
    megadepth_cmd(c(input, flags), stdout = TRUE)
}

megadepth_shell2 <- function(input, theArgs) {
    # prepare list for conversion to vector
    # Convert the list to a flag vector
    flags <- cmdfun::cmd_list_to_flags(cmdfun::cmd_list_interp(theArgs),
        prefix = "--"
    )

    # Run ls shell command
    # system2(find_megadepth(), c(input, flags), stdout = TRUE)
    megadepth_cmd(c(input, flags), stdout = TRUE)
}
