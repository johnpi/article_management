#!/bin/bash

. library_std.sh

args_num_test "$#" 1 1 "A path to a PDF file should be given as argument."

file_readable "${1}"

File="${1}"

./lookup_crossref.sh "$(./extract_doi.sh ${File})"

