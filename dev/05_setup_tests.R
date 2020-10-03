## Code for getting the files
dir.create(here::here("inst", "tests"), showWarnings = FALSE)

test_files <- c(
    "test.bam",
    "test.bam.bai",
    "test_exons.bed",
    "testbw2.bed",
    "test3.bam",
    "long_reads.bam",
    "test2.bam",
    "test2.bam.bai"
)
sapply(test_files, function(x) {
    download.file(
        paste0(
            "https://github.com/ChristopherWilks/megadepth/",
            "raw/master/tests/",
            x
        ),
        destfile = here::here("inst", "tests", x),
        mode = "wb"
    )
})


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

## Copy test bigwig file to the package dir
file.copy(
    file.path(tempdir(), "test.bam.all.bw"),
    here::here("inst", "tests", "test.bam.all.bw"),
    overwrite = TRUE
)


## Copy test files to the package for the other tests on Windows
test_files <- dir(tempdir(), "test.bam", full.names = TRUE)
dir.create(here::here("inst", "tests", "test_output_files"),
    showWarnings = FALSE)
sapply(test_files,
    file.copy,
    here::here("inst", "tests", "test_output_files/"))


## For trying to debug on Windows
if (xfun::is_windows()) {
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

