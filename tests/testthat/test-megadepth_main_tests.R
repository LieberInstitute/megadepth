# Based on tests at https://github.com/ChristopherWilks/megadepth/blob/master/tests/test.sh

if(FALSE) {
    ## Code for getting the files
    dir.create(here::here("inst", "tests"), showWarnings = FALSE)
    download.file("https://github.com/ChristopherWilks/megadepth/raw/master/tests/test.bam", destfile = here::here("inst", "tests", "test.bam"), mode = "wb")
    download.file("https://github.com/ChristopherWilks/megadepth/raw/master/tests/test.bam.bai", destfile = here::here("inst", "tests", "test.bam.bai"), mode = "wb")
    download.file("https://github.com/ChristopherWilks/megadepth/raw/master/tests/test_exons.bed", destfile = here::here("inst", "tests", "test_exons.bed"), mode = "wb")
}

## Create test files
megadepth_shell(
    pkg_file("inst", "tests", "test.bam"),
    "prefix" = file.path(tempdir(), "test.bam"),
    "threads" = 1,
    "no-head" = TRUE,
    "bigwig" = TRUE,
    "auc" = TRUE,
    "min-unique-qual" = 10,
    "annotation" = pkg_file("inst", "tests", "test_exons.bed"),
    "frag-dist" = TRUE,
    "alts" = TRUE,
    "include-softclip" = TRUE,
    "only-polya" = TRUE,
    "read-ends" = TRUE,
    "test-polya" = TRUE,
    "no-annotation-stdout" = TRUE
)

## Run AUC test
test_that("check AUC test", {
    expect_equal(
        megadepth_shell(file.path(tempdir(), "test.bam.all.bw"))[2],
        readLines(
            "https://raw.githubusercontent.com/ChristopherWilks/megadepth/master/tests/testbw1.total_auc"
        )
    )
})
