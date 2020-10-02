## Copied from https://github.com/snystrom/cmdfun/blob/master/R/cmd_args.R
## with permission from Spencer Nystrom while
## cmdfun is approved at CRAN.
## This is in relation to the Bioconductor submission at
## https://github.com/Bioconductor/Contributions/issues/1696

# use_package("magrittr")
# use_package("purrr")
# use_package("testthat")

cmd_args_all <- function(keep = NULL, drop = NULL){
  argList <- as.list(match.call(definition = sys.function(sys.parent()),
                     call = sys.call(sys.parent()),
                     expand.dots = TRUE))[-1]
  args <- lapply(argList, eval, envir = parent.frame())

  list_keep_or_drop(args, keep = keep, drop = drop)

}


#' @importFrom magrittr %>%
cmd_args_dots <- function(keep = NULL, drop = NULL){

  argList <- as.list(match.call(definition = sys.function(sys.parent()),
                     call = sys.call(sys.parent()),
                     expand.dots = FALSE))[-1]

  args <- lapply(argList[["..."]], eval, envir = parent.frame())

  list_keep_or_drop(args, keep = keep, drop = drop)
}

cmd_args_named <- function(keep = NULL, drop = NULL){
  argList <- as.list(match.call(definition = sys.function(sys.parent()),
                     call = sys.call(sys.parent()),
                     expand.dots = FALSE))[-1]

  args <- lapply(argList, eval, envir = parent.frame()) %>%
    cmd_list_drop_named("...")

  list_keep_or_drop(args, keep = keep, drop = drop)
}


#' @importFrom magrittr %>%
#' @importFrom magrittr %<>%
cmd_list_interp <- function(args, flag_lookup = NULL){

  testthat::expect_type(args, "list")

  if (length(args) == 0) { return(NULL) }

  testthat::expect_named(args)

  if (any(flag_lookup == "TRUE" | flag_lookup == "FALSE")) {
    warning("flag_lookup may contain boolean definitions, which could cause unexpected behavior")
  }

  if (!is.null(flag_lookup)) {
    args <- convert_names(args, flag_lookup)
  }

  if (is.null(flag_lookup)) {
    flag_lookup <- args_as_lookup(args)
  }
  check_args_contain_illegal_flags(args)

  args %<>%
    drop_list_NULL() %>%
    purrr::discard(~{all(is.na(.x))}) %>%
    true_to_empty() %>%
    drop_list_logicals() %>%
    cmd_list_drop_named("")

  purrr::imap_dbl(flag_lookup, count_matched_args, args) %>%
    purrr::set_names(concatenate_args(flag_lookup)) %>%
    find_multimatched_args() %>%
    purrr::walk(warn_multimatched_arg)

  if (length(args) == 0) {return(NULL)}

  return(args)
}

#' @importFrom magrittr %>%
cmd_list_to_flags <- function(flagList, prefix = "-", sep = ","){

  if (is.null(flagList)) return(NULL)
  if (length(flagList) == 0) return(NULL)

  testthat::expect_named(flagList)

  flags <- purrr::imap(flagList, ~{c(paste0(prefix, .y), paste0(.x, collapse = sep))}) %>%
    unlist() %>%
    purrr::set_names(NULL)

  flags <- flags[flags != ""]

  return(flags)
}


## From https://github.com/snystrom/cmdfun/blob/master/R/utils_internal.R

utils::globalVariables(".")

drop_list_fun <- function(list, fun){
  testthat::expect_equal(class(fun), "function")
  list[!purrr::map_lgl(list, fun)]
}

drop_list_logicals <- function(list){
  drop_list_fun(list, is.logical)
}

drop_list_NULL <- function(list){
  drop_list_fun(list, is.null)
}

convert_logical_to_empty <- function(list, bool = TRUE){
  list <- purrr::map(list, ~{
    if (!is.logical(.x)) return(.x)

    if (.x == bool) return("")

    return(.x)
  })

}
true_to_empty <- function(list){
  list <- convert_logical_to_empty(list, TRUE)
  return(list)
}

convert_names <- function(obj, dict){
  testthat::expect_named(obj)
  testthat::expect_named(dict)

  names(obj)[names(obj) %in% names(dict)] <- dict[names(obj)[names(obj) %in% names(dict)]]
  return(obj)
}

count_matched_args <- function(value, name, dots){
  names(dots) %in% c(value, name) %>% sum
}

find_multimatched_args <- function(vec){
  testthat::expect_named(vec)
  names(vec[vec > 1])
}

warn_multimatched_arg <- function(name){
  message(paste0(name, " is set multiple times in function call, ensure this is correct behavior."))
}

concatenate_args <- function(dict, sep = "/"){
  paste(names(dict), dict, sep = sep)
}


flag_is_illegal <- function(flag,
                                  illegal_chars = c("&", "\\|", ";", "\\(", "\\)", "\\{", "\\}", "\\$", "\\@", "\\/", " ")){
  any(purrr::map_lgl(illegal_chars, grepl, flag))
}

error_illegal_flag <- function(name){
  stop(paste0(name, " is not a valid flag name. Contains illegal character."))
}

check_args_contain_illegal_flags <- function(args){
  is_illegal <- purrr::map_lgl(names(args), flag_is_illegal) %>%
    purrr::set_names(names(args))

  illegals <- is_illegal[is_illegal == T]

  purrr::walk(names(illegals), error_illegal_flag)
}

sanitize_path <- function(path){
  file.path(dirname(path), basename(path))
}

args_as_lookup <- function(args){
  flag_lookup <- names(args)
  names(flag_lookup) <- names(args)
  return(flag_lookup)
}

list_keep_or_drop <- function(list, keep = NULL, drop = NULL){

  if (length(list) == 0){return(list)}

  testthat::expect_named(list)

  if (!is.null(keep) & !is.null(drop)) {
    stop("only one of keep or drop may be defined")
  }

  if (is.null(keep) & is.null(drop)) { return(list) }

  if (!is.null(keep)){
    testthat::expect_type(keep, "character")
    filteredList <- cmd_list_keep(list, keep)
  }

  if (!is.null(drop)){
    testthat::expect_type(drop, "character")
    filteredList <- cmd_list_drop(list, drop)
  }

  return(filteredList)

}


## From https://github.com/snystrom/cmdfun/blob/master/R/utils.R
cmd_list_keep_named <- function(list, names){
  list[(names(list) %in% names)]
}

cmd_list_drop_named <- function(list, names){
  list[!(names(list) %in% names)]
}

