#' Read a junction TSV file created by Megadepth as a table
#'
#' Read an `*jxs.tsv` file created by `bam_to_junctions()` or manually by
#' the user using Megadepth.
#'
#' @param tsv_file A `character(1)` specifying the path to the tab-separated
#' (TSV) file created manually using `megadepth_shell()` or on a previous
#' `bam_to_junctions()` run.
#'
#' @importFrom readr read_delim
#' @return A `tibble::tibble()` with the junction data that follows the format
#' specified at
#' <https://github.com/ChristopherWilks/megadepth#megadepth-pathtobamfile---junctions>.
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
#' # ## Read the data as a tibble using the format specified at
#' # ## https://github.com/ChristopherWilks/megadepth#megadepth-pathtobamfile---junctions
#' # read_junction_table(example_jxs)
read_junction_table <- function(tsv_file) {
    suppressMessages(
        header <- readr::read_delim(
            tsv_file,
            delim = "\t",
            progress = FALSE,
            n_max = 1,
            col_names = FALSE
        )
    )

    ## The output might have 6 or 12 columns
    ## https://github.com/ChristopherWilks/megadepth#megadepth-pathtobamfile---junctions
    if (!ncol(header) %in% c(6, 12)) {
        warning(
            "Looks like the number of columns in:\n",
            tsv_file,
            "\n is different from the expected output of 6 or 12 fields",
            "(single or paired-end data).",
            call. = FALSE
        )
        ## Try reading it anyway
        return(
            readr::read_delim(
                tsv_file,
                delim = "\t",
                progress = FALSE,
                col_names = FALSE
            )
        )
    }

    ## Define the expected columns and classes
    col_names <- c("chr", "pos", "strand", "insert_length", "cigar", "coords")
    col_names <- c(col_names, paste0("mate_", col_names))
    col_class <- setNames(rep(c("c", "i", "i", "i", "c", "c"), 2), col_names)

    ## Limit to the number of columns present
    col_names <- col_names[seq_len(ncol(header))]
    col_class <- col_class[seq_len(ncol(header))]

    ## Read the junctions
    jxs <- readr::read_delim(
        tsv_file,
        delim = "\t",
        col_names = col_names,
        col_types = col_class,
        progress = FALSE
    )

    ## Translate the strand into the format used in Bioconductor
    for (i in c("strand", "mate_strand")[c("strand", "mate_strand") %in% colnames(jxs)]) {
        jxs[[i]] <- ifelse(jxs[[i]] == 0, "+", "-")
    }

    return(jxs)
}
