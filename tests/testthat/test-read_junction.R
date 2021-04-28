example_bam <- system.file("tests",
    "test2.bam",
    package = "megadepth",
    mustWork = TRUE
)

example_jxs <- bam_to_junctions(example_bam,
    all_junctions = TRUE,
    junctions = TRUE,
    overwrite = TRUE
)

all_jxs <- read_junction_table(example_jxs[["all_jxs.tsv"]])

##### read_junction_table #####

test_that("read_junction_table has correct output", {
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

    expect_equal(jxs, chris_jxs, ignore_attr = TRUE)
})

test_that("read_junction_table catches user input errors", {
    expect_error(
        read_junction_table(tsv_file = "no_correct_extension"),
        'tsv_file must have the extension "all_jxs.tsv" or "jxs.tsv"'
    )
})

##### process_junction_table ######

# Don't test on windows as needs to download and run .sh script
if (!xfun::is_windows()) {

    # download Chris' script for testing
    process_jx_script_path <- file.path(tempdir(), "process_jx_output.sh")

    download.file(
        "https://raw.githubusercontent.com/ChristopherWilks/megadepth/master/junctions/process_jx_output.sh",
        process_jx_script_path
    )

    Sys.chmod(process_jx_script_path, "0755")

    # wrap using process_jx_output.sh in function
    process_jx_output_shell <- function(all_jxs_path, process_jx_script_path) {
        system(paste(
            process_jx_script_path,
            all_jxs_path
        ))

        # processed junctions
        processed_jxs <- readr::read_delim(
            paste0(all_jxs_path, ".sjout"),
            delim = "\t",
            col_names = c(
                "chr",
                "start",
                "end",
                "strand",
                "intron_motif",
                "annotated",
                "uniquely_mapping_reads",
                "multimapping_reads"
            ),
            col_types = cols("chr" = "c")
        )

        return(processed_jxs)
    }

    test_that("process_junction_table has correct output", {

        # also read/test junctions from test.bam (as well as test2.bam above)
        example_bam2 <- system.file("tests",
            "test.bam",
            package = "megadepth",
            mustWork = TRUE
        )

        example_jxs2 <- bam_to_junctions(example_bam2,
            all_junctions = TRUE,
            junctions = TRUE,
            overwrite = TRUE
        )

        suppressWarnings(expr = {
            processed_jxs2_shell <- process_jx_output_shell(
                all_jxs_path = example_jxs2[["all_jxs.tsv"]],
                process_jx_script_path
            )
        })

        suppressWarnings(expr = {
            processed_jxs_shell <- process_jx_output_shell(
                all_jxs_path = example_jxs[["all_jxs.tsv"]],
                process_jx_script_path
            )
        })

        # ignore_attr = TRUE is needed as there are "spec" and "problems"
        # attributes that are created on the tibble through read_delim()
        expect_equal(process_junction_table(all_jxs),
            processed_jxs_shell,
            ignore_attr = TRUE
        )

        expect_equal(example_jxs2[["all_jxs.tsv"]] %>%
            read_junction_table() %>%
            process_junction_table(),
        processed_jxs2_shell,
        ignore_attr = TRUE
        )
    })
}

test_that("process_junction_table catches user input errors", {
    suppressWarnings(expr = {
        jxs <- read_junction_table(example_jxs[["jxs.tsv"]])
    })

    expect_error(
        process_junction_table(jxs),
        "all_jxs argument should have colnames"
    )
})

# use local full-size bam for testing
# avoid testing when local bam is not available, to avoid large test times
# in which case, unit testing relies on using test.bam/test2.bam above
bam_path <- "/data/RNA_seq_diag/niccolo_X_linked_dystonia/180420-140039/STAR/NIAA_Aligned.sortedBysamtools.out.bam"

if (file.exists(bam_path)) {
    local_bam_jxs <- bam_to_junctions(bam_path,
        all_junctions = TRUE,
        overwrite = TRUE
    )

    # take first n_rows_to_test rows
    n_rows_to_test <- 1000000
    local_bam_jxs_head <- local_bam_jxs[["all_jxs.tsv"]] %>%
        gsub(".all_jxs", "_head.all_jxs", .)

    local_bam_jxs[["all_jxs.tsv"]] %>%
        readr::read_delim(
            n_max = n_rows_to_test,
            col_names = FALSE,
            delim = "\t"
        ) %>%
        readr::write_delim(local_bam_jxs_head,
            col_names = FALSE,
            delim = "\t"
        )

    local_bam_jxs_processed <- read_junction_table(local_bam_jxs_head) %>%
        process_junction_table()

    suppressWarnings(
        local_bam_jxs_processed_shell <-
            process_jx_output_shell(
                local_bam_jxs_head,
                process_jx_script_path
            )
    )

    test_that("process_junction_table works on a larger set of jxs", {
        expect_equal(local_bam_jxs_processed,
            local_bam_jxs_processed_shell,
            ignore_attr = TRUE
        )
    })
}
