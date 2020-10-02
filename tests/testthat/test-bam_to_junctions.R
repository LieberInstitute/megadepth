## Install if necessary
install_megadepth()

## Run test to obtain junctions from a BAM file
test_that("test long reads support for junctions", {
    bam_to_junctions(pkg_file("tests", "test2.bam"), overwrite = TRUE)

    expect_equal(
        readLines(file.path(tempdir(), "test2.bam.jxs.tsv")),
        readLines(
            "https://raw.githubusercontent.com/ChristopherWilks/megadepth/master/tests/test2.bam.jxs.tsv"
        )
    )
    expect_error(
        bam_to_junctions(pkg_file("tests", "test2.bam")),
        "The following files already exist"
    )
})

## test long reads support for junctions
test_that("test long reads support for junctions", {
    megadepth_shell(
        pkg_file("tests", "long_reads.bam"),
        "junctions" = TRUE,
        "prefix" = file.path(tempdir(), "long_reads.bam"),
        "long-reads" = TRUE
    )

    bam_to_junctions(
        pkg_file("tests", "long_reads.bam"),
        "prefix" = file.path(tempdir(), "long_reads.bam.r"),
        long_reads = TRUE
    )

    expect_equal(
        readLines(file.path(tempdir(), "long_reads.bam.jxs.tsv")),
        readLines(
            "https://raw.githubusercontent.com/ChristopherWilks/megadepth/master/tests/long_reads.bam.jxs.tsv"
        )
    )

    expect_equal(
        readLines(file.path(tempdir(), "long_reads.bam.jxs.tsv")),
        readLines(file.path(
            tempdir(), "long_reads.bam.r.jxs.tsv"
        ))
    )
})
