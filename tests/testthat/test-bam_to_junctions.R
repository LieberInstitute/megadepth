## Run test to obtain junctions from a BAM file
test_that("test bam_to_junctions has correct output", {
    bam_to_junctions(pkg_file("tests", "test2.bam"),
        overwrite = TRUE,
        all_junctions = TRUE,
        junctions = TRUE
    )

    expect_equal(
        readLines(file.path(tempdir(), "test2.bam.jxs.tsv")),
        readLines(
            "https://raw.githubusercontent.com/ChristopherWilks/megadepth/master/tests/test2.bam.jxs.tsv"
        )
    )

    expect_equal(
        readLines(file.path(tempdir(), "test2.bam.all_jxs.tsv")),
        readLines(
            "https://raw.githubusercontent.com/ChristopherWilks/megadepth/master/tests/test2.bam.all_jxs.tsv"
        )
    )

    expect_error(
        bam_to_junctions(pkg_file("tests", "test2.bam")),
        "The following files already exist"
    )

    # test changing filter_in/filter_out will remove junctions
    bam_to_junctions(pkg_file("tests", "test2.bam"),
        overwrite = TRUE,
        all_junctions = TRUE,
        junctions = TRUE,
        filter_in = 65536
    )

    expect_equal(
        length(readLines(file.path(tempdir(), "test2.bam.jxs.tsv"))),
        0
    )

    bam_to_junctions(pkg_file("tests", "test2.bam"),
        overwrite = TRUE,
        all_junctions = TRUE,
        junctions = TRUE,
        filter_out = 261
    )

    expect_equal(
        length(readLines(file.path(tempdir(), "test2.bam.jxs.tsv"))),
        0
    )
})

## test long reads support for junctions
test_that("test long reads support for junctions", {
    megadepth_shell(
        pkg_file("tests", "long_reads.bam"),
        "junctions" = TRUE,
        "all_junctions" = FALSE,
        "prefix" = file.path(tempdir(), "long_reads.bam"),
        "long-reads" = TRUE
    )

    bam_to_junctions(
        pkg_file("tests", "long_reads.bam"),
        overwrite = TRUE,
        junctions = TRUE,
        all_junctions = FALSE,
        prefix = file.path(tempdir(), "long_reads.bam.r"),
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
