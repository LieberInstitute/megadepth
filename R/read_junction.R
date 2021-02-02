#' Read a junction TSV file created by Megadepth as a table
#'
#' Read an `*all_jxs.tsv` or `*jxs.tsv` file created by `bam_to_junctions()` or
#' manually by the user using Megadepth. The rows of a `*jxs.tsv` can have
#' either 7 or 14 columns, which can lead to warnings when reading in - these
#' are safe to ignore. For details on the format of the input TSV file, check
#' <https://github.com/ChristopherWilks/megadepth#junctions>.
#'
#' @param tsv_file A `character(1)` specifying the path to the tab-separated
#'   (TSV) file created manually using `megadepth_shell()` or on a previous
#'   `bam_to_junctions()` run.
#'
#' @importFrom readr read_delim
#' @return A `tibble::tibble()` with the junction data that follows the format
#'   specified at <https://github.com/ChristopherWilks/megadepth#junctions>.
#' @export
#'
#' @examples
#'
#' ## Install if necessary
#' install_megadepth()
#'
#' ## Find the example BAM file
#' example_bam <- system.file("tests", "test.bam",
#'     package = "megadepth", mustWork = TRUE
#' )
#'
#' ## Run bam_to_junctions()
#' example_jxs <- bam_to_junctions(example_bam, overwrite = TRUE)
#'
#' ## Read the junctions in as a tibble
#' all_jxs <- read_junction_table(example_jxs[["all_jxs.tsv"]])
#'
#' all_jxs
read_junction_table <- function(tsv_file) {

    # define the expected column names and types
    if (grepl("all_jxs.tsv", tsv_file)) {
        col_names <- c(
            "read_name",
            "chr",
            "start",
            "end",
            "mapping_strand",
            "cigar",
            "unique"
        )

        col_types <- c("dcddici")
    } else if (grepl("jxs.tsv", tsv_file)) {
        col_names <- c(
            "chr_id",
            "POS_field",
            "mapping_strand",
            "insert_length",
            "cigar",
            "junction_coords",
            "unique",
            "mate_ref_id",
            "mate_POS_field",
            "mate_mapping_strand",
            "mate_insert_length",
            "mate_cigar",
            "mate_junction_coords",
            "mate_unique"
        )

        col_types <- c("ciidcciciidcci")
    } else {
        stop('tsv_file must have the extension "all_jxs.tsv" or "jxs.tsv"')
    }

    # load in the junctions
    jxs <- read_delim(
        tsv_file,
        delim = "\t",
        progress = FALSE,
        col_names = col_names,
        col_types = col_types,
    )

    ## Translate the strand into the format used in Bioconductor
    for (i in seq_along(jxs)) {
        if (grepl("strand", colnames(jxs[i]))) {
            jxs[[i]] <- ifelse(jxs[[i]] == 0, "+", "-")
        }
    }

    return(jxs)
}
