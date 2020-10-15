## test conversion of BAM to BigWig
if (!xfun::is_windows()) {
    test_that("test conversion of BAM to bw", {

        ## Create the bigwig file
        new_files <- bam_to_bigwig(
            pkg_file("tests", "test.bam"),
            overwrite = TRUE
        )

        ## Check the md5sum
        expect_equal(
            unname(tools::md5sum(new_files["all.bw"])),
            unname(tools::md5sum(pkg_file("tests", "test.bam.all.bw")))
        )
        expect_error(
            bam_to_bigwig(pkg_file("tests", "test.bam")),
            "The following files already exist"
        )
    })
}
