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

##### process_junctions #####

# download Chris' script for testing
process_jx_script_path <- file.path(tempdir(), "process_jx_output.sh")

download.file(
    "https://raw.githubusercontent.com/ChristopherWilks/megadepth/master/junctions/process_jx_output.sh",
    process_jx_script_path
)

# wrap using process_jx_output.sh in function
process_jx_output_shell <- function(all_jxs, process_jx_script_path) {

    # process using process_jx_output.sh
    all_jxs %>% readr::write_delim(file.path(tempdir(), "tmp_jxs.tsv"),
        delim = "\t"
    )

    system(paste(
        "source",
        file.path(tempdir(), "process_jx_output.sh"),
        file.path(tempdir(), "tmp_jxs.tsv")
    ))

    # processed junctions
    processed_jxs <- readr::read_delim(
        file.path(tempdir(), "tmp_jxs.tsv.sjout"),
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
        skip = 1
    ) # skipp the colnames, replaced with above

    return(processed_jxs)
}

##### process_junction_table ######

test_that("process_junction_table has correct output", {
    suppressWarnings(expr = {
        processed_jxs_shell <- process_jx_output_shell(
            all_jxs,
            process_jx_script_path
        )
    })

    expect_equal(process_junction_table(all_jxs),
        processed_jxs_shell,
        ignore_attr = TRUE
    )
})

test_that("process_junction_table catches user input errors", {
    suppressWarnings(expr = {
        jxs <- read_junction_table(example_jxs[["jxs.tsv"]])
    })

    expect_error(
        process_junction_table(jxs),
        "all_jxs argument should have colnames"
    )
})
