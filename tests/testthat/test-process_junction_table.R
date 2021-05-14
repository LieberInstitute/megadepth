test_that("read_junction_table has correct output", {
    example_bam <- system.file("tests",
        "test2.bam",
        package = "megadepth",
        mustWork = TRUE
    )

    example_jxs <- bam_to_junctions(example_bam, overwrite = TRUE, junctions = TRUE)
    all_jxs <- read_junction_table(example_jxs[["all_jxs.tsv"]])

    expect_equal(
        all_jxs,
        read_junction_table(
            "https://raw.githubusercontent.com/ChristopherWilks/megadepth/master/tests/test2.bam.all_jxs.tsv"
        )
    )

    suppressWarnings(expr = {
        jxs <- read_junction_table(example_jxs[["jxs.tsv"]])
        chris_jxs <- read_junction_table(
            "https://raw.githubusercontent.com/ChristopherWilks/megadepth/master/tests/test2.bam.jxs.tsv"
        )
    })

    # remove the "problems" attribute
    # which stores the warning that some rows have 7 cols
    # this differs between the two objects as path to the files are different
    attr(jxs, "problems") <- NULL
    attr(chris_jxs, "problems") <- NULL

    expect_equal(jxs, chris_jxs)
})
