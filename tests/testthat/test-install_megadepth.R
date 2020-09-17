megadepth::install_megadepth()

test_that("installation works", {
    expect_message(
        megadepth::install_megadepth(),
        "It seems megadepth has been installed. Use force = TRUE to reinstall or upgrade."
    )
})
