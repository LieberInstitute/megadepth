#' Read a coverage TSV file created by Megadepth
#'
#' Read an `*annotation.tsv` file created by `get_coverage()` or manually by
#' the user using Megadepth.
#'
#' @param tsv_file A `character(1)` specifying the path to the tab-separated
#' (TSV) file created manually using `megadepth_shell()` or on a previous
#' `get_coverage()` run.
#' @param verbose A `logical(1)` controlling whether to suppress messages when
#' reading the data.
#'
#' @return A [GRanges-class][GenomicRanges::GRanges-class] object with the
#' coverage summarization across the annotation ranges.
#' @export
#' @family Coverage functions
#' @importFrom GenomicRanges GRanges
#' @importFrom readr read_delim cols
#'
#' @examples
#'
#' ## For RleList, equivalent to rtracklayer::import.bw(as = "RleList")
#' ## GenomicRanges::coverage(x, weights = "cov")
read_coverage <- function(tsv_file, verbose = TRUE) {
    if (verbose) {
        coverage <- read_coverage_internal(tsv_file)
    } else {
        suppressMessages(coverage <- read_coverage_internal(tsv_file))
    }
    return(coverage)
}

read_coverage_internal <- function(tsv_file) {
    coverage <- readr::read_delim(
        tsv_file,
        delim = "\t",
        col_names = c("chr", "start", "end", "cov"),
        col_types = readr::cols(
            chr = "c",
            start = "i",
            end = "i",
            cov = "n"
        ),
        progress = FALSE
    )

    ## Cast into a GRanges object
    coverage <- GenomicRanges::GRanges(coverage)
    return(coverage)
}
