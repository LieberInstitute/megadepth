# Based on tests at https://github.com/ChristopherWilks/megadepth/blob/master/tests/test.sh

## Install if necessary
install_megadepth()



## Create test files
if (!xfun::is_windows()) {
    ## This currently fails on Windows
    megadepth_shell(
        pkg_file("tests", "test.bam"),
        "prefix" = file.path(tempdir(), "test.bam"),
        "threads" = 1,
        "bigwig" = TRUE,
        "auc" = TRUE,
        "min-unique-qual" = 10,
        "annotation" = pkg_file("tests", "test_exons.bed"),
        "frag-dist" = TRUE,
        "alts" = TRUE,
        "include-softclip" = TRUE,
        "only-polya" = TRUE,
        "read-ends" = TRUE,
        "test-polya" = TRUE,
        "no-annotation-stdout" = TRUE
    )
} else {
    ## Copy the test files
    test_files <-
        dir(pkg_file("tests", "test_output_files"),
            "test.bam",
            full.names = TRUE
        )
    sapply(test_files, file.copy, tempdir())
}

## Run AUC test
total_auc <-
    megadepth_shell(file.path(tempdir(), "test.bam.all.bw"))
test_that("test just total auc", {
    expect_equal(
        total_auc[length(total_auc)],
        readLines(
            "https://raw.githubusercontent.com/ChristopherWilks/megadepth/master/tests/testbw1.total_auc"
        )
    )
})

## test with uniques
test_that("test with uniques", {
    megadepth_shell(
        pkg_file("tests", "test3.bam"),
        "coverage" = TRUE,
        "min-unique-qual" = 10,
        "bigwig" = TRUE,
        "auc" = TRUE,
        "prefix" = file.path(tempdir(), "test3"),
        "no-auc-stdout" = TRUE
    )
    expect_equal(
        readLines(file.path(tempdir(), "test3.auc.tsv")),
        readLines(
            "https://raw.githubusercontent.com/ChristopherWilks/megadepth/master/tests/test3.auc.out.tsv"
        )
    )
})


## test bigwig2mean on remote BW
test_that("test bigwig2mean on remote bw", {
    megadepth_shell(
        "http://stingray.cs.jhu.edu/data/temp/megadepth.test.bam.all.bw",
        "op" = "mean",
        "annotation" = pkg_file("tests", "testbw2.bed"),
        "prefix" = file.path(tempdir(), "bw2.remote.mean"),
        "no-annotation-stdout" = TRUE
    )

    expect_equal(
        readLines(file.path(
            tempdir(), "bw2.remote.mean.annotation.tsv"
        )),
        readLines(
            "https://raw.githubusercontent.com/ChristopherWilks/megadepth/master/tests/testbw2.bed.mean"
        )
    )
})

## only print sums use different order in BED file from what's in BW to test keep_order == true
test_that("test bigwig2mean on local bw", {
    megadepth_shell(
        file.path(tempdir(), "test.bam.all.bw"),
        "--sums-only" = TRUE,
        "annotation" = pkg_file("tests", "testbw2.bed"),
        "prefix" = file.path(tempdir(), "test.bam.bw2"),
        "no-annotation-stdout" = TRUE
    )


    expect_equal(
        readLines(file.path(
            tempdir(), "test.bam.bw2.annotation.tsv"
        )),
        readLines(
            "https://raw.githubusercontent.com/ChristopherWilks/megadepth/master/tests/testbw2.bed.out.tsv"
        )
    )
})
