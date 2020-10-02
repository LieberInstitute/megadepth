#' Extract junctions from a BAM file
#'
#' Given a BAM file, extract junction information including co-ordinates,
#' strand, anchor length for each junction read.
#'
#' @inheritParams bam_to_bigwig
#'
#' @param prefix A `character(1)` specifying the output file prefix. This
#'   function creates a file called `prefix.jxs.tsv`. By default, the prefix is
#'   the BAM file name and the file is created in the `tempdir()` and will be
#'   deleted after you close your R session.
#' @param long_reads A `logical(1)` indicating whether to increase the buffer
#'   size to accommodate for long-read RNA-sequencing.
#'
#' @return A `character(1)` with the path to the generated junctions TSV file.
#' @export
#'
#' @examples
#'
#' ## Install if necessary
#' install_megadepth()
#'
#' if (!exists("example_bam")) {
#'     ## Intialise path to the example BAM file
#'     example_bam <- system.file("tests", "test.bam",
#'         package = "megadepth", mustWork = TRUE
#'     )
#' }
#'
#' example_jxs <- bam_to_junctions(example_bam)
#'
#' ## print path to generated BigWig
#' example_jxs
bam_to_junctions <- function(bam_file,
    prefix = file.path(tempdir(), paste0(basename(bam_file))),
    long_reads = FALSE) {
    megadepth_shell2(
        bam_file,
        list(
            "prefix" = prefix,
            "junctions" = TRUE,
            "long-reads" = long_reads
        )
    )

    return(prefix)
}
