#!/bin/bash

# It extracts a doi string from a PDF article if it exists.

. library_std.sh

args_num_test "$#" 1 1 "A path to a PDF file should be given as argument."

file_readable "${1}"

File="${1}"

#doi: 

doi="$(pdftotext -enc Latin1 "${File}" - | grep -i '[^a-zA-Z]doi: *[^ ]\+' | head -n 1 | sed -e 's/^.*doi:\? *//gi' -e 's/[\.) ]\+$//g' -e 's/]$//g')"

echo "${doi}"

