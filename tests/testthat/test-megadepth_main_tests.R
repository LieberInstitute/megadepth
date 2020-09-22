# Based on tests at https://github.com/ChristopherWilks/megadepth/blob/master/tests/test.sh

if (FALSE) {
    ## Code for getting the files
    dir.create(here::here("inst", "tests"), showWarnings = FALSE)
    download.file(
        "https://github.com/ChristopherWilks/megadepth/raw/master/tests/test.bam",
        destfile = here::here("inst", "tests", "test.bam"),
        mode = "wb"
    )
    download.file(
        "https://github.com/ChristopherWilks/megadepth/raw/master/tests/test.bam.bai",
        destfile = here::here("inst", "tests", "test.bam.bai"),
        mode = "wb"
    )
    download.file(
        "https://github.com/ChristopherWilks/megadepth/raw/master/tests/test_exons.bed",
        destfile = here::here("inst", "tests", "test_exons.bed"),
        mode = "wb"
    )
    download.file(
        "https://github.com/ChristopherWilks/megadepth/raw/master/tests/testbw2.bed",
        destfile = here::here("inst", "tests", "testbw2.bed"),
        mode = "wb"
    )
}

## Install if necessary
install_megadepth()

## Create test files
megadepth_shell(
    pkg_file("tests", "test.bam"),
    "prefix" = file.path(tempdir(), "test.bam"),
    "threads" = 1,
    "no-head" = TRUE,
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

## Copy test bigwig file to the package dir
if (FALSE) {
    file.copy(file.path(tempdir(), "test.bam.all.bw"), here::here("inst", "tests", "test.bam.all.bw"), overwrite = TRUE)
}

## Run AUC test
test_that("test just total auc", {
    expect_equal(
        megadepth_shell(file.path(tempdir(), "test.bam.all.bw"))[2],
        readLines(
            "https://raw.githubusercontent.com/ChristopherWilks/megadepth/master/tests/testbw1.total_auc"
        )
    )
})


## test bigwig2mean
megadepth_shell(
    file.path(tempdir(), "test.bam.all.bw"),
    "op" = "mean",
    "annotation" = pkg_file("tests", "testbw2.bed"),
    "prefix" = file.path(tempdir(), "bw2.mean"),
    "no-annotation-stdout" = TRUE
)

test_that("test bigwig2mean", {
    expect_equal(
        readLines(file.path(tempdir(), "bw2.mean.annotation.tsv")),
        readLines(
            "https://raw.githubusercontent.com/ChristopherWilks/megadepth/master/tests/testbw2.bed.mean"
        )
    )
    expect_equal(
        read_coverage(file.path(tempdir(), "bw2.mean.annotation.tsv")),
        get_coverage(
            file.path(tempdir(), "test.bam.all.bw"),
            op = "mean",
            annotation = pkg_file("tests", "testbw2.bed"),
            prefix = file.path(tempdir(), "bw2.mean.r")
        )
    )
})
