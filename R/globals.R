# Solve "no visible binding for global variable 'chr'... etc" issue
# https://www.r-bloggers.com/2019/08/no-visible-binding-for-global-variable/
utils::globalVariables(c(
    "chr",
    "start",
    "end",
    "strand",
    "read_name",
    "n_reads",
    "uniquely_mapping_reads",
    "intron_motif",
    "annotated",
    "multimapping_reads"
))
