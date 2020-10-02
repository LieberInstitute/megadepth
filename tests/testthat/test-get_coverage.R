## Install if necessary
install_megadepth()

## test bigwig2mean
test_that("test bigwig2mean", {
    megadepth_shell(
        pkg_file("tests", "test.bam.all.bw"),
        "op" = "mean",
        "annotation" = pkg_file("tests", "testbw2.bed"),
        "prefix" = file.path(tempdir(), "bw2.mean"),
        "no-annotation-stdout" = TRUE
    )

    expect_equal(
        readLines(file.path(
            tempdir(), "bw2.mean.annotation.tsv"
        )),
        readLines(
            "https://raw.githubusercontent.com/ChristopherWilks/megadepth/master/tests/testbw2.bed.mean"
        )
    )
    expect_equal(
        read_coverage(file.path(
            tempdir(), "bw2.mean.annotation.tsv"
        )),
        get_coverage(
            pkg_file("tests", "test.bam.all.bw"),
            op = "mean",
            annotation = pkg_file("tests", "testbw2.bed"),
            prefix = file.path(tempdir(), "bw2.mean.r")
        )
    )
})
