pkg_file <- function(..., mustWork = TRUE) {
    system.file(..., package = "megadepth", mustWork = mustWork)
}
