#' Convert a BAM file to a BigWig
#'
#' Given an input BAM file, convert this to the BigWig format which can then be
#' used in `get_coverage`.
#'
#' @param bam_file A `character(1)` with the path to the input BAM file.
#' @param prefix A `character(1)` specifying the output file prefix. This
#'   function creates a file called `prefix.all.bw` that can be read again later
#'   with `read_coverage()`. By default, the prefix is the BAM file name and the
#'   file is created in the `tempdir()` and will be deleted after you close your
#'   R session.
#' @param min_unique_qual A `integer(1)` specifying a mapping quality threshold
#'   and only bases above this will be used to generate the BigWig.
#' @param double_count A `logical(1)` determining whether to count the
#'   overlapping ends of paired ends reads twice.
#'
#' @return A `character(1)` with the path to the generated BigWig file.
#' @export
#'
#' @examples
#'
#' ## Install if necessary
#' install_megadepth()
#'
#' ## Intialise path to the example BAM file
#' example_bam <- system.file("tests", "test.bam",
#'     package = "megadepth", mustWork = TRUE
#' )
#'
#' example_bw <- bam_to_bigwig(example_bam)
#'
#' ## print path to generated BigWig
#' example_bw
bam_to_bigwig <- function(bam_file,
    prefix = file.path(tempdir(), paste0(basename(bam_file))),
    min_unique_qual = 10,
    double_count = FALSE) {
    megadepth_shell2(
        bam_file,
        list(
            "prefix" = prefix,
            "bigwig" = TRUE,
            "min-unique-qual" = min_unique_qual,
            "double-count" = double_count
        )
    )

    return(prefix)
}
