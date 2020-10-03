#' Compute coverage summarizations across a set of regions
#'
#' Given an input set of annotation regions, compute coverage summarizations
#' using Megadepth for a given BigWig file.
#'
#' Note that the chromosome names (seqnames) in the BigWig file and the
#' annotation file should use the same format. Otherwise, Megadepth will
#' return 0 counts.
#'
#' @param bigwig_file A `character(1)` with the path to the input BigWig file.
#' @param op A `character(1)` specifying the summarization operation to
#' perform.
#' @param annotation A `character(1)` path to a BED file with the genomic
#' coordinates you are interested in.
#' @param prefix A `character(1)` specifying the output file prefix. This
#' function creates a file called `prefix.annotation.tsv` that can be read
#' again later with `read_coverage()`. By default the file is created in
#' the `tempdir()` and will be deleted after you close your R session.
#'
#' @return A [GRanges-class][GenomicRanges::GRanges-class] object with the
#' coverage summarization across the annotation ranges.
#' @export
#' @family Coverage functions
#'
#' @examples
#'
#' ## Install if necessary
#' install_megadepth()
#'
#' ## Next, we locate the example BigWig and annotation files
#' example_bw <- system.file("tests", "test.bam.all.bw",
#'     package = "megadepth", mustWork = TRUE
#' )
#' annotation_file <- system.file("tests", "testbw2.bed",
#'     package = "megadepth", mustWork = TRUE
#' )
#'
#' ## Compute the coverage
#' bw_cov <- get_coverage(example_bw, op = "mean", annotation = annotation_file)
#' bw_cov
#'
#' ## If you want to cast this into a RleList object use the following code:
#' ## (it's equivalent to rtracklayer::import.bw(as = "RleList"))
#' ## although in the megadepth case the data has been summarized
#' GenomicRanges::coverage(bw_cov)
#'
#' ## Checking with derfinder and rtracklayer
#' bed <- rtracklayer::import(annotation_file)
#'
#' ## The file needs a name
#' names(example_bw) <- "example"
#'
#' ## Read in the base-pair coverage data
#' if( !xfun::is_windows()) {
#' regionCov <- derfinder::getRegionCoverage(
#'     regions = bed,
#'     files = example_bw,
#'     verbose = FALSE
#' )
#'
#' ## Summarize the base-pair coverage data.
#' ## Note that we have to round the mean to make them comparable.
#' testthat::expect_equivalent(
#'     round(sapply(regionCov[c(1, 3:4, 2)], function(x) mean(x$value)), 3),
#'     bw_cov$score,
#' )
#'
#' ## If we compute the sum, there's no need to round
#' testthat::expect_equivalent(
#'     sapply(regionCov[c(1, 3:4, 2)], function(x) sum(x$value)),
#'     get_coverage(example_bw, op = "sum", annotation = annotation_file)$score,
#' )
#' }
get_coverage <-
    function(bigwig_file,
    op = c("sum", "mean", "max", "min"),
    annotation,
    prefix = file.path(tempdir(), "bw.mean")) {
        megadepth_shell2(
            bigwig_file,
            list(
                "op" = match.arg(op),
                "annotation" = annotation,
                "prefix" = prefix,
                "no-annotation-stdout" = TRUE
            )
        )
        read_coverage(paste0(prefix, ".annotation.tsv"))
    }
