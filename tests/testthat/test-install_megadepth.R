test_that("installation of the latest version works", {
    expect_message(
        megadepth::install_megadepth(force = TRUE),
        "megadepth has been installed to"
    )
    expect_equal(
        find_exec("megadepth", "Megadepth"),
        find_megadepth()
    )
    expect_equal(
        megadepth_cmd("--version", stdout = TRUE),
        paste("megadepth", megadepth_latest())
    )
    expect_equal(
        megadepth_cmd("--version", stdout = TRUE),
        megadepth_shell(version = TRUE)
    )
})
