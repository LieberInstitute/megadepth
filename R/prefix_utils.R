## Helper function for locating prefix files
prefix_files <- function(prefix) {
    files_found <- dir(
        dirname(prefix),
        pattern = paste0("^", basename(prefix)),
        full.names = TRUE
    )
    ## Set the names if we found any files
    if (length(files_found) > 0) {
        names(files_found) <- gsub(
            paste0("^", basename(prefix), "\\."),
            "",
            basename(files_found)
        )
    }
    return(files_found)
}

## Helper function for checking if the files exist already
prefix_exists <- function(prefix, expected_ext) {
    expected_files <- paste0(prefix, ".", expected_ext)
    print(expected_files)
    files_present <- file.exists(expected_files)
    if (any(files_present)) {
        stop(
            "The following files already exist.\n",
            "Use overwrite = TRUE to replace them. Existing file(s):\n",
            paste(expected_files[files_present], collapse = "\n"),
            call. = FALSE
        )
    }
}
