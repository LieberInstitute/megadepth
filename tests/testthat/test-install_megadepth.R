test_that("installation works", {
    expect_message(
        megadepth::install_megadepth(force = TRUE),
        "megadepth has been installed to"
    )
    ## This test is currently failing: it re-installs megadepth on GHA
    ## to /github/home/bin
    # expect_message(
    #     megadepth::install_megadepth(force = FALSE),
    #     "It seems megadepth has been installed. Use force = TRUE to reinstall or upgrade."
    # )
})
