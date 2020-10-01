#' Install Megadepth
#'
#' Download the appropriate Megadepth executable for your platform from Github
#' and try to copy it to a system directory so \pkg{megadepth} can run the
#' \command{megadepth} command.
#'
#' This function tries to install Megadepth to \code{Sys.getenv('APPDATA')} on
#' Windows, \file{~/Library/Application Support} on macOS, and \file{~/bin/} on
#' other platforms (such as Linux). If these directories are not writable, the
#' package directory \file{Megadepth} of \pkg{megadepth} will be used. If it
#' still fails, you have to install Megadepth by yourself and make sure it can
#' be found via the environment variable \code{PATH}.
#'
#' If you want to install Megadepth to a custom path, you can set the global
#' option \code{megadepth.dir} to a directory to store the Megadepth executable
#' before you call \code{install_megadepth()}, e.g.,
#' \code{options(megadepth.hugo.dir = '~/Downloads/Megadepth_1.0.4/')}.
#' This may be useful for you to use a specific
#' version of Megadepth for a specific project. You can set this option per
#' project, similar to how \code{blogdown.hugo.dir} is used for specifying
#' the directory for Hugo in the \pkg{blogdown} package..
#' See \href{https://bookdown.org/yihui/blogdown/global-options.html}{Section
#' 1.4 Global options} for details, or store a copy of Megadepth on a USB Flash
#' drive along with your project code.
#'
#' @param version A `character(`)` specifying the Megadepth version number,
#' e.g., \code{1.0.4}; the special value \code{latest} means the latest version
#' (fetched from Github releases).
#' @param force A `logical(1)` specifying whether to install megadepth even if
#' it has already been installed.
#'
#' @importFrom xfun is_windows is_macos same_path
#' @importFrom utils download.file file_test
#' @importFrom fs dir_exists
#' @export
#' @references
#' This function is based on blogdown::install_hugo() which is available from
#' <https://github.com/rstudio/blogdown/blob/master/R/install.R>.
#'
#' @examples
#'
#' ## Install megadepth
#' install_megadepth()
install_megadepth <- function(version = "latest", force = FALSE) {
    if (Sys.which("megadepth") != "" && !force) {
        message("It seems megadepth has been installed. Use force = TRUE to reinstall or upgrade.")
        return(invisible())
    }

    if (version == "latest") {
        version <- megadepth_latest()
        message("The latest megadepth version is ", version)
    }

    base <- sprintf(
        "https://github.com/ChristopherWilks/megadepth/releases/download/%s/",
        version
    )

    exec_ext <- if (xfun::is_windows()) {
        ".exe"
    } else if (xfun::is_macos()) {
        "_macos"
    } else {
        ""
    }

    url <- paste0(base, "megadepth", exec_ext)
    exec_name <-
        ifelse(xfun::is_windows(), "megadepth.exe", "megadepth")
    exec <- file.path(tempdir(), exec_name)

    utils::download.file(url,
        destfile = exec,
        quiet = TRUE,
        mode = "wb"
    )

    if (!xfun::is_windows()) {
        Sys.chmod(exec, "0755")
    }

    install_megadepth_bin(exec)
}

megadepth_latest <- function() {
    h <- readLines("https://github.com/ChristopherWilks/megadepth/releases/latest",
        warn = FALSE
    )
    r <- '^.*?releases/tag/([0-9.]+)".*'
    version <- gsub(r, "\\1", grep(r, h, value = TRUE)[1])
    return(version)
}


install_megadepth_bin <- function(exec) {
    success <- FALSE
    dirs <- bin_paths()
    for (destdir in dirs) {
        dir.create(destdir, showWarnings = FALSE)
        success <- file.copy(exec, destdir, overwrite = TRUE)
        if (success) {
              break
          }
    }
    if (!success) {
          stop(
              "Unable to install megadepth to any of these dirs: ",
              paste(dirs, collapse = ", ")
          )
      }
    message("megadepth has been installed to ", normalizePath(destdir))
}

# possible locations of the megadepth executable
bin_paths <- function(dir = "Megadepth",
    extra_path = getOption("megadepth.dir")) {
    if (xfun::is_windows()) {
        path <- Sys.getenv("APPDATA", "")
        path <- if (fs::dir_exists(path)) {
            file.path(path, dir)
        }
    } else if (xfun::is_macos()) {
        path <- "~/Library/Application Support"
        path <- if (fs::dir_exists(path)) file.path(path, dir)
        path <- c("/usr/local/bin", path)
    } else {
        path <- c("~/bin", "/snap/bin", "/var/lib/snapd/snap/bin")
    }
    path <- c(extra_path, path, pkg_file(dir, mustWork = FALSE))
    path
}

# find an executable from PATH, APPDATA, system.file(), ~/bin, etc
find_exec <- function(cmd, dir, info = "") {
    for (d in bin_paths(dir)) {
        exec <- if (xfun::is_windows()) {
              paste0(cmd, ".exe")
          } else {
              cmd
          }
        path <- file.path(d, exec)
        if (utils::file_test("-x", path)) {
              break
          } else {
              path <- ""
          }
    }
    path2 <- Sys.which(cmd)
    if (path == "" || xfun::same_path(path, path2)) {
        if (path2 == "") {
              stop(cmd, " not found. ", info, call. = FALSE)
          }
        return(cmd) # do not use the full path of the command
    } else {
        if (path2 != "") {
              warning(
                  "Found ",
                  cmd,
                  ' at "',
                  path,
                  '" and "',
                  path2,
                  '". The former will be used. ',
                  "If you don't need both copies, you may delete/uninstall one."
              )
          }
    }
    normalizePath(path)
}

find_megadepth <- local({
    path <- NULL # cache the path to megadepth
    function() {
        if (is.null(path)) {
              path <<- find_exec(
                  "megadepth",
                  "Megadepth",
                  "You can install it via megadepth::install_megadepth()"
              )
          }
        path
    }
})
