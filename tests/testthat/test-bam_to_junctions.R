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
