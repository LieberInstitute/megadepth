% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_junction.R
\name{process_junction_table}
\alias{process_junction_table}
\title{Process junctions into a STAR compatible format}
\usage{
process_junction_table(all_jxs)
}
\arguments{
\item{all_jxs}{A \code{tibble::tibble()} containing junction data ("all.jxs.tsv")
generated by \code{bam_to_junctions(all_junctions = TRUE)} and imported through
\code{megadepth::read_junction_table()}.}
}
\value{
Processed junctions in a STAR-compatible format.
}
\description{
Parses the junctions outputted from \code{process_junction_table()} into an STAR
compatible format (SJ.out) for more convenient use in downstream analyses.
The columns strand, intron_motif and annotated will always be 0 (undefined)
but can be derived through extracting the dinucleotide motifs for the given
reference coordinates for canonical motifs. This function is an
R-implementation of the Megadepth helper script, on which further details of
column definitions can be found:
\url{https://github.com/ChristopherWilks/megadepth#junctions}.
}
\examples{

## Install if necessary
install_megadepth()

## Find the example BAM file
example_bam <- system.file("tests", "test.bam",
    package = "megadepth", mustWork = TRUE
)

## Run bam_to_junctions()
example_jxs <- bam_to_junctions(example_bam, overwrite = TRUE)

## Read the junctions in as a tibble
all_jxs <- read_junction_table(example_jxs[["all_jxs.tsv"]])

## Process junctions into a STAR-compatible format
processed_jxs <- process_junction_table(all_jxs)

processed_jxs
}
