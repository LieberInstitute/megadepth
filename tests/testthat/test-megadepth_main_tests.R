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
    download.file(
        "https://github.com/ChristopherWilks/megadepth/raw/master/tests/test3.bam",
        destfile = here::here("inst", "tests", "test3.bam"),
        mode = "wb"
    )
    download.file(
        "https://github.com/ChristopherWilks/megadepth/raw/master/tests/long_reads.bam",
        destfile = here::here("inst", "tests", "long_reads.bam"),
        mode = "wb"
    )
}

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

    if (FALSE) {
        ## Copy test files to the package for the other tests on Windows
        test_files <- dir(tempdir(), "test.bam", full.names = TRUE)
        dir.create(here::here("inst", "tests", "test_output_files"),
            showWarnings = FALSE)
        sapply(test_files,
            file.copy,
            here::here("inst", "tests", "test_output_files/"))
    }
} else {
    ## Copy the test files
    test_files <-
        dir(pkg_file("tests", "test_output_files"),
            "test.bam",
            full.names = TRUE)
    sapply(test_files, file.copy, tempdir())

    ## For trying to debug on Windows
    if (FALSE) {
        manual_cmd <- paste(
            pkg_file("tests", "test.bam"),
            "--prefix",
            file.path(tempdir(), "test.bam"),
            "--threads 1",
            "--bigwig",
            "--auc",
            "--min-unique-qual 10",
            "--annotation ",
            pkg_file("tests", "test_exons.bed"),
            "--frag-dist",
            "--alts",
            "--include-softclip",
            "--only-polya",
            "--read-ends",
            "--test-polya",
            "--no-annotation-stdout"
        )
        megadepth_cmd(manual_cmd)
        paste(find_megadepth(), manual_cmd)
        # C:\\Users\\fellg\\AppData\\Roaming\\Megadepth\\megadepth.exe D:/Dropbox/Code/megadepth/inst/tests/test.bam --prefix C:\\Users\\fellg\\AppData\\Local\\Temp\\RtmpKefDQ8/test.bam --threads 1 --bigwig --auc --min-unique-qual 10 --annotation  D:/Dropbox/Code/megadepth/inst/tests/test_exons.bed --frag-dist --alts --include-softclip --only-polya --read-ends --test-polya --no-annotation-stdout
        ## Error
        # building whole annotation region map done
        # 2 chromosomes for annotated regions read
        # Processing BAM: "D:/Dropbox/Code/megadepth/inst/tests/test.bam"
        # [bwGetOverlappingIntervalsCore] Got an error
        # [bwClose] There was an error while finishing writing a bigWig file! The output is likely truncated.
        # [bwGetOverlappingIntervalsCore] Got an error
        # [bwClose] There was an error while finishing writing a bigWig file! The output is likely truncated.
        # Read 96 records

    }

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



## Copy test bigwig file to the package dir
if (FALSE) {
    file.copy(
        file.path(tempdir(), "test.bam.all.bw"),
        here::here("inst", "tests", "test.bam.all.bw"),
        overwrite = TRUE
    )
}



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
            file.path(tempdir(), "test.bam.all.bw"),
            op = "mean",
            annotation = pkg_file("tests", "testbw2.bed"),
            prefix = file.path(tempdir(), "bw2.mean.r")
        )
    )
})

## test with uniques
megadepth_shell(
    here::here("inst", "tests", "test3.bam"),
    "coverage" = TRUE,
    "min-unique-qual" = 10,
    "bigwig" = TRUE,
    "auc" = TRUE,
    "prefix" = file.path(tempdir(), "test3"),
    "no-auc-stdout" = TRUE
)

test_that("test with uniques", {
    expect_equal(
        readLines(file.path(tempdir(), "test3.auc.tsv")),
        readLines(
            "https://raw.githubusercontent.com/ChristopherWilks/megadepth/master/tests/test3.auc.out.tsv"
        )
    )
})

## test long reads support for junctions
megadepth_shell(
    here::here("inst", "tests", "long_reads.bam"),
    "junctions" = TRUE,
    "prefix" = file.path(tempdir(), "long_reads.bam"),
    "long-reads" = TRUE
)

test_that("test long reads support for junctions", {
    expect_equal(
        readLines(file.path(tempdir(), "long_reads.bam.jxs.tsv")),
        readLines(
            "https://raw.githubusercontent.com/ChristopherWilks/megadepth/master/tests/long_reads.bam.jxs.tsv"
        )
    )
})

# test bigwig2mean on remote BW
megadepth_shell(
    "http://stingray.cs.jhu.edu/data/temp/megadepth.test.bam.all.bw",
    "op" = "mean",
    "annotation" = pkg_file("tests", "testbw2.bed"),
    "prefix" = file.path(tempdir(), "bw2.remote.mean"),
    "no-annotation-stdout" = TRUE
)

test_that("test bigwig2mean on remote bw", {
    expect_equal(
        readLines(file.path(
            tempdir(), "bw2.remote.mean.annotation.tsv"
        )),
        readLines(
            "https://raw.githubusercontent.com/ChristopherWilks/megadepth/master/tests/testbw2.bed.mean"
        )
    )
})

# only print sums use different order in BED file from what's in BW to test keep_order == true
megadepth_shell(
    file.path(tempdir(), "test.bam.all.bw"),
    "--sums-only" = TRUE,
    "annotation" = pkg_file("tests", "testbw2.bed"),
    "prefix" = file.path(tempdir(), "test.bam.bw2"),
    "no-annotation-stdout" = TRUE
)

test_that("test bigwig2mean on remote bw", {
    expect_equal(
        readLines(file.path(
            tempdir(), "test.bam.bw2.annotation.tsv"
        )),
        readLines(
            "https://raw.githubusercontent.com/ChristopherWilks/megadepth/master/tests/testbw2.bed.out.tsv"
        )
    )
})
