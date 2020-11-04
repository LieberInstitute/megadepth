test_that("read_junction tests", {
    example_bam <- system.file("tests",
        "test.bam",
        package = "megadepth",
        mustWork = TRUE
    )
    example_jxs <- bam_to_junctions(example_bam, overwrite = TRUE)
    jxs <- read_junction_table(example_jxs)

    weird_jxs_file <- file.path(tempdir(), "weird_jxs_file.tsv")
    write.table(
        cbind(jxs, jxs),
        file = weird_jxs_file,
        col.names = FALSE,
        row.names = FALSE,
        quote = FALSE,
        sep = "\t"
    )

    single_jxs_file <- file.path(tempdir(), "single_jxs_file.tsv")
    single_jxs <- jxs[seq_len(6)]
    single_jxs$strand <- ifelse(single_jxs$strand == "+", 0, 1)
    write.table(
        single_jxs,
        file = single_jxs_file,
        col.names = FALSE,
        row.names = FALSE,
        quote = FALSE,
        sep = "\t"
    )


    expect_equal(
        colnames(jxs)[seq_len(6)],
        gsub("mate_", "", colnames(jxs)[seq_len(6) + 6])
    )
    expect_warning(
        read_junction_table(weird_jxs_file),
        "different from the expected output of 6 or 12 fields"
    )
    expect_equivalent(
        read_junction_table(single_jxs_file),
        jxs[seq_len(6)]
    )
})
